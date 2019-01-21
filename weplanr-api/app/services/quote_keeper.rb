class QuoteKeeper
  BOOKING_TRANSACTION = 500

  attr_accessor :quote, :wedding, :vendor

  def initialize quote
    @quote = quote
    @wedding = quote.wedding
    @vendor = quote.vendor
  end

  def accept
    # NOTE will raise an error if false
    StripeUtils.validate_account(vendor.stripe_account_id)

    # TODO: put under transaction block / error handler
    process_booking
    if quote.delivery_date && quote.delivery_date > 6.weeks.from_now
      transaction = PaymentService.pay_deposit(quote, wedding)

      process_invoices transaction

      wedding.users.map do |user|
        UserMailer.send_downpayment_confirmation(user, vendor, quote).deliver_now if user.email
      end
      VendorMailer.send_booking_notif(vendor, quote, transaction).deliver_now unless env_test?

      quote.accept
    else
      quote.full_invoice
      fulfill
    end
  end

  def fulfill
    transaction = PaymentService.pay_due(quote)

    invoices = quote.invoices
    invoices.unpaid.each(&:paid)
    transaction.update(invoice_id: invoices&.first.id) unless env_test?

    wedding.users.map do |user|
      UserMailer.send_full_payment_confirmation(user, vendor, quote).deliver_now if user.email && !env_test?
    end
    VendorMailer.payment_confirmation(vendor, quote, transaction).deliver_now unless env_test?

    quote.fulfill
  end

  def process_booking
    quote.update_vendor_settings

    vendor.bookings.create(
      wedding: wedding,
      schedule: quote.delivery_date,
      quote: quote)

    wedding.update_users_metadata unless wedding.is_personalised?
    wedding.reward_transactions.create(quote: quote) if quote.total >= BOOKING_TRANSACTION && Reward.state == 1

    conversation = quote.message.conversation

    Messenger::Notification.transfer_to_booking(conversation.vendor_uid, conversation)
    Messenger::Notification.transfer_to_booking(wedding.uid, conversation)
  end

  def process_invoices(transaction)
    deposit = quote.deposit_invoice
    deposit.paid
    transaction.update(invoice_id: deposit.id) unless env_test?
    quote.due_invoice
  end

  def valid?
    quote.errors.blank?
  end

  def env_test?
    Rails.env.test?
  end


  private

  def method_missing(method, *args, &block)
    if quote.respond_to? method
      quote.send method, *args, &block
    else
      super
    end
  end
end
