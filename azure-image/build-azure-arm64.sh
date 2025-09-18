#!/bin/bash
mkdir -p output

podman run \
--rm \
--name bootc-demo-vmdk-bootc-gitops-bootc-image-builder \
--tty \
--privileged \
--security-opt label=type:unconfined_t \
-v ./output:/output/ \
-v /var/lib/containers/storage:/var/lib/containers/storage \
--label bootc.image.builder=true \
quay.io/centos-bootc/bootc-image-builder:latest \
ghcr.io/ferrory/bootc-demo-azure:stream9 \
--output /output/ \
--type vhd \
--target-arch arm64 \
--use-librepo=True \
--rootfs xfs


# -v ./config.toml:/config.toml:ro \
