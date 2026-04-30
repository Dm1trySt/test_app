#!/bin/bash
set -euo pipefail

if [ -f tmp/pids/server.pid ]; then
  echo "WARN: Cleaning old server.pid..."
  rm -f tmp/pids/server.pid
fi
echo "Starting app..."
exec "$@"