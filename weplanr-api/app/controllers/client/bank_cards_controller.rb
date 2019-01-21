class Client::BankCardsController < Client::BaseController
  include CRUD

  after_action :delete_payment_methods, only: :create, if: -> { @success }

  def create
    card = PaymentService.create_payment_method('card', obj_params, current_user)

    @_obj = current_user.wedding.bank_cards.new(
      external_id: card.id,
      card_type: card.brand,
      full_name: card.name,
      number: "**** **** **** #{card.last4}",
      expiry_month: card['exp_month'],
      expiry_year: card['exp_year'],
    )

    if @success = @_obj.save
      render_common_response
    else
      render_422 obj
    end
  end

  private

  def collection
    @_collection ||= current_user.wedding.bank_cards
  end

  def obj_params
    params.require(:data).require(:attributes).permit(*%i(
      name
      number cvv
      exp_month exp_year
    ))
  end

  def serializer
    Client::BankCardSerializer
  end

  def delete_payment_methods
    old_cards = current_user.wedding.bank_cards.where.not(id: obj.id)
    card_ids = old_cards.pluck(:external_id)

    if card_ids.any?
      old_cards.destroy_all
      PaymentService.delete_payment_methods(card_ids, current_user)
    end
  end
end
