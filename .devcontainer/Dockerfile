# Use Ubuntu as a base image
FROM ubuntu:22.04

# Set the environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    lsb-release \
    gnupg \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    tk-dev \
    libffi-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Docker (Docker in Docker) with Compose plugin
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.12 from source
RUN wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz \
    && tar -xvf Python-3.12.0.tgz \
    && cd Python-3.12.0 \
    && ./configure --enable-optimizations \
    && make -j $(nproc) \
    && make altinstall \
    && cd .. \
    && rm -rf Python-3.12.0 Python-3.12.0.tgz

# Install PipX
RUN python3.12 -m ensurepip \
    && python3.12 -m pip install --upgrade pip \
    && python3.12 -m pip install --user pipx \
    && /root/.local/bin/pipx ensurepath

# Install AlgoKit using PipX
RUN /root/.local/bin/pipx install algokit

# Set up the environment
ENV PATH="/root/.local/bin:${PATH}"

# Copy and configure Docker entrypoint script
COPY dind-entrypoint.sh /usr/local/bin/dind-entrypoint.sh
RUN chmod +x /usr/local/bin/dind-entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/dind-entrypoint.sh"]

# Verify installation
RUN docker --version && \
    docker compose version && \
    git --version && \
    npm --version && \
    node --version && \
    python3.12 --version && \
    algokit --version

# Default command
CMD ["bash"]
