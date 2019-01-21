# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: true, logger: (-> {Rails.logger }) do
  allow do
    #origins 'localhost:3000', 'localhost:3001',
            #'http://weplanr.spstage.com', 'http://admin.weplanr.spstage.com',
            #'http://uat.weplanr.com', 'http://admin.weplanr.com',
            #'http://www.weplanr.com', 'http://weplanr.com',
            #'https://www.weplanr.com', 'https://weplanr.com', 'https://admin.weplanr.com'
    origins '*'
    resource '*',
      headers: :any,
      methods: %i(get post put patch delete options head),
      max_age: 0
  end
end
