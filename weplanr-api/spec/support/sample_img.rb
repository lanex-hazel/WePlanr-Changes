def sample_img
  file_path = Rails.root.join(*%w(spec fixtures sample.jpg))
  file = fixture_file_upload(file_path, 'image/jpeg')
end
