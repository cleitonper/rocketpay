
#!/bin/sh
built="/tmp/mix.lock"
current="/app/mix.lock"

function update() {
  cp "${built}" "${current}"
  pwd
  ls -la
  ls -la deps
}

if ! [[ -f $current ]]; then
  echo "[info] Creating lockfike..."
  update
  exit 0
fi

if [[ "$(cmp -s $built $current)" != "0" ]]; then
  echo "[info] Updating lockfile..."
  update
  exit 0
fi