#!/bin/sh

DOMAIN=${1:-"localhost"}
API_URL="http://$DOMAIN:8080/jsonrpc"

/usr/bin/curl -fns -H 'content-type: application/json;' --data-binary '{"jsonrpc": "2.0", "method": "VideoLibrary.Scan",  "id": "sh"}' "$API_URL" > /dev/null
/usr/bin/curl -fns -H 'content-type: application/json;' --data-binary '{"jsonrpc": "2.0", "method": "VideoLibrary.Clean", "id": "sh"}' "$API_URL" > /dev/null
/usr/bin/curl -fns -H 'content-type: application/json;' --data-binary '{"jsonrpc": "2.0", "method": "AudioLibrary.Scan",  "id": "sh"}' "$API_URL" > /dev/null
/usr/bin/curl -fns -H 'content-type: application/json;' --data-binary '{"jsonrpc": "2.0", "method": "AudioLibrary.Clean", "id": "sh"}' "$API_URL" > /dev/null

