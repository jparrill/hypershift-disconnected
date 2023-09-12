The DNS part it's one of the mosts critical parts. To configure the name resolution in our virtualized environment we will need to:

Create the DNS main configuration for the dnsmasq server:

- `/opt/dnsmasq/dnsmasq.conf`
```conf
strict-order
bind-dynamic
#log-queries
bogus-priv
dhcp-authoritative

#BM Network IPv6
dhcp-range=ipv6,2620:52:0:1306::11,2620:52:0:1306::20,64
dhcp-option=ipv6,option6:dns-server,2620:52:0:1306::1

resolv-file=/opt/dnsmasq/upstream-resolv.conf
except-interface=lo
dhcp-lease-max=81
log-dhcp
no-hosts

# DHCP Reservations
dhcp-leasefile=/opt/dnsmasq/hosts.leases

# Include all files in a directory depending on the suffix
conf-dir=/opt/dnsmasq/include.d/*.ipv6
```

Create the upstream resolver to delegate the non-local environments queries

- `/opt/dnsmasq/upstream-resolv.conf`
```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

Create the different component DNS configurations

- `/opt/dnsmasq/include.d/hosted-nodeport.ipv6`
```
host-record=api-int.hosted-ipv6.hypershiftbm.lab,2620:52:0:1306::5
host-record=api-int.hosted-ipv6.hypershiftbm.lab,2620:52:0:1306::6
host-record=api-int.hosted-ipv6.hypershiftbm.lab,2620:52:0:1306::7
host-record=api.hosted-ipv6.hypershiftbm.lab,2620:52:0:1306::5
host-record=api.hosted-ipv6.hypershiftbm.lab,2620:52:0:1306::6
host-record=api.hosted-ipv6.hypershiftbm.lab,2620:52:0:1306::7
address=/apps.hosted-ipv6.hypershiftbm.lab/2620:52:0:1306::60
dhcp-host=aa:aa:aa:aa:04:11,hosted-worker0,[2620:52:0:1306::11]
dhcp-host=aa:aa:aa:aa:04:12,hosted-worker1,[2620:52:0:1306::12]
dhcp-host=aa:aa:aa:aa:04:13,hosted-worker2,[2620:52:0:1306::13]
```

- `/opt/dnsmasq/include.d/hub.ipv6`
```
host-record=api-int.hub-ipv6.hypershiftbm.lab,2620:52:0:1306::2
host-record=api.hub-ipv6.hypershiftbm.lab,2620:52:0:1306::2
address=/apps.hub-ipv6.hypershiftbm.lab/2620:52:0:1306::3
dhcp-host=aa:aa:aa:aa:03:01,ocp-master-0,[2620:52:0:1306::5]
dhcp-host=aa:aa:aa:aa:03:02,ocp-master-1,[2620:52:0:1306::6]
dhcp-host=aa:aa:aa:aa:03:03,ocp-master-2,[2620:52:0:1306::7]
dhcp-host=aa:aa:aa:aa:03:06,ocp-installer,[2620:52:0:1306::8]
dhcp-host=aa:aa:aa:aa:03:07,ocp-bootstrap,[2620:52:0:1306::9]
```

- `/opt/dnsmasq/include.d/infra.ipv6`
```
host-record=registry.hypershiftbm.lab,2620:52:0:1306::1
```

Now we need to create the systemd service to manage this dnsmasq and disable the system one:

- `/etc/systemd/system/dnsmasq-virt.service`
```
[Unit]
Description=DNS server for Openshift 4 Clusters.
After=network.target

[Service]
User=root
Group=root
ExecStart=/usr/sbin/dnsmasq -k --conf-file=/opt/dnsmasq/dnsmasq.conf

[Install]
WantedBy=multi-user.target
```

The commands to do so:

```
systemctl daemon-reload
systemctl disable --now dnsmasq
systemctl enable --now dnsmasq-virt
```

!!! note

    This step is required for **Disconnected** and **Connected** environments, also this is relevant for **Virtualized** or **Bare Metal** environments. The only difference is where the resources will be configured, in a non virtualized environment is necessary something more reliable that a small dnsmasq (e.i Bind).