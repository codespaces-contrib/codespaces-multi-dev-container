#/usr/env/bin bash
set -e
codespace_name="$1"
workspace_folder_in_container="${2:-/workspaces}"
codespace_user="$32:-codespace}"

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

verify_command() {
    if ! type $1 >/dev/null 2>&1; then
        echo -e "Required command missing. $1 not found.\nPlease install $2 and ensure it is in the PATH."
        exit 1
    fi
}

verify_command gh "the GitHub CLI"
verify_command code "VS Code"
verify_command ssh "an OpenSSH client"

if [ -z "$codespace_name" ]; then
    echo -e "Missing argument: codespace name.\n\nUsage: $0 <codespace_name> [workspace_folder_in_container] [codespace_user]\n\nAvailable codespaces:\n"
    gh codespace list --json name -t '{{ range $i, $codespace := . }}{{ $codespace.name }}~{{ end }}' | tr '~' '\n' 
    exit 1
fi

gh_path="$(which gh)"
host_name="${codespace_name}-multi-container"
if ! grep -q "Host ${host_name}" ~/.ssh/config; then
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cat << EOF >> ~/.ssh/config
# START CODESPACES ${host_name}
Host ${host_name}
	User ${codespace_user}
	ProxyCommand "${gh_path}" cs ssh -c ${codespace_name} --stdio
	UserKnownHostsFile /dev/null
    GlobalKnownHostsFile /dev/null
	StrictHostKeyChecking no
	ControlMaster auto
# END CODESPACES ${host_name}
EOF
fi
echo
echo "Verifying Remote - SSH and Remote - Containers extensions are installed..."
code --install-extension ms-vscode-remote.remote-ssh > /dev/null
code --install-extension ms-vscode-remote.remote-containers > /dev/null
echo "Opening SSH connection to ${codespace_name} using Remote - SSH..."
code --disable-workspace-trust --skip-add-to-recently-opened --remote ssh-remote+${host_name} "${workspace_folder_in_container}"
cat << 'EOF'

Next:

1. In the new Remote - SSH VS Code window that appears, start a new VS Code terminal.
2. Run the following for each folder with a dev container you want to open: code <folder name>
3. In each new window, click the "Reopen in Container" button in the notification that appears.
4. Use each window as you would normally.

EOF
read -p "When done, press enter to remove the temporary SSH configurations or Ctrl+C to leave it in place." -s
echo
sed -i'.bak' "/# START CODESPACES ${host_name}/,/# END CODESPACES ${host_name}/d" ~/.ssh/config
