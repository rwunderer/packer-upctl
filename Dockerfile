#-------------------
# Download upctl
#-------------------
FROM alpine:3.19.0@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48 as builder

# renovate: datasource=github-releases depName=upcloud-cli lookupName=UpCloudLtd/upcloud-cli
ARG UPCTL_VERSION=3.3.0
# renovate: datasource=docker depName=hashicorp/packer lookupName=hashicorp/packer
ARG PACKER_VERSION=1.10.1
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
FROM hashicorp/packer:1.10.1@sha256:f4d956671d79a2173a62ccfac261b611ea7cde8e8da30971b9dfb294fd960b16 as packer

COPY --from=builder /bin/upctl /bin/upctl
