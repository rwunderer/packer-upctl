#-------------------
# Download upctl
#-------------------
FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS builder

# renovate: datasource=github-releases depName=upcloud-cli lookupName=UpCloudLtd/upcloud-cli
ARG UPCTL_VERSION=3.37.0
# renovate: datasource=docker depName=hashicorp/packer lookupName=hashicorp/packer
ARG PACKER_VERSION=1.16.2
ARG TARGETARCH
ARG TARGETOS
ARG TARGETVARIANT

WORKDIR /tmp

RUN apk --no-cache add --upgrade \
    curl

RUN ARCH=${TARGETARCH} && \
    [ "${ARCH}" == "amd64" ] && ARCH="x86_64" || true && \
    IMAGE=upcloud-cli_${UPCTL_VERSION}_${TARGETOS}_${ARCH}${TARGETVARIANT}.tar.gz && \
    curl -SsL -o ${IMAGE} https://github.com/UpCloudLtd/upcloud-cli/releases/download/v${UPCTL_VERSION}/${IMAGE} && \
    tar xzf ${IMAGE} upctl && \
    install upctl /bin/upctl && \
    rm ${IMAGE} upctl

#-------------------
# Packer image
#-------------------
FROM hashicorp/packer:1.16.2@sha256:5aa2160b623fad0b99f8ae8d9cc162ba9775ae428367edca88addc01bb86dd52 AS packer

COPY --from=builder /bin/upctl /bin/upctl
