class Client::InvoicesController < Client::BaseController
  include CRUD
  include SearchConcern

  def show
    render json: obj, serializer: Client::InvoiceDetailsSerializer
  end

  private

  def collection
    @_collection ||=
      begin
        result = obj_class.order(updated_at: :desc)
        result = result.search_by_status(params[:status]) if params[:status].present?


        if params[:action] == 'index'
          filter_by_updated_date(result)
        else
          result
        end
      end
  end

  def serializer
    Client::InvoiceSerializer
  end

  def obj
    @_obj ||=
      begin
        if current_user.is_vendor?
          Invoice.where(vendor_id: current_user.vendors.pluck(:id)).find(params[:id])
        else
          Invoice.where(wedding: current_user.wedding).find(params[:id])
        end
      end
  end

  def obj_class
    current_user.vendor.invoices
  end
end
