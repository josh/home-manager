#!/bin/bash

if [ -n "$CACHIX_AUTH_TOKEN" ] || [ -f "$HOME/.config/cachix/cachix.dhall" ]; then
  exec cachix push josh "$1"
else
  echo "cachix not configured, run cachix authtoken <TOKEN>" >&2
  exit 0
fi
