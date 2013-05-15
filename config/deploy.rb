require 'bundler/capistrano'
require 'rvm/capistrano'

# basic shit
set :user, "ken"
set :application, "monsters"
server "50.56.246.165", :web, :app, :db, primary: true

set :rvm_ruby_string, '1.9.3@monsters'
# git stuff
set :repository, "git@github.com:kendaganio/monsters.git"
set :scm, :git
set :branch, :master

# deploy specific shit
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache

# Fix permissions
=begin
before "deploy:start", "deploy:fix_permissions"
after "deploy:restart", "deploy:fix_permissions"
=end

# if you want to clean up old releases on each deploy uncomment this:
before("deploy:cleanup") { set :use_sudo, false }
after "deploy:restart", "deploy:cleanup"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false

namespace :deploy do

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
  end
  after "deploy:setup", "deploy:setup_config"

end
