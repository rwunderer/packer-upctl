#-------------------
# Download upctl
#-------------------
FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS builder

# renovate: datasource=github-releases depName=upcloud-cli lookupName=UpCloudLtd/upcloud-cli
ARG UPCTL_VERSION=3.21.0
# renovate: datasource=docker depName=hashicorp/packer lookupName=hashicorp/packer
ARG PACKER_VERSION=1.13.1
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
FROM hashicorp/packer:1.13.1@sha256:feb1830f59911911e2e5a842604bda0d30ee0ca25aa0b8cc788a0ece6df11a5f AS packer

COPY --from=builder /bin/upctl /bin/upctl
