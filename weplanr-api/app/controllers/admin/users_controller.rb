class Admin::UsersController < Admin::BaseController
  include CRUD

  def index
    super(
      confirmed_count: params[:status].eql?('unconfirmed') ? 0 : collection_all_status.confirmed.count,
      unconfirmed_count: params[:status].eql?('confirmed') ? 0 : collection_all_status.unconfirmed.count,
    )
  end

  def csv
    send_data(CSV.generate { |csv|
      csv << %w(First\ Name Last\ Name Verified Email Mobile\ Number Date\ Joined Last\ Seen)

      collection.each do |obj|
        attr = [
          obj.firstname,
          obj.lastname,
          obj.is_confirmed ? 'Yes' : 'No',
          obj.email,
          obj.phone,
          obj.created_at.strftime('%-d %b, %Y %I:%M%p %Z'),
          obj.last_activity_at&.strftime('%-d %b, %Y %I:%M%p %Z'),
        ]

        csv << attr
      end
    }, filename: Time.current.strftime('WePlanr Users - %-d %b, %Y %k:%M %Z.csv'))
  end


  def custom_auth_token_getter
    params.fetch(:t, false)
  end


  private
  
  def obj_class
    User
  end

  def collection
    @_collection ||= collection_by_status(collection_all_status)
  end

  def collection_all_status
    @_all_status_collection ||=
      begin
        result =
          if cname = params[:customer_name]
            User.customers.search_by_fullname(cname)
          else
            User.customers
          end

        result = collection_by_date(result, :created_at, :created) if params[:created_since]
        result = collection_by_date(result, :last_activity_at, :active) if params[:active_since]

        result.order('created_at DESC')
      end
  end

  def collection_by_status(records=User)
    case params[:status]
    when 'confirmed'
      records.confirmed
    when 'unconfirmed'
      records.unconfirmed
    else
      records
    end
  end

  def collection_by_date records, condition_key, param_key
    start_date = DateTime.parse(params["#{param_key}_since"])
    end_date = DateTime.parse(params["#{param_key}_until"])

    condition = {}
    condition[condition_key] = start_date..end_date

    records.where(condition)
  end


  def obj_params
    params.require(:data).require(:attributes).permit *%w(
      firstname lastname email phone password
    )
  end

  def serializer
    Admin::UserSerializer
  end
end
