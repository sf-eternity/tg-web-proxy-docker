#!/bin/sh
set -eu

cp /default/telemt.template.toml /etc/telemt/telemt.template.toml

if [ -n "${PROXY_ENABLED+x}" ] && [ "$PROXY_ENABLED" = "true" ]; then
    envsubst < /templates/proxy.template > /proxy
    cat /proxy >> /etc/telemt/telemt.template.toml
fi

cp /default/config.template.json /etc/tproxy-server/config.template.json

if [ -n "$PUBLIC_SITE_DIR" ]; then
    jq '.public_dir = "$PUBLIC_SITE_DIR"' /etc/tproxy-server/config.template.json > tmp.json && mv tmp.json /etc/tproxy-server/config.template.json
fi

if [ -n "$PUBLIC_SITE_UPSTREAM" ]; then
    jq 'del(.public_dir)' /etc/tproxy-server/config.template.json > tmp.json && mv tmp.json /etc/tproxy-server/config.template.json
    jq '.public_upstream = "http://127.0.0.1:3000"' /etc/tproxy-server/config.template.json > tmp.json && mv tmp.json /etc/tproxy-server/config.template.json

    UPSTREAM_CLEANED=${PUBLIC_SITE_UPSTREAM#http://}
    while true; do
        socat TCP-LISTEN:3000,bind=127.0.0.1,reuseaddr,fork TCP:"$UPSTREAM_CLEANED"
        sleep 2
    done > /dev/null 2>&1 & 
fi

exec /entrypoint.sh