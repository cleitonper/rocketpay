ARG ELIXIR_VERSION=11.4-alpine

FROM elixir:${ELIXIR_VERSION}

RUN apk add --no-cache alpine-sdk

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz


ARG USER=elixir
ARG GID=1000
ARG UID=1000

ENV USER=${USER}
ENV HOME=/home/${USER}
ENV PATH=${HOME}/.local/bin:${PATH}
ENV APP_DIR=${HOME}/app

RUN \
  addgroup \
    -g 1000 \
    "${USER}" && \
  adduser \
    -u 1000 \
    -G "${USER}" \
    -h "${HOME}" \
    -s /bin/sh \
    -D "${USER}" && \
  su "${USER}" sh -c "mkdir -p ${APP_DIR}" && \
  su "${USER}" sh -c "mkdir -p ${HOME}/.local/bin"

USER "${USER}"
WORKDIR "${APP_DIR}"

COPY --chown="${USER}":"${USER}" mix.exs mix.lock "${APP_DIR}"/
COPY --chown="${USER}":"${USER}" config "${APP_DIR}"/config

RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get && \
  mix deps.compile && \
  cp mix.lock /tmp/

COPY --chown="${USER}":"${USER}" . .

RUN mv ./docker/scripts/development/*.sh "${HOME}/.local/bin" && \
  rm -rf ./docker

ENTRYPOINT "entrypoint.sh"