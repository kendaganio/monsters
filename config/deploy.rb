require 'bundler/capistrano'

# basic shit
set :user, "ken"
set :application, "monsters"
server "50.56.246.165", :web, :app, :db, primary: true

# git stuff
set :repository, "git@github.com/kendaganio:monsters.git"
set :scm, :git
set :branch, :master

# deploy specific shit
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache


# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

set :use_sudo, :false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
