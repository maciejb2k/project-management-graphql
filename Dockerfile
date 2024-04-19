FROM ruby:3.2.0

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install --jobs 4 
