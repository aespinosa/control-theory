FROM ruby

RUN mkdir /app && \
    gem install --no-document rack

ADD config.ru /app/config.ru

WORKDIR /app

CMD rackup
