require 'rails_helper'

describe Vendor do

  context 'referral code' do

    it 'creates with business name' do
      expect {
        obj = Vendor.create business_name: 'WePlanr'
        expect(obj.referral_code).to be_present
      }.to change { ReferralCode.count }.by 1
    end

    it 'creates with no business name ' do
      expect {
        obj = Vendor.create
        expect(obj.referral_code).to be_present
      }.to change { ReferralCode.count }.by 1
    end

  end

  context 'update slug on business name change' do
    it 'updates slug too' do
      obj = Vendor.create business_name: 'First'

      expect {
        obj.business_name = 'SeCoNd'
        obj.save and obj.reload
      }.to change { obj.slug }.from('first').to 'second'
    end
  end

  context 'primary service' do
    let(:obj) { Vendor.create }

    it 'changes when assigned with valid internal_id' do
      expect {
        obj.update internal_id: '10.123'
      }.to change { obj.primary_service }
    end

    it 'does not change when assigned with invalid internal_id' do
      expect {
        obj.update internal_id: '20'
      }.not_to change { obj.primary_service }
    end

  end

  context 'internal_id' do
    let(:obj) { Vendor.create }
 
    it 'assigns when primary_service is added and increments service assigned_with' do
      expect {
        expect {
          obj.update primary_service: Category.first
        }.to change { obj.reload.internal_id }.to '1.1'
      }.to change { Category.first.vendors_assigned_with }.by 1
    end
 
    it 'not assigns when no primary_service is added' do
      expect(obj.internal_id).to be_blank
    end

    it 'returns custom error message' do
      obj.update internal_id: '1.1'

      vendor = Vendor.new internal_id: '1.1'
      vendor.save
    end
 
  end

  context 'business number' do

    xit 'validate thru abn lookup' do
      obj = Vendor.new business_number: '36080025038'
      expect(obj.valid?).to be_truthy

      obj2 = Vendor.new business_number: '123'
      expect(obj2.valid?).to be_falsy
    end

  end

  context 'Associations' do
    it "should have many unavailable dates" do
      t = Vendor.reflect_on_association(:unavailable_dates)
      expect(t.macro).to eq :has_many
    end

    it "should have many bookings" do
      t = Vendor.reflect_on_association(:bookings)
      expect(t.macro).to eq :has_many
    end
  end

end
