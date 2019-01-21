class Admin::ReferralsController < Admin::BaseController
  include CRUD

  def update
    obj = Referral.find params[:id]
    obj.attributes = obj_params

    if obj.save(validate: false)
      render json: obj, serializer: serializer
    else
      render_422 obj
    end
  end

  def csv
    columns = %w(Referred\ By\ (First\ Name) Referred\ By\ (Last\ Name) Referred\ By\ (Email) Date\ of\ referral Gift\ card\ sent Notified Referred\ Vendor\ (Business Name) Referred\ Vendor\ (Email) Successful\ registration Date\ of\ registration)

    send_data(CSV.generate { |csv|
      csv << columns

      collection.each do |obj|
        referrer = obj.referrer
        referred_user = referrer.is_a?(Wedding) ? referrer.primary_account : referrer
        referred_vendor = obj.referred_vendor

        attr = [
          referred_user.firstname,
          referred_user.lastname,
          referred_user.email,
          obj.created_at.strftime('%-d %b, %Y %I:%M%p %Z'),
          obj.gift_card_sent ? 'Sent' : 'Pending',
          obj.notified ? 'Sent' : 'Pending',
          referred_vendor&.business_name,
          obj.referred_email,
          obj.registered_date ? 'Yes' : 'No',
          obj.registered_date&.strftime('%-d %b, %Y %I:%M%p %Z'),
        ]

        csv << attr
      end
    }, filename: Time.current.strftime('WePlanr Referrals - %-d %b, %Y %k:%M %Z.csv'))
  end

  def custom_auth_token_getter
    params.fetch(:t, false)
  end


  private
  
  def collection
    @_collection ||=
      begin
        result = collection_by_status(Referral)
        result = collection_by_referrer(result) if params[:referred_by]

        if created_since = params[:created_since]
          start_date = DateTime.parse(created_since)
          end_date = DateTime.parse(params[:created_until])

          result = result.where(created_at: start_date..end_date)
        end

        result.order(created_at: :desc)
      end
  end

  def collection_by_status records
    status = params[:status]

    if status && status == 'pending'
      records.pending
    elsif status && status == 'successful'
      records.successful
    else
      records
    end
  end

  def collection_by_referrer records
    referrer = params[:referred_by]

    if referrer.eql? 'customer'
      records.customer
    elsif referrer.eql? 'vendor'
      records.vendor
    end
  end

  def obj_params
    params.require(:data).require(:attributes).permit *%w(gift_card_sent notified)
  end

  def serializer
    Admin::ReferralSerializer
  end
end
