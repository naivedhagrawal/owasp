FROM owasp/dependency-check:latest

# Install dependency-check
RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://github.com/jeremylong/DependencyCheck/releases/download/v6.5.3/dependency-check-6.5.3-release.zip && \
    unzip dependency-check-6.5.3-release.zip -d /opt && \
    ln -s /opt/dependency-check/bin/dependency-check.sh /usr/local/bin/dependency-check && \
    rm dependency-check-6.5.3-release.zip

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/dependency-check"]
