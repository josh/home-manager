#!/usr/bin/env bash

branch=$(git branch 2>/dev/null | grep '^\*')
[ "x$1" != x ] && tracking=$1 || tracking=''${branch/* /}

git config "branch.$tracking.remote" origin
git config "branch.$tracking.merge" "refs/heads/$tracking"

echo "tracking origin/$tracking"
