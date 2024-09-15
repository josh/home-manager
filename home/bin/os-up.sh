#!/bin/bash

set -euo pipefail

if [ ! -f /etc/nixos ]; then
  echo "Not a NixOS system" >&2
  exit 1
fi

# Ensure sudo wrapper is in PATH
export PATH="/run/wrappers/bin:$PATH"

nh os switch --out-link /tmp/os-up-result /etc/nixos/
cachix-push /tmp/os-up-result
rm /tmp/os-up-result
