FROM node:18-alpine AS build

# Install required system dependencies for various package managers and compilers
RUN apk add --no-cache \
    git \
    make \
    g++ \
    python3 \
    py3-pip \
    bash \
    openjdk17 \
    curl \
    wget \
    gnupg \
    zip \
    unzip

# Install snyk CLI
RUN npm install -g snyk@latest

# Create a working directory
WORKDIR /app

# Copy project files (this should be optimized in a real-world scenario)
COPY . .

# Install dependencies for different project types
RUN if [ -f "package.json" ]; then npm ci; fi
RUN if [ -f "yarn.lock" ]; then yarn install --frozen-lockfile; fi
RUN if [ -f "pom.xml" ]; then mvn dependency:go-offline; fi # Maven
RUN if [ -f "build.gradle" ]; then ./gradlew dependencies; fi # Gradle
RUN if [ -f "requirements.txt" ]; then pip3 install -r requirements.txt; fi # Python
RUN if [ -f "Gemfile" ]; then bundle install; fi # Ruby

# --- Snyk Scan Stage ---
FROM alpine:latest

# Install required system dependencies for snyk
RUN apk add --no-cache \
    bash \
    curl \
    gnupg \
    ca-certificates

# Copy snyk binary from the build stage
COPY --from=build /usr/local/bin/snyk /usr/local/bin/snyk
COPY --from=build /app /app

WORKDIR /app

# Set entrypoint to run snyk scan. You can customize the scan targets here.
ENTRYPOINT ["/usr/local/bin/snyk", "test", "--all-projects", "--severity-threshold=high", "--fail-on=all"]

# Example of running a specific scan target
# ENTRYPOINT ["/usr/local/bin/snyk", "test", "--file=package.json"]

# Example for container scanning
# ENTRYPOINT ["/usr/local/bin/snyk", "container", "test", "your-image-name"]

# Example for IaC scanning
# ENTRYPOINT ["/usr/local/bin/snyk", "iac", "test", "."]

# Example for Code scanning
# ENTRYPOINT ["/usr/local/bin/snyk", "code", "test", "."]

# Example with authentication (using SNYK_TOKEN environment variable)
# ENV SNYK_TOKEN="your_snyk_token"
# ENTRYPOINT ["/usr/local/bin/snyk", "auth", "$SNYK_TOKEN", "&&", "/usr/local/bin/snyk", "test", "--all-projects", "--severity-threshold=high", "--fail-on=all"]