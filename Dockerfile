ARG ELIXIR_VERSION=11.4-alpine

FROM elixir:${ELIXIR_VERSION}

RUN apk add --no-cache alpine-sdk

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir /app
WORKDIR /app

COPY config mix.exs mix.lock /app/

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile

COPY . .

RUN mv ./docker/scripts/*.sh /usr/local/bin && \
    rm -rf ./docker

ENTRYPOINT "entrypoint.sh"