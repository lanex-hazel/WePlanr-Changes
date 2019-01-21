class UpdateQuotesForExpiryJob

  def self.perform
    Quote.for_expiry.each do |quote|
      quote.update status: Quote::EXPIRED
    end
  end

end
