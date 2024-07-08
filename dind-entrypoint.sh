#!/bin/sh
# Start the Docker daemon in the background
dockerd &

# Wait for the Docker daemon to start
while ! docker info > /dev/null 2>&1; do
    echo "Waiting for Docker daemon to start..."
    sleep 1
done

# Execute the passed command
exec "$@"
