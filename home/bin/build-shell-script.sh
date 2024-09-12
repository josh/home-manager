#!/bin/sh

set -eux

[ -n "${out:-}" ]
[ -n "${name:-}" ]

TEXT="$(tail +2 "$SCRIPT_PATH")"

mkdir -p "$out/bin"

cat <<EOF >"$out/bin/$name"
#!${RUNTIME_SHELL}
export PATH="${RUNTIME_PATH}"
${TEXT}
EOF
chmod +x "$out/bin/$name"
