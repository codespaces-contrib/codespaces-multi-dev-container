# GitHub Codespaces Multi-Development Container

Visual Studio Code Remote - Containers supports [a pattern](https://code.visualstudio.com/remote/advancedcontainers/connect-multiple-containers) that allows the use of multiple development containers at the same time for a source tree. Unfortunately [GitHub Codespaces](https://github.com/features/codespaces) does not currently support attaching a second window to a different container in the same Codespaces. However, the fact that the same technology is used in both Remote - Containers and Codespaces allows you to use the Remote - Containers extension with a codespace to achieve the same goal with some subtle tweaks.

This variation of the pattern enables you to spin up completely separate dev containers in the same codespace without unifying everything in a single Docker Compose file. If you'd prefer to spin everything up at once using Docker Compose, [see this variation instead](https://github.com/chuxel/codespaces-multi-dev-container-compose).

Codespaces will ultimately have first class support for this pattern, so this is a workaround given current limitations.

## Setup

1. Install VS Code locally
2. Install the [GitHub Codespaces](https://marketplace.visualstudio.com/items?itemName=GitHub.codespaces) extension in local VS Code
3. Install the [VS Code Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in local VS Code
4. Install the Docker CLI locally (e.g. by installing Docker Desktop - though Docker itself does not need to be running)
5. On macOS or Linux, install `jq` locally:
  - macOS: `brew install jq`
  - Linux: Use your distro's package manger to install. For example, `sudo apt-get install jq`

## Using this sample

1. Create a codespace from this repository from VS Code client locally (<kbd>F1</kbd> or <kbd>ctrl</kbd>+<kbd>shift</kbd>+<kbd>p</kbd>, select **Codesaces: Create New Codespace**, enter this repository)

    > Note: If you accidentally created the codespace from the web, you can open it in VS Code client after things are up and running if you prefer.

2. In this codespace, open a terminal and run the command: `keep-me-alive`
<!--
3. On Windows, be sure the **Remote - Containers: Execute in WSL** user setting is **Unchecked** (`"remote.containers.executeInWSL": false` in `settings.json`).
-->

4. Next, copy `open-codespace-dev-container.sh`<!-- (macOS / Linux) or `open-codespace-dev-container.ps1` and `open-codespace-dev-container.cmd` (Windows) --> to your local machine.

5. In a **local** terminal, use the script to set up a connection to one of the sub-folders in this repository. For example, on macOS / Linux:

    ```bash
    bash open-codespace-dev-container.sh container-1-src
    ```
  <!--
    ... or on Windows, use PowerShell/Command Prompt (not WSL) as follows:
    ```powershell
    .\open-codespace-dev-container.cmd container-1-src
    ```
-->
5. In the VS Code window that appears, click **Reopen in Container** when a notification appears.

In a bit, this new window will be using the development container for this folder.

## Adapting the sample for your own use

This sample applies the same [patterns](https://code.visualstudio.com/remote/advancedcontainers/connect-multiple-containers) used in Remote - Containers for this same scenario. To adapt for your own use:

1. Make your own copy of this repository (or copy contents into an existing one) and add other sub-folders to your Codespace with dev container configuration. You can use the same command described above to access these by referencing the folder name.
2. If your new container relies on contents outside of the `.devcontainer` folder (particularly if common across all containers), add them to `common-config.list` in the root of the repository. This ensures they are copied down locally so the build can function as expected.
3. For multi-repo scenarios, you can setup the "bootstrap" container (in the root `.devcontainer` folder) to clone repositories as described in [this sample](https://github.com/Chuxel/codespaces-multi-repo) instead.

Note that if you are using a Docker Compose file or would prefer to have all containers start up at once, see [this variation instead](https://github.com/chuxel/codespaces-multi-dev-container-compose) for an alternate approach.

## TODOs

There are few to-dos for this sample:

1. Create a PowerShell version of the `open-codespace-dev-container.sh` script for Windows.
2. Cache VS Code Server between development containers to avoid having to download it multiple times.
3. Look for ways to further reduce steps.

