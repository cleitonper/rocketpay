#!/bin/sh
lockfile.sh

PLTS=${HOME}/app/priv/plts
if ls ${PLTS}/*.plt >/dev/null 2>&1; then
  echo '[info] Dialyzer: restoring plts from cache...'
else
  echo '[info] Dialyzer: generating plts...'
  mix dialyzer --plt
fi

CERTS=${HOME}/app/priv/cert
if ls ${CERTS}/*.pem >/dev/null 2>&1; then
  echo '[info] SSL: Restoring certs from cache...'
else
  echo '[info] SSL: Generating certs...'
  mix phx.gen.cert
fi

dockerize -wait tcp://$DB_HOSTNAME:$DB_PORT -timeout 10s

mix ecto.setup
mix phx.server