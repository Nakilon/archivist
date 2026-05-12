FROM ruby:2.7.8-alpine
RUN apk add build-base
RUN wget https://github.com/rubygems/rubygems/archive/refs/tags/v3.4.22.tar.gz -O - | tar zxf -
RUN cd rubygems-3.4.22 && ruby setup.rb --no-ri && gem update bundler && cd .. && rm -rf rubygems-3.4.22
RUN apk add git
