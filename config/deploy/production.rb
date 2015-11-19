set :user, "connectedcity"
set :branch, 'master'
set :rails_env, "production"

server "production.connectedcity.com", :web, :app, :db, primary: true

