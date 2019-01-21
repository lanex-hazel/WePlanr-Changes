class Admin::BaseController < ApplicationController
  include CommonErrors
  include HttpAuthConcerns

  def model_class
    Admin
  end
end
