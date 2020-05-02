#!/bin/sh

GRAPHITE_HOST=${1:-localhost}
GRAPHITE_PORT=${2:-2003}
GRAPHITE_PREFIX=${3:-internet}
TIME=`date +%s`
file="/tmp/speedtest"

speedtest --format=json | tee $file
ping=$(cat $file | jq .ping.latency)
download=$(cat $file | jq .download.bandwidth)
upload=$(cat $file | jq .upload.bandwidth)

echo "Sending to $GRAPHITE_HOST:$GRAPHITE_PORT:"
echo "$GRAPHITE_PREFIX.ping $ping $TIME"
echo "$GRAPHITE_PREFIX.download $(( $download * 8 )) $TIME"
echo "$GRAPHITE_PREFIX.upload $(( $upload * 8 )) $TIME"

echo "$GRAPHITE_PREFIX.ping $ping $TIME" | nc -w5 $GRAPHITE_HOST $GRAPHITE_PORT
echo "$GRAPHITE_PREFIX.download $(( $download * 8 )) $TIME" | nc -w5 $GRAPHITE_HOST $GRAPHITE_PORT
echo "$GRAPHITE_PREFIX.upload $(( $upload * 8 )) $TIME" | nc -w5 $GRAPHITE_HOST $GRAPHITE_PORT
