FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get install -y vim

WORKDIR /app

ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install -j4

ADD . /app


EXPOSE 3000

