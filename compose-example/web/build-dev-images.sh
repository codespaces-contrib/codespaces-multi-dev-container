#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
docker build --target build-base -t save-june-web-build .
devcontainer build --image-name save-june-web-devcontainer .