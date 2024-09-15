#!/bin/bash

set -euo pipefail

if [ ! -f /etc/NIXOS ]; then
  echo "Not a NixOS system" >&2
  exit 1
fi

x() {
  echo "+ $*" >&2
  "$@"
}

# Ensure sudo wrapper is in PATH
export PATH="/run/wrappers/bin:$PATH"

if [ -d .git ] && [[ "$(git remote get-url origin)" == "https://github.com/josh/home-manager"* ]]; then
  x nh os switch /etc/nixos --out-link /tmp/os-up-result -- --override-input josh-home-manager "$PWD"
else
  x nh os switch /etc/nixos --update --out-link /tmp/os-up-result
fi

x cachix-push /tmp/os-up-result
rm /tmp/os-up-result
