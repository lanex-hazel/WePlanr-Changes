require 'rails_helper'
include FeeCalculator

describe FeeCalculator, type: :request do
  context '#calculate_weplanr_fee' do
    it 'returns correct for 8.25%' do
      expect(calculate_weplanr_fee( 260.00 )).to eq 21.15
    end

    it 'returns correct for 2.25%' do
      expect(calculate_weplanr_fee(  10500.00  )).to eq 235.95
    end
  end
end