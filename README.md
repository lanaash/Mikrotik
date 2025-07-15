# mikrotik

## Linux on yer Mikrotik

Simple Linux guest with SSH installed into container

## Useful commands

Maybe

## script_track_default_route_adjust_vrrp_priority

Attempt to have Cisco et al like "VRRP route tracking" functionality in mikrotik config. 

In this case we track default route (e.g. PPPoE or BGP) and adjust VRRP priority if it is not found in the table.

You need to comment the VRRP interfaces with 'Primary' or 'Backup' and use priorities 100 and 90 respectively.

You could schedule this to loop every 10 seconds for example.


## simple_speedtest_poc.sh

Useful to find optimal 4G install location before fixing in place. Uses API call to start a speedtest to remote server e.g. a Mikrotik CHR.


## upgrade_routeros.sh

Simple bash script to help roll out upgrades to desired versions.  

Assumes version 7 (REST API) and that upgrade version is architecture specific i.e. arm, arm64 rather than per-router.

Maybe useful if you have a few routers & want some control.
