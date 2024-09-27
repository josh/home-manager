#!/usr/bin/env bash

git branch --merged | grep -v "\*" | xargs -n 1 git branch --delete
