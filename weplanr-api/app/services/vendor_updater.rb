class VendorUpdater

  attr_reader :vendor, :params

  def initialize vendor, params
    @vendor = vendor
    @params = params
  end

  def save
    Vendor.transaction do
      save_vendor

      if new_locations = params[:locations]
        vendor.locations = new_locations
      end

      if new_other_locations = params[:other_locations]
        vendor.other_locations = new_other_locations
      end

      if new_services= params[:services]
        vendor.services = new_services
      end

      if params[:pricing_and_packages]
        remove_pricings # remove pricings if id isnt provided
        save_pricings
      end

      if params[:unavailable_dates]
        remove_unavailable_dates # remove if id isnt provided
        save_unavailable_dates
      end

      if params[:msg_notif_setting]
        msg_notif_setting = vendor.settings.msg_notif_setting.first_or_initialize
        msg_notif_setting.update(value: params[:msg_notif_setting])
      end

      vendor.save
    end
  end

  def save_vendor
    new_attr = params.except(:stripe_auth_code, :social_channels)

    if auth_code = params[:stripe_auth_code]
      new_attr['stripe_account_id'] = StripeUtils.get_stripe_account_key(auth_code)
    end

    if social_channels = params[:social_channels]
      new_attr['social_channels'] = social_channels.select{ |_,val| val }
    end

    if tags = new_attr[:tags]
      vendor.tag_list = tags.join(',')
    end

    vendor.attributes = new_attr.slice(*vendor_columns)
  end

  def save_pricings
    @pricing_and_packages = save_associated_records(vendor.pricing_and_packages, params[:pricing_and_packages])
  end

  def save_unavailable_dates
    @unavailable_dates = save_associated_records(vendor.unavailable_dates, params[:unavailable_dates])
  end

  def remove_pricings
    remove_associated_records(vendor.pricing_and_packages, params[:pricing_and_packages])
  end

  def remove_unavailable_dates
    remove_associated_records(vendor.unavailable_dates, params[:unavailable_dates])
  end

  def valid?
    vendor.valid? &&
      (@pricing_and_packages.blank? or @pricing_and_packages.all?(&:valid?)) &&
      (@unavailable_dates.blank? or @unavailable_dates.all?(&:valid?))
  end

  def method_missing(method, *args, &block)
    vendor.send method, *args, &block
  end

  def vendor_columns
    @_vendor_columns ||= Vendor.column_names.reject{ |attr| attr['profile_photo'] }.push :profile_photo
  end

  def save_associated_records associated_records, new_data
    new_data.map do |new_attr|
      obj_id = new_attr[:id]
      obj = obj_id ? associated_records.find(obj_id) : associated_records.new

      obj.attributes = new_attr.except(:id)
      obj.save
      obj
    end
  end

  def remove_associated_records associated_records, new_data
    to_update = new_data.map{ |attr| attr[:id] }.compact
    associated_records.where.not(id: to_update).destroy_all
  end

end
