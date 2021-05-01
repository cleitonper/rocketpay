#!/bin/sh
lockfile.sh

PLTS=${HOME}/app/priv/plts
if ls ${PLTS}/*.plt >/dev/null 2>&1; then
  echo '[info] Dialyzer: restoring plts from cache...'
else
  echo '[info] Dialyzer: generating plts...'
  mix dialyzer --plt
fi

dockerize -wait tcp://$DB_HOSTNAME:$DB_PORT -timeout 10s

mix ecto.setup
mix phx.server