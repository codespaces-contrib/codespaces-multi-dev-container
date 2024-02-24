param (
    $codespaceName="",
    $workspaceFolderInContainer="/workspaces",
    $codespaceUser="codespace"
)

$ErrorActionPreference = "Stop"


function Check-Command($command, $name) {
    if ((Get-Command $command 2>$null) -eq $null) {
        Write-Host "Required command missing. $1 not found."
        Write-Host "Please install $2 and ensure it is in the PATH."
        exit 1
    }
}

Check-Command "gh" "the GitHub CLI"
Check-Command "code" "VS Code"
Check-Command "ssh" "an OpenSSH client"

if ($codespaceName -eq "") {
    Write-Host "Missing argument: codespace name."
    Write-Host
    WriteHost "Usage: codespace-remote-ssh-connect <codespace_name> [workspace_folder_in_container] [codespace_user]"
    Write-Host 
    Write-Host "Available codespaces:"
    gh codespace list --json name -t '{{ range $i, $codespace := . }}{{ $codespace.name }}~{{ end }}' | tr '~' '\n' 
    exit 1
}

$ghPath = (Get-Command "gh").Source
$hostName = "${codespaceName}-multi-container"

$sshConfigSnippet="
# START CODESPACES ${hostName}
Host ${hostName}
	User ${codespaceUser}
	ProxyCommand ""${ghPath}"" cs ssh -c ${codespaceName} --stdio
	UserKnownHostsFile /dev/null
    GlobalKnownHostsFile /dev/null
	StrictHostKeyChecking no
	ControlMaster auto
# END CODESPACES ${hostName}
"

if ((Test-Path "${HOME}\.ssh\config") -ne $true -Or (Get-Content -Path "${HOME}\.ssh\config" | Select-String "Host ${hostName}" -casesensitive -quiet) -ne $true){
    New-Item -ItemType Directory -Force -Path "${HOME}\.ssh" > $null
    if ((Test-Path "${HOME}\.ssh\config") -ne $true) {
        New-Item -ItemType File -Force -Path "${HOME}\.ssh\config" > $null
    }
    $sshConfig = Get-Content -Path "${HOME}\.ssh\config" -Raw
    [IO.File]::WriteAllText("${HOME}\.ssh\config", ($sshConfig+$sshConfigSnippet -replace "`r`n", "`n"))
}

Write-Host "Verifying Remote - SSH and Remote - Containers extensions are installed..."
code --install-extension ms-vscode-remote.remote-ssh > $null
code --install-extension ms-vscode-remote.remote-containers > $null
Write-Host "Opening SSH connection to ${codespace_name} using Remote - SSH..."
code --disable-workspace-trust --skip-add-to-recently-opened --remote "ssh-remote+${hostName}" "${workspaceFolderInContainer}"

Write-Host "
Next:

1. In the new Remote - SSH VS Code window that appears, start a new VS Code terminal.
2. Run the following for each folder with a dev container you want to open: code <folder name>
3. In each new window, click the "Reopen in Container" button in the notification that appears.
4. Use each window as you would normally.

"
Read-Host "When done, press enter to remove the temporary SSH configurations or Ctrl+C to leave it in place"

$sshConfig = (Get-Content "${HOME}\.ssh\config" -Raw) -replace "(?ms)# START CODESPACES ${hostName}\r?\n.*\r?\n# END CODESPACES ${hostName}", ""
[IO.File]::WriteAllText("${HOME}\.ssh\config", ($sshConfig.Trim() -replace "`r`n", "`n"))
