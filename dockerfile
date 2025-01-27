FROM node:18-alpine

# Install OpenJDK for Maven
RUN apk add --no-cache openjdk11

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

# Accept the Snyk token as a build argument
ARG SNYK_TOKEN

# Set the Snyk token as an environment variable
ENV SNYK_TOKEN=${SNYK_TOKEN}

# Install Snyk CLI globally
RUN npm install -g snyk

# Authenticate with Snyk using the token
RUN snyk auth $SNYK_TOKEN

# Default command (optional)
CMD [ "snyk", "--help" ]