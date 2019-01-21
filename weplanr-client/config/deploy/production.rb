server '10.0.1.84',
       user: 'deploy',
       roles: %w{app db web background},
       ssh_options: {
          proxy: Net::SSH::Proxy::Command.new('ssh -W %h:%p master@13.55.137.180')
       }

set :stage, :production
set :branch,    'production'
set :deploy_to, '/home/deploy/client'
