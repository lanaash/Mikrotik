#!/bin/bash
#-------------------------------------------------------------------------------------------------------
# Script to copy a validated routeros version to Mikrotik and then reboot into the new version
#
# The approved routeros version is stored for each architecture in routeros/upgrade/$ARCHITECTURE/
# e.g. routeros/upgrade/arm/routeros-7.17.1-arm.npk
#
# Put a list of Mikrotik CPE IP/FQDNs into file called ips.txt
#-------------------------------------------------------------------------------------------------------

echo ; echo "* Mikrotik upgrade script" ; echo

# Vars
APIUSER=apiuser
SSHUSER=admin
DEBUG=True

# Get passwords
echo "Mikrotik admin password:"
read -s SSHPASS
echo "Mikrotik API password:"
read -s APIPASS

# Read in router IP/FQDNs from file
for ROUTER in `cat ips.txt`; do

    # Flags
    IS_ONLINE=''
    IS_MIKROTIK=''

    echo; echo "** Connecting to $ROUTER"

    # Check router is online and is a mikrotik
    ping -c3 -i 0.200 -W 0.300 $ROUTER > /dev/null 2>&1
    if [ "$?" = "0" ]; then
        IS_ONLINE=1
        PLATFORM=$(curl -k -u $APIUSER:$APIPASS -s http://$ROUTER/rest/system/resource | jq '.platform' 2>/dev/null | sed 's/\"//g' | tr '[:upper:]' '[:lower:]')
        if [ "$PLATFORM" = "mikrotik" ]; then
            IS_MIKROTIK=1
        else
            echo " Not a mikrotik"
            IS_MIKROTIK=0
        fi
    else
        echo " Offline"
        IS_ONLINE=0
    fi

    if [ "$IS_ONLINE" = "1" ] && [ "$IS_MIKROTIK" = "1"  ]; then
        # Check current routeros version & hardware architecture
        CURRENT_VERSION=$(curl -k -u $APIUSER:$APIPASS -s http://$ROUTER/rest/system/resource | jq '.version' | sed 's/\"//g' | awk '{print $1}')
        ARCHITECTURE=$(curl -k -u $APIUSER:$APIPASS -s http://$ROUTER/rest/system/resource | jq '.["architecture-name"]' | sed 's/\"//g')

        # Get our current version number and filename
        UPGRADE_VERSION=$(ls -1t routeros/upgrade/$ARCHITECTURE/ |  head -n1 | sed -e 's/routeros-\(.*\)-.*/\1/')
        UPGRADE_FILE=$(ls -1t routeros/upgrade/$ARCHITECTURE/ | head -n1)

        # Debug
        if [ "$DEBUG" = "True" ]; then
            echo " DEBUG: Router model     = $PLATFORM"
            echo " DEBUG: RouterOS version = $CURRENT_VERSION"
            echo " DEBUG: Architecture     = $ARCHITECTURE"
            echo " DEBUG: Upgrade version  = $UPGRADE_FILE"
        fi

        # Check that the current version is routeros 7 and also not running the upgrade version already
        if [ "$UPGRADE_VERSION" != "$CURRENT_VERSION" ] && [[ "$CURRENT_VERSION" =~ ^7 ]]; then
            echo " Can be upgraded with routeros/upgrade/$ARCHITECTURE/$UPGRADE_FILE"
            read -p " Proceed to upgrade and reboot the router? (y or n) " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo ; echo " Copying $UPGRADE_FILE"
                sshpass -p "$SSHPASS" scp routeros/upgrade/$ARCHITECTURE/$UPGRADE_FILE $SSHUSER@$ROUTER:/. > /dev/null 2>&1
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
