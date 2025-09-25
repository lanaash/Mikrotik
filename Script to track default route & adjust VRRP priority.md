# Cisco like default route tracking for VRRP failover

Attempt to have Cisco et al like "VRRP route tracking" functionality in mikrotik config.

In this case we track default route (e.g. source PPPoE or BGP) and adjust down the VRRP priority if it is not found in the table.

You need to comment the VRRP interfaces with 'Primary' or 'Backup' and use priorities 100 and 90 respectively.

You could schedule this to loop every 30 seconds for example.

## RouterOS scheduler
```
/system/scheduler add interval=30s name=Run_Track_Default_For_VRRP on-event="/system/script/run Track_Default_For_VRRP" policy=read,write start-time=startup
```

## RouterOS script
```
# Function to change the VRRP priority on an interface
:local changePriority do={
  :put "VRRP interface $2 priority changed to $1"
  :log info "SCRIPT - VRRP interface $2 priority changed to $1"
  /interface/vrrp/set priority=$1 $2
} 

# Function to leave VRRP priority unchanged on an interface
:local leavePriority do={ :put "VRRP interface $2 priority is $1 so nothing to do" }

# Globals for our scripts VRRP priority values
:local healthyPriority  100
:local degradedPriority 80

# Start with the routing table
/ip/route {
# Check we have a default route
  :local checkDefault [find where 0.0.0.0/0 in dst-address and active ]
  :if ([:len $checkDefault] != 0) do={
# Default route found so check if we should be primary router in each VRRP interface and take action if needed
    :put "Default gateway found -"
# We only take action on 'Primary' services not 'Backup'
	:foreach vrrpInt in [/interface/vrrp find where comment="Primary"] do={
      :local vrrpIntName [/interface/vrrp get $vrrpInt value-name=name]
      :local vrrpIntPriority [/interface/vrrp/ get [find name=$vrrpIntName] priority];
	  :if ($vrrpIntPriority != $healthyPriority) do={
          $changePriority $healthyPriority  $vrrpIntName
      } else={
	      $leavePriority $vrrpIntPriority $vrrpIntName
	  }
    }
  } else={
# We don't have a default route so check if we should be primary router in each VRRP interface and take action if needed
    :put "Default gateway not found -"
# We only take action on 'Primary' services not 'Backup'
	:foreach vrrpInt in [/interface/vrrp find where comment="Primary"] do={
      :local vrrpIntName [/interface/vrrp get $vrrpInt value-name=name]
      :local vrrpIntPriority [/interface/vrrp/ get [find name=$vrrpIntName] priority];
	  :if ($vrrpIntPriority = $healthyPriority) do={
          $changePriority $degradedPriority $vrrpIntName
      } else={
	      $leavePriority $vrrpIntPriority $vrrpIntName
	  }
    }
  }
}
```
