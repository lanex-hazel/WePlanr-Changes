module SearchConcern
  extend ActiveSupport::Concern

  def apply_search records
    records = records.searchable

    if search_query.present?
      records = records.search(search_query)
    end

    if (service_filter = params[:services]).present?
      records = records.search_by_services(service_filter)
    end

    if (location_filter = params[:locations]).present?
      records = records.search_by_locations(location_filter)
    end

    if (date_filter = params[:date]).present?
      records = records.search_by_date(Date.parse(date_filter))
    end

    records 
  end

  def filter_by_creation_date data
    filter_by_date(data,
      attr: :created_at,
      date_since: params[:created_since],
      date_until: params[:created_until],
    )
  end

  def filter_by_updated_date data
    filter_by_date(data,
      attr: :updated_at,
      date_since: params[:created_since],
      date_until: params[:created_until],
    )
  end

  def filter_by_date data, attr: :created_at, date_since: nil, date_until: nil
    if date_since && date_until
      start_date = DateTime.parse(date_since)
      end_date = DateTime.parse(date_until)

      filters = {}
      filters[attr] = start_date..end_date

      data.where(filters)
    else
      data
    end
  end

  def search_query
    #params[:q].to_s.split.join('+')
    params[:q].to_s
  end
end
