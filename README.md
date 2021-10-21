# GitHub Codespaces Multi-Development Container

Visual Studio Code Remote - Containers supports [a pattern](https://code.visualstudio.com/remote/advancedcontainers/connect-multiple-containers) that allows the use of multiple development containers at the same time for a source tree. Unfortunatley [GitHub Codespaces](https://github.com/features/codespaces) does not currently support attaching a second window to a different container in the same Codespaces. However, the fact that the same technology is used in both Remote - Containers and Codespaces allows you to use the Remote - Containers extension with a Codespace to achieve the same goal with some subtle tweaks.

This variation of the pattern enables you to spin up completely separate dev containers in the same Codespaace without unifying everything in a Docker Compose file. If you'd prefer to use Docker Compose instead, [see this variation](https://github.com/chuxel/codespaces-multi-dev-container-compose).

Codespaces will ultimately have first class support for this partern, so this is a workaround given current limitations.

## Setup

1. Install VS Code locally
2. Install the [GitHub Codespaces](https://marketplace.visualstudio.com/items?itemName=GitHub.codespaces) extension in local VS Code
3. Install the [VS Code Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in local VS Code
4. Install Docker locally
5. Install `jq`:
  - macOS: `brew install jq`
  - Linux: Use your distro's package manger to install. For example, `sudo apt-get install jq`

## Using this sample

1. Create a codespace from this repository from VS Code client locally (<kbd>F1</kbd> or <kbd>ctrl</kbd>+<kbd>shift</kbd>+<kbd>p</kbd>, select **Codesaces: Create New Codespace**, enter this repository)
2. In this Codespace, open a terminal and run the command `keep-me-alive`.
2. Next, copy `open-codespace-dev-container.sh` to your local machine.
3. Open a terminal and use the script to set up a connection to one of the sub-folders in this repository. For example:

    ```bash
    ./open-codespace-dev-container.sh container-1-src
    ```
  
4. In the VS Code window that appears, click **Reopen in Container** when a notification appears.

In a bit, this new window will be using the development container for this folder.

## Adapting the sample for your own use

This sample applies the same [patterns](https://code.visualstudio.com/remote/advancedcontainers/connect-multiple-containers) used in Remote - Containers for this same scenario. To adapt for your own use:

1. Make your own copy of this repository (or copy contents into an existing one) and add other sub-folders to your Codespace with dev container configuration. You can use the same command described above to access these by referencing the folder name.
2. If your new container relies on contents outside of the `.devcontainer` folder (particularly if common across all containers), add them to `common-config.list` in the root of the repository. This ensures they are copied down locally so the buld can function as expected.
3. For multi-repo scenarios, you can setup the "bootstrap" container (in the root `.devcontainer` folder) to clone repositories as described in [this sample](https://github.com/Chuxel/codespaces-multi-repo) instead.

Note that if you are using a Docker Compose file or would prefer to have all containers start up at once, see [this variation instead](https://github.com/chuxel/codespaces-multi-dev-container-compose) for an alternate approach.

## TODOs

There are few to-dos for this sample:
2. Create a PowerShell version of the `open-codespace-dev-container.sh` script for Windows.
3. Cache VS Code Server between development containers to avoid having to download it multiple times.
4. Look for ways to further reduce steps.
5. Update the Remote - Containers documentation to describe the pattern this way.
