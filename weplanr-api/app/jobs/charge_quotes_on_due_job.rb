class ChargeQuotesOnDueJob
 
  def self.perform(*args)
    quotes = Quote.on_due

    quotes.each do |quote|
      transaction = PaymentService.pay_due(quote)

      attr = {
        amount: transaction.amount / 2,
        scheduled_at: quote.payment_due,
        transaction: transaction,
        vendor: quote.vendor,
        quote: quote
      }

      transaction.payouts.create(attr)
      transaction.payouts.create(attr.merge(scheduled_at: quote.payment_due + 5.days))

      # TODO: handle errors
      # TODO: update quote status to?
      # TODO: send confirmation email?
    end
  end

end
