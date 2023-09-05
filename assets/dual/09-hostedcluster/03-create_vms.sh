#!/bin/bash

kcli create vm -P start=False -P uefi_legacy=true -P plan=hosted-dual -P memory=8192 -P numcpus=16 -P disks=[200,200] -P nets=["{\"name\": \"dual\", \"mac\": \"aa:aa:aa:aa:11:01\"}"] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa1101 -P name=hosted-dual-worker0
kcli create vm -P start=False -P uefi_legacy=true -P plan=hosted-dual -P memory=8192 -P numcpus=16 -P disks=[200,200] -P nets=["{\"name\": \"dual\", \"mac\": \"aa:aa:aa:aa:11:02\"}"] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa1102 -P name=hosted-dual-worker1
kcli create vm -P start=False -P uefi_legacy=true -P plan=hosted-dual -P memory=8192 -P numcpus=16 -P disks=[200,200] -P nets=["{\"name\": \"dual\", \"mac\": \"aa:aa:aa:aa:11:03\"}"] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa1103 -P name=hosted-dual-worker2

sleep 2
systemctl restart ksushy