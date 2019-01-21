require 'rails_helper'

describe Booking do

  let!(:vendor) { auth_user.vendors.create business_name: 'PadSource' }

  it 'is valid with valid attributes' do
    expect(Booking.new(schedule: Time.now)).to be_valid
  end

  it  'is not valid without a date' do
    expect(Booking.new(schedule: nil, client: 'SP')).to_not be_valid
  end

  context "Associations" do
    it "should belong to a vendor" do
      t = Booking.reflect_on_association(:vendor)
      expect(t.macro).to eq :belongs_to
    end
  end

  context '.eventDay' do
    it 'should return schedule to YYYY-MM-DD format' do
      vendor.bookings.create schedule: "2017-06-11 10:58:00", client: 'WePlanr'

      result = Booking.first.eventDay

      expect(result).to eq "2017-06-11"
    end
  end

   context '.eventDate' do
    it 'should return schedule to DD.MM.YYYY format' do
      vendor.bookings.create schedule: "2017-06-11 10:58:00", client: 'WePlanr'

      result = Booking.first.eventDate

      expect(result).to eq "11.06.2017"
    end
  end
end