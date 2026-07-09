#!/bin/bash
set -e

BUILD_ARCH=$1
FRP_VERSION=$2

echo "Installing FRP version ${FRP_VERSION} for architecture ${BUILD_ARCH}"

select_machine() {
    local machine;
    case $1 in
        "aarch64")
            machine="arm64"
            ;;
        "amd64")
            machine="amd64"
            ;;
        "armhf")
            machine="arm"
            ;;
        "armv7")
            machine="arm"
            ;;
        "i386")
            machine="386"
            ;;
        *)
            echo "Unsupported architecture: $1"
            exit 1
            ;;
    esac
    echo "$machine"
}

MACHINE=$(select_machine $BUILD_ARCH)

DOWNLOAD_URL="https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${MACHINE}.tar.gz"

echo "Downloading frp from: $DOWNLOAD_URL"

mkdir -p /tmp/frp
curl -L -o /tmp/frp.tar.gz "$DOWNLOAD_URL"
tar -xzf /tmp/frp.tar.gz -C /tmp/frp --strip-components=1

cp /tmp/frp/frpc /usr/src/frpc
chmod a+x /usr/src/frpc

rm -rf /tmp/frp /tmp/frp.tar.gz

echo "FRP client installed successfully: $(/usr/src/frpc --version)"
