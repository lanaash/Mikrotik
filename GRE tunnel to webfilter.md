# GRE tunnel to webfilter with policy routing

Static NAT in the path e.g. intermediate firewall kills GRE keepalives!!

## Customer router

```
#
# Mikrotik policy route web traffic over GRE tunnel to webfilter
#
# Create loopback IP
/ip/address add address=10.0.0.254 interface=lo network=10.0.0.254

# Create GRE interface
/interface/gre add !keepalive local-address=10.0.0.254 name=gre-tunnel1 remote-address=10.30.0.1
/ip/address add address=10.10.0.2/30 interface=gre-tunnel1 network=10.10.0.0

# Create custom table
/routing/table add disabled=no fib name=webfilter

# Add route to custom table
/ip/route add disabled=no dst-address=0.0.0.0/0 gateway=10.10.0.1 routing-table=webfilter

# Mark the routing so web traffic is routed via GRE interface
/ip/firewall/mangle add action=mark-routing chain=prerouting dst-port=80,443 new-routing-mark=webfilter \
passthrough=no protocol=tcp src-address=192.168.0.0/24


```

## Webfilter edge router
```
!
! Cisco tunnel peer
!
interface Tunnel0
 ip address 10.10.0.1 255.255.255.252
 tunnel source GigabitEthernet0/0
 tunnel destination 10.0.0.254
!
ip route 192.168.0.0 255.255.255.0 10.10.0.2
!
```
