FROM ruby:2.6

#Allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    apt-transport-https

#Ensure we install an up-to-date version of NOde
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

#Ensure latest packages for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
    tee /etc/apt/sources.list.d/yarn.list

#Install packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    nodejs \
    yarn

COPY Gemfile* /usr/src/
WORKDIR /usr/src/
ENV BUNDLE_PATH /gems
RUN bundle install

COPY . /usr/src/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]