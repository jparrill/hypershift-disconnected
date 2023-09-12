Once the mirroring process was done, you will have two main objects that needs to be applied in the Management Cluster:

- ICSP (Image Content Source Policies) or IDMS (Image Digest Mirror Set)
- Catalog Sources

Using the `oc-mirror` tool, the output artifacts will be located, as we mentioned before, in a new folder called `oc-mirror-workspace/results-XXXXXX/`.

ICSP/IDMS will raise an "special" MachineConfig change that will not reboot your nodes, but reboot the kubelet in each of them.

After that, and having all the nodes schedulables and `READY`, you will need to apply the new catalog sources generated.

The catalog sources will trigger some actions in the `openshift-marketplace operator`, like download the catalog image, and process it in order to grab all the `PackageManifests` included in that image. You can check the new sources executing: `oc get packagemanifest` using the new CatalogSource as a source.

## Applying the artifacts

First we need to create the ICSP/IDMS artifacts:

```bash
oc apply -f oc-mirror-workspace/results-XXXXXX/imageContentSourcePolicy.yaml
```

Now wait for the nodes to be ready again and execute this other command

```bash
oc apply -f catalogSource-XXXXXXXX-index.yaml
```