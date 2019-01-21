module FeeCalculator

  def calculate_application_fee quote
    vendor = quote.vendor
    return 0 if quote.wedding.referrals.is_referred?(vendor.email)

    if vendor.has_custom_vendor_fee?
      weplanr_fee = vendor.custom_vendor_fee_flat || 0

      if percent_fee = vendor.custom_vendor_fee_pcg
        weplanr_fee += quote.subtotal * (percent_fee / 100.0)
      end

      return weplanr_fee
    end

    weplanr_fee = calculate_weplanr_fee(quote.subtotal)
    if weplanr_fee > 0
      deduct_vendor_credits(weplanr_fee, vendor).to_i
    else
      0
    end
  end

  def calculate_weplanr_fee total
    ( total * calculate_weplanr_fee_pcg(total) ) - stripe_additional_fee
  end

  def calculate_weplanr_fee_pcg total
    if total <= 1_000
      high_percent
    elsif total > 10_000
      mid_percent
    else
      pro_rate = high_percent - (high_percent - mid_percent) * (total - 1000) / (10_000 - 1000)
      pro_rate.round(3)
    end
  end

  def high_percent
    0.0825 # prev 0.10
  end

  def mid_percent
    0.0225 # prev 0.04
  end

  def stripe_additional_fee
    0.3 # 30cents
  end

  def deduct_vendor_credits weplanr_fee, vendor
    promo_code = vendor.referral_code
    current_credit = promo_code.current_credit

    if weplanr_fee >= current_credit
      new_credit = 0
      new_weplanr_fee = weplanr_fee - current_credit
    else
      new_credit = current_credit - weplanr_fee
      new_weplanr_fee = 0
    end

    if promo_code.update(current_credit: new_credit)
      new_weplanr_fee
    else
      weplanr_fee
    end
  end

end
