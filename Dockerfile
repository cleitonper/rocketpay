# --------------------------------------------------------------------
# Dockerfile |~| Definições de Ambientes
# --------------------------------------------------------------------
#
# As imagens dos ambientes de desenvolvimento e produção são criadas
# em etapas especificas deste Dockerfile por meio da funcionalidade
# `Multi Stage Build` do Docker.
# _



# Versão Elixir usada em todas as etapas
ARG ELIXIR_VERSION=1.11-alpine



# --------------------------------------------------------------------
# Ambiente de Desenvolvimento |~| Imagem
# --------------------------------------------------------------------
#
# Etapa responsável por criar a imagem que será usada no ambiente de
# desenvolvimento. Aqui são descritas as dependencias e configurações
# necessárias para criar esse ambiente.
# _

FROM elixir:${ELIXIR_VERSION} as development

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
    -g ${GID} \
    "${USER}" && \
  adduser \
    -u ${UID} \
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



# --------------------------------------------------------------------
# Novo Release |~| Etapa Intermediária
# --------------------------------------------------------------------
#
# Esta estapa é responsável por compilar o código fonte do projeto e
# gerar os executáveis de uma nova versão da aplicação.
# _

FROM elixir:${ELIXIR_VERSION} as build

RUN apk add --no-cache build-base

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

RUN mkdir config
COPY config/config.exs config/$MIX_ENV.exs config/
RUN mix deps.compile

COPY priv priv

COPY lib lib
RUN MIX_ENV=$MIX_ENV mix compile
COPY config/runtime.exs config/
RUN MIX_ENV=$MIX_ENV mix release

COPY docker/scripts/production scripts



# --------------------------------------------------------------------
# Ambiente de Produção |~| Imagem
# --------------------------------------------------------------------
#
# Etapa responsável por gerar a imagem que será executada em produção.
# Neste ponto, o código fonte da aplicação já foi compilado na etapa
# `build` e é copiado para a etapa a seguir para ser executado.
# _

FROM alpine:3.12.1 AS production
RUN apk add --no-cache openssl ncurses-libs libgcc libstdc++

ARG USER=elixir
ARG GID=1000
ARG UID=1000

ENV USER=${USER}
ENV HOME=/home/"${USER}"
ENV PATH=${HOME}/.local/bin:${PATH}
ENV APP_DIR="${HOME}/app"

RUN \
  addgroup \
  -g ${GID} \
  -S "${USER}" && \
  adduser \
  -s /bin/sh \
  -u ${UID} \
  -G "${USER}" \
  -h "${HOME}" \
  -D "${USER}" && \
  su "${USER}" sh -c "mkdir -p ${APP_DIR}" && \
  su "${USER}" sh -c "mkdir -p ${HOME}/.local/bin"

USER "${USER}"
WORKDIR "${APP_DIR}"

COPY --from=build --chown="${USER}":"${USER}" /app/_build/prod/rel/rocketpay ./
COPY --from=build --chown="${USER}":"${USER}" /app/scripts/*.sh "${HOME}/.local/bin"
COPY --from=build --chown="${USER}":"${USER}" /usr/local/bin/dockerize /usr/local/bin

ENTRYPOINT "entrypoint.sh"



# --------------------------------------------------------------------
# Prometheus |~| Imagem
# --------------------------------------------------------------------
#
# Prometheus é um banco de dados usado para armazenar métricas do
# projeto, como uso do cpu, memória e do banco de daods. Sua inserção
# no Dockerfile foi feita para evitar a criação de montagens de
# associação (bind mounts).
# _

FROM prom/prometheus:v2.26.0 AS prometheus

COPY docker/prometheus /etc/prometheus



# --------------------------------------------------------------------
# Grafana |~| Imagem
# --------------------------------------------------------------------
#
# Grafana é uma ferramenta destinada a exibir as metricas coletadas
# do projeto por meio de gráficos de fácil compreensão. Sua inserção
# no Dockerfile foi feita para evitar a criação de montagens de
# associação (bind mounts).
# _

FROM grafana/grafana:7.5.2 AS grafana

COPY ./docker/grafana/ /etc/grafana/provisioning