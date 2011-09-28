RUBY_PATH = "/opt/ruby-1.8.7-p299/bin"

target = ENV["target"]

if target.nil?
  target = "staging"
  puts "No target variable set, using '#{target}'."
end

set :rails_env, target

set :application, "liminal-apparel"

set :scm, :git
set :repository, "git@github.com:iviney/liminal-apparel.git"

set :user, "rails"
set :use_sudo, false
set :deploy_to, "/var/www/rails/liminal-apparel/#{target}".tap { |r| p r }
set :deploy_via, :remote_cache

host = "test.store.liminal.org.nz"

role :web, host
role :app, host
role :db,  host, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# Bundler deployment setup
require 'bundler/capistrano'

# Sharing sqlite database file
set(:shared_database_path) { "#{shared_path}/databases" }
set(:shared_config_path) { "#{shared_path}/config" }
namespace :sqlite3 do
  desc "Make shared folders: databases and config"
  task :make_shared_folder, :roles => :db do
    run "mkdir -p #{shared_database_path}"
    run "mkdir -p #{shared_config_path}"
  end

  desc "Generate a database configuration file"
  task :build_configuration, :roles => :db do
    db_options = {
      "adapter"  => "sqlite3",
      "database" => "#{shared_database_path}/#{target}.sqlite3",
      "timeout"  => 5000
    }
    config_options = { target => db_options }.to_yaml
    put config_options, "#{shared_config_path}/sqlite_config.yml"
  end

  desc "Links the configuration file"
  task :link_configuration_file, :roles => :db do
    run "ln -nsf #{shared_config_path}/sqlite_config.yml #{release_path}/config/database.yml"
  end
end

after "deploy:setup", "sqlite3:make_shared_folder"
after "deploy:setup", "sqlite3:build_configuration"
 
after "deploy", "sqlite3:link_configuration_file"
after "sqlite3:link_configuration_file", "deploy:restart"
