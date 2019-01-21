class Client::ProfileSerializer < ActiveModel::Serializer
  attributes *%i(
    firstname lastname email phone
    wedding_details role
    is_vendor uid
    user_settings reset_password_token referral_code
  )

  attribute :profile_photo do
    if wedding
      wedding.avatar_photo
    else
      object.profile_photo.url
    end
  end

  attribute :internal_id do
    "CUS-#{object.id.to_s.rjust(6, '0')}"
  end

  attribute :auth_token do
    object.auth_tokens.last&.token
  end

  attribute :partner do
    object.partner&.attributes&.slice(*%w(firstname lastname email role))
  end

  attribute :msg_notif_setting do
    next 'off' unless wedding

    setting = wedding.settings.msg_notif_setting.first
    setting ? setting.value : 'off'
  end


  attribute :outstanding_todo do
    outstanding_todo = wedding&.outstanding_todo
    todo = outstanding_todo&.todo

    {
      name: todo.name,
      views: outstanding_todo.views,
      redirect_copy: todo.redirect_copy,
      question_copy: todo.question_copy,
      reminder_copy: todo.reminder_copy,
      suggestion_copy: todo.suggestion_copy,
    } if todo
  end

  def wedding_details
    wedding ? wedding.attributes.slice(*%w(location budget date no_of_guests uid)) : {}
  end

  def is_vendor
    object.is_vendor?
  end

  def user_settings
    obj = object.metadata_event
    remind_dashboard = false

    if object.welcome_flg
      remind_dashboard = true
      object.set_welcome_flag
    end

    recalculate_planned = wedding.present? ? wedding.budgets.count > 0 : false

    {
      customised: wedding&.is_personalised?,
      remind_user: remind_dashboard,
      state: obj['current_state'],
      pending_enquiry: obj['vendor_id'],
      keyword_search: obj['keyword_search'],
      continue: obj['continue'],
      recalculate_planned: recalculate_planned
    }
  end

  attribute :referral_code do
    wedding&.referral_code&.code
  end

  def wedding
    @_wedding ||= object.wedding
  end

end
