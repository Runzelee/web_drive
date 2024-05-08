#!/bin/sh

sed -i "s|bind_port = 7000|bind_port = $BIND_PORT|g" /frp/frps.toml
sed -i "1 a vhostHTTPPort = 8080" /frp/frps.toml
/frp/frps -c /frp/frps.toml
