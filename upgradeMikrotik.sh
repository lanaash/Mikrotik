#!/bin/bash
#-------------------------------------------------------------------------------------------------------
# Script to copy a validated routeros version to Mikrotik and then reboot into the new version
#
# The approved routeros version is stored for each architecture in routeros/upgrade/$ARCHITECTURE/
# e.g. routeros/upgrade/arm/routeros-7.17.1-arm.npk
#
# Put a list of Mikrotik IP/FQDNs into file called ips.txt
#
# ASH 2025
#-------------------------------------------------------------------------------------------------------

echo ; echo "* Mikrotik upgrade script" ; echo

# Vars
APIUSER=apiuser
SSHUSER=admin

# Get passwords
echo "Mikrotik admin password:"
read -s SSHPASS
echo "Mikrotik API password:"
read -s APIPASS

# Read in router IP/FQDNs from file
for ROUTER in `cat ips.txt`; do

    # Control vars
    IS_ONLINE=''
    IS_MIKROTIK=''
    NO_UPGRADE_FILE=''
    ERROR_MSG='Errors           ='

    echo; echo "** Connecting to $ROUTER"

    # Check router is online and is a mikrotik
    ping -c3 -i 0.200 -W 0.300 $ROUTER > /dev/null 2>&1
    if [ "$?" = "0" ]; then
        IS_ONLINE=1
        PLATFORM=$(curl -k -u $APIUSER:$APIPASS -s http://$ROUTER/rest/system/resource | jq '.platform' 2>/dev/null | sed 's/\"//g' | tr '[:upper:]' '[:lower:]')
        if [ "$PLATFORM" = "mikrotik" ]; then
            IS_MIKROTIK=1
        else
            IS_MIKROTIK=0
            ERROR_MSG="${ERROR_MSG} Not a mikrotik. "
        fi
    else
        IS_ONLINE=0
        ERROR_MSG="${ERROR_MSG} Not online. "
    fi

    if [ "$IS_ONLINE" = "1" ] && [ "$IS_MIKROTIK" = "1"  ]; then
        # Check current routeros version & hardware architecture
        CURRENT_VERSION=$(curl -k -u $APIUSER:$APIPASS -s http://$ROUTER/rest/system/resource | jq '.version' | sed 's/\"//g' | awk '{print $1}')
        ARCHITECTURE=$(curl -k -u $APIUSER:$APIPASS -s http://$ROUTER/rest/system/resource | jq '.["architecture-name"]' | sed 's/\"//g')

        # Get our current version number and filename
        UPGRADE_VERSION=$(ls -1t routeros/upgrade/$ARCHITECTURE/ |  head -n1 | sed 's/routeros-\(.*\)-.*/\1/')
        UPGRADE_FILE=$(ls -1t routeros/upgrade/$ARCHITECTURE/ | head -n1)
        if [[ -z "$UPGRADE_FILE" ]]; then
            # No file
            NO_UPGRADE_FILE=0
            ERROR_MSG="${ERROR_MSG} No upgrade firmware found. "
        fi

        if [ "$UPGRADE_VERSION" = "$CURRENT_VERSION" ]; then
             ERROR_MSG="${ERROR_MSG} Upgrade not required.  "
        fi

        if [[ "$CURRENT_VERSION" =~ ^6 ]]; then
             ERROR_MSG="${ERROR_MSG} Not version 7. "
        fi

        echo " Router model     = $PLATFORM"
        echo " RouterOS version = $CURRENT_VERSION"
        echo " Architecture     = $ARCHITECTURE"
        echo " Upgrade version  = $UPGRADE_VERSION"


        # Check that the current version is routeros 7 and also not running the upgrade version already
        if [ "$UPGRADE_VERSION" != "$CURRENT_VERSION" ] && [[ "$CURRENT_VERSION" =~ ^7 ]] && [ "$NO_UPGRADE_FILE" != "0" ]; then
            echo " Can be upgraded with routeros/upgrade/$ARCHITECTURE/$UPGRADE_FILE"
            read -p " Proceed to upgrade and reboot the router? (y or n) " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo ; echo " Copying $UPGRADE_FILE"
                sshpass -p "$SSHPASS" scp routeros/upgrade/$ARCHITECTURE/$UPGRADE_FILE $SSHUSER@$ROUTER:/. > /dev/null 2>&1
                if [ "$?" = "0" ]; then
                    echo " File copied, router now rebooting to start upgrade!"
                    curl -k -u $APIUSER:$APIPASS -s -X POST http://$ROUTER/rest/system/reboot  > /dev/null 2>&1
                else
                    echo " File copy failed!"
                fi
            else
                echo " $ERROR_MSG"
            fi
        else
            echo " $ERROR_MSG"
        fi
    else
        echo " $ERROR_MSG"
    fi
done
