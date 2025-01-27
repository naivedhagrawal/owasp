FROM debian:stable-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    make \
    g++ \
    nodejs \
    npm \
    default-jre-headless \
    dotnet-sdk-6.0 \
    ruby \
    golang \
    bash \
    curl \
    zip \
    unzip \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    gnupg \
    maven \
    gradle \
    && rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine (optional, only if needed for Docker-in-Docker)
RUN apt-get update && apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io docker-compose-plugin && rm -rf /var/lib/apt/lists/*

# Install Snyk CLI globally
RUN npm install -g snyk@latest

# Create a non-root user and group
RUN groupadd -r snyk && useradd -r -g snyk snyk

# Add snyk user to docker group (optional, only if needed for Docker-in-Docker)
RUN usermod -aG docker snyk

# Switch to the non-root user
USER snyk

# Set working directory (optional - can be overridden by volume mount)
WORKDIR /app

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD snyk --version || exit 1

# Entrypoint to run Snyk scan with options
ENTRYPOINT ["snyk"]