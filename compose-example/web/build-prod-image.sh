#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
docker build --target production -t save-june-web .