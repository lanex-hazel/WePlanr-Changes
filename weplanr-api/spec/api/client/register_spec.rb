require 'rails_helper'

describe 'POST /register' do

  let!(:vendor) { Vendor.create business_name: 'SourcePad' }

  context 'valid' do

    let(:valid_params) do
      {
        data: {
          attributes: {
            name: 'SourcePad',
            email: 'sp@gmail.com',
            password: '123',
            date: 1.year.from_now,
            location: 'Sydney',
            budget: 5000,
            phone: 5000,
            metadata_event: {current_state: 'dashboard'},
            vendor_ids: [vendor.id]
          }
        }
      }
    end

    it 'returns status 201' do
      post '/api/register', params: valid_params
      expect(response.status).to eq 201
    end

    it 'creates user' do
      expect {
        post '/api/register', params: valid_params
      }.to change { User.count }.by 1
    end

    it 'creates wedding' do
      expect {
        post '/api/register', params: valid_params
      }.to change { Wedding.count }.by 1
    end

    it 'assigns outstanding todo' do
      expect {
        post '/api/register', params: valid_params
      }.to change { OutstandingTodo.count }
    end

    it 'assigns user\'s favorite vendors' do
      expect {
        post '/api/register', params: valid_params
      }.to change { Favorite.count }
    end

  end # end of context


  context 'invalid' do

    let(:invalid_params) do
      {
        data: {
          attributes: {
            email: 'sp',
          }
        }
      }
    end

    it 'returns status 422' do
      post '/api/register', params: invalid_params
      expect(response.status).to eq 422
    end

    it 'does not change db' do
      expect {
        post '/api/register', params: invalid_params
      }.not_to change { User.count }
    end

  end

end
