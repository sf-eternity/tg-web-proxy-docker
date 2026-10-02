An implementation of tg-web-proxy designed for easy deployment in Docker.

Base: https://github.com/RTHeLL/tg-web-proxy

# Docker compose file
Normally, you don't need to touch anything here; settings can be configured via the .env file.
```yaml
services:
  tproxy:
    image: ghcr.io/sf-eternity/tg-web-proxy-docker:latest
    container_name: tg-web-proxy-docker
    restart: unless-stopped
    env_file:
      - .env
    ports:
      - "${LISTENING_PORT_HTTP}:80"
      - "${LISTENING_PORT_HTTPS}:443"
    volumes:
      - ./site:/srv/tproxy-site:ro
      - ./caddy_data:/data/caddy
    extra_hosts:
      - "host.docker.internal:host-gateway"
    healthcheck:
      test: ["CMD", "curl", "--fail", "--silent", "http://127.0.0.1:8081/readyz"]
      interval: 30s
      timeout: 5s
      retries: 5
      start_period: 45s
```


# Usage

clone repo:
```shell
git clone https://github.com/sf-eternity/tg-web-proxy-docker.git
cd tg-web-proxy-docker
```

make .env:
```shell
cp .env.example .env
```

```env
# SERVER SETTINGS
LISTENING_PORT_HTTP: 80
LISTENING_PORT_HTTPS: 443
TPROXY_HOSTNAME: proxy.example.com
ACME_EMAIL: you@example.com
SITE_VARIANT: northwind-field
# openssl rand -hex 16
TPROXY_SECRET: ""

# PROXY  SETTINGS
# a proxy that the server itself will use to connect to Telegram.
PROXY_ENABLED: "false" 
PROXY_TYPE: "socks5"
PROXY_ADDRESS: "host.docker.internal:1080"
PROXY_USERNAME: ""
PROXY_PASSWORD: ""

# PUBLIC SITE SETTINGS
# directory with stub site files. Will be ignored if PUBLIC_SITE_UPSTREAM specified.
PUBLIC_SITE_DIR: "/srv/tproxy-site"
# http (not https) url of public site. Example: http://host.docker.internal:5000
PUBLIC_SITE_UPSTREAM: "" 
```

start
```shell
docker compose up -d
```
