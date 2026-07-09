ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG FRP_VERSION

COPY bootstrap.sh /bootstrap.sh
COPY run.sh /run.sh
COPY frpc.toml /frpc.toml

# Install bashio for Home Assistant add-on configuration support
RUN apk add --no-cache curl jq \
    && mkdir -p /tmp/bashio \
    && curl -L -f -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v0.16.2.tar.gz" | tar -xzf - --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && chmod a+x /bootstrap.sh \
    && chmod a+x /run.sh \
    && /bootstrap.sh $BUILD_ARCH $FRP_VERSION

CMD [ "/run.sh" ]
