set :user, "ubuntu"
set :branch, 'master'
set :rails_env, "production"

server "production.canadarentalguide.com", :web, :app, :db, primary: true

