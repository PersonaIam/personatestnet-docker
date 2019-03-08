#!/bin/bash

set -e

CONFIG_FILE=$HOME/persona-node/config.$NETWORK.json
tmp=$(mktemp)
jq '.db |= . + {"host":"'$DB_HOST'"} | .db |= . + {"database":"'$DB_NAME'"} | .db |= . + {"user":"'$DB_USER'"} | .db |= . + {"password":"'$DB_PASSWORD'"}' $CONFIG_FILE > "$tmp" && mv "$tmp" $CONFIG_FILE

# Start persona node
exec pm2-docker start app.js -- --genesis genesisBlock.$NETWORK.json --config config.$NETWORK.json

exec "$@"
