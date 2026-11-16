# Postiz for Railway: the official image, pinned by version and digest,
# plus a small start script. Bump the tag and digest together to upgrade.
FROM ghcr.io/gitroomhq/postiz-app:v2.26.0@sha256:875e61ac5d0ac43c3dec78a78a7032dfb03d9a8c6d4936ebb18adb606cc207c5

# Postiz sets its login cookie on the registrable domain of FRONTEND_URL.
# For a *.up.railway.app address that is ".railway.app", so browsers would send
# the session cookie to every app hosted on Railway. Make every cookie that
# passes through nginx (frontend and API) host-only for the requested host.
RUN sed -i 's|^\(\s*\)listen 5000;|&\n\1proxy_cookie_domain ~^.+$ $host;|' /etc/nginx/nginx.conf \
 && grep -q 'proxy_cookie_domain' /etc/nginx/nginx.conf \
 && nginx -t

# Fixed settings from upstream's docker-compose. Uploaded media lives on the
# /uploads volume and nginx serves it from the app's own domain.
ENV IS_GENERAL=true \
    BACKEND_INTERNAL_URL=http://localhost:3000 \
    STORAGE_PROVIDER=local \
    UPLOAD_DIRECTORY=/uploads \
    NEXT_PUBLIC_UPLOAD_DIRECTORY=/uploads \
    RUN_CRON=true \
    NX_ADD_PLUGINS=false

COPY start.sh /railway-start.sh
RUN chmod 755 /railway-start.sh

EXPOSE 5000
CMD ["/railway-start.sh"]
