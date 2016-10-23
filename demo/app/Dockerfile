FROM ruby

RUN mkdir /app && \
    gem install --no-document rack unicorn

ADD config.ru /app/config.ru

WORKDIR /app

CMD unicorn
