module ReferralConcern
  extend ActiveSupport::Concern

  included do
    before_create :assign_referral_code
  end


  def assign_referral_code
    loop do
      string = (referral_base_string or 'nil').gsub(/\W/, '').first(6)
      random_num = rand(999).to_s.rjust(3, '0')
      code = "#{string}#{random_num}au"

      next if ReferralCode.exists?(code: code)

      build_referral_code code: code
      break
    end
  end

  def referral_base_string
    uid
  end

end
