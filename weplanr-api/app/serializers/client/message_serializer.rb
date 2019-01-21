class Client::MessageSerializer < ActiveModel::Serializer
  attributes :created_at

  attribute :conversation_uid do
    object.conversation.uid
  end

  attribute :content do
    object.content.gsub(/(?:\n\r?|\r\n?)/, '<br>') if object.content.present?
  end

  attribute :sent_by do
    object.user_id ? 'user' : 'vendor'
  end

  attribute :quote do
    quote.attributes.slice(*%w(id status total created_at quote_no)).merge(total: quote.total) if quote
  end

  attribute :invoice do
    quote.invoices.order(created_at: :asc).pluck(*%i(invoice_no)) if quote
  end

  def quote
    @_quote ||= object.quote
  end
end
