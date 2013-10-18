
require 'bundler/capistrano'

set :application, "todoapp"
set :repository, "git@github.com:fms-serin/todoapp.git"
set :deploy_to, "/var/www/todoapp"

set :scm, :git
set :branch, "master"

set :user, "server_user"
set :use_sudo, false
set :rails_env, "production"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true, :port => 22 }
set :keep_releases, 5

default_run_options[:pty] = true
server "10.0.1.121", :app, :web, :db, :primary => true


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end

  desc "Restart applicaiton"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before "deploy:assets:precompile" do
  run ["ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml",
       "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml",
       "ln -fs #{shared_path}/uploads #{release_path}/uploads"
  ].join(" && ")
end

after "deploy", "deploy:restart"
after "deploy", "deploy:cleanup"