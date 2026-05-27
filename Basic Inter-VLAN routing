# Mikrotik basic Inter-VLAN routing

Simple config for routing and switching in same device

https://help.mikrotik.com/docs/spaces/ROS/pages/15302988/Switch+Chip+Features#SwitchChipFeatures-Inter-VLANrouting


## Bridge
```
/interface bridge
add name=bridge1

/interface bridge port
add bridge=bridge1 comment=defconf interface=ether3
add bridge=bridge1 comment=defconf interface=ether4
```

## VLANs
```
/interface vlan
add interface=bridge1 name=VLAN10 vlan-id=10
add interface=bridge1 name=VLAN20 vlan-id=20
```

## IP Addresses
```
/ip address
add address=192.168.88.1/24 comment=defconf interface=bridge network=192.168.88.0
add address=192.168.10.254/24 interface=VLAN10 network=192.168.10.0
add address=192.168.20.254/24 interface=VLAN20 network=192.168.20.0
```

## DHCP
```
/ip pool
add name=POOL10 ranges=192.168.10.10-192.168.10.20
add name=POOL20 ranges=102.168.20.10-192.168.20.20

/ip dhcp-server
add address-pool=POOL10 interface=VLAN10 name=DHCP10
add address-pool=POOL20 interface=VLAN20 name=DHCP20

/ip dhcp-server network
add address=192.168.10.0/24 dns-server=192.168.10.200 gateway=192.168.10.254 netmask=24
add address=192.168.20.0/24 gateway=192.168.20.254 netmask=24
```

## Switch
```
/interface ethernet switch vlan
add ports=ether3,switch1-cpu switch=switch1 vlan-id=10
add ports=ether4,switch1-cpu switch=switch1 vlan-id=20
```
