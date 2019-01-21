class PagesController < ApplicationController

  def index
    render json: {
      data: {
        attributes: obj ? obj.attributes.slice('content') : {content: ''}
      }
    }
  end

  def not_found
    render json: {}, status: 404
  end


  private

  def obj
    @_obj ||=
      begin
        site = CamaleonCms::Site.first.decorate
        site.the_posts.select(:content).where(id: site.options[:home_page]).first
      end
  end
end
