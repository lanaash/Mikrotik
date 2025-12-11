# Useful RouterOS commands

# Router uptime, hardware, architecture & firmware
/system/resource print

# License
/system/license print

# Device mode & features
/system/device-mode/print

# Logged in users
/user/active/print

# Reboot
/system/reboot

# System health (CPU temp, SFP temp, fans, PSUs)
/system/health print

# View default build script
```
/system default-configuration print
```

# RouterOS Upgrade
```
/system/package/update/check-for-updates
/system/package/update/install
```
# BIOS Upgrade (packaged with RouterOS)
```
/system/routerboard/print
/system/routerboard/upgrade
```
# List Routing table
/ip/route/print

# List Interfaces & MTUs
/interface/print

## SNMP
```
/system/resource print oid
/interface/print oid
```

## IP config
/ip/address/print

## List ARP table
/ip/arp/print

## Find in ARP table
/ip/arp/print where address=x.x.x.x

## MAC Table
/interface/bridge/host/print

## Hostname
/system/identity/print

## Interface stats
```
/interface/ethernet/reset-counters
/interface/ethernet/print stats
```
## Ethernet throughput (bandwidth) & packets-per-second (PPS)
/interface/monitor-traffic sfp-sfpplus1

## Running services and ACLs
/ip/service/print

## Quick view of VOIP bandwidth traversing router
```
/tool/torch interface=pppoe-out1 dscp=26  # SIP
/tool/torch interface=pppoe-out1 dscp=46  # RTP
```
## Telnet client
/system/telnet <IP> <TCP Port>

## Ping
/ping <IP>

## Firewall state table
/ip/firewall/connection/print

## Firewall stats
/ip/firewall/filter/print stats

## NAT rules
/ip/firewall/nat print

## NAT translations
/ip/firewall/connection/print detail

## PPPoE interface
/interface/pppoe-client/monitor pppoe-out1

## PPPoE throughput (bandwidth) & packets-per-second (PPS)
/interface/monitor-traffic pppoe-out1

## Check CPU utilisation
/system/resource/monitor

## Reali-time traffic monitoring
```
/tool/torch pppoe-out1
/tool/torch pppoe-out1 ip-protocol=any port=any
```
## STP & Bridge
/interface/bridge monitor

## Interface state
/interface/ethernet/monitor <number>

## Blink interface
/interface/ethernet/blink <number>

## PPPoE state
/interface/pppoe-client monitor <number>

## IP connection tracking
/tool/torch interface=pppoe-out1 src-address=<IP/Bitmask>

## DHCP leases
/ip/dhcp-server/lease/print

## Show config
/export

## Factory defaults
/system/reset-configuration

## Import config (copy FILENAME to /files first)
/import file-name=FILENAME verbose=yes [dry-run]

## Upgrade (copy routeros and any packages to /files first)
/reboot

## Downgrade (copy routeros and any packages to /files first)
/system/package/downgrade

## Command history
/system/history/print detail

## Logs
/log/print

## Console settings
115200 8N1

## Sniffer (Quick)
/tool/sniffer/quick interface=ether1 ip-protocol=icmp

## PCAP
```
/tool/sniffer/print

/tool/sniffer/set filter-ip-address=192.168.1.73/32
/tool/sniffer/set filter-direction=any
/tool/sniffer/set filter-stream=yes

/tool/sniffer/set file-name=my.pcap

/tool/sniffer/set memory-limit=50M
/tool/sniffer/set file-limit=50M

/tool/sniffer/start interface=ether1 
/tool/sniffer/stop                  
```

## PPPoE
/interface/pppoe-client/print

## BGP
```
/routing/bgp/session/print where established
/ip/route/print where bgp active
```
Do not stop BGP sessions!!!

## PoE
/interface/ethernet set etyher1 poe-out=off|on

## Safe-mode
Ctrl+X

## LTE Running state incl APN
/interface/lte/print detail

## LTE status and connection detail
/interface/lte/monitor lte1

## LTE Cell network monitor - towers and signals
/interface/lte/cell-monitor duration=10 lte1


## LTE modem capabilities
/interface/lte/show-capabilities lte1
