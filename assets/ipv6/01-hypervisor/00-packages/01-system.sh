#!/bin/bash

sudo dnf install dnsmasq radvd vim golang podman bind-utils net-tools httpd-tools tree htop strace tmux
systemctl enable --now podman