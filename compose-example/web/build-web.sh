#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
target_folder="${1:-out}"
mkdir -p "${target_folder}"

cp -r src public views package.json package-lock.json "${target_folder}/"

cd "${target_folder}"
npm install --prodiction
