class Admin::RewardTransactionsController < Admin::BaseController
  include CRUD
  include SearchConcern

  attr_accessor :current_user

  def update
    obj = RewardTransaction.find params[:id]
    @current_user = obj.wedding
    reward = current_user.reward
    obj.attributes = obj_params

    handle_credit reward

    if obj.save && reward.save
      render json: obj, serializer: serializer
    else
      render_422 obj
    end
  end

  def csv
    columns = %w(Customer\ (Email) Transaction\ Amount Datetime Gift\ card\ sent Notified)

    send_data(CSV.generate { |csv|
      csv << columns

      collection.each do |obj|
        attr = [
          obj.wedding.primary_account.email,
          "$ %.2f" % obj.quote.total,
          obj.created_at.strftime('%-d %b, %Y %I:%M%p %Z'),
          obj.gift_card_sent ? 'Sent' : 'Pending',
          obj.notified ? 'Sent' : 'Pending'
        ]

        csv << attr
      end
    }, filename: Time.current.strftime('WePlanr Rewards - %-d %b, %Y %k:%M %Z.csv'))
  end

  def custom_auth_token_getter
    params.fetch(:t, false)
  end


  private

  def handle_credit reward
    if obj_params[:gift_card_sent]
      reward.add current_user.reward_transactions.sent.count == 0
    else
      reward.minus current_user.reward_transactions.sent.count == 1
    end
  end
  
  def collection
    @_collection ||= filter_by_creation_date(RewardTransaction).order(created_at: :desc)
  end

  def obj_params
    params.require(:data).require(:attributes).permit *%w(gift_card_sent notified)
  end

  def serializer
    Admin::RewardTransactionSerializer
  end
end
