set :rails_env, 'production'
server '10.0.1.84',
  user: 'deploy',
  roles: %w{web app db},
  ssh_options: {
    proxy: ::Net::SSH::Proxy::Command.new('ssh -W %h:%p master@13.55.137.180')
  }

set :branch, 'production'
