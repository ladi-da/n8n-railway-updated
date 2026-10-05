FROM n8nio/n8n:latest

USER root

# Copy external execution hook
COPY n8n-hooks /data/hooks

# Enable explicit GC + register hook
ENV NODE_OPTIONS="--expose-gc"
ENV EXTERNAL_HOOK_FILES="/data/hooks/gc-after-exec.js"

# Install Puppeteer community node.
# Build dependencies are required for native modules under the newer Node version,
# then removed so they don't remain in the final image.
RUN apk add --no-cache --virtual .build-deps \
        python3 \
        make \
        g++ && \
    mkdir -p /opt/n8n-custom-nodes && \
    cd /opt/n8n-custom-nodes && \
    npm install --omit=dev \
        n8n-nodes-puppeteer && \
    chown -R node:node /opt/n8n-custom-nodes && \
    apk del .build-deps

# Create n8n data directory
RUN mkdir -p /home/node/.n8n

# Load custom/community nodes
ENV N8N_CUSTOM_EXTENSIONS="/opt/n8n-custom-nodes"

# Stay root because your runtime-mounted volume needs root/chown handling
