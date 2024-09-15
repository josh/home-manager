#!/bin/bash

set -euo pipefail

nh os switch --out-link /tmp/os-up-result /etc/nixos/
cachix-push /tmp/os-up-result
