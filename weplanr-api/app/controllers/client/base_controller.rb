class Client::BaseController < ApplicationController
  include CommonErrors
  include HttpAuthConcerns
end
