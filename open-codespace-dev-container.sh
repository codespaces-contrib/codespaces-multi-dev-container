#/usr/env/bin bash
set -e

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

devcontainer_relative_path="${1:-"."}"
export DOCKER_HOST="tcp://localhost:${2:-9256}"
workspace_folder_in_container="${3:-"unknown"}"

CODESPACES_DEFAULT_WORKSPACE_MOUNT="/var/lib/docker/codespacemount/workspace"

if ! type jq > /dev/null 2>&1; then
    echo 'The jq utility is required for this script. Use "brew install jq" on macOS or the package mmanager for your distro on Linux (e.g. apt-get install jq)'
    exit 1
fi

# Find boostrap container
bootstrap_container="$(docker ps -q --filter "label=com.github.codespaces.active.workspace=true")"
echo "Boostrap container ID: ${bootstrap_container}"

# Set compose project name if one exists on boostrap container
COMPOSE_PROJECT_NAME="$(docker inspect -f '{{ index .Config.Labels "com.docker.compose.project" }}' ${bootstrap_container})"
if [ ! -z "${COMPOSE_PROJECT_NAME}" ]; then
    echo "Compose project name: ${COMPOSE_PROJECT_NAME}"
    export COMPOSE_PROJECT_NAME
fi

# Find the workspace mount point on the host
workspace_mount_source="$(docker inspect -f '{{range .HostConfig.Mounts}}{{if eq .Target "/workspaces"}}{{.Source}}{{end}}{{end}}' ${bootstrap_container})"
if [ -z "${workspace_mount_source}" ]; then
    workspace_mount_source="${CODESPACES_DEFAULT_WORKSPACE_MOUNT}"
fi
echo "Workspace mount source: ${workspace_mount_source}"

# Determine where workspace exists in boostrap container
if [ "${workspace_folder_in_container}" = "unknown" ]; then
    workspace_folder_in_container="$(docker exec -i ${bootstrap_container} /bin/sh -c 'cat /tmp/__boostrap_container_workspace_folder')"
fi

# Create a temp directory in the current folder - ensures we don't hit trusted workspace issues
temp_dir="$(pwd)/._devcontainer_temp"
mkdir -p "${temp_dir}"
cat << 'EOF' > "${temp_dir}/.gitignore"
*
.
EOF
echo "Temp directory: ${temp_dir}"
temp_devcontainer_folder="${temp_dir}/${devcontainer_relative_path}"
mkdir -p "${temp_devcontainer_folder}"
echo "Temp dev container path: ${temp_devcontainer_folder}"

# Copy config files
echo
echo "Copying:"
while IFS= read -r content_path; do
    echo "- ${content_path}"
    docker cp -L "${bootstrap_container}:${workspace_folder_in_container}/${content_path}" "${temp_dir}" 2>/dev/null || echo "   (Skipped, does not exist.)"
done < common-config.list
echo "- ${devcontainer_relative_path}/.devcontainer"
docker cp -L "${bootstrap_container}:${workspace_folder_in_container}/${devcontainer_relative_path}/.devcontainer" "${temp_devcontainer_folder}"

# Remove comments given devcontainer.json is a jsonc file
temp_evcontainerjson_file="${temp_devcontainer_folder}/.devcontainer/devcontainer.json"
sed -i'.bak' -e "s/\\/\\/.*/ /g" "${temp_evcontainerjson_file}"
# Append workspace mount property if not a docker compose definition
if ! jq -e '.dockerComposeFile' "${temp_evcontainerjson_file}" >/dev/null 2>&1; then
    jq  --arg workspaceFolder "${workspace_folder_in_container}/${devcontainer_relative_path}" \
        --arg workspaceMount "source=${workspace_mount_source},destination=/workspaces,type=bind" \
        '.workspaceFolder = $workspaceFolder | .workspaceMount = $workspaceMount' \
        "${temp_evcontainerjson_file}" > "${temp_evcontainerjson_file}.new"
    mv -f "${temp_evcontainerjson_file}.new" "${temp_evcontainerjson_file}"
fi

# Remotely build dev container better perf
echo "Building dev container..."
docker exec -i ${bootstrap_container} /bin/sh -c "\
    cd ${workspace_folder_in_container}/${devcontainer_relative_path}; \
    devcontainer build ."

# Launch VS Code
echo
echo "Launching VS Code..."
code --force-user-env --disable-workspace-trust --skip-add-to-recently-opened "${temp_devcontainer_folder}"
echo "Done!"
echo
echo "Press F1 or Cmd/Ctrl+Shift+P and select the Remote-Containers: Reopen in Container in the new VS Code window to connect."
echo
