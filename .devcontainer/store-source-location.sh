#!/usr/bin/env bash

# Add workspace path to temp file
echo "$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)" > /tmp/__boostrap_container_workspace_folder

