#!/usr/bin/env bash
# This assumes a default installation of luarocks for test purposes

set -e

SCRIPT_DIR=$(dirname "$0")

$HOME/.luarocks/bin/busted      \
  -m '?.lua;?/?.lua;?/init.lua'         \
  -C "${SCRIPT_DIR}/lua"        \
  chip-build/test.lua           \
  $@

