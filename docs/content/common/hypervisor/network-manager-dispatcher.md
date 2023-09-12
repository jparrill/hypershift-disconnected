This is a script which modifies the system DNS resolver to point firstly to the dnsmasq (configured later). This will allow the virtual machines to resolve the different domains, routes and registries you will need for the different steps of the process.

To enable this, we need to create an script in `/etc/NetworkManager/dispatcher.d/` called `forcedns`, and it will have this content:

=== "IPv4"

    ```bash
    #!/bin/bash

    export IP="192.168.125.1" ## CHANGE THIS!
    export BASE_RESOLV_CONF="/run/NetworkManager/resolv.conf"

    if ! [[ `grep -q "$IP" /etc/resolv.conf` ]]; then
    export TMP_FILE=$(mktemp /etc/forcedns_resolv.conf.XXXXXX)
    cp $BASE_RESOLV_CONF $TMP_FILE
    chmod --reference=$BASE_RESOLV_CONF $TMP_FILE
    sed -i -e "s/hypershiftbm.lab//" -e "s/search /& hypershiftbm.lab /" -e "0,/nameserver/s/nameserver/& $IP\n&/" $TMP_FILE
    mv $TMP_FILE /etc/resolv.conf
    fi
    echo "ok"
    ```

=== "IPv6"

    ```bash
    #!/bin/bash

    export IP="2620:52:0:1306::1" ## CHANGE THIS!
    export BASE_RESOLV_CONF="/run/NetworkManager/resolv.conf"

    if ! [[ `grep -q "$IP" /etc/resolv.conf` ]]; then
    export TMP_FILE=$(mktemp /etc/forcedns_resolv.conf.XXXXXX)
    cp $BASE_RESOLV_CONF $TMP_FILE
    chmod --reference=$BASE_RESOLV_CONF $TMP_FILE
    sed -i -e "s/hypershiftbm.lab//" -e "s/search /& hypershiftbm.lab /" -e "0,/nameserver/s/nameserver/& $IP\n&/" $TMP_FILE
    mv $TMP_FILE /etc/resolv.conf
    fi
    echo "ok"
    ```

=== "Dual stack"

    ```bash
    #!/bin/bash

    export IP="192.168.126.1" ## CHANGE THIS!
    export BASE_RESOLV_CONF="/run/NetworkManager/resolv.conf"

    if ! [[ `grep -q "$IP" /etc/resolv.conf` ]]; then
    export TMP_FILE=$(mktemp /etc/forcedns_resolv.conf.XXXXXX)
    cp $BASE_RESOLV_CONF $TMP_FILE
    chmod --reference=$BASE_RESOLV_CONF $TMP_FILE
    sed -i -e "s/hypershiftbm.lab//" -e "s/search /& hypershiftbm.lab /" -e "0,/nameserver/s/nameserver/& $IP\n&/" $TMP_FILE
    mv $TMP_FILE /etc/resolv.conf
    fi
    echo "ok"
    ```

The `IP` variable at first part of the script needs to be changed to point to the IP of the Hypervisor's interface hosting the Openshift management cluster.

After the file creation, we need to add execution permissions `chmod 755 /etc/NetworkManager/dispatcher.d/forcedns` and then execute it initially once. The output should show `ok`.
