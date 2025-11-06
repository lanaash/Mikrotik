# Pre-reqs
APN Profiles are already configured. The script can just flip between them based on the installed SIM

# Schedule
```
/system scheduler add interval=60s name=Run_Configure_APN on-event="/system/script/run Configure_APN" policy=read,write start-time=startup
```

# Script
```
:global mobileState
:global currentMobileApn
:global newMobileApn "default"
:set $mobileState value=[/interface/lte/get lte1 running as-string]
:set $currentMobileApn value=[/interface/lte/get lte1 apn-profiles  as-string]
:put "Running=$mobileState APN=$currentMobileApn"
/interface/lte/monitor lte1 once do={
  :global mobileImsi $"imsi"
  :global mobileIccid $"uicc"
}
:put "IMSI=$mobileImsi ICCID=$mobileIccid"
:if ($mobileState = "yes") do={
  :put "Mobile connected nothing to do..."
} else={
  :if ($mobileImsi ~"^23410" || $mobileIccid ~"^894411") do={ :set newMobileApn "O2" }
  :if ($mobileImsi ~"^23415" || $mobileIccid ~"^894410") do={ :set newMobileApn "Vodafone" }
  :if ($mobileImsi ~"^23433" || $mobileIccid ~"^894430" || $mobileIccid ~"^894412") do={ :set newMobileApn "EE" }
  :if ($currentMobileApn = $newMobileApn) do={
    :put "APN correctly set so nothing to do..."
  } else={
    :put "Changing APN from $currentMobileApn to $newMobileApn"
	:log info "Changing APN from $currentMobileApn to $newMobileApn"
	/interface/lte set [ find default-name=lte1 ] apn-profiles="$newMobileApn"
  }
}
```
