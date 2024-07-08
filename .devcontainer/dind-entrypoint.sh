#!/bin/bash
set -e

# Start Docker daemon
/usr/bin/dockerd &

# Wait until Docker daemon is running
while (! docker stats --no-stream ); do
  echo "Waiting for Docker to launch..."
  sleep 1
done

# Execute the original command
exec "$@"
