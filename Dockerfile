FROM n8nio/n8n:2.35.3

USER root

COPY n8n-hooks /data/hooks

ENV NODE_OPTIONS="--expose-gc"
ENV EXTERNAL_HOOK_FILES="/data/hooks/gc-after-exec.js"

RUN npm install -g npm@9 && \
    mkdir -p /opt/n8n-custom-nodes && \
    cd /opt/n8n-custom-nodes && \
    npm install --omit=dev \
      n8n-nodes-puppeteer && \
    chown -R node:node /opt/n8n-custom-nodes

RUN mkdir -p /home/node/.n8n

ENV N8N_CUSTOM_EXTENSIONS="/opt/n8n-custom-nodes"
