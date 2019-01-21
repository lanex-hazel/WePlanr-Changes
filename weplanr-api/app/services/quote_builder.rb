class QuoteBuilder

  attr_reader :params, :vendor, :wedding, :quote, :quote_items

  def initialize vendor, wedding, params
    @params = params
    @vendor = vendor
    @wedding = wedding
  end

  def save
    Quote.transaction do
      create_quote
      update_quote_items
      # quote_discounted

      if valid? && quote.save && assign_to_message
        true
      else
        raise ActiveRecord::Rollback
      end
    end
  end

  def valid?
    quote.valid? && quote_items.all?(&:valid?)
  end

  def errors
    _errors = [quote.errors, quote_items.map(&:errors)].flatten.compact
    _errors.find(&:any?) || Quote.new.errors
  end


  private

  def create_quote
    quote_params = params.permit(*%i(payment_due status delivery_date)).to_h
    quote_params[:is_gst] = vendor.registered_for_gst
    quote_params[:wedding] = wedding

    @quote =
      if _quote = vendor.quotes.drafts.find_by_wedding_id(wedding.id)
        _quote.attributes = quote_params
        _quote
      else
        vendor.quotes.new(quote_params)
      end
    @quote.save
  end

  def update_quote_items
    @quote.quote_items.destroy_all
    @quote_items = params[:quote_items].map do |item_params|
      item_params = item_params.permit(*%i(name description quantity cost total))
      @quote.quote_items.new(item_params)
    end
  end

  # def quote_discounted
  #   if referral = vendor.is_user_referral?(wedding)
  #     quote.discount_items.create(referral: referral, price: referral.discount_fee)
  #   end
  # end

  def assign_to_message
    return true if quote.draft?

    messenger = Messenger::Vendor.new(vendor)
    msg = messenger.send_quote(wedding.uid, quote)

    if msg && wedding.settings.always_notify_on_msg?
      UserMailer.send_new_msg_notif(wedding, vendor, msg).deliver_now
    end

    return msg
  end

  def method_missing(method, *args, &block)
    quote.send method, *args, &block
  end
end
