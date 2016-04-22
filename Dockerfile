# Base image with ruby 2.2.0
FROM ruby:2.2.0-alpine

# Install required libraries and dependencies
RUN apt-get update && apt-get install -y nodejs nodejs-legacy npm --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN npm install bower -g

# Build whaler-ui project
RUN mkdir /usr/src/app/
WORKDIR /usr/src/app/

# Add and install Gemfile
ADD ./Gemfile /usr/src/app/Gemfile
ADD ./Gemfile.lock /usr/src/app/Gemfile.lock
# RUN bundle install

# Add source code
ADD . /usr/src/app

# Can't use bower inside a git submodule
# See https://github.com/bower/bower/issues/1492
ENV GIT_DIR /usr/src/app/


# Expose server port
EXPOSE 80

# Start rails server
CMD ruby bin/setup && rails server -b "0.0.0.0" -p 80
