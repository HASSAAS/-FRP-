ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG FRP_VERSION

COPY bootstrap.sh /bootstrap.sh
COPY run.sh /run.sh
COPY frpc.toml /frpc.toml

# Step 1: Install required packages
RUN apk add --no-cache curl jq

# Step 2: Install bashio
RUN mkdir -p /tmp/bashio \
    && curl -L -f -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v0.16.2.tar.gz" -o /tmp/bashio.tar.gz \
    && tar -xzf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio /tmp/bashio.tar.gz

# Step 3: Set permissions and install frp
RUN chmod a+x /bootstrap.sh \
    && chmod a+x /run.sh \
    && /bootstrap.sh $BUILD_ARCH $FRP_VERSION

CMD [ "/run.sh" ]

