#!/bin/bash

kcli create network -c 192.168.126.0/24 -P dhcp=false -P dns=false -d 2620:52:0:1305::0/64 --domain hypershiftbm.lab --nodhcp dual