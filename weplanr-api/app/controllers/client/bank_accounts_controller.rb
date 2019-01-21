class Client::BankAccountsController < Client::BaseController
  include CRUD

  def create
    bank = PaymentService.create_payment_method('bank_account', obj_params, current_user)

    @_obj = current_user.wedding.bank_accounts.new(
      external_id: bank.id,
      bank_name: bank.bank_name,
      account_name: bank.account_holder_name,
      account_number: "**** **** **** #{bank.last4}",
      account_type: bank.account_holder_type,
      routing_number: bank.routing_number,
      country: bank.country
    )

    if @_obj.save
      render_common_response
    else
      render_422 obj
    end
  end

  private

  def collection
    @_collection ||= (current_user.wedding || current_user.vendor).bank_accounts
  end

  def obj_params
    params.require(:data).require(:attributes).permit(*%i(
      bank_name
      country
      currency
      account_number
      account_holder_name
      account_holder_type
      routing_number
    ))
  end

  def serializer
    Client::BankAccountSerializer
  end
end
