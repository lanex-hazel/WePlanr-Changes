class Client::QuotesController < Client::BaseController
  include CRUD
  include SearchConcern

  def show
    render json: obj, serializer: Client::QuoteDetailsSerializer
  end

  def draft
    @_obj = vendor.quotes.drafts.where(wedding_id: params[:wedding_id]).first_or_initialize
    show
  end

  def create
    @_obj = QuoteBuilder.new(vendor, wedding, obj_params)

    if obj.save
      render_common_response
    else
      render_422 obj
    end
  end

  def accept
    @_obj = QuoteKeeper.new(wedding_quote)

    if obj.accept
      render_common_response
    else
      render_422 obj
    end
  end

  def fulfill
    @_obj = QuoteKeeper.new(wedding_quote)

    if obj.fulfill
      render json: obj, serializer: Client::QuoteDetailsSerializer
    else
      render_422 obj
    end
  end

  def reject
    if wedding_quote.reject
      render json: wedding_quote, serializer: serializer
    else
      render_422 wedding_quote
    end
  end


  private

  def obj
    @_obj ||=
      begin
        if current_user.is_vendor?
          Quote.where(vendor_id: current_user.vendors.pluck(:id)).find(params[:id])
        else
          Quote.where(wedding: current_user.wedding).find(params[:id])
        end
      end
  end

  def wedding_quote
    @_wed_quote ||= current_user.wedding.quotes.find params[:id]
  end

  def obj_params
    params.require(:data).require(:attributes)
  end

  def serializer
    Client::QuoteSerializer
  end

  def obj_class
    vendor.quotes
  end

  def collection
    @_collection ||=
      begin
        data = obj_class.includes(:transactions).order(created_at: :desc)
        status = params[:status]
        if status.present? && status != 'accepted'
          data = data.search_by_status(status)
        elsif status.present? && status == 'accepted'
          data = data.booked
        end
        filter_by_creation_date(data)
      end
  end

  def vendor
    current_user.vendors.find params[:my_vendor_id]
  end

  def wedding
    Wedding.find obj_params[:wedding_id]
  end

end
