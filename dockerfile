FROM debian:stable-slim

WORKDIR /app

# Install essential dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    make \
    g++ \
    nodejs \
    npm \
    default-jre-headless \
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

# Install .NET SDK 6.0 (Correct way)
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 6.0 \
    && rm dotnet-install.sh

# Set environment variables for .NET
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"

# ... (rest of your Dockerfile)

# Install Snyk CLI globally
RUN npm install -g snyk@latest

# Create a non-root user and group
RUN groupadd -r snyk && useradd -r -g snyk snyk

# Add snyk user to docker group
RUN usermod -aG docker snyk

# Switch to the non-root user
USER snyk

# Set working directory
WORKDIR /app

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD snyk --version || exit 1

# Entrypoint
ENTRYPOINT ["snyk"]