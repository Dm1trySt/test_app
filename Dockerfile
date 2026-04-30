FROM ruby:3.0-slim AS base

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists*

WORKDIR /test_app

FROM base AS builder
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    git

COPY Gemfile Gemfile.lock ./
RUN bundle install

FROM builder AS development

COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 4000
CMD ["bundle", "exec", "rails", "s", "-p", "4000", "-b", "0.0.0.0"]

FROM base AS production

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . .
RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN useradd -m test_user
RUN chown -R test_user:test_user /test_app
USER test_user

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]