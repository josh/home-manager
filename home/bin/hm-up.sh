#!/bin/bash

set -euo pipefail

if [ -d .git ] && [ "$(git remote get-url origin)" = "https://github.com/josh/home-manager" ]; then
  FLAKE="$(pwd)"
else
  FLAKE="github:josh/home-manager"
fi
export FLAKE
echo "Using $FLAKE as home manager flake" >&2

nh home switch --backup-extension backup --out-link /tmp/hm-up-result -- --refresh
cachix-push /tmp/hm-up-result
