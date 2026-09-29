FROM ghcr.io/sf-eternity/tg-web-proxy-image:1

RUN apt-get update && apt-get install -y \
    socat jq gettext-base \
    && apt-get clean \
    && rm -rf /var/lib/lists/*

RUN mkdir /default
RUN mv \
    /etc/tproxy-server/config.template.json \
    /etc/telmet/telmet.template.toml \
    /default/

COPY preentrypoint.sh /preentrypoint.sh
COPY proxy.template /templates/proxy.template

RUN chmod 0755 /preentrypoint.sh

ENTRYPOINT [ "/preentrypoint.sh" ]