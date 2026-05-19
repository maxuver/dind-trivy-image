# hadolint ignore=DL3007
ARG DOCKER_VERSION=20.10.17
FROM docker:${DOCKER_VERSION}-dind

ARG TRIVY_VERSION=0.45.0
ENV TRIVY_CACHE_DIR=/trivy-cache \
    TRIVY_NO_PROGRESS=true \
    TRIVY_QUIET=true

# hadolint ignore=DL3018
RUN apk add --no-cache curl bash ca-certificates git && \
    curl -sSL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz" \
      | tar xz -C /usr/local/bin trivy && \
    mkdir -p ${TRIVY_CACHE_DIR} && \
    trivy --cache-dir ${TRIVY_CACHE_DIR} image --download-db-only && \
    trivy --cache-dir ${TRIVY_CACHE_DIR} image --download-java-db-only

RUN trivy --version && docker --version

LABEL org.opencontainers.image.source="https://github.com/maxuver/dind-trivy-image"
