ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG FRP_VERSION

COPY bootstrap.sh /bootstrap.sh
COPY run.sh /run.sh
COPY frpc.toml /frpc.toml

# Install jq for parsing HA add-on options
RUN apk add --no-cache curl jq

# Install frp client
RUN chmod a+x /bootstrap.sh \
    && chmod a+x /run.sh \
    && /bootstrap.sh $BUILD_ARCH $FRP_VERSION

CMD [ "/run.sh" ]

