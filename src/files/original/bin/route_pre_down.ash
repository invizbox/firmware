#!/bin/sh

# Copyright 2020 InvizBox Ltd
#
# Licensed under the InvizBox Shared License;
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        https://www.invizbox.com/lic/license.txt

ip rule del from 10.101.0.0/24 table 1
ip route del default via ${route_vpn_gateway} dev ${dev} table 1
mkdir -p /tmp/openvpn/1/
echo "down" > /tmp/openvpn/1/status
