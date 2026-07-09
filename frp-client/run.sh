#!/bin/bash
set -e

# Load bashio
if [ -f /usr/lib/bashio/bashio.sh ]; then
    source /usr/lib/bashio/bashio.sh
fi

CONFIG_PATH='/share/frpc.toml'
DEFAULT_CONFIG_PATH='/frpc.toml'

if [ ! -f "$CONFIG_PATH" ]; then
    cp $DEFAULT_CONFIG_PATH $CONFIG_PATH
fi

# Replace configuration placeholders with actual values
sed -i "s/your_server_addr/$(bashio::config 'serverAddr')/g" $CONFIG_PATH
sed -i "s/7000/$(bashio::config 'serverPort')/g" $CONFIG_PATH
sed -i "s/123456789/$(bashio::config 'authToken')/g" $CONFIG_PATH
sed -i "s/your_local_ip/$(bashio::config 'localIP')/g" $CONFIG_PATH
sed -i "s/8123/$(bashio::config 'localPort')/g" $CONFIG_PATH
sed -i "s/your_proxy_name/$(bashio::config 'proxyName')/g" $CONFIG_PATH
sed -i "s/your_domain/$(bashio::config 'customDomain')/g" $CONFIG_PATH

cd /usr/src

./frpc -c $CONFIG_PATH > /share/frpc.log 2>&1 &
FRPC_PID=$!

stop_frpc() {
    echo "Stopping frpc..."
    kill -15 $FRPC_PID
    wait $FRPC_PID 2>/dev/null
    echo "frpc stopped."
    exit 0
}

trap stop_frpc SIGTERM SIGHUP

tail -f /share/frpc.log &
wait $FRPC_PID
