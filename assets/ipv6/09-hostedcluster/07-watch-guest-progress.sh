export GUEST_KUBECONFIG=$(pwd)/hc-kubeconfig.yaml

oc get secret -n clusters-hosted admin-kubeconfig -o jsonpath='{.data.kubeconfig}' | base64 -d > ${GUEST_KUBECONFIG}

oc get --kubeconfig=${GUEST_KUBECONFIG} clusterversion,nodes,co