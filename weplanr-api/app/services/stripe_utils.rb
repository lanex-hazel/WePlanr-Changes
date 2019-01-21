class StripeUtils
  class << self

    def get_stripe_account_key code
      response = HTTParty.post 'https://connect.stripe.com/oauth/token',
        query: {
          client_secret: ENV['STRIPE_API_KEY'],
          code: code,
          grant_type: 'authorization_code'
        }

      if response['error'].nil?
        validate_account(response['stripe_user_id'])
        response['stripe_user_id']
      else
        raise response['error_description']
      end
    end


    def validate_account stripe_account_id
      return true if Rails.env.test?

      unless Stripe::Account.retrieve(stripe_account_id).charges_enabled
        raise Stripe::StripeError.new(nil, json_body: {
          error: { message: 'Stripe account is unable to accept payment.'}
        })
      end
    end

    def get_application_fee fee_id
      if fee_id.present?
        Stripe::ApplicationFee.retrieve(fee_id).amount
      else
        0
      end
    end

  end
end
