class WeddingBuilder

  attr_reader :params, :wedding, :user

  def initialize params
    @params = params
  end

  def save
    Wedding.transaction do
      create_user
      create_wedding
      assign_outstanding_todo
      assign_favorite_vendors
      create_reward_credit
      wedding.settings.notify_msg_always.first_or_create

      if valid?
        UserMailer.send_confirmation(user).deliver_now

        admin_notif = AdminNotification.new(user: user, description: 'new user signed up')
        AdminMailer.inform_new_customers([admin_notif]).deliver_now!

        return true
      else
        raise ActiveRecord::Rollback
      end
    end
  end

  def valid?
    user.valid? && wedding.valid?
  end

  def errors
    _errors = [user&.errors, wedding&.errors].flatten.compact
    _errors.find(&:any?) || User.new.errors
  end


  private


  def create_user
    @user = UserService.create_user params
  end

  def create_wedding
    wedding_params = params.permit(*%i(date location budget))
    wedding_params[:budget] ||= 0
    @wedding = user.create_wedding(wedding_params)
    user.save
  end

  def assign_outstanding_todo
    user.wedding.create_outstanding_todo todo: user.pending_todos.order(timing_max_month: :desc, timing_min_month: :desc).first
  end

  def assign_favorite_vendors
    UserService.bulk_favorite(params, user)
  end

  def create_reward_credit
    Reward.create(wedding: wedding)
  end

  def method_missing(method, *args, &block)
    user.send method, *args, &block
  end

end
