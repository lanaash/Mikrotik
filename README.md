# Mikrotik


## Useful RouterOS commands
Collection of day to day CLI commands

## Linux guest on Mikrotik

Simple Linux guest with SSH installed into Mikrotik container

## Stream live Mikrotik packet capture into Wireshark

Easier than messing around with pcap files

## Script to track default route & adjust VRRP priority

Attempt to have Cisco et al like "VRRP route tracking" functionality in mikrotik config.

In this case we track default route (e.g. source PPPoE or BGP) and adjust down the VRRP priority if it is not found in the table.

You need to comment the VRRP interfaces with 'Primary' or 'Backup' and use priorities 100 and 90 respectively.

You could schedule this to loop every 30 seconds for example.


## API PoCs

Simple PoCs for RouterOS functionality via Rest API


