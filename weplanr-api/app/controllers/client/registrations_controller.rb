class Client::RegistrationsController < Client::BaseController
  include CRUD
  skip_before_action :authenticate!

  private

  def obj_class
    WeddingBuilder
  end

  def obj_params
    @_obj_params ||=
      begin
        metadata_event = params.require(:data).require(:attributes)[:metadata_event]
        params[:data].require(:attributes).permit(*%i(
          name firstname lastname phone email password
          date location budget
        )
          .push(metadata_event: metadata_event.present? ? metadata_event.keys : [])
          .push(vendor_ids: [])
        )
      end
  end

  # def serializer
  #   Client::ProfileSerializer
  # end
end
