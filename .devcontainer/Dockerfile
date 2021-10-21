FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-16-bullseye

# Docker script also installs socat which we'll use
ENV DOCKER_BUILDKIT=1
COPY forward-docker-socket.sh keep-me-alive.sh library-scripts/docker-debian.sh /tmp/
RUN chmod +x /tmp/docker-debian.sh /tmp/keep-me-alive.sh /tmp/forward-docker-socket.sh \
    && /tmp/docker-debian.sh \
    && su node -c 'npm install -g @vscode/dev-container-cli' \
    && mv /tmp/forward-docker-socket.sh /usr/local/share/forward-docker-socket.sh \
    && mv /tmp/keep-me-alive.sh /usr/local/bin/keep-me-alive \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/docker-debian.sh

ENTRYPOINT ["/usr/local/share/docker-init.sh", "/usr/local/share/forward-docker-socket.sh"]
CMD ["sleep", "infinity"]