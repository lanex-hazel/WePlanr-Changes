require 'rails_helper'

describe 'PATCH /admin/features/:id' do

  let(:obj) { Feature.find 1 }

  it 'returns status 200' do
    auth_patch "/api/admin/features/#{obj.id}", data: {attributes: {status: 1}}
    expect(response.status).to eq 200
  end

end
