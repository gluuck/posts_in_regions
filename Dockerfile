FROM ruby:2.6.10

WORKDIR /app
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn postgresql-client 
COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v 2.4.22
RUN bundle install

COPY . .

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
