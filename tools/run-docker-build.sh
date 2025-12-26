#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=ignisos-toolchain:latest
USER_ID=$(id -u)
GROUP_ID=$(id -g)

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: 'docker' command not found."
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Error: Docker daemon not running"
  exit 1
fi

docker build -t "$IMAGE_NAME" . --quiet
docker run --rm -v "$(pwd)":/work -w /work --user "$USER_ID:$GROUP_ID" "$IMAGE_NAME" \
  bash -lc "cd src && make iso && chown -R $USER_ID:$GROUP_ID ignisos.iso"

exit 0
