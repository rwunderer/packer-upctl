#-------------------
# Download upctl
#-------------------
FROM alpine:3.18.4@sha256:eece025e432126ce23f223450a0326fbebde39cdf496a85d8c016293fc851978 as builder

# renovate: datasource=github-releases depName=upcloud-cli lookupName=UpCloudLtd/upcloud-cli
ARG UPCTL_VERSION=3.1.0
# renovate: datasource=docker depName=hashicorp/packer lookupName=hashicorp/packer
ARG PACKER_VERSION=1.9.4
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
FROM hashicorp/packer:1.9.4@sha256:33386b90aeb67a1dde1730b75a67d306dc8b9aebf2a0bbb96d9e96164b484e2b as packer

COPY --from=builder /bin/upctl /bin/upctl
