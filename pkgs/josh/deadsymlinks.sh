#!/usr/bin/env bash

find . -type l ! -exec test -r {} \; -print 2>/dev/null
