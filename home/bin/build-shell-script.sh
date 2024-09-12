#!/bin/bash

set -euo pipefail
set -x

[ -n "${out:-}" ]
[ -n "${name:-}" ]

TEXT="$(cat "$SCRIPT_PATH")"
[[ $TEXT == "#!/bin/bash"* ]]
TEXT="${TEXT#*#!/bin/bash$'\n'}"

mkdir -p "$out/bin"

cat <<EOF >"$out/bin/$name"
#!${RUNTIME_SHELL}
export PATH="${RUNTIME_PATH}"
${TEXT}
EOF
chmod +x "$out/bin/$name"
