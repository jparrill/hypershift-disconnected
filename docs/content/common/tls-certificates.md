!!! important

    This section is only relevant in disconnected scenarios. If this doesn't apply to your situation, please proceed to the next section.

In this section, we'll cover the TLS certificates involved in the process, primarily focusing on the private registries from which the images will be pulled. While there may be additional certificates, we'll concentrate on these particular ones.

It's important to distinguish between the various methods and their impact on the associated cluster. All of these methods essentially modify the content of the following files on the OCP (OpenShift Container Platform) master and worker nodes:

- `/etc/pki/ca-trust/extracted/pem/`
- `/etc/pki/ca-trust/source/anchors/`
- `/etc/pki/tls/certs/`

## Adding a CA to the Management Cluster

There are multiple ways to achieve this, with the most common one described [here](https://docs.openshift.com/container-platform/latest/security/certificates/updating-ca-bundle.html). This method involves utilizing the `image-registry-operator`, which deploys the CAs to the OCP nodes.

Hypershift's operators and controllers automatically handle this process, so if you're using a GA (Generally Available) released version, it should work seamlessly, and you won't need to apply these steps. This Hypershift feature is included in the payload of the 2.4 MCE release.

However, if this feature is not working as expected or if it doesn't apply to your situation, you can follow this procedure:

- Check if the `openshift-config` namespace in the Management cluster contains a ConfigMap named `user-ca-bundle`.
- If the ConfigMap doesn't exist, execute the following command:

```bash
## REGISTRY_CERT_PATH=<PATH/TO/YOUR/CERTIFICATE/FILE>
export REGISTRY_CERT_PATH=/opt/registry/certs/domain.crt

oc create configmap user-ca-bundle -n openshift-config --from-file=ca-bundle.crt=${REGISTRY_CERT_PATH}
```

- Otherwise, if that ConfigMap exists, execute this other command:

```bash
## REGISTRY_CERT_PATH=<PATH/TO/YOUR/CERTIFICATE/FILE>
export REGISTRY_CERT_PATH=/opt/registry/certs/domain.crt
export TMP_FILE=$(mktemp)

oc get cm -n openshift-config user-ca-bundle -ojsonpath='{.data.ca-bundle\.crt}' > ${TMP_FILE}
echo >> ${TMP_FILE}
echo \#registry.$(hostname --long) >> ${TMP_FILE}
cat ${REGISTRY_CERT_PATH} >> ${TMP_FILE}
oc create configmap user-ca-bundle -n openshift-config --from-file=ca-bundle.crt=${TMP_FILE} --dry-run=client -o yaml | kubectl apply -f -
```

You have a functional script located in the `assets/<NetworkStack>/09-tls-certificates/01-config.sh`, [this is the sample for IPv6](https://github.com/jparrill/hypershift-disconnected/blob/main/assets/ipv6/09-tls-certificates/01-config.sh).
