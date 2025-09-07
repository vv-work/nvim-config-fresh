#!/usr/bin/env bash

# Simple script to sanity check bash LSP and formatting
set -euo pipefail

greet() {
  local name=${1:-world}
  echo "Hello, ${name}!"
}

greet "$@"

