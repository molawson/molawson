require "bundler/capistrano"

set :application, "molawson"

set :scm, :git
set :repository,  "git@github.com:molawson/molawson.git"
set :deploy_via, :remote_cache

set :user, "deploy"
set :use_sudo, false
set :deploy_to, "/srv/apps/#{application}/"


set :default_environment, {
  'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH",
  'RAILS_ENV' => "production"
}

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

role :web, "kirby.molawson.com"
role :app, "kirby.molawson.com"
role :db,  "kirby.molawson.com", :primary => true


after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
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

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  end
  after "deploy:setup", "deploy:setup_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
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

before "deploy:setup", "db"
after "deploy:update_code", "db:symlink"

namespace :deploy do
  namespace :assets do
    task :precompile do
      run "cd #{release_path} && bundle exec rake assets:precompile"
    end
  end
end

after "deploy:update_code", "deploy:assets:precompile"

namespace :app do
  task :update_posts do
    run "cd #{current_path} && bundle exec rake update_posts"
  end
end
