---
title: Dual Stack
---

This network configuration is (for now) by definition disconnected. The main reason is because the remote registries cannot work with IPv6 so we will include this part in the documentation.

All the scripts provided will hold part or the whole automation to reproduce the environment. To do that this is the repository holding all the scripts for [Dual Stack environments](https://github.com/jparrill/hypershift-disconnected/tree/main/assets/dual).

This documentation is prepared to be followed in a concrete order:

- [Hypervisor](hypervisor/)
- [DNS](dns.md)
- [Registry](registry.md)
- [Management Cluster](mgmt-cluster/)
- [Webserver](webserver.md)
- [Mirroring](mirror/)
- [Multicluster Engine](mce/)
- [TLS Certificates](tls-certificates.md)
- [HostedCluster](hostedcluster/)
- [Watching Deployment progress](watching/)