class PaymentService
  extend FeeCalculator

  CURRENCY = 'aud'
  DEPOSIT_PERCENT = 0.40

  class << self

    def create_payment_method type, data, user
      source = { object: type }.merge(stringify data)
      wedding = user.wedding

      if stripe_id = wedding.stripe_account_id
        customer = Stripe::Customer.retrieve(stripe_id)
        customer.sources.create(source: source)
      else
        customer = Stripe::Customer.create(
          description: "Customer for #{user.email}'s #{wedding.name} wedding",
          source: source
        )
        wedding.update(stripe_account_id: customer.id)

        customer.sources.data.last
      end
    end

    def delete_payment_methods id, user
      ids = id.is_a?(Array) ? id : [id]
      wedding = user.wedding

      customer = Stripe::Customer.retrieve(wedding.stripe_account_id)
      ids.map do |id|
        customer.sources.retrieve(id).delete
      end
    end


    def pay_vendor_registration amount, vendor, card_details
      transact vendor, 'Vendor signup fee' do
        Stripe::Charge.create(
          currency: CURRENCY,
          amount: amount.to_i,
          description: "Vendor signup fee for #{vendor.email}",
          source: card_details.to_h.merge(object: 'card'),
        )
      end
    end


    def pay_deposit(quote, wedding)
      vendor = quote.vendor
      deposit = (quote.total * DEPOSIT_PERCENT).to_f.round(2)

      transaction = transact(wedding, 'Payment deposit', quote: quote) do
        vendor_stripe_account = vendor.stripe_account_id
        token = get_transact_token(wedding.stripe_account_id, vendor_stripe_account)
        application_fee = calculate_application_fee(quote)

        # convert amount/fee to integer cents
        Stripe::Charge.create({
          source: token.id,
          currency: CURRENCY,
          amount: (deposit * 100).to_i,
          application_fee: (application_fee * DEPOSIT_PERCENT * 100).to_i,
          description: "Payment Deposit for quote: #{quote.id}",
        }, stripe_account: vendor_stripe_account)
      end

      create_payout(transaction, quote, vendor)

      return transaction
    end

    def pay_due quote
      wedding = quote.wedding
      vendor = quote.vendor

      transaction = transact(wedding, 'Payment due', quote: quote) do
        vendor_stripe_account = vendor.stripe_account_id
        token = get_transact_token(wedding.stripe_account_id, vendor_stripe_account)
        application_fee = calculate_application_fee(quote)

        # convert amount/fee to integer cents
        Stripe::Charge.create({
          source: token.id,
          currency: CURRENCY,
          amount: (quote.amount_due * 100).to_i,
          application_fee: (application_fee * quote.amount_due_pct * 100).to_i,
          description: "Complete payment for quote: #{quote.id}",
        }, stripe_account: vendor_stripe_account)
      end

      create_payout(transaction, quote, vendor)

      return transaction
    end


    private


    def transact payer, description, transaction_opts={}, &block
      return true if Rails.env.test?

      stripe_error = nil
      charge = nil

      Transaction.transaction do
        begin
          charge = yield
        rescue Stripe::StripeError => error
          stripe_error = error
          raise ActiveRecord::Rollback
        end
      end

      raise stripe_error if stripe_error

      record_transaction(payer, charge, {
        description: description
      }.merge(transaction_opts))
    end

    def record_transaction payer, charge, transaction_opts
      app_fee = StripeUtils.get_application_fee(charge.application_fee)

      log = {
        amount: charge.amount / 100.0, # convert from cent to decimal
        application_fee: app_fee / 100.0,
        metadata: { stripe: charge.to_h }
      }.merge(transaction_opts)

      if payer.is_a? Vendor
        payer.paid_transactions.create!(log)
      else
        payer.transactions.create!(log)
      end
    #rescue => e
      # TODO saves error and email admin then raise error and return keep calm message
    end

    def create_payout transaction, quote, vendor
      transaction.payouts.create(
        amount: transaction.amount,
        quote: quote,
        transaksyon: transaction,
        vendor: vendor
      ) unless Rails.env.test?
    end

    def get_transact_token payer_stripe_id, vendor_stripe_id
      token_params = { customer: payer_stripe_id }
      Stripe::Token.create(token_params, stripe_account: vendor_stripe_id)
    end

    def stringify data
      data.deep_merge(data) {|_,_,val| val.to_s}
    end

  end
end
