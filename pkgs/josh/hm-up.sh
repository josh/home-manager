#!/usr/bin/env bash

set -euo pipefail

if [ -f /etc/NIXOS ]; then
  echo "NixOS not supported, use 'os-up' instead" >&2
  exit 1
fi

x() {
  echo "+ $*" >&2
  "$@"
}

FLAKE="github:josh/home-manager"
if [ -d .git ] && [[ "$(git remote get-url origin)" == "https://github.com/josh/home-manager"* ]]; then
  FLAKE="$(pwd)"
fi

x nh home switch "$FLAKE" --backup-extension backup --out-link /tmp/hm-up-result -- --refresh
rm /tmp/hm-up-result
