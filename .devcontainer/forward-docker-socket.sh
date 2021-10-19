#!/usr/bin/env bash

SOURCE_SOCKET="/var/run/docker.sock"
TARGET_PORT="9256"

# Wrapper function to only use sudo if not already root
sudoIf()
{
    if [ "$(id -u)" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Set up socket forwader
sudoIf nohup bash -c "socat TCP-LISTEN:${TARGET_PORT},fork,bind=127.0.0.1 UNIX-CONNECT:${SOURCE_SOCKET} > /tmp/socat.log 2>&1 &" > /dev/null 2>&1

set +e
exec "$@"