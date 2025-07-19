#!/bin/sh
# Wait script for Mosquitto
set -e

# Wait for netmaker to be ready
while ! nc -z netmaker 8081; do
  echo "Waiting for Netmaker to be ready..."
  sleep 2
done

echo "Netmaker is ready, starting Mosquitto..."
exec /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf
