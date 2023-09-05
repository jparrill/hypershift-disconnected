#!/bin/bash

cp radvd.conf /etc/radvd.conf
systemctl enable --now radvd