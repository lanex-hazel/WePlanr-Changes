server '10.0.1.188',
       user: 'deploy',
       roles: %w{app db web background},
       ssh_options: {
          proxy: Net::SSH::Proxy::Command.new('ssh -W %h:%p weplanr@52.70.111.48')
       }

set :stage, :staging
set :branch,    'master'
set :deploy_to, '/home/deploy/admin'
