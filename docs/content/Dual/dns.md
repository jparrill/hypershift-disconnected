The DNS part it's one of the mosts critical parts. To configure the name resolution in our virtualized environment we will need to:

Create the DNS main configuration for the dnsmasq server:

- `/opt/dnsmasq/dnsmasq.conf`
```conf
strict-order
bind-dynamic
#log-queries
bogus-priv
dhcp-authoritative

#BM Network IPv4
dhcp-range=dual,192.168.126.120,192.168.126.250,255.255.255.0,24h
dhcp-option=dual,option:dns-server,192.168.126.1
dhcp-option=dual,option:router,192.168.126.1

#BM Network dual
dhcp-range=dual,2620:52:0:1306::11,2620:52:0:1306::20,64
dhcp-option=dual,option6:dns-server,2620:52:0:1306::1

resolv-file=/opt/dnsmasq/upstream-resolv.conf
except-interface=lo
dhcp-lease-max=81
log-dhcp
no-hosts

# DHCP Reservations
dhcp-leasefile=/opt/dnsmasq/hosts.leases

# Include all files in a directory depending on the suffix
conf-dir=/opt/dnsmasq/include.d/*.dual
```

Create the upstream resolver to delegate the non-local environments queries

- `/opt/dnsmasq/upstream-resolv.conf`
```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

Create the different component DNS configurations

- `/opt/dnsmasq/include.d/hosted-nodeport.dual`
```
host-record=api-int.hosted-dual.hypershiftbm.lab,192.168.126.20
host-record=api-int.hosted-dual.hypershiftbm.lab,192.168.126.21
host-record=api-int.hosted-dual.hypershiftbm.lab,192.168.126.22
host-record=api.hosted-dual.hypershiftbm.lab,192.168.126.20
host-record=api.hosted-dual.hypershiftbm.lab,192.168.126.21
host-record=api.hosted-dual.hypershiftbm.lab,192.168.126.22

## IMPORTANT!: You should point to the node which is exposing the router.
## You can also use MetalLB to expose the Apps wildcard.
address=/apps.hosted-dual.hypershiftbm.lab/192.168.126.30

dhcp-host=aa:aa:aa:aa:04:11,hosted-worker0,192.168.126.30
dhcp-host=aa:aa:aa:aa:04:12,hosted-worker1,192.168.126.31
dhcp-host=aa:aa:aa:aa:04:13,hosted-worker2,192.168.126.32
dhcp-host=aa:aa:aa:aa:11:01,hosted-worker0,[2620:52:0:1306::30]
dhcp-host=aa:aa:aa:aa:11:02,hosted-worker1,[2620:52:0:1306::31]
dhcp-host=aa:aa:aa:aa:11:03,hosted-worker2,[2620:52:0:1306::32]
```

- `/opt/dnsmasq/include.d/hub.dual`
```
host-record=api-int.hub-dual.hypershiftbm.lab,192.168.126.10
host-record=api.hub-dual.hypershiftbm.lab,192.168.126.10
address=/apps.hub-dual.hypershiftbm.lab/192.168.126.11
dhcp-host=aa:aa:aa:aa:10:01,ocp-master-0,192.168.126.20
dhcp-host=aa:aa:aa:aa:10:02,ocp-master-1,192.168.126.21
dhcp-host=aa:aa:aa:aa:10:03,ocp-master-2,192.168.126.22
dhcp-host=aa:aa:aa:aa:10:06,ocp-installer,192.168.126.25
dhcp-host=aa:aa:aa:aa:10:07,ocp-bootstrap,192.168.126.26

host-record=api-int.hub-dual.hypershiftbm.lab,2620:52:0:1306::2
host-record=api.hub-dual.hypershiftbm.lab,2620:52:0:1306::2
address=/apps.hub-dual.hypershiftbm.lab/2620:52:0:1306::3
dhcp-host=aa:aa:aa:aa:10:01,ocp-master-0,[2620:52:0:1306::5]
dhcp-host=aa:aa:aa:aa:10:02,ocp-master-1,[2620:52:0:1306::6]
dhcp-host=aa:aa:aa:aa:10:03,ocp-master-2,[2620:52:0:1306::7]
dhcp-host=aa:aa:aa:aa:10:06,ocp-installer,[2620:52:0:1306::8]
dhcp-host=aa:aa:aa:aa:10:07,ocp-bootstrap,[2620:52:0:1306::9]
```

- `/opt/dnsmasq/include.d/infra.dual`
```
host-record=registry.hypershiftbm.lab,2620:52:0:1306::1
host-record=registry.hypershiftbm.lab,192.168.126.1
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