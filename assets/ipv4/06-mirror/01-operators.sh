function download_oc_mirror() {
    curl -Lk https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/oc-mirror.tar.gz -o oc-mirror.tar.gz
    tar xvzf oc-mirror.tar.gz
    rm -f oc-mirror.tar.gz
    chmod 755 oc-mirror
    mkdir -p ${HOME}/bin
    cp oc-mirror ${HOME}/bin
}

if [[ ! -f oc-mirror ]];then
    download_oc_mirror
fi

OCM=$(pwd)/oc-mirror
REGISTRY=registry.$(hostname --long):5000

if [[ ! -f ${HOME}/.docker/config.json ]];then
	echo "File: ${HOME}/.docker/config.json Not Found, please perform an podman/docker login into the registry and place the output file in that path"
    exit 1
fi

oc-mirror --source-skip-tls --config imagesetconfig.yaml docker://${REGISTRY}


echo "Check into the output folder, the ImageContentSourcePolicies to be applied into the Management server"
echo "oc apply -f oc-mirror-workspace/results-XXXXXX/imageContentSourcePolicy.yaml"