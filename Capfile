load 'deploy' if respond_to?(:namespace) # cap2 differentiator

default_run_options[:pty] = true

# be sure to change these
set :user, 'mikegriffin'
set :domain, 'watchmetrain.net'
set :application, 'watchmetrain'

# the rest should be good
set :repository,  "git@github.com:mgriffin/watchmetrain.git" 
set :deploy_to, "/home/#{user}/watchmetrain"
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

server domain, :app, :web

namespace :deploy do
  task :restart do
    run "cp /home/#{user}/watchmetrain/db.rb #{current_path}/db.rb"
    run "touch #{current_path}/tmp/restart.txt" 
  end
end