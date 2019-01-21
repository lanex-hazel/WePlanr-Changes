require 'net/ssh/proxy/command'
require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL


SSHKit.config.output_verbosity = :debug


puts ARGV
settings =
  case ARGV[0]
  when 'master'
    {bastion: 'weplanr@52.70.111.48', app: 'deploy@10.0.1.188'}
  when 'production'
    {bastion: 'master@13.55.137.180', app: 'deploy@10.0.1.84'}
  end

SSHKit::Backend::Netssh.configure do |ssh|
  ssh.ssh_options = {
    proxy: Net::SSH::Proxy::Command.new("ssh -W %h:%p #{settings[:bastion]}")
  }
end

run_locally do
  execute 'gulp --no-color && cp -r vendor dist/vendor'
  execute 'cd dist/scripts && gzip -k -9 *'
  execute 'cd dist/styles && gzip -k -9 *'
  execute 'env GZIP=-9 tar -zcvf dist.tar.gz dist'
end

on "#{settings[:app]}" do
  as 'deploy' do
    upload! 'dist.tar.gz', '/home/deploy/admin/current'
    execute 'rm -r /home/deploy/admin/current/dist && cd /home/deploy/admin/current && tar xvf dist.tar.gz'
  end
end

run_locally do
  execute 'rm dist.tar.gz'
end

