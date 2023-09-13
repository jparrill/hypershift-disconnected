In a bare metal environment the way to go is using the real BMC of the nodes used for the management cluster to be managed by Metal3 for discovering and provision, but in a virtual environment we cannot do that. As a workaround we will use `ksushy` which is an implementation of `sushy-tools` that allow us to have a BMCs for the virtual machines.

To configure `ksushy` we need to execute these commands:

```bash
sudo dnf install python3-pyOpenSSL.noarch python3-cherrypy -y
kcli create sushy-service --ssl --ipv6 --port 9000
sudo systemctl daemon-reload
systemctl enable --now ksushy
```

To test if this service is working fine check the service itself with `systemctl status ksushy`. Also you can execute a curl against the exposed interface:

```
curl -Lk https://[2620:52:0:1305::1]:9000/redfish/v1
```
