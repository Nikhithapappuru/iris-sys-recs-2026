 
FROM ruby:3.4.1


RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    default-mysql-client


RUN npm install --global yarn


WORKDIR /app


COPY Gemfile Gemfile.lock ./

 
RUN gem install bundler -v 2.6.6
RUN bundle _2.6.6_ install


COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]


EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
