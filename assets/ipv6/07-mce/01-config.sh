#!/bin/bash

BASE_PATH=$(pwd)
cd ../05-mirror/deploy
cat <<EOF > multiclusterengine/multicluster_v1alpha1_multiclusterengine.yaml
apiVersion: multicluster.openshift.io/v1
kind: MultiClusterEngine
metadata:
  name: multiclusterengine-sample
spec:
  availabilityConfig: Basic
  overrides:
    components:
    - enabled: true
      name: assisted-service
    - enabled: true
      name: cluster-lifecycle
    - enabled: true
      name: cluster-manager
    - enabled: true
      name: discovery
    - enabled: true
      name: hive
    - enabled: true
      name: server-foundation
    - enabled: true
      name: cluster-proxy-addon
    - enabled: true
      name: local-cluster
    - enabled: true
      name: hypershift-local-hosting
    - enabled: false
      name: managedserviceaccount-preview
    - enabled: true
      name: hypershift-preview
EOF

./multiclusterengine/start.sh --watch