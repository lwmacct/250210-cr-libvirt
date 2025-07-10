#!/usr/bin/env bash
{
    chown root:kvm /dev/kvm
    chmod 660 /dev/kvm
    cat >/etc/libvirt/qemu.conf <<EOF
user = "root"
group = "root"
dynamic_ownership = 0
EOF

}
