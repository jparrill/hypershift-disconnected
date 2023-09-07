---
title: Home
---

# Hypershift Disconnected

HyperShift is middleware for hosting [OpenShift](https://www.openshift.com/) control planes at scale that solves for cost and time to provision, as well as portability cross cloud with strong separation of concerns between management and workloads.
Clusters are fully compliant [OpenShift Container Platform](https://www.redhat.com/en/technologies/cloud-computing/openshift/container-platform) (OCP) clusters and are compatible with standard OCP and Kubernetes toolchains.

Disconnected, on premises, in-house, it has multiple names but it references all the Openshift deployments that are not connected to internet and in this case using Hypershift as a base.

The main purpose of this documentation is spread the technical details about the self-managed deployments on bare metal servers (or virtual Machines) focusing on the 3 networking different configurations:

- IPv4
- IPv6
- Dual stack

Each ones has their particularities and details, so we will do a deep dive on all topics, from the Node/Hypervisor configuration, until the artifacts involved in the deployment.

[IPv4](IPv4/){ .md-button }
[IPv6](IPv6/){ .md-button }
[Dual stack](Dual/){ .md-button }

This documentation will be focused in Virtual Machines but it's expandable to bare metal nodes, we will remark the different aspects of each kind of deployment.