FROM debian:stable-slim

WORKDIR /app

# Install essential dependencies, including wget
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
    wget \
    && rm -rf /var/lib/apt/lists/* # Correct placement of &&

# Install .NET SDK 6.0
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 6.0 \
    && rm dotnet-install.sh

ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
RUN apt-get update && apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io docker-compose-plugin && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group (AFTER Docker installation)
RUN groupadd -r snyk && useradd -r -g snyk snyk

# Add snyk user to docker group (AFTER Docker installation)
RUN usermod -aG docker snyk

# Install Snyk CLI globally (using build argument)
ARG SNYK_TOKEN
RUN npm config set '@snyk:registry' 'https://registry.npmjs.org/'
RUN npm install -g snyk@latest
RUN snyk config set token $SNYK_TOKEN

# Switch to the non-root user
USER snyk

# Set working directory
WORKDIR /app

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD snyk --version || exit 1

# Entrypoint
ENTRYPOINT ["snyk"]