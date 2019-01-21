require 'rails_helper'

describe 'PATCH /my_vendors/:id' do

  context 'by vendor owner' do
    let(:vendor) { auth_user.vendors.create business_name: 'SourcePad' }

    let(:valid_params) do
      {
        data: {
          attributes: {
            business_name: 'Changed 1',
            tags: %w(photo weplanr awoo),
            social_channels: {
              facebook: 'this'
            }
          }
        }
      }
    end

    it 'returns status 200' do
      auth_patch "/api/my_vendors/#{vendor.id}", valid_params
      expect(response.status).to eq 200
    end

    it 'updates db' do
      expect {
        auth_patch "/api/my_vendors/#{vendor.id}", valid_params
      }.to change{ vendor.reload.business_name }.from('SourcePad').to 'Changed 1'
    end

    context 'with pricing_and_packages' do
      let!(:pricing) { vendor.pricing_and_packages.create(name: 'Consultation', price: 5.00) }

      let(:valid_params_with_pricings) {
        new_params = valid_params

        new_params[:data][:attributes][:pricing_and_packages] = [
          {id: pricing.id, name: 'Development'},
          {name: 'Happiness', price: 999},
        ]
        new_params
      }

      it 'save pricing_and_packages' do
        expect {
          expect {
            auth_patch "/api/my_vendors/#{vendor.id}", valid_params_with_pricings
          }.to change{ pricing.reload.name }.from('Consultation').to 'Development'
        }.to change{ vendor.pricing_and_packages.count }.by 1

        expect(PricingAndPackage.last.name).to eq 'Happiness'
        expect(PricingAndPackage.last.price).to eq 999
      end

    end
  end # by vendor owner

  context 'not by vendor owner' do
    let(:vendor) { Vendor.create business_name: 'SourcePad' }

    let(:valid_params) do
      {
        data: {
          attributes: {
            business_name: 'Changed 1'
          }
        }
      }
    end

    it 'returns status 404' do
      auth_patch "/api/my_vendors/#{vendor.id}", valid_params
      expect(response.status).to eq 404
    end

    it 'not updates db' do
      expect {
        auth_patch "/api/my_vendors/#{vendor.id}", valid_params
      }.not_to change{ vendor.reload.business_name }
    end

  end # not by vendor owner
end
