# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require "rvm/capistrano"
require "bundler/capistrano"

set :rvm_ruby_string, '1.9.2'

set :application, "molawson"
set :repository,  "git://github.com/molawson/molawson.git"

set :scm, :git

set :user, "deploy"
set :use_sudo, false

set :deploy_to, "/var/apps/molawson/"
set :deploy_via, :remote_cache

role :web, "50.57.182.246"
role :app, "50.57.182.246"
role :db,  "50.57.182.246", :primary => true

namespace :deploy do
  task :start do ; end
  
  task :stop do ; end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :create_config_files do
    default_admin_login = <<-EOF
    USERNAME: #{user}
    PASSWORD: #{password}
    EOF
    
    admin_login = ERB.new(default_admin_login)

    run "mkdir -p #{shared_path}/config" 
    put admin_login.result, "#{shared_path}/config/admin_login.yml"

    default_newrelic = <<-EOF
    common: &default_settings
      license_key: 'secretstring'
      app_name: molawson
      monitor_mode: true
      developer_mode: false
      log_level: info
      ssl: false
      apdex_t: 0.5
      capture_params: false
      transaction_tracer:
        enabled: true
        transaction_threshold: apdex_f
        record_sql: obfuscated
        stack_trace_threshold: 0.500
      error_collector:
        enabled: true
        capture_source: true    
        ignore_errors: ActionController::RoutingError

    development:
      <<: *default_settings
      monitor_mode: false
      developer_mode: true

    test:
      <<: *default_settings
      monitor_mode: false

    production:
      <<: *default_settings
      monitor_mode: true

    staging:
      <<: *default_settings
      monitor_mode: true
      app_name: molawson-staging
    EOF
    
    newrelic = ERB.new(default_newrelic)
    put newrelic.result, "#{shared_path}/config/newrelic.yml"
  end

  task :symlink_config_files do
    run "ln -nfs #{shared_path}/config/admin_login.yml #{release_path}/config/admin_login.yml" 
    run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml" 
  end
end

before "deploy:setup", "deploy:create_config_files"
after "deploy:update_code", "deploy:symlink_config_files" 

namespace :db do
  desc "Create database yaml in shared path" 
  task :default do
    default_template = <<-EOF
    development:
      database: #{application}_development
      adapter: postgresql
      encoding: unicode
      template: template0
      pool: 5
      username: #{user}
      password: #{password}

    test:
      database: #{application}_test
      adapter: postgresql
      encoding: unicode
      template: template0
      pool: 5
      username: #{user}
      password: #{password}

    production:
      database: #{application}_production
      adapter: postgresql
      encoding: unicode
      template: template0
      pool: 5
      username: #{user}
      password: #{password}
    EOF
    
    db_config = ERB.new(default_template)

    run "mkdir -p #{shared_path}/config" 
    put db_config.result, "#{shared_path}/config/database.yml" 
  end

  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end

before "deploy:setup", :db
after "deploy:update_code", "db:symlink" 
