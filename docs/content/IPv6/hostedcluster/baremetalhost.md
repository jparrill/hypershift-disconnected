## Bare Metal Hosts

BareMetalHost is an openshift-machine-api object where we include some physical and logical details to be identified by the Metal3 operator that afterwards will be linked with other Assisted Service objects called Agents. This is how the object looks like:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: hosted-ipv6-worker0-bmc-secret
  namespace: clusters-hosted-ipv6
data:
  password: YWRtaW4=
  username: YWRtaW4=
type: Opaque
---
apiVersion: metal3.io/v1alpha1
kind: BareMetalHost
metadata:
  name: hosted-ipv6-worker0
  namespace: clusters-hosted-ipv6
  labels:
    infraenvs.agent-install.openshift.io: hosted-ipv6
  annotations:
    inspect.metal3.io: disabled
    bmac.agent-install.openshift.io/hostname: hosted-ipv6-worker0
spec:
  automatedCleaningMode: disabled
  bmc:
    disableCertificateVerification: true
    address: redfish-virtualmedia://[192.168.125.1]:9000/redfish/v1/Systems/local/hosted-ipv6-worker0
    credentialsName: hosted-ipv6-worker0-bmc-secret
  bootMACAddress: aa:aa:aa:aa:03:11
  online: true
```

**Details**:

- We will have at least 1 secret which holds the BMH credentials, so we will need to create at least 2 objects per worker node.
- `spec.metadata.labels["infraenvs.agent-install.openshift.io"]` Is the link between the Assisted Installer and the BareMetalHost objects.
- `spec.metadata.annotations["bmac.agent-install.openshift.io/hostname"]` Is the node name it will take on deployment.
- `spec.automatedCleaningMode` prevents the node to be erased by the Metal3 operator.
- `spec.bmc.disableCertificateVerification` Is set to `true`` avoid the certification validation from the client.
- `spec.bmc.address` Is the BMC address of the worker node.
- `spec.bmc.credentialsName` Is the Secret where the User/Password credentials are stored.
- `spec.bootMACAddress` Is the interface MacAddress where the node will be boot from.
- `spec.online` Is the way we want the node once the BMH object is created.

To deploy this object we just need to use the same procedure as before:

!!! important

    If we create the BareMetalHost and the destination Nodes are not in place (thinking of VirtualMachines), please make sure you create first the Virtual Machines.

```bash
oc apply -f 04-bmh.yaml
```

This will be the process:

- Preparing (Trying to reach the nodes):
```
NAMESPACE         NAME             STATE         CONSUMER   ONLINE   ERROR   AGE
clusters-hosted   hosted-worker0   registering              true             2s
clusters-hosted   hosted-worker1   registering              true             2s
clusters-hosted   hosted-worker2   registering              true             2s
```

- Provisioning (Nodes Booting up)
```
NAMESPACE         NAME             STATE          CONSUMER   ONLINE   ERROR   AGE
clusters-hosted   hosted-worker0   provisioning              true             16s
clusters-hosted   hosted-worker1   provisioning              true             16s
clusters-hosted   hosted-worker2   provisioning              true             16s
```

- Provisioned (Nodes Booted up successfully)
```
NAMESPACE         NAME             STATE         CONSUMER   ONLINE   ERROR   AGE
clusters-hosted   hosted-worker0   provisioned              true             67s
clusters-hosted   hosted-worker1   provisioned              true             67s
clusters-hosted   hosted-worker2   provisioned              true             67s
```

## Agents registration

After the Nodes boot, we will see some agents appearing in the namespace

```
NAMESPACE         NAME                                   CLUSTER   APPROVED   ROLE          STAGE
clusters-hosted   aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0411             true       auto-assign
clusters-hosted   aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0412             true       auto-assign
clusters-hosted   aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0413             true       auto-assign
```

These agents represent the nodes that are available for an installation. To assign them to a HostedCluster we need to scale up the NodePool.

## Scaling up the Nodepool

Once we have the BareMetalHosts created, the statuses of these BareMetalHost will transition from `Registering` (Trying to reach the Node's BMC) to `Provisioning` (Booting up the node) and finally to `Provisioned` (The node has been booted properly).

The nodes will boot with the Agent's RHCOS LiveISO and with a pod running by default called "agent". This agent is the piece in the node that will receive the steps from the Assisted Service Operator to install Openshift payload.

To do so we just need to execute this command:

```bash
oc -n clusters scale nodepool hosted-ipv6 --replicas 3
```

After the nodepool scalation we can see the agents are assigned to a Hosted Cluster

```
NAMESPACE         NAME                                   CLUSTER   APPROVED   ROLE          STAGE
clusters-hosted   aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0211   hosted    true       auto-assign
clusters-hosted   aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0212   hosted    true       auto-assign
clusters-hosted   aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0213   hosted    true       auto-assign
```

And the NodePool replicas set

```
NAMESPACE   NAME     CLUSTER   DESIRED NODES   CURRENT NODES   AUTOSCALING   AUTOREPAIR   VERSION                              UPDATINGVERSION   UPDATINGCONFIG   MESSAGE
clusters    hosted   hosted    3                               False         False        4.14.0-0.nightly-2023-08-29-102237                                      Minimum availability requires 3 replicas, current 0 available
```

So now we need to wait until the Nodes join the cluster. The Agents will give you some hints about in which stage they are and what is the status. Initially they does not post any status, but eventually they will.
