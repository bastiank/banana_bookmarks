require "bundler/capistrano"

#default_environment['SSL_CERT_FILE'] = "/srv/runner/cacert.pem"

set :rvm_ruby_string, 'ruby-1.9.2-p180'
require "rvm/capistrano"


set :application, "Bookmarks"

#set :git_server_name, "git.event.gd"
#set :user, "runner"

ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:bastiank/banana_bookmarks.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :deploy_to, "/home/bastian/rails_apps/bookmarks"

role :web, "bookmarks.arrowsoft.de"                          # Your HTTP server, Apache/etc
role :app, "bookmarks.arrowsoft.de"                          # This may be the same as your `Web` server
role :db,  "bookmarks.arrowsoft.de", :primary => true # This is where Rails migrations will run

after "deploy", "deploy:cleanup" # keep only the last 5 releases

#require "delayed/recipes"                   
#after "deploy:stop",    "delayed_job:stop" 
#after "deploy:start",   "delayed_job:start" 
#after "deploy:restart", "delayed_job:restart"


namespace :deploy do
  task :link_db do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :symlink_uploads do
    run "ln -nfs #{shared_path}/uploads  #{release_path}/public/uploads"
  end
end
after 'deploy:update_code', 'deploy:symlink_uploads'
after "deploy:update_code", "deploy:link_db"

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
#
require 'capistrano-unicorn'
load 'deploy/assets'
