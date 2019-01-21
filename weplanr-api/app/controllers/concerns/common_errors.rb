module CommonErrors
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render_404 "#{e.to_s.match(/find (\w+)/)[1]} not found"
    end

    rescue_from Stripe::InvalidRequestError do |e|
      body = e.json_body
      err  = body[:error]

      msg =
        if err[:message] =~ /^Must authenticate as a connected account to be able to use customer parameter/
          'Stripe account is unable to accept payment.'
        else
          # TODO email admin
          'Payment request error. Please contact our support.'
        end

      render json: { errors: [msg] }, status: 422
    end

    rescue_from Stripe::CardError do |e|
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      logger.fatal 'Stripe::CardError'
      logger.fatal "Status is: #{e.http_status}"
      logger.fatal "Type is: #{err[:type]}"
      logger.fatal "Charge ID is: #{err[:charge]}"
      # The following fields are optional
      logger.fatal "Code is: #{err[:code]}" if err[:code]
      logger.fatal "Decline code is: #{err[:decline_code]}" if err[:decline_code]
      logger.fatal "Param is: #{err[:param]}" if err[:param]
      logger.fatal "Message is: #{err[:message]}" if err[:message]

      if current_user && params[:controller] == 'client/quotes' && params[:action] == 'accept'
        UserMailer.send_card_declined(current_user).deliver_now
      end

      render json: { errors: [err[:message]] }, status: e.http_status
    end

    rescue_from Stripe::StripeError do |e|
      body = e.json_body
      err  = body[:error]

      render json: { errors: [err[:message]] }, status: 422
    end

    #rescue_from Stripe::RateLimitError do |e|
    # Too many requests made to the API too quickly
    #rescue_from Stripe::InvalidRequestError do |e|
    # Invalid parameters were supplied to Stripe's API
    #rescue_from Stripe::AuthenticationError do |e|
    # Authentication with Stripe's API failed
    # (maybe you changed API keys recently)
    #rescue_from Stripe::APIConnectionError do |e|
    # Network communication with Stripe failed
    #rescue_from Stripe::StripeError do |e|
    # Display a very generic error to the user, and maybe send
    # yourself an email

    rescue_from HTTPClient::ReceiveTimeoutError do |e|
      logger.fatal "#{e}"
      render json: { errors: ["Oops! One moment. We are reconnecting to your messages"] }, status: 422
    end
  end


  def render_401 msg
    render json: {
      error: msg
    }, status: 401
  end

  def render_422(_obj = obj)
    render json: {
      message: 'Validation failed',
      errors: _obj.errors.full_messages
    }, status: 422
  end

  def render_404 msg = 'Record not found'
    render json: { error: msg }, status: 404
  end
end
