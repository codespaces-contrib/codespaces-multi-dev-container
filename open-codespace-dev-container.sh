#/usr/env/bin bash
set -e

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DEVCONTAINER_BASE_FOLDER="${1:-"."}"
export DOCKER_HOST="tcp://localhost:${2:-9256}"

workspace_container="$(docker ps -q --filter "label=com.github.codespaces.active.workspace=true")"
COMPOSE_PROJECT_NAME="$(docker inspect -f '{{ index .Config.Labels "com.docker.compose.project" }}' ${workspace_container})"
if [ ! -z "${COMPOSE_PROJECT_NAME}" ]; then
    export COMPOSE_PROJECT_NAME
fi
workspace_folder_in_container="$(docker exec -i ${workspace_container} /bin/sh -c 'cat /tmp/__boostrap_container_workspace_folder')"

temp_dir="$(pwd)/._devcontainer_temp"
mkdir -p "${temp_dir}"
cat << 'EOF' > "${temp_dir}/.gitignore"
*
../._devcontainer_temp
EOF

echo "Boostrap container ID: ${workspace_container}"
echo "Workspace folder in container: ${workspace_folder_in_container}"
echo "Temp directory: ${temp_dir}"

# Copy config files
echo
echo "Copying:"
while IFS= read -r content_path; do
    echo "- ${content_path}"
    docker cp -L "${workspace_container}:${workspace_folder_in_container}/${content_path}" "${temp_dir}" 2>/dev/null || echo "   (Skipped, does not exist.)"
done < common-config.list
echo "- ${DEVCONTAINER_BASE_FOLDER}/.devcontainer"
target_base_folder="${temp_dir}/${DEVCONTAINER_BASE_FOLDER}"
mkdir -p "${target_base_folder}"
docker cp -L "${workspace_container}:${workspace_folder_in_container}/${DEVCONTAINER_BASE_FOLDER}/.devcontainer" "${target_base_folder}"

export SECONDARY_CODESPACE_CONTAINER=true

echo
echo "Launching VS Code..."
code --force-user-env --disable-workspace-trust --skip-add-to-recently-opened "${target_base_folder}"
