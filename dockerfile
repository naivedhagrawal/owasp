FROM openjdk:11-jre-slim

# Install dependencies and dependency-check
RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://github.com/jeremylong/DependencyCheck/releases/download/v12.0.1/dependency-check-12.0.1-release.zip && \
    unzip dependency-check-12.0.1-release.zip -d /opt && \
    ln -s /opt/dependency-check/bin/dependency-check.sh /usr/local/bin/dependency-check && \
    rm dependency-check-12.0.1-release.zip
RUN dependency-check --scan .

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/dependency-check"]
