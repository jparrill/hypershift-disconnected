#!/bin/bash

sudo dnf install python3-pyOpenSSL.noarch python3-cherrypy -y
kcli create sushy-service --ssl --port 9000
sudo systemctl daemon-reload
systemctl enable --now ksushy