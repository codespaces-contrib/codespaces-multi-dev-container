#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
target_folder="${1:-out}"
mkdir -p "${target_folder}"

go build
mv worker "${target_folder}/"