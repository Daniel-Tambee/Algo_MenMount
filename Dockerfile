# Use the official Python image as a base image
FROM python:3.12-slim

# Install necessary packages
RUN apt install -y \
    git \
    npm \
    curl \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Docker (Docker in Docker) with Compose plugin
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Install PipX
RUN python -m pip install --upgrade pip \
    && python -m pip install --user pipx \
    && python -m pipx ensurepath

# Install AlgoKit using PipX
RUN pipx install algokit

# Set up the environment
ENV PATH="/root/.local/bin:${PATH}"

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify installation
RUN docker --version && \
    docker compose version && \
    git --version && \
    npm --version && \
    algokit --version

# Entry point
CMD ["bash"]
