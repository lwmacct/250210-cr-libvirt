FROM ghcr.io/lwmacct/250209-cr-vscode:dev-2502090
ARG DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libvirt-daemon-system-systemd libvirt-daemon-driver-* \
        virt-manager qemu-utils qemu-system-x86 qemu-system-arm \
        libvirt-clients dnsmasq ebtables \
        grub-pc-dbg grub-efi-amd64-dbg \
        xorriso live-build syslinux squashfs-tools reprepro dosfstools; \
    npm cache clean --force; \
    useradd libvirt-qemu; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        bridge-utils; \
    echo;

COPY apps/ /apps/

LABEL org.opencontainers.image.source=https://github.com/lwmacct/250210-cr-libvirt
LABEL org.opencontainers.image.licenses=MIT
