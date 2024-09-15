#!/bin/bash

set -euo pipefail

# Ensure sudo wrapper is in PATH
export PATH="/run/wrappers/bin:$PATH"

nh os switch --out-link /tmp/os-up-result /etc/nixos/
cachix-push /tmp/os-up-result
