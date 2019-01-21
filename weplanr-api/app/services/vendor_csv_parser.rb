# Vendor CSV Headers
#   id
#   profile:_business_trading_name
#   profile:contact_name
#   profile:address_(summary)
#   profile:photos
#   profile:about_description
#   profile:service_location
#   profile:services
#   profile:pricing_and_packages
#   profile:website
#   profile:facebook
#   profile:instagram
#   profile:pinterest
#   profile:twitter
#   profile:youtube/vimeo
#   account:_publiccontact_name
#   account:_publicacn/abn
#   account:_publicphone_number_(primary)
#   account:_public_phone_number_(secondary)
#   account:_private_email
#   account:_private_registered_business_address_(full___not_visible_to_public)
#   account:_private_registered_for_gst?_y/n
#
class VendorCsvParser

  SOCIAL_CHANNEL_PATTERN = /(facebook|instagram|pinterest|twitter|youtube|vimeo)/
  ATTRIBUTE_MAPPINGS = {
    internal_id: /^id/,
    email: /email/,
    business_number: /(acn|abn)/,
    #business_address: /business.+address/,
    primary_phone: /phone_number.+primary/,
    secondary_phone: /phone.?number.+secondary/,
    contact_name: /profile.?contact.?name/,
    firstname: /public.?contact.?first.?name/,
    lastname: /public.?contact.?last.?name/,
    business_name: /business.+name/,
    about: /about.+description/,
    address_summary: /address.+summary/,
    social_channels: SOCIAL_CHANNEL_PATTERN,
    website: /website/,
    locations: /location/,
    parse_pricing_and_packages: /pricing.?and.?packages/,
    services: /services/,
    registered_for_gst: /registered.?for.?gst/,
  }


  def self.parse file
    result = []

    SmarterCSV.process(file) do |row|
      result.push parse_attributes(row[0])
    end

    result
  end

  def self.parse_attributes row
    result = {social_channels: {}}

    row.each do |key, value|
      attr_name = get_attribute_mapping(key)
      next if attr_name.nil?

      case attr_name
      when :about
        result[attr_name] = encode(value)
      when :locations, :services, :parse_pricing_and_packages
        result[attr_name] = encode(value.split(/[\;\r\n]+/))
      when :social_channels
        social_channel = get_social_channel(value)
        result[:social_channels][social_channel] = encode(value)
      else
        result[attr_name] = encode(value)
      end
    end

    result
  end

  def self.get_social_channel string
    if string =~ /(facebook|instagram|pinterest|twitter|youtube|vimeo)/
      $1
    else
      :undetermined
    end
  end

  def self.get_attribute_mapping key
    result = ATTRIBUTE_MAPPINGS.find{ |attr, pattern| key =~ pattern }
    (result || []).first
  end

  # Fixes possible Encoding::UndefinedConversionError:
  #   eg. from ASCII-8BIT to UTF-8
  def self.encode str
    return str unless str.is_a? String
    str.encode('utf-8', invalid: :replace, undef: :replace, replace: '')
  end
end
