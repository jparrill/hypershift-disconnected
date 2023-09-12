---
title: Hypervisor Prerequisites
---

- **CPU**: As much CPUs we can provide, more HostedCluster could be running at the same time.
    - **Recommended**: 16 CPUs/Node for 3 nodes.
    - **Minimal Dev**: If you are working on a development environment maybe you can work fine with 12 CPUs/Node for 3 nodes.
- **Memory**: As much RAM we can provide, more HostedCluster could be hosted.
    - **Recommended**: 48 Gb of RAM/Node
    - **Minimal Dev**: 18 Gb of RAM/Node
- **Storage**: It's key to use SSD as a storage to host MCE
    - **Management Cluster**: 250 Gb
    - **Registry**: Depends on how many releases/operators/images you will host. An acceptable number could be 500Gb and preferibly separated from the disk where the HostedCluster is hosted.
    - **Webserver**: Depends on how many isos/images you will host An acceptable number could be 500Gb.
    - **Production**: For a production environment we want to keep separated all 3 mentioned things in their different disks. A good configuration for Production is:
        - **Registry** we will use 2Tb
        - **Management Cluster** is fine with 500Gb.
        - **WebServer** will be enough with 2Tb.