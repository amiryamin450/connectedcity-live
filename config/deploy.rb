set :stages, %w(production staging)
set :default_stage, 'staging'


require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'sidekiq/capistrano'
require 'cape'

Cape.remote_rake_executable = '/usr/local/rvm/bin/rvm in . do bundle exec rake'
Cape do
  mirror_rake_tasks :tire do |recipe|
    recipe.env['CLASS'] = lambda { ENV['CLASS'] }
    recipe.env['INDEX'] = lambda { ENV['INDEX'] }
    recipe.env['RAILS_ENV'] = lambda { rails_env }
  end
end

set :rvm_type, :system
set :rvm_ruby_string, :release_path
set :bundle_dir, ''
set :bundle_flags, '--system --quiet'

set :cmd_prefix, -> { path_to_bin_rvm(:with_ruby => "in #{fetch(:current_path)}") }  
set :sidekiq_cmd, -> { "#{fetch(:cmd_prefix)} bundle exec sidekiq" }
set :sidekiqctl_cmd, -> { "#{fetch(:cmd_prefix)} bundle exec sidekiqctl" }

set :application, 'connectbook'
set :deploy_via, :remote_cache
set :use_sudo, false


set :scm, 'git'
set :repository,  'git@bitbucket.org:deversus/connectedcity.git'
set :deploy_to, "/var/www/#{application}"
set :shared_children, shared_children + %w{config/settings.local.yml}
set :branch, 'master'


default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} puma server"
    task command, roles: :app, except: {no_release: true} do
      run "sudo service #{application} #{command}"
    end
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end