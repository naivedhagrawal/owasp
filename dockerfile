# Use a base image with Node.js
FROM node:18-alpine

# Accept the Snyk token as a build argument
ARG SNYK_TOKEN

# Set the Snyk token as an environment variable
ENV SNYK_TOKEN=${SNYK_TOKEN}

# Install Snyk CLI globally
RUN npm install -g snyk

# Authenticate with Snyk using the token
RUN snyk auth $SNYK_TOKEN

# Set a default working directory
WORKDIR /app

# Default command (optional)
CMD [ "snyk", "--help" ]