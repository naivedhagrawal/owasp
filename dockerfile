# Base image with Node.js (Slim Debian-based)
FROM node:18-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    git \
    curl \
    jq \
    docker-ce-cli \
    build-essential \
    libffi-dev \
    unzip \
    && apt-get install -y openjdk-11-jdk \
    && apt-get install -y maven \
    && apt-get install -y ruby-full \
    && apt-get install -y golang \
    && apt-get install -y php-cli \
    && pip3 install --upgrade pip \
    && pip3 install ansible-lint cfn-lint checkov \
    && gem install bundler \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y terraform \
    && rm -rf /var/lib/apt/lists/*

# Install Snyk CLI globally
RUN npm install -g snyk

# Expose default working directory for scans
WORKDIR /workspace

# Default command to display Snyk version and instructions
CMD ["sh", "-c", "echo 'Snyk CLI is installed. Use it in your Jenkins pipeline or manually from this container.' && snyk --version"]
