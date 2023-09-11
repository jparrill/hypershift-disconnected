This Agent Service Config object it's part of the Assisted Service addon included in MCE/ACM. It's in charge of the Baremetal cluster deployment and if the addon is enabled, you will need to deploy an operand (CRD) called `AgentServiceConfig` in order to configuring it.

## Agent Service Config Objects

The CRD is described [here](https://github.com/openshift/assisted-service/blob/master/docs/operator.md#creating-an-agentserviceconfig-resource) and we will focus on the main part to make it work in disconnected environments.

Also, to configure Multicluster Engine to work properly in a disconnected environment, we need to include some additional ConfigMaps.

### Custom Registries configuration

This ConfigMap contains the disconnected details to customize the deployment.

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: custom-registries
  namespace: multicluster-engine
  labels:
    app: assisted-service
data:
  ca-bundle.crt: |
    -----BEGIN CERTIFICATE-----
    -----END CERTIFICATE-----
  registries.conf: |
    unqualified-search-registries = ["registry.access.redhat.com", "docker.io"]

    [[registry]]
    prefix = ""
    location = "registry.redhat.io/openshift4"
    mirror-by-digest-only = true

    [[registry.mirror]]
      location = "registry.hypershiftbm.lab:5000/openshift4"

    [[registry]]
    prefix = ""
    location = "registry.redhat.io/rhacm2"
    mirror-by-digest-only = true
    ...
    ...
```

This object includes 2 fields, the first one contains the CAs which will be loaded in the different processes of the deployment.

### Assisted Service Customization

This ConfigMap will be consumed by the Assisted Service operator and it contains variables which will modify the behaviour od the controllers.

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: assisted-service-config
  namespace: multicluster-engine
data:
  PUBLIC_CONTAINER_REGISTRIES: "quay.io,registry.ci.openshift.org,registry.redhat.io"
  ALLOW_CONVERGED_FLOW: "false"
```

The documentation about how to customize the operator is found [here](https://github.com/openshift/assisted-service/blob/master/docs/operator.md#specifying-environmental-variables-via-configmap)

### Assisted Service Config

This is the Assisted Service Config object which includes the necessary info to perform the right functioning of the operator.

```yaml
---
apiVersion: agent-install.openshift.io/v1beta1
kind: AgentServiceConfig
metadata:
  annotations:
    unsupported.agent-install.openshift.io/assisted-service-configmap: assisted-service-config
  name: agent
  namespace: multicluster-engine
spec:
  mirrorRegistryRef:
    name: custom-registries
  databaseStorage:
    storageClassName: lvms-vg1
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi
  filesystemStorage:
    storageClassName: lvms-vg1
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 20Gi
  osImages:
  - cpuArchitecture: x86_64
    openshiftVersion: "4.14"
    rootFSUrl: http://registry.hypershiftbm.lab:8080/images/rhcos-414.92.202308281054-0-live-rootfs.x86_64.img
    url: http://registry.hypershiftbm.lab:8080/images/rhcos-414.92.202308281054-0-live.x86_64.iso
    version: 414.92.202308281054-0
```

Here we will remark the important things

- The `metadata.annotations["unsupported.agent-install.openshift.io/assisted-service-configmap"]` Annotation, will reference the ConfigMap name to be consumed by the operator to customize the behaviour.
- The `spec.mirrorRegistryRef.name` points to the ConfigMap containing the disconnected registry info to be consumed by the Assisted Service Operator. It will inject those resources during the deployment process.
- The `spec.osImages` field contains the different versions to be available for deployment by this operator. In this section we need to include the mentioned fields as a mandatory ones.

Let's fill this section for 4.14 dev preview ec4 version (sample):

- [Release URL](https://amd64.ocp.releases.ci.openshift.org/releasestream/4-dev-preview/release/4.14.0-ec.4)
- [RHCOS Info](https://releases-rhcos-art.apps.ocp-virt.prod.psi.redhat.com/?arch=x86_64&release=414.92.202307250657-0&stream=prod%2Fstreams%2F4.14-9.2#414.92.202307250657-0)

Previously you need to download the RootFS and LiveIso files, but let's asume that we already did that:

```yaml
  - cpuArchitecture: x86_64
    openshiftVersion: "4.14"
    rootFSUrl: http://registry.hypershiftbm.lab:8080/images/rhcos-414.92.202309101331-0-live-rootfs.x86_64.img
    url: http://registry.hypershiftbm.lab:8080/images/rhcos-414.92.202309101331-0-live.x86_64.iso
    version: 414.92.202307250657-0
```

## Deployment

To deploy all the objects, we just need to put them all in the same file and apply them against the Management Cluster

```bash
oc apply -f agentServiceConfig.yaml
```

This will trigger 2 pods

```bash
assisted-image-service-0                               1/1     Running   2             11d
assisted-service-668b49548-9m7xw                       2/2     Running   5             11d
```

The `Assisted Image Service` pod is in charge of the RHCOS Boot Image template creation, that will be customized with each cluster you will deploy.

The `Assisted Service` is the operator.