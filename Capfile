load 'deploy' if respond_to?(:namespace) # cap2 differentiator

default_run_options[:pty] = true

# be sure to change these
set :user, 'mike'
set :domain, 'watchmetrain.net'
set :application, 'watchmetrain'

# the rest should be good
set :repository,  "git@github.com:mgriffin/watchmetrain.git" 
set :deploy_to, "/var/www/watchmetrain"
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'to_php'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false
set :keep_releases, 3

server domain, :app, :web

namespace :deploy do
  task :restart do
    run "cd #{current_path} && composer install"
  end
end
