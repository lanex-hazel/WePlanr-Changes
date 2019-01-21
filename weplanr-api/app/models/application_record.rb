class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def assign_uniq_token(attr, scope={})
    loop do
      scope[attr] = SecureRandom.uuid
      next if self.class.exists?(scope)

      assign_attributes(scope)
      break
    end
  end

  def assign_uid
    assign_uniq_token :uid
  end

  def convert_to_boolean val
    if val.is_a? String
      %w(y true 1).include?(val.downcase)
    else
      val
    end
  end
end
