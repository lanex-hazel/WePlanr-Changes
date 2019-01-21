require 'rails_helper'

describe 'POST /admin/vendors/csv_upload' do

  it 'changes database' do
    expect {
      auth_post '/api/admin/vendors/csv_upload', file: sample_csv
    }.to change { Vendor.count }.by 4
  end

  it 'saves right business name' do
    auth_post '/api/admin/vendors/csv_upload', file: sample_csv

    created_business_names = json_response['data'].map{ |d| d['attributes']['business_name'] }
    expect(created_business_names).to include('Possum Creek Studios', 'Melissa Hope Hair and Makeup', 'Larissa McKay Music')
  end

  it 'not create duplicate vendor' do
    auth_post '/api/admin/vendors/csv_upload', file: sample_csv

    expect {
      auth_post '/api/admin/vendors/csv_upload', file: sample_csv
    }.not_to change{ Vendor.count }
  end

end
