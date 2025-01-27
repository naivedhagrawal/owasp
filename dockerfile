# Use Node.js 18 Alpine-based image
FROM node:18-alpine

# Step 1: Install essential utilities (git, curl, bash, etc.)
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    git \
    curl \
    jq \
    bash \
    && rm -rf /var/cache/apk/*

# Step 2: Install build dependencies (start simple)
RUN apk add --no-cache \
    build-base \
    libffi-dev \
    unzip \
    && rm -rf /var/cache/apk/*

# Step 3: Install Ruby (testing this package first)
RUN apk add --no-cache ruby && rm -rf /var/cache/apk/*

# Step 4: Manually Install Golang
RUN curl -fsSL https://golang.org/dl/go1.18.6.linux-amd64.tar.gz -o go.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz \
    && ln -s /usr/local/go/bin/go /usr/bin/go

# Step 5: Install Maven separately (if still required)
RUN apk add --no-cache maven && rm -rf /var/cache/apk/*

# Step 6: Test if Terraform works on Alpine
RUN apk add terraform && rm -rf /var/cache/apk/*

# Step 7: Install Snyk CLI globally
RUN npm install -g snyk

# Expose default working directory for scans
WORKDIR /workspace

# Default command to display Snyk version and instructions
CMD ["sh", "-c", "echo 'Snyk CLI is installed. Use it in your Jenkins pipeline or manually from this container.' && snyk --version"]
