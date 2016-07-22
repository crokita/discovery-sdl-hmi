#!/bin/bash

# Find sdl_core's IP address using the etcd database 
# The HMI can run first if you add a wait=true paramater for etcd where it
# will wait for a change in etcd
HMI_WEBSOCKET_IP="$(curl -L http://192.168.1.130:4001/v2/keys/servers/core | /usr/sbin/jq '.node.value')"
#cut off the quotations
HMI_WEBSOCKET_IP="$(sed 's/\"//g' <<< ${HMI_WEBSOCKET_IP})"
echo "Changing Flags.js HMI ServerAddress to ${HMI_WEBSOCKET_IP}"

# Replace IP and Port in flags file to match the machine's IP address
perl -pi -e 's/127.0.0.1:8087/'$HMI_WEBSOCKET_IP':8087/g' /var/www/app/Flags.js
cat /var/www/app/Flags.js
# Start nginx
/usr/sbin/nginx