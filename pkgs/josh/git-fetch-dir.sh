#!/usr/bin/env bash
# usage: git-fetch-dir [path...]

set -e

fetch() {
  set -x
  git --git-dir="$1" fetch --all --quiet
}
export -f fetch

declare -a paths
paths=("$@")
if [ ${#paths[@]} -eq 0 ]; then
  paths+=("$PWD")
fi

find "${paths[@]}" -name .git -type d -prune |
  tr '\n' '\0' |
  xargs --null --max-procs=4 --replace='{}' bash -c 'fetch "{}"'
