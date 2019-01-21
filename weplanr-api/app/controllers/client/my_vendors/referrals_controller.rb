class Client::MyVendors::ReferralsController < Client::BaseController
  include CRUD

  def create
    @_obj = obj_class.new(obj_params)

    if obj.save
      ReferralMailer.referral(vendor, obj).deliver_now
      render_common_response
    else
      render_422 obj
    end
  end

  private

  def vendor
    @_vendor ||= current_user.vendors.find params[:my_vendor_id]
  end

  def collection
    obj_class.where(status: 'accepted')
  end

  def obj_params
     @_obj_params ||=
      params[:data].require(:attributes).permit(*%i(
        referred_email
      ))
  end

  def obj_class
    vendor.referrals
  end

  def serializer
    Client::ReferralSerializer
  end

  def serialize_array records=collection, each_serializer=serializer, meta={}
    {
      vendor_referral: vendor.referral_code.slice(*%w(code accumulated_credit current_credit)),
      meta: meta,
      data: records.map do |obj|
        json = serialize_obj(obj, each_serializer)
        json[:errors] = obj.errors.full_messages if obj.errors.any?

        json
      end
    }
  end
end