# Use a slim version of Debian as a base image
FROM debian:bookworm-slim

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
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.12 from deadsnakes PPA
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y python3.12 python3.12-venv python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install PipX
RUN pip3 install --upgrade pip \
    && pip3 install --user pipx \
    && /root/.local/bin/pipx ensurepath

# Install AlgoKit using PipX
RUN /root/.local/bin/pipx install algokit

# Set up the environment
ENV PATH="/root/.local/bin:${PATH}"

# Verify installation
RUN docker --version && \
    docker compose version && \
    git --version && \
    npm --version && \
    algokit --version

# Entry point
CMD ["bash"]
