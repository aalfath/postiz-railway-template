#!/bin/sh
# nginx owns Railway's PORT (default 5000) and proxies to the frontend (4200)
# and the backend (3000). The backend also reads PORT, so it gets 3000.
set -eu
LISTEN_PORT="${PORT:-5000}"
if [ "$LISTEN_PORT" != "5000" ]; then
  sed -i "s/listen 5000;/listen ${LISTEN_PORT};/" /etc/nginx/nginx.conf
fi
mkdir -p "${UPLOAD_DIRECTORY:-/uploads}"
nginx
export PORT=3000
exec pnpm run pm2
