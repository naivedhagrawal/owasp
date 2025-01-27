FROM debian:stable-slim

# Set working directory
WORKDIR /workspace

# Install essential dependencies and language toolchains
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 python3-pip python3-venv \
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
    gnupg \
    maven \
    gradle \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install .NET SDK (latest LTS)
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel lts \
    && rm dotnet-install.sh

# Set environment variables for .NET
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"

# Add Docker GPG key and repository for Docker CLI support
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    > /etc/apt/sources.list.d/docker.list

# Install Docker CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
    docker-ce-cli \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Snyk CLI globally
RUN npm install -g snyk@latest && npm cache clean --force

# Create a non-root user for running Snyk
RUN groupadd -r snyk && useradd -r -g snyk snyk

# Switch to non-root user
USER snyk

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD snyk --version || exit 1

# Entrypoint to default to Snyk commands
ENTRYPOINT ["snyk"]

# Default command
CMD ["--help"]
