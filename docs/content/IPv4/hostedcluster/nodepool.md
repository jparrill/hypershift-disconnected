NodePool is a scalable set of worker nodes attached to a HostedCluster. NodePool machine architectures are uniform within a given pool, and are independent of the control plane’s underlying machine architecture.

This is how looks like:

```yaml
apiVersion: hypershift.openshift.io/v1beta1
kind: NodePool
metadata:
  creationTimestamp: null
  name: hosted-ipv4
  namespace: clusters
spec:
  arch: amd64
  clusterName: hosted-ipv4
  management:
    autoRepair: false
    upgradeType: InPlace
  nodeDrainTimeout: 0s
  platform:
    type: Agent
  release:
    image: registry.hypershiftbm.lab:5000/openshift/release-images:4.14.0-0.nightly-2023-08-29-102237 ## CHANGE THIS!!
  replicas: 0
status:
  replicas: 0
```

**Details**:

- All the nodes included in this NodePool will be based on Openshift `4.14.0-0.nightly-2023-08-29-102237` version.
- The Upgrade type is set to `InPlace` which means that the same bare metal node will be re-used on a upgrade situation.
- Autorepair is set to `false` because the node will not be recreated when this dissapear.
- Replicas is set to `0` because we want to scale them in the right moment.

This is the [NodePool documentation](https://hypershift-docs.netlify.app/reference/api/#hypershift.openshift.io%2fv1beta1)

To deploy this object we just need to use the same procedure as before:

```bash
oc apply -f 02-nodepool.yaml
```

And this is how the NodePool looks like (at this point):

```bash
NAMESPACE   NAME          CLUSTER   DESIRED NODES   CURRENT NODES   AUTOSCALING   AUTOREPAIR   VERSION                              UPDATINGVERSION   UPDATINGCONFIG   MESSAGE
clusters    hosted-ipv4   hosted    0                               False         False        4.14.0-0.nightly-2023-08-29-102237
```

!!! important

    we need to keep the nodepool replicas to 0 until all the steps are in place.