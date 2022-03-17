#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
devcontainer build --image-name save-june-worker-devcontainer .