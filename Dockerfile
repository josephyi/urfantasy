FROM ruby:2.2.1

RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy vim libpq-dev cron
RUN npm install -g phantomjs

RUN mkdir /app

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /app
WORKDIR /app
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace