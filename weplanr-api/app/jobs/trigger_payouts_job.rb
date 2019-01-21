class TriggerPayoutsJob
 
  def self.perform(*args)
    payouts = Payout.pending

    payouts.each do |payout|
      # TODO: check if stripe account balance is sufficient

      resp = Stripe::Payout.create({
        amount: payout.amount, # integer in cents
        currency: PaymentService::CURRENCY,
      }, {stripe_account: payout.vendor.stripe_account_id})

      payout.update(metadata: resp.to_h)
    end
  end

end
