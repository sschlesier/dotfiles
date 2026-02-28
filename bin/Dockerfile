FROM node:22-slim

RUN apt-get update && apt-get install -y \
    git \
    curl \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Pass --build-arg CACHE_BUST=$(date +%s) to force reinstall of claude-code
ARG CACHE_BUST=1
RUN npm install -g @anthropic-ai/claude-code

RUN useradd -m -s /bin/bash claude

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER claude
WORKDIR /home/claude/workspace

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["claude", "--dangerously-skip-permissions"]
