#-------------------
# Download upctl
#-------------------
FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS builder

# renovate: datasource=github-releases depName=upcloud-cli lookupName=UpCloudLtd/upcloud-cli
ARG UPCTL_VERSION=3.23.0
# renovate: datasource=docker depName=hashicorp/packer lookupName=hashicorp/packer
ARG PACKER_VERSION=1.14.2
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
FROM hashicorp/packer:1.14.2@sha256:250bf3081634255dcabb112ceefd8c77f0b9093e16b21a15516d03a7e996d239 AS packer

COPY --from=builder /bin/upctl /bin/upctl
