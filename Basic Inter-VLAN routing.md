# Mikrotik basic Inter-VLAN routing

https://www.youtube.com/watch?v=mltK461pcuM

## Bridge
```
/interface bridge
add name=bridge1 vlan-filtering=yes

/interface bridge port
add bridge=bridge1 comment=defconf interface=ether3 pvid=10
add bridge=bridge1 comment=defconf interface=ether4 pvid=20

/interface bridge vlan
add bridge=bridge1 tagged=bridge1 untagged=ether3 vlan-ids=10
add bridge=bridge1 tagged=bridge1 untagged=ether4 vlan-ids=20
```

## VLANs
```
/interface vlan
add interface=bridge1 name=vlan10 vlan-id=10
add interface=bridge1 name=vlan20 vlan-id=20
```

## IP Addresses
```
/ip address
add address=192.168.10.254/24 interface=vlan10 network=192.168.10.0
add address=192.168.20.254/24 interface=vlan20 network=192.168.20.0
```

## DHCP
```
/ip pool
add name=POOL10 ranges=192.168.10.10-192.168.10.20
add name=POOL20 ranges=102.168.20.10-192.168.20.20

/ip dhcp-server
add address-pool=POOL10 interface=vlan10 name=DHCP10
add address-pool=POOL20 interface=vlan20 name=DHCP20

/ip dhcp-server network
add address=192.168.10.0/24 dns-server=192.168.20.200 gateway=192.168.10.254 netmask=24
add address=192.168.20.0/24 dns-server=192.168.20.200 gateway=192.168.20.254 netmask=24
```

