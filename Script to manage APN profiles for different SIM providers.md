# Pre-reqs
The APN Profiles are already configured. The script can just flip between them based on the installed SIM

# Schedule
```
/system scheduler add interval=60s name=Run_Configure_APN on-event="/system/script/run Configure_APN" policy=read,write start-time=startup
```

# Script
```
# Vars
:local mobileState
:local currentMobileApn
:local mobileImsi
:local mobileIccid
# If we can't identify SIM we leave set to the default APN profile
:local newMobileApn "default"
# Get current configured APN Profile
:set $currentMobileApn value=[/interface/lte/get lte1 apn-profiles  as-string]
# Get SIM details
/interface/lte/monitor lte1 once do={
  :set mobileImsi $"imsi"
  :set mobileIccid $"uicc"
}
# From SIM details get APN Profile we should be using
:put "IMSI=$mobileImsi ICCID=$mobileIccid"
:if ($mobileImsi ~"^23410" || $mobileIccid ~"^894411") do={ :set newMobileApn "O2" }
:if ($mobileImsi ~"^23415" || $mobileIccid ~"^894410") do={ :set newMobileApn "Vodafone" }
:if ($mobileImsi ~"^23433" || $mobileIccid ~"^894430" || $mobileIccid ~"^894412") do={ :set newMobileApn "EE" }
# Check current configured APN matches the required APN
:if ($currentMobileApn = $newMobileApn) do={
  :put "APN correctly set to $currentMobileApn so nothing to do..."
  #:log info "APN correctly set to $currentMobileApn so nothing to do..."
} else={
    :put "Changing APN from $currentMobileApn to $newMobileApn"
	:log info "Changing APN from $currentMobileApn to $newMobileApn"
	/interface/lte set [ find default-name=lte1 ] apn-profiles="$newMobileApn"
}
```
