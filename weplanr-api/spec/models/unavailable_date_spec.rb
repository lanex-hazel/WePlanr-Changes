require 'rails_helper'

describe UnavailableDate do

  let!(:vendor) { auth_user.vendors.create business_name: 'PadSource' }

  it 'is valid with valid attributes' do
    expect(UnavailableDate.new(date: Date.today, reason:'fullybooked')).to be_valid
  end

  it  'is not valid without a date and reason' do
    expect(UnavailableDate.new(date: nil, reason: nil)).to_not be_valid
  end

  it 'only accepts reason fullybooked or closed' do
    expect(UnavailableDate.new(date: Date.today, reason:'vacation')).to_not be_valid
  end

  context "Associations" do
    it "should belong to a vendor" do
      t = UnavailableDate.reflect_on_association(:vendor)
      expect(t.macro).to eq :belongs_to
    end
  end

  context '.get_by_reason' do
    it 'should return dates that are closed' do
      vendor.unavailable_dates.create date: Date.today, reason: 'fullybooked'
      vendor.unavailable_dates.create date: Date.today + 1, reason: 'closed'
      vendor.unavailable_dates.create date: Date.today - 1, reason: 'closed'
      
      result = UnavailableDate.get_by_reason('closed')

      expect(result.count).to eq 2
    end

    it 'should return dates that are fullybooked' do
      vendor.unavailable_dates.create date: Date.today, reason: 'fullybooked'
      vendor.unavailable_dates.create date: Date.today + 1, reason: 'closed'
      vendor.unavailable_dates.create date: Date.today - 1, reason: 'closed'
      
      result = UnavailableDate.get_by_reason('fullybooked')

      expect(result.count).to eq 1
    end

  end
end
