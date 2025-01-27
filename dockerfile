# Use Node.js 18 Alpine-based image
FROM node:18-alpine

# Install essential utilities first (git, curl, etc.)
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    git \
    curl \
    jq \
    bash \
    && rm -rf /var/cache/apk/*

# Install build dependencies (compiler, libraries)
RUN apk add --no-cache \
    build-base \
    libffi-dev \
    unzip \
    ruby \
    golang \
    && rm -rf /var/cache/apk/*

# Install Maven separately (if still required)
RUN apk add --no-cache maven && rm -rf /var/cache/apk/*

# Install Terraform from HashiCorp repository (if required)
RUN apk add terraform && rm -rf /var/cache/apk/*

# Install Docker CLI (docker-ce-cli)
RUN curl -fsSL https://download.docker.com/linux/alpine/gpg | gpg
