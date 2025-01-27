# Use Node.js 18 Alpine-based image
FROM node:18-alpine

# Install necessary dependencies
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    git \
    curl \
    jq \
    build-base \
    libffi-dev \
    unzip \
    maven \
    ruby \
    golang \
    php7-cli \
    openjdk11 \
    bash \
    && pip3 install --upgrade pip \
    && pip3 install ansible-lint cfn-lint checkov \
    && gem install bundler \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list \
    && apk add terraform \
    && rm -rf /var/cache/apk/*

# Install Docker CLI (docker-ce-cli) on Alpine (docker-cli available from the Docker's official repository)
RUN curl -fsSL https://download.docker.com/linux/alpine/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/alpine $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apk add docker-cli \
    && rm -rf /var/cache/apk/*

# Install Snyk CLI globally
RUN npm install -g snyk

# Expose default working directory for scans
WORKDIR /workspace

# Default command to display Snyk version and instructions
CMD ["sh", "-c", "echo 'Snyk CLI is installed. Use it in your Jenkins pipeline or manually from this container.' && snyk --version"]
