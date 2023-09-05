#!/bin/bash
export CUSTOM_REGISTRY="${REGISTRY:-registry.$(hostname --long)}"
export MCE_TAG="${TAG:-2.4.0-DOWNANDBACK-2023-08-30-13-57-19}"
export DOWNSTREAM=true
export PULL_SECRET=${MCE_PULL_SECRET_PATH:-/root/baremetal/hub/operators/mirror/mce-mirror/mce-mirror-pull-secret.json}

function clone_deploy_repo() {
    git clone https://github.com/stolostron/deploy.git
}

if [[ ! -d ./deploy ]];then
  echo "Clone the deploy repo con configure it for MCE Downstream deployment"
  clone_deploy_repo
fi

if [[ ! -f ${PULL_SECRET} ]];then
    echo "You need to set the MCE_PULL_SECRET_PATH variable pointing to the Pull secret path to pull images from acm downstream"
    exit 1
fi

cd deploy

## Mirror
for rawImage in $(sed "s#__DESTINATION_ORG__#${CUSTOM_REGISTRY}/acm-d#g" mirror/${MCE_TAG}.txt);
do
  image=${rawImage%%=*}
  echo "IMAGE: ${image}"
  skopeo copy --all docker://${image} docker://${image/quay.io/${CUSTOM_REGISTRY}} --authfile ${PULL_SECRET}
  echo
done

echo "#################"
echo "## Important!! ##"
echo "#################"
echo "There will be some missing images not included in the txt manifest, if you face a imagepullbackoff please use a command like this"
echo "skopeo copy --all docker://quay.io/acm-d/\${IMAGENAME} docker://${CUSTOM_REGISTRY}/acm-d/\${IMAGENAME} --authfile ${PULL_SECRET}"

echo "Please follow the upstream instructions to configure the deploy repo to run the MCE script for Downstream images"
echo "[Check This](https://github.com/stolostron/deploy#prepare-to-deploy-open-cluster-management-instance-only-do-once)"

