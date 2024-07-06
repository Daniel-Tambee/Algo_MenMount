# Use Ubuntu as a base image
FROM ubuntu:22.04

# Set the environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    npm \
    curl \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    lsb-release \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Docker (Docker in Docker) with Compose plugin
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.12 and PipX
RUN add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y python3.12 python3.12-venv python3-pip \
    && python3.12 -m pip install --upgrade pip \
    && python3.12 -m pip install --user pipx \
    && /root/.local/bin/pipx ensurepath \
    && rm -rf /var/lib/apt/lists/*

# Install AlgoKit using PipX
RUN /root/.local/bin/pipx install algokit

# Set up the environment
ENV PATH="/root/.local/bin:${PATH}"

# Verify installation
RUN docker --version && \
    docker compose version && \
    git --version && \
    npm --version && \
    python3.12 --version && \
    algokit --version

# Entry point
CMD ["bash"]
