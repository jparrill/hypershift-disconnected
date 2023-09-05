#!/bin/bash

sudo yum -y install libvirt libvirt-daemon-driver-qemu qemu-kvm
sudo usermod -aG qemu,libvirt $(id -un)
sudo newgrp libvirt
sudo systemctl enable --now libvirtd
sudo dnf -y copr enable karmab/kcli
sudo dnf -y install kcli
sudo kcli create pool -p /var/lib/libvirt/images default
kcli create host kvm -H 127.0.0.1 local
sudo setfacl -m u:$(id -un):rwx /var/lib/libvirt/images
kcli create network  -c 192.168.122.0/24 default