# config valid only for current version of Capistrano
lock '3.10.0'

set :application, 'weplanr-api'
set :repo_url, 'git@github.com:WePlanr/weplanr-api.git'

set :deploy_to, '/home/deploy/app'
set :ssh_options, { forward_agent: true }

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 1

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }


namespace :puma do
  desc 'Says a message when deployment complete'
  task :notice_me_senpai do
    system("\\say Notice me sen pie!")
  end
  after :restart, :notice_me_senpai
end
