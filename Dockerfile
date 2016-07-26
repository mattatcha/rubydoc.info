FROM ruby:2.3
MAINTAINER Loren Segal <lsegal@soen.ca>

# Install docker
RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-get install -y docker-engine

# Bundle first to keep cache
ADD ./Gemfile /app/Gemfile
ADD ./Gemfile.lock /app/Gemfile.lock
ADD ./.bundle /app/.bundle
WORKDIR /app
RUN bundle --without test

# Rest of app
ADD . /app

EXPOSE 8080
ENV DOCKERIZED=1
ENV BUNDLE_GEMFILE=/app/Gemfile

CMD bundle exec rake server:start
