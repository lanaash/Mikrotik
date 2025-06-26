# mikrotik

## script_track_default_route_adjust_vrrp_priority

Attempt to have Cisco like "VRRP tracking" functionality in our mikrotik config. 

In this case we track default route (e.g. PPPoE or BGP) and adjust VRRP priority if it is not found in the table.

The base priorities are stored in the comment for the VRRP interface  so you can choose what router is primary or backup per VRRP group as needed.

You could schedule this to loop every 10 seconds for example.


## simple_speedtest_poc.sh

Useful to find optimal 4G install location before fixing in place


## upgradeMikrotik.sh

Simple bash script to help roll out upgrades to "approved" versions.  

Assumes version 7.x.x and that upgrade version is architecture specific i.e. arm rather than per-router.

Maybe useful if you want some control.
