# Mikrotik


## Useful RouterOS commands
Collection of day to day CLI commands


## Linux guest on Mikrotik

Simple Linux guest with SSH installed into Mikrotik container
## Stream live Mikrotik packet capture into Wireshark

Easier than working with pcap files


## DHCP server for remote relay

Simple example for providing DHCP services to remote relay such as a layer 3 switch or other aggregation router


## RouterOS script to track default route & adjust VRRP priority

Attempt to have Cisco/Juniper/Ekinops/Huawei (etc etc) like "VRRP route tracking" functionality in Mikrotik config.

In this case we track default route (e.g. source PPPoE or BGP) and adjust down the VRRP priority if it is not found in the table.

You need to comment the VRRP interfaces with 'Primary' or 'Backup' and use priorities 100 and 90 respectively.

You could schedule this to loop every 30 seconds for example.



## RouterOS script to manage APN profile depending on SIM

Change APN profile depending on the inserted SIM card. Might help where APN settings are needed and SIM cards can be swapped around e.g. emergency Internet cover.

You could schedule this to loop every 30 seconds for example.



## API PoCs in python & bash

Simple PoCs for exploring RouterOS config via the Rest API


