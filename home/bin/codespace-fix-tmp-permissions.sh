#!/bin/bash
# https://github.com/NixOS/nix/issues/6680

set -euo pipefail

OLD_ACL=$(getfacl /tmp 2>/dev/null)
/usr/bin/sudo setfacl -k /tmp
NEW_ACL=$(getfacl /tmp 2>/dev/null)

if [ "$OLD_ACL" != "$NEW_ACL" ]; then
  echo "ACLs changed:"
  echo "$OLD_ACL"
  echo "---"
  echo "$NEW_ACL"
else
  echo "ACLs are the same"
fi
