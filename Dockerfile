FROM ruby:2.2.1

RUN apt-get update -qq && apt-get install -y build-essential nodejs nodejs-legacy npm libpq-dev
RUN npm install webpack webpack-dev-server -g

RUN mkdir /app

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /app
WORKDIR /app