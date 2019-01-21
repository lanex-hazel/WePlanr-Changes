class Client::CategoriesController < Client::BaseController
  skip_before_action :authenticate!

  def index
    render json: { data: collection }
  end

  def show
    render json: { data: serializer(obj) }
  end

  private

  def collection
    obj_class.all.map do |category|
      serializer(category)
    end
  end

  def obj_class
    Category
  end

  def obj
    @_obj ||= obj_class.find(params[:id])
  end

  def serializer category
    {
      id: category.id,
      name: category.name,
      order_rank: category.order_rank,
      services: category.services.pluck(:name)
    }
  end

end
