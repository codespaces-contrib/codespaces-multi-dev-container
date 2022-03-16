# Using GitHub Codespaces with Multiple Development Containers

Visual Studio Code Remote - Containers supports the idea of connecting to multiple containers in the same source tree. There is even [a pattern](https://code.visualstudio.com/remote/advancedcontainers/connect-multiple-containers) if you are using Docker Compose for your configuration. Unfortunately [GitHub Codespaces](https://github.com/features/codespaces) does not currently support attaching a second window to a different container in the same Codespaces. However, the fact that the same technology is used in both Remote - Containers and Codespaces allows you to use the Remote - Containers extension with a codespace to achieve the same goal with some subtle tweaks.

This repository includes a script that you can use to connect to multiple containers via the GitHub CLI and the Remote - Containers extension. Any dev container configuration files can be in sub-folders rather than the repository root.

Codespaces will ultimately have first class support for this pattern, so this is a workaround given current limitations.

## Setup

1. Install [VS Code](https://code.visualstudio.com/) (stable) locally.
2. Install the [GitHub CLI](https://cli.github.com/) locally.
3. Install an OpenSSH client and [configure an SSH key for use with GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/about-ssh).

## Using this sample

1. Create a codespace from this repository if you do not already have one. You can do this using the GitHub CLI as follows:

    ```bash
    gh codespace create --repo codespaces-contrib/codespaces-multi-dev-container
    ```

    Note the name of the codespace. If you have an existing codespace you want to use instead, you can find out its name by running:

    ```bash
    gh codespace list
    ```

2. Next, copy `codespace-remote-ssh-connect.sh` (macOS / Linux) or `codespace-remote-ssh-connect.ps1` and `codespace-remote-ssh-connect.cmd` (Windows) to your local machine.

3. In a **local** terminal, use the script to set up a connection to the codespace. For example, on macOS / Linux (replacing &lt;codespace-name&gt; with the name from step 1):

    ```bash
    bash codespace-remote-ssh-connect.sh <codespace-name>
    ```

    ... or on Windows, use PowerShell/Command Prompt (not WSL) as follows:
    ```powershell
    .\codespace-remote-ssh-connect.cmd <codespace-name>
    ```

4. In the new Remote - SSH VS Code window that appears, start a new VS Code terminal.

5. Run the following for each folder with a dev container you want to open:

    ```bash
    code <folder name>
    ```

    For example:

    ```bash
    code codespaces-multi-dev-container/container-1-src
    code codespaces-multi-dev-container/container-2-src
    ```


6. In each new window, click the "Reopen in Container" button in the notification that appears.

7. After everything is up and running, use each window as you would normally.

## Adapting the sample for your own use

To adapt for your own use:

1. Make a copy of the appropriate `codespace-remote-ssh-connect-*.*` files on your local machine in a spot where you can use them. (You can optionally place them in other repositories to share with others, but this is not required).
2. You do not need a custom container configuration in the root of your repository for this model to work. However, if your repository has a `.devcontainer` folder or `.devcontainer.json` file in the root of the repository with a custom image or Dockerfile, make sure the [docker-in-docker](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/docker-in-docker.md) is included.
3. Add your actual dev container configuration files to sub-folders in the repository rather than the repository root.
4. Use the script as described above to access them.

## TODOs

There are few to-dos for this sample:

1. Cache VS Code Server between development containers to avoid having to download it multiple times.
2. Look for ways to further reduce steps.

