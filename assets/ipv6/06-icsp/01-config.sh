#!/bin/bash

### IMPORTANT!!
### THIS IS ONLY RELEVANT IF YOU ARE TRYING TO DEPLOY A NON_RELEASE MCE VERSION.
### This script will make sure you can pull images from the registry using tags instead of just digests

BASE_PATH=$(pwd)
TEMPLATE_FOLDER=${BASE_PATH}/templates
MC_ICSP_TEMPLATE=${TEMPLATE_FOLDER}/mc-icsp.template.yaml
MC_ICSP_RAW_FILE=${TEMPLATE_FOLDER}/icsp-raw-mc.template.yaml
ICSP_MCE_DOWNSTREAM_TEMPLATE=${TEMPLATE_FOLDER}/icsp.template.yaml
REGULAR_ICSP_OUTFILE=${BASE_PATH}/mce-icsp.yaml
MC_ICSP_OUTFILE=${BASE_PATH}/mce-mc-icsp.yaml

export PRIVATE_REGISTRY=${REGISTRY:-registry.$(hostname --long):5000}
## Generate MC Raw file

export B64_RAWICSP=$(envsubst < ${MC_ICSP_RAW_FILE} | base64 -w0)

envsubst < ${MC_ICSP_TEMPLATE} > ${MC_ICSP_OUTFILE}
envsubst < ${ICSP_MCE_DOWNSTREAM_TEMPLATE} > regular-mce-icsp.yaml

sleep 2

echo "Now you need to apply the output files: "
echo "oc apply -f regular-mce-icsp.yaml -f mce-mc-icsp.yaml"
echo "it will take a while... to amke sure it was finished, check MCP and MC resources using oc command"