class Client::TransactionsController < Client::BaseController
  include CRUD

  private

  def collection
    current_user.vendor.transactions.order('created_at DESC')
  end

  def serializer
    Client::TransactionSerializer
  end
end
