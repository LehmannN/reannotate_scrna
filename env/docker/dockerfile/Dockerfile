# Set the base image
FROM debian:jessie-slim

# Set image metadata
LABEL author="Nathalie Lehmann" \
      description="scAnnotatiONT Docker image" \
      maintainer="nathalie.lehmann@bio.ens.psl.eu"

# Install core packages
RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    git \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*
