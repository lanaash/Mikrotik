#!/bin/bash
#-------------------------------------------------------------------------------------------------------
# Script to copy our validated routeros version to Mikrotik CPE and then reboot
# into the new version
#
# The approved routeros version is stored for each architecture in routeros/current/$ARCH/
# e.g. routeros/current/arm/routeros-7.17.1-arm.npk
#
# Put a list of Mikrotik CPE IP/FQDNs into file called ips.txt
#-------------------------------------------------------------------------------------------------------

echo ; echo "* Mikrotik CPE upgrade script" ; echo

# Vars
APIUSER=admin
SSHUSER=admin
DEBUG=True

# Get passwords
echo "Mikrotik admin password:"
read -s SSHPASS
echo "Mikrotik API password:"
read -s APIPASS

# Read in router names/ips from file
for ROUTER in `cat ips.txt`; do

    # Flags
    ISONLINE=''
    ISMIKROTIK=''

    echo; echo "** Connecting to $ROUTER"

    # Check router is online and is a mikrotik
    ping -c3 -i 0.200 -W 0.300 $ROUTER > /dev/null 2>&1
    if [ "$?" = "0" ]; then
        ISONLINE=1
        PLATFORM=$(curl -k -u $APIUSER:$APIPASS -s http://$ROUTER/rest/system/resource | jq '.platform' 2>/dev/null | sed 's/\"//g' | tr '[:upper:]' '[:lower:]')
        if [ "$PLATFORM" = "mikrotik" ]; then
            ISMIKROTIK=1
        else
            echo "$ROUTER is not a mikrotik"
            ISMIKROTIK=0
        fi
    else
        echo " Offline"
        ISONLINE=0
    fi

    if [ "$ISONLINE" = "1" ] && [ "$ISMIKROTIK" = "1"  ]; then

        # Check current routeros version & hardware architecture
        VERSION=$(curl -k -u $APIUSER:$APIPASS -s http://$ROUTER/rest/system/resource | jq '.version' | sed 's/\"//g' |  grep -E -o "([0-9]{1,3}[\\.]){2}[0-9]{1,3}")
        ARCH=$(curl -k -u $APIUSER:$APIPASS -s http://$ROUTER/rest/system/resource | jq '.["architecture-name"]' | sed 's/\"//g')

        # Get our current version number and filename
        CURRENT=$(ls -1t routeros/current/$ARCH/ |  head -n1 | grep -E -o "([0-9]{1,3}[\\.]){2}[0-9]{1,3}")
        FILE=$(ls -1t routeros/current/$ARCH/ | head -n1)

        # Debug
        if [ "$DEBUG" = "True" ]; then
            echo " DEBUG: Router model     = $PLATFORM"
            echo " DEBUG: RouterOS version = $VERSION"
            echo " DEBUG: Architecture     = $ARCH"
            echo " DEBUG: Upgrade file     = $FILE"
        fi

        if [ "$VERSION" != "$CURRENT" ]; then
            echo " $ROUTER can be upgraded with routeros/current/$ARCH/$FILE"
            read -p " Proceed to upgrade and reboot the router? (y or n) " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo ; echo " Copying $FILE"
                sshpass -p "$SSHPASS" scp routeros/current/$ARCH/$FILE $SSHUSER@$ROUTER:/. > /dev/null 2>&1
                if [ "$?" = "0" ]; then
                    echo " Rebooting..."
                    curl -k -u $APIUSER:$APIPASS -s -X POST http://$ROUTER/rest/system/reboot  > /dev/null 2>&1
                else
                    echo " File copy failed!"
                fi
            else
                echo " Leaving this one then..."
            fi
        else
            echo " Running our current version so nothing to do"
        fi
    fi
done

