set :application, "kalugamap"
set :repository,  "kalugamap@s1.alno.name:/home/kalugamap/git/kalugamap"

set :user, "kalugamap"
set :use_sudo, false
set :deploy_to, "/home/kalugamap/apps/kalugamap"

set :whenever_command, "bundle exec whenever"
set :whenever_identifier, defer { application }
set :whenever_options, :roles => :db, :only => { :primary => true }

server "s1.alno.name", :web, :app, :db, :primary => true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :scm, :git

default_environment['RAILS_ENV'] = 'production'

require 'bundler/capistrano'

namespace :deploy do

  desc "Restarting application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} ; script/delayed_job restart"
    thinking_sphinx.restart
  end

  task :start, :roles => :app do
    run "cd #{current_path} ; script/delayed_job stop; script/delayed_job start"
    thinking_sphinx.restart
    unicorn.start
  end

  after "deploy:migrate", :roles => :app do
    restart
  end
end

after "deploy:update_code", roles => :app do

  # Create base configs from samples
  ['database', 'sphinx', 'mapapp'].each do |config|
    run "yes n | cp -i #{release_path}/config/#{config}.yml.sample #{shared_path}/config/#{config}.yml"
    run "ln -nfs #{shared_path}/config/#{config}.yml #{release_path}/config/#{config}.yml"
  end

  # Link unicorn config
  run "mkdir -p #{release_path}/config/unicorn"
  run "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn/production.rb"

  # Link tiles and sphinx directories
  run "ln -nfs #{shared_path}/tiles  #{release_path}/public/tiles"
  run "ln -nfs #{shared_path}/sphinx #{release_path}/db/sphinx"

  run "cd #{release_path} && bundle exec rake osm:import UPDATE=1"
  thinking_sphinx.configure
end

load 'deploy/assets'

require 'capistrano-unicorn'
require 'whenever/capistrano'
require 'thinking_sphinx/deploy/capistrano'
