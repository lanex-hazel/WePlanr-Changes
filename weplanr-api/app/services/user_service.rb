class UserService

  class << self

    def create_user params
      user_params = params.permit(*%i(
          firstname lastname email phone password
        )
        .push(metadata_event: params[:metadata_event]? params[:metadata_event].keys : [] )
      )

      User.create(user_params)
    end

    def bulk_favorite params, user
      vendor_params = params.permit(vendor_ids: [])[:vendor_ids]
      vendors = Vendor.where(id: vendor_params)
      if vendors.present?
        vendors.each do |vendor_obj|
          Favorite.create(vendor: vendor_obj, user: user)
        end
      end
    end

  end

end
