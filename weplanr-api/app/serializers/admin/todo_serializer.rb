class Admin::TodoSerializer < ActiveModel::Serializer
  attributes *%i(
    name
    timing_min_month timing_max_month
    suggestion_copy reminder_copy question_copy redirect_copy
  )
end
