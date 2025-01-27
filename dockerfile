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

# Step 2: Install basic build dependencies (start simple)
RUN apk add --no-cache \
    build-base \
    libffi-dev \
    unzip \
    && rm -rf /var/cache/apk/*

# Step 3: Install Ruby and Golang (additional dependencies)
RUN apk add --no-cache \
    ruby \
    golang \
    && rm -rf /var/cache/apk/*

# Step 4: Test if each step works individually (installing Maven separately)
RUN apk add --no-cache maven && rm -rf /var/cache/apk/*

# Step 5: Test if Terraform works on Alpine
RUN apk add terraform && rm -rf /var/cache/apk/*

# Step 6: Install Snyk CLI globally
RUN npm install -g snyk

# Expose default working directory for scans
WORKDIR /workspace

# Default command to display Snyk version and instructions
CMD ["sh", "-c", "echo 'Snyk CLI is installed. Use it in your Jenkins pipeline or manually from this container.' && snyk --version"]
