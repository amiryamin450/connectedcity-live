FROM ruby:2.7.1 AS rails-toolbox

RUN apt-get update -qq && apt-get install -y nodejs imagemagick libmagickcore-dev libmagickwand-dev
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]