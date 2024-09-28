#!/usr/bin/env bash

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

GITHUB_TOKEN="$(gh auth token)"
if [ -n "$GITHUB_TOKEN" ]; then
  echo "Using GitHub access token" >&2
  export NIX_CONFIG="extra-access-tokens = github.com=$GITHUB_TOKEN"
else
  echo "No GitHub access token" >&2
fi

nixos_flake="/etc/nixos"
if [ -L "$nixos_flake" ]; then
  nixos_flake="$(readlink -f "$nixos_flake")"
fi

if [ -d .git ] && [[ "$(git remote get-url origin)" == "https://github.com/josh/home-manager"* ]]; then
  x nh os switch "$nixos_flake" --out-link /tmp/os-up-result -- --override-input josh-home-manager "$PWD"
else
  x nh os switch "$nixos_flake" --update --out-link /tmp/os-up-result
fi

x cachix-push /tmp/os-up-result
rm /tmp/os-up-result
