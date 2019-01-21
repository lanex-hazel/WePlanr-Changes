class AbnLookup
  class << self

    def client
      @@_client ||= Abn::Client.new(ENV['ABN_LOOKUP_GUID'])
    end

    def validate abn
      return true if Rails.env.test?

      result = client.search(abn)
      raise result[0] if result.is_a? Array

      abn.eql? result[:abn]
    end

    def method_missing(method, *args, &block)
      client.send method, *args, &block
    end

  end
end
