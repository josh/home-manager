#!/bin/sh

set -eux

[ -n "${out:-}" ]
[ -n "${name:-}" ]

TEXT="$(sed '1d' "$SCRIPT_PATH")"

mkdir -p "$out/bin"

cat <<EOF >"$out/bin/$name"
#!${RUNTIME_SHELL}
export PATH="${RUNTIME_PATH}"
${TEXT}
EOF
chmod +x "$out/bin/$name"
