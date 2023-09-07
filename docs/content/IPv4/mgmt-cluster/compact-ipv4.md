In this section we will talk about how to deploy the Openshift management cluster. To do that we will need some files in place:

- The pull secret to pull images from the source registry
- The kcli plan which contains the Openshift definition

### Pull Secret

Should be in the same folder as the kcli plan and should take `openshift_pull.json` as a name.

### Kcli plan

- `mgmt-compact-hub-ipv4.yaml`

```yaml
plan: hub-ipv4
force: true
version: nightly
tag: "4.14.0-0.nightly-2023-08-29-102237"
cluster: "hub-ipv4"
domain: hypershiftbm.lab
api_ip: 192.168.125.10
ingress_ip: 192.168.125.11
disconnected_url: registry.hypershiftbm.lab:5000
disconnected_update: true
disconnected_user: dummy
disconnected_password: dummy
disconnected_operators_version: v4.13
disconnected_operators:
- name: metallb-operator
- name: lvms-operator
  channels:
  - name: stable-4.13
disconnected_extra_images:
- quay.io/mavazque/trbsht:latest
- quay.io/jparrill/hypershift:BMSelfManage-v4.14-rc-v3
- registry.redhat.io/openshift4/ose-kube-rbac-proxy:v4.10
dualstack: false
disk_size: 200
extra_disks: [200]
memory: 48000
numcpus: 16
ctlplanes: 3
workers: 0
manifests: extra-manifests
metal3: true
network: ipv4
users_dev: developer
users_devpassword: developer
users_admin: admin
users_adminpassword: admin
metallb_pool: ipv4-virtual-network
metallb_ranges:
- 192.168.125.150-192.168.125.190
metallb_autoassign: true
apps:
- users
- lvms-operator
- metallb-operator
vmrules:
- hub-bootstrap:
    nets:
    - name: ipv4
      mac: aa:aa:aa:aa:02:10
- hub-ctlplane-0:
    nets:
    - name: ipv4
      mac: aa:aa:aa:aa:02:01
- hub-ctlplane-1:
    nets:
    - name: ipv4
      mac: aa:aa:aa:aa:02:02
- hub-ctlplane-2:
    nets:
    - name: ipv4
      mac: aa:aa:aa:aa:02:03
```

!!! note

    In order to know what means each of this parameters you can check the official documentation [here](https://kcli.readthedocs.io/en/latest/#how-to-use)

### Deployment

To start the provisioning procedure we need to execute this:

```bash
kcli create cluster openshift --pf mgmt-compact-hub-ipv4.yaml
```