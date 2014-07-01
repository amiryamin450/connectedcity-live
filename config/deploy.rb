set :stages, %w(production staging)
set :default_stage, 'staging'


require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'sidekiq/capistrano'

set :application, 'connectbook'
set :user, 'clewis'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository,  'git@github.com:camidoo/connectedcity.git'
set :branch, 'master'


default_run_options[:pty] = true
ssh_options[:forward_agent] = true
