FROM debian:latest

# Install dependencies and dependency-check
RUN apt-get update && \
    apt-get install -y wget unzip openjdk-11-jre && \
    wget https://github.com/jeremylong/DependencyCheck/releases/download/v6.5.3/dependency-check-6.5.3-release.zip && \
    unzip dependency-check-6.5.3-release.zip -d /opt && \
    ln -s /opt/dependency-check/bin/dependency-check.sh /usr/local/bin/dependency-check && \
    rm dependency-check-6.5.3-release.zip

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/dependency-check"]
