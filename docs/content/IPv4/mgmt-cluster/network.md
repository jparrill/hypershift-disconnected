Firstly we need to make sure we have the right networks ready to be used in the Hypervisor. These networks will be used to host the Management and Hosted clusters.

To configure it we will use this `kcli` command:

```
kcli create network -c 192.168.125.0/24 -P dhcp=false -P dns=false --domain hypershiftbm.lab ipv4
```

Where:

- `-c` remarks the CIDR used for that network
- `-P dhcp=false` configures the network to disable the DHCP, this will be done by the dnsmasq we've configured before.
- `-P dns=false` configures the network to disable the DNS, this will be done by the dnsmasq we've configured before.
- `--domain` sets the domain to search into.
- `ipv4` is the name of the network that will be created.

This is how looks like the network once created:

```
[root@hypershiftbm ~]# kcli list network
Listing Networks...
+---------+--------+---------------------+-------+------------------+------+
| Network |  Type  |         Cidr        |  Dhcp |      Domain      | Mode |
+---------+--------+---------------------+-------+------------------+------+
| default | routed |   192.168.122.0/24  |  True |     default      | nat  |
| ipv4    | routed |   192.168.125.0/24  | False | hypershiftBM.lab | nat  |
| ipv6    | routed | 2620:52:0:1306::/64 | False | hypershiftBM.lab | nat  |
+---------+--------+---------------------+-------+------------------+------+
```

```
[root@hypershiftbm ~]# kcli info network ipv4
Providing information about network ipv4...
cidr: 192.168.125.0/24
dhcp: false
domain: hypershiftBM.lab
mode: nat
plan: kvirt
type: routed
```

