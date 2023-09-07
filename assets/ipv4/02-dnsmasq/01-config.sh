#!/bin/bash

mkdir -p /opt/dnsmasq

cp -r dnsmasq.conf upstream-resolv.conf include.d /opt/dnsmasq/
cp dnsmasq-virt.service /etc/systemd/system/dnsmasq-virt.service

systemctl daemon-reload
systemctl disable --now dnsmasq
systemctl enable --now dnsmasq-virt