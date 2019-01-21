class Reward < ApplicationRecord
  INITIAL_REWARD_FEE = 50
  SUCCEEDING_REWARD_FEE = 25
  belongs_to :wedding

  def add initial
    fee = initial ? INITIAL_REWARD_FEE : SUCCEEDING_REWARD_FEE
    self.credit += fee
  end

  def minus initial
    fee = initial ? INITIAL_REWARD_FEE : SUCCEEDING_REWARD_FEE
    self.credit -= fee
  end

  def self.state
    reward = Feature.find(3)
    reward.status
  end

end