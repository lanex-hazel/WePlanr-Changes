module CRUD
  extend ActiveSupport::Concern
  include ArraySerializer
  include Paginator

  SUCCESS_STATUSES = {
    'create' => 201,
    'update' => 200,
    'delete' => 204
  }


  def index(extra_meta={})
    meta = { record_count: collection.count }.merge(extra_meta)

    records =
      if params[:page]
        paginate(collection, params[:page])
      else
        collection
      end

    render json: serialize_array(records, serializer, meta)
  end

  def show
    render json: obj, serializer: serializer
  end

  def create
    @_obj = obj_class.new(obj_params)

    if obj.save
      render_common_response
    else
      render_422 obj
    end
  end

  def update
    obj.update obj_params
    render_common_response
  end

  def destroy
    obj.destroy
    render json: nil, status: 204
  end


  #=====================
  #  Non-routes methods
  #=====================

  def render_common_response
    if obj.valid?
      render json: obj, serializer: serializer, status: SUCCESS_STATUSES[params[:action]]
    else
      render_422 obj
    end
  end

  def obj
    @_obj ||= begin
                id = params[:id] || params[:data].try(:[], :id)
                obj_class.find(id) if id
              end
  end

  def obj_class
    collection
  end

  # TODO: uncomment if already needed
  #def collection
    #@_collection ||= obj_class.all
  #end

  def serializer; end
end
