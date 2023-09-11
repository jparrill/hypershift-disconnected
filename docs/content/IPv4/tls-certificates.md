!!! important

    This section is only relevant in disconnected scenarios, if this is not your case, you can continue with the next section


The TLS certificates involved in the process are basically the private registry/ies where the images will be pulled from, maybe there are more but we will focus on the mentioned one.

We need to differenciate the multiple ways to do this and their affectation to the involved cluster. All the methods will end in mostly the same way. The processes changes the content of the files mentioned in the next list but this time will be done in the OCP master and worker nodes:

- `/etc/pki/ca-trust/extracted/pem/`
- `/etc/pki/ca-trust/source/anchors/`
- `/etc/pki/tls/certs/`

## Adding a CA to the Management Cluster

We have multiple ways to do this, the most common one is described [here](https://docs.openshift.com/container-platform/latest/security/certificates/updating-ca-bundle.html) where the user will take advantage of the `image-registry-operator` and the CAs will end deployed in the OCP nodes.

Hypershift include in their operators and controllers the procedures to do this automatically so if you are using a GA released version this should work properly and **you don't need to apply this**. This Hypershift feature it's included in the payload of 2.4 MCE release.

If this is not working properly or this is not your case, you can follow this procedure:

- Check in the Management cluster if the `openshift-config` namespace contains a ConfigMap called `user-ca-bundle`.
- If the ConfigMap does not exists, execute this command

```bash
## REGISTRY_CERT_PATH=<PATH/TO/YOUR/CERTIFICATE/FILE>
export REGISTRY_CERT_PATH=/opt/registry/certs/domain.crt

oc create configmap user-ca-bundle -n openshift-config --from-file=ca-bundle.crt=${REGISTRY_CERT_PATH}
```

- Otherwise, if that ConfigMap exists, execute this other command

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

You have a functional script located in the `assets/<NetworkStack>/09-tls-certificated/01-config.sh`, [this is the sample for IPv4](https://github.com/jparrill/hypershift-disconnected/blob/main/assets/ipv4/09-tls-certificates/01-config.sh).


