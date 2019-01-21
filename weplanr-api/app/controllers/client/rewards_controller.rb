class Client::RewardsController < Client::BaseController
  include CRUD

  private

  def obj
    current_user.wedding.reward
  end

  def serializer
    Client::RewardSerializer
  end
end
