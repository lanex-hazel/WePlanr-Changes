class Client::TagsController < Client::BaseController

  def index
    render json: { data: collection }
  end

  private

  def collection
    ActsAsTaggableOn::Tag.where('LOWER(name) LIKE ?', "%#{params.fetch(:q, '').downcase}%").pluck(:name)
  end

end
