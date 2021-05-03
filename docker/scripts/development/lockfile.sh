
#!/bin/sh
built="/tmp/mix.lock"
current="${HOME}/app/mix.lock"

function update() {
  cp "${built}" "${current}"
}

if ! [[ -f $current ]]; then
  echo "[info] Dependencies: creating lockfike..."
  update
  exit 0
fi

if [[ "$(cmp -s $built $current)" != "0" ]]; then
  echo "[info] Dependencies: updating lockfile..."
  update
  exit 0
fi