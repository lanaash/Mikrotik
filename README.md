# Mikrotik


## Useful RouterOS commands


## Linux guest on Mikrotik

Simple Linux guest with SSH installed into Mikrotik container

## Stream live Mikrotik packet capture into Wireshark

Easier than messing around with pcap files

## RouterOS Scripting

### script_track_default_route_adjust_vrrp_priority

Attempt to have Cisco et al like "VRRP route tracking" functionality in mikrotik config. 

In this case we track default route (e.g. PPPoE or BGP) and adjust down VRRP priority if it is not found in the table.

You need to comment the VRRP interfaces with 'Primary' or 'Backup' and use priorities 100 and 90 respectively.

You could schedule this to loop every 30 seconds for example.
```
/system/scheduler add interval=30s name=Run_Track_Default_For_VRRP on-event="/system/script/run Track_Default_For_VRRP" policy=read,write start-time=startup
```


## PoCs

### speedtest_api_poc.sh

Useful to find optimal 4G install location before fixing in place. Uses API call to start a speedtest to remote server e.g. a Mikrotik CHR.

### firewall_filter_api_poc.sh

Simple PoC to explore surfacing firewall policy


