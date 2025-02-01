# mikrotik

## script_track_default_route_adjust_vrrp_priority

Attempt to have Cisco like "VRRP tracking" functionality. 

In this case we track default route (e.g. PPPoE or BGP) and adjust VRRP priority.

The base priorities are stored in the comment for the VRRP interface  so you can choose what router is primary or backup per VRRP group as needed.


## upgradeMikrotik.sh

Simple bash script to help roll out upgrades to "approved" versions.  

Assumes version 7.x.x and that upgrade version is actritcture specific i.e. arm rather than per-router.

Maybe useful if you want some control.
