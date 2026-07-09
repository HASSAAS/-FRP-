#!/bin/bash
set -e

CONFIG_PATH='/share/frpc.toml'
DEFAULT_CONFIG_PATH='/frpc.toml'

# Read HA add-on options from /data/options.json
SERVER_ADDR=$(jq -r '.serverAddr // empty' /data/options.json)
SERVER_PORT=$(jq -r '.serverPort // empty' /data/options.json)
AUTH_TOKEN=$(jq -r '.authToken // empty' /data/options.json)
LOCAL_IP=$(jq -r '.localIP // empty' /data/options.json)
LOCAL_PORT=$(jq -r '.localPort // empty' /data/options.json)
PROXY_NAME=$(jq -r '.proxyName // empty' /data/options.json)
CUSTOM_DOMAIN=$(jq -r '.customDomain // empty' /data/options.json)

if [ ! -f "$CONFIG_PATH" ]; then
    cp $DEFAULT_CONFIG_PATH $CONFIG_PATH
fi

# Replace configuration placeholders with actual values
sed -i "s/your_server_addr/${SERVER_ADDR}/g" $CONFIG_PATH
sed -i "s/7000/${SERVER_PORT}/g" $CONFIG_PATH
sed -i "s/123456789/${AUTH_TOKEN}/g" $CONFIG_PATH
sed -i "s/your_local_ip/${LOCAL_IP}/g" $CONFIG_PATH
sed -i "s/8123/${LOCAL_PORT}/g" $CONFIG_PATH
sed -i "s/your_proxy_name/${PROXY_NAME}/g" $CONFIG_PATH
sed -i "s/your_domain/${CUSTOM_DOMAIN}/g" $CONFIG_PATH

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
