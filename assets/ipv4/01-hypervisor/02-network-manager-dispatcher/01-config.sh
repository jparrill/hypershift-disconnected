#!/bin/bash

sudo cp forcedns /etc/NetworkManager/dispatcher.d/forcedns
sleep 1
/etc/NetworkManager/dispatcher.d/forcedns