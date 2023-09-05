#!/bin/bash
## This script checks if the user-ca-bundle is patched, it will not deploy anything. If all the patches are in place, there is no need to execute it.
## If not all the patches are in place, you will need to apply the workaround, for that:

## WORKAROUND=true ./01-config.sh

export REGISTRY_CERT_PATH=/opt/registry/certs/domain.crt

function check_user_ca_bundle() {
    oc get cm -n openshift-config user-ca-bundle -o yaml | grep $(cat -q ${REGISTRY_CERT_PATH})
    if [[ $? == 1 ]]; then
        echo "The user-ca-bundle configMap is not patched"
    fi
}

function workaround() {
    oc get cm -n openshift-config user-ca-bundle --no-headers
    if [[ $? == 1 ]];then
        echo "user-ca-bundle ConfigMap does not exists, creating it"
        oc create configmap user-ca-bundle -n openshift-config --from-file=ca-bundle.crt=${REGISTRY_CERT_PATH}
    else
        echo "user-ca-bundle ConfigMap exists, patching it"
        export TMP_FILE=$(mktemp)
        oc get cm -n openshift-config user-ca-bundle -ojsonpath='{.data.ca-bundle\.crt}' > ${TMP_FILE}
        echo >> ${TMP_FILE}
        echo \#registry.$(hostname --long) >> ${TMP_FILE}
        cat ${REGISTRY_CERT_PATH} >> ${TMP_FILE}
        oc create configmap user-ca-bundle -n openshift-config --from-file=ca-bundle.crt=${TMP_FILE} --dry-run=client -o yaml | kubectl apply -f -
    fi
}

if [[ -z ${KUBECONFIG} ]];then
    echo "KUBECONFIG variable not set, trying the default one for kcli"
    if [[ -f "/root/.kcli/clusters/hub-ipv4/auth/kubeconfig" ]];then
        export KUBECONFIG=/root/.kcli/clusters/hub-ipv4/auth/kubeconfig
    else
        echo "KUBECONFIG variable not set, please set it up pointing to the Management cluster"
        exit 1
    fi
fi

check_user_ca_bundle

if [[ ${WORKAROUND} == "true" ]];then
    echo "executing workaround"
    workaround
fi

