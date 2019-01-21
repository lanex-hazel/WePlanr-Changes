def sample_csv
  path = Rails.root.join(*%w(spec fixtures vendors.csv))
  fixture_file_upload(path, 'text/csv')
end
