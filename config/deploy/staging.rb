set :user, "ubuntu"
set :branch, 'develop'
set :rails_env, "staging"

server "staging.connectedcity.com", :web, :app, :db, primary: true

