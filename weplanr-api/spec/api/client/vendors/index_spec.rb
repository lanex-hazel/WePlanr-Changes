require 'rails_helper'

describe 'GET /vendors' do

  let!(:sourcepad) { Vendor.create business_name: 'SourcePad', services: %w(Audio Entertainment), locations: %w(NSW WA SA Au\ Wide) }
  let!(:weplanr) { Vendor.create business_name: 'WePlanr', services: %w(Makeup Hair), locations: %w(NSW Australia\ Wide) }
  let!(:jabee) { Vendor.create business_name: 'Jollibee', services: %w(Audio Catering), locations: %w(NSW) }
  let!(:weplaner) { Vendor.create business_name: 'WePlaner', services: %w(BOXING), locations: %w(OTHER_LOCATION) }

  it 'returns status 200' do
    jabee.unavailable_dates.create date: Time.current
    get '/api/vendors'
    expect(response.status).to eq 200
  end

  it 'returns all vendors' do
    get '/api/vendors'
    expect(json_response['data'].count).to eq 4
  end

  context 'searching' do

    before do
      sourcepad.unavailable_dates.create(date: 1.year.from_now + 1.day, reason: 'closed')
      weplanr.unavailable_dates.create(date: 1.year.from_now, reason: 'fullybooked')
      jabee.unavailable_dates.create(date: 1.year.from_now, reason: 'fullybooked')
      weplaner.unavailable_dates.create(date: 1.year.from_now, reason: 'fullybooked')
    end

    it 'search by q' do
      get '/api/vendors', params: { q: 'WePlanr' }

      expect(json_response['data'].count).to eq 1
      expect(json_response['data'].map{ |d| d['attributes']['business_name']}).to include 'WePlanr'
    end

    it 'search q with services ' do
      get '/api/vendors', params: { q: 'Catering' }

      expect(json_response['data'].count).to eq 1
      expect(json_response['data'].map{ |d| d['attributes']['business_name']}).to include 'Jollibee'
    end

    it 'search q with locations ' do
      get '/api/vendors', params: { q: 'WA' }

      # expect(json_response['data'].count).to eq 1
      expect(json_response['data'].map{ |d| d['attributes']['business_name']}).to include 'SourcePad'
    end

    it 'search by services' do
      get '/api/vendors', params: { services: 'Catering Makeup' }

      expect(json_response['data'].count).to eq 2
    end

    it 'search by locations' do
      get '/api/vendors', params: { locations: 'South Wide' }

      expect(json_response['data'].count).to eq 1
      expect(json_response['data'].map{ |d| d['attributes']['business_name']}).to include 'WePlanr'
    end

    it 'search by available date' do
      get '/api/vendors', params: { date: 1.year.from_now.iso8601 }

      expect(json_response['data'].count).to eq 1
      expect(json_response['data'].map{ |d| d['attributes']['business_name']}).to include 'SourcePad'
    end

    it 'search by locations and services' do
      get '/api/vendors', params: { services: 'Audio', locations: 'NSW' }

      expect(json_response['data'].count).to eq 2
      expect(json_response['data'].map{ |d| d['attributes']['business_name']}).to include 'SourcePad', 'Jollibee'
    end

    it 'search by locations, services, and available date' do
      get '/api/vendors', params: { services: 'Audio', locations: 'NSW', date: 1.year.from_now.iso8601 }

      expect(json_response['data'].count).to eq 1
      expect(json_response['data'].map{ |d| d['attributes']['business_name']}).to include 'SourcePad'
    end

  end # searching

  context 'similarity searching' do
    let!(:putobooth) { Vendor.create business_name: 'Photography'  }
    let!(:putoshop) { Vendor.create business_name: 'random string', services: %w(Photography)  }

    it 'is not so strict' do
      get '/api/vendors', params: { q: 'photograph' }
      expect(json_response['data'].count).to eq 2

      #get '/api/vendors', params: { q: 'photobooth' }
      #expect(json_response['data'].count).to eq 1

      get '/api/vendors', params: { q: 'photo' }
      expect(json_response['data'].count).to eq 2

      get '/api/vendors', params: { q: 'photographer' }
      expect(json_response['data'].count).to eq 2

      #get '/api/vendors', params: { q: 'phooto' }
      #expect(json_response['data'].count).to eq 1
    end
  end

  context 'exact match' do
    let!(:putobooth) { Vendor.create business_name: 'Photography'  }
    let!(:putoshop) { Vendor.create business_name: 'random string', services: %w(Photography)  }

    it 'allows misspelled business name' do
      get '/api/vendors', params: { q: 'photg' }
      expect(json_response['data'].count).to eq 1

      get '/api/vendors', params: { q: 'brandon' }
      expect(json_response['data'].count).to eq 1
    end
  end

  context 'exact match' do
    let!(:putobooth) { Vendor.create business_name: 'Photography'  }
    let!(:putoshop) { Vendor.create business_name: 'random string', services: %w(Photography)  }

    it 'returns exact business name match only' do
      get '/api/vendors', params: { q: 'photography' }
      expect(json_response['data'].count).to eq 1
    end
  end

  context 'grouping' do

    it 'groups by service' do
      get '/api/vendors?group_by=service'
      expect(json_response['data']).to be_a Hash
    end

    it 'groups by location' do
      get '/api/vendors?group_by=location'
      expect(json_response['data']).to be_a Hash
    end

  end # grouping


  context 'pagination' do

    it 'returns correctly' do
      expect(Vendor.count).to eql 4

      auth_get '/api/vendors?page[size]=2&page[number]=1'
      expect(json_response['data'].count).to eq 2

      auth_get '/api/vendors?page[size]=3&page[number]=2'
      expect(json_response['data'].count).to eq 1
    end

  end # pagination
end
