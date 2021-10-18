# GitHub Codespaces Multi-Development Container

Visual Studio Code Remote - Containers supports [a pattern](https://code.visualstudio.com/remote/advancedcontainers/connect-multiple-containers) that allows the use of multiple development containers at the same time for a source tree. Unfortunatley [GitHub Codespaces](https://github.com/features/codespaces) does not currently support attaching a second window to a different container in the same Codespaces. However, the fact that the same technology is used in both Remote - Containers and Codespaces allows you to use the Remote - Containers extension with a Codespace to achieve the same goal with some subtle tweaks.

Codespaces will ultimately have first class support for this partern, so this is a workaround given current limitations.

## Setup

1. Install VS Code locally
2. Install the [GitHub Codespaces](https://marketplace.visualstudio.com/items?itemName=GitHub.codespaces) extension in local VS Code
3. Install the [VS Code Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in local VS Code
4. Install Docker locally

## Using this sample

1. Create a codespace from this repository from VS Code client locally (<kbd>F1</kbd> or <kbd>ctrl</kbd>+<kbd>shift</kbd>+<kbd>p</kbd>, select **Codesaces: Create New Codespace**, enter this repository)
2. Copy `open-codespace-dev-container.sh` to your local machine.
3. Use the script to set up a connection to one of the sub-folders in this repository. For example:

    ```bash
    ./open-codespace-dev-container.sh container-1-src
    ```

4. In the VS Code window that appears, click **Reopen in Container** when a notification appears.

In a bit, this new window will be using the development container for this folder.

## TODOs

There are few to-dos for this sample:
1. Use a script to print terminal output in the "Boostrap" container to keep all the containers running - once the gh cli supports connecting via SSH, this could be used as well.
2. Create a PowerShell version of the `open-codespace-dev-container.sh` script for Windows.
3. Cache VS Code Server between development containers to avoid having to download it multiple times.
4. Look for ways to further reduce steps.
5. Update the Remote - Containers documentation to describe the pattern this way.

## Adapting the sample for your own use

This sample applies the same [patterns](https://code.visualstudio.com/remote/advancedcontainers/connect-multiple-containers) used in Remote - Containers for this same scenario. To adapt for your own use:

1. Modify the extensions and contents of each dev container by updating the `Dockerfile` and `devcontainer.json` file in `container-1-src` and `container-2-src` as needed. You can also rename the folders.
2. If you need to add another folder, copy the contents of `container-1-src` to create a new folder. Then update `docker-compose.yml` and add a new section for your container. For example, if you created a `container-3-src` folder, you could add a new section like this:

    ```yaml
    # Development container 3
    container-3:
      build:
        context: container-3-src/.devcontainer
        dockerfile: Dockerfile
      volumes:
        - ./container-3-src:/workspace:cached
      command: /bin/sh -c "while sleep 1000; do :; done"
    ```

3. If your new container relies on contents outside of the `.devcontainer` folder (particularly if common across all containers), add them to `common-config.list` in the root of the repository.

There are also several variations of this same general pattern that can be used. For multi-repo scenarios, you can setup the "bootstrap" container (in the root `.devcontainer` folder) to clone repositories as described in [this sample](https://github.com/Chuxel/codespaces-multi-repo). You can then modify `docker-compose.yaml` to reference the appropriate locations for the Dockerfiles and add the appropriate `.devcontaienr` config into the repositories.
