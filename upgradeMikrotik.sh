#!/bin/bash
#-------------------------------------------------------------------------------------------------------
# Script to copy a validated routeros version 7 to Mikrotik and then reboot into the new version
#
# The approved routeros version is stored for each architecture in upgrade/$ARCHITECTURE/
# e.g. upgrade/arm/routeros-7.17.1-arm.npk
#
# Works on a list of Mikrotik IP/FQDNs into file called mikrotik.list
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

# Read in router IP/FQDNs from file e.g. pulled from Oxidized
for ROUTER in `cat /root/routeros/mikrotik.list`; do

    # Error message
    ERROR_MSG='Errors = '

    # Control vars
    IS_ONLINE=''
    IS_MIKROTIK=''
    IS_UPGRADABLE=''

    echo; echo "** Connecting to $ROUTER"

    # Check router is online and is a mikrotik
    ping -c3 -i 0.200 -W 0.300 $ROUTER > /dev/null 2>&1
    if [ "$?" = "0" ]; then
        IS_ONLINE=1
        PLATFORM=$(curl -k -u $APIUSER:$APIPASS -s https://$ROUTER/rest/system/resource | jq '.platform' 2>/dev/null | sed 's/\"//g' | tr '[:upper:]' '[:lower:]')
        if [ "$PLATFORM" = "mikrotik" ]; then
            IS_MIKROTIK=1
        else
            IS_MIKROTIK=0
            ERROR_MSG="${ERROR_MSG} Not a mikrotik ver 7. "
            IS_UPGRADABLE="No"
        fi
    else
        IS_ONLINE=0
        ERROR_MSG="${ERROR_MSG} Not online. "
        IS_UPGRADABLE="No"
    fi

    # If router is online and is mikrotik we can proceed with next checks
    if [ "$IS_UPGRADABLE" != "No" ]; then
        # Check current routeros version & hardware architecture
        CURRENT_VERSION=$(curl -k -u $APIUSER:$APIPASS -s https://$ROUTER/rest/system/resource | jq '.version' | sed 's/\"//g' | awk '{print $1}')
        ARCHITECTURE=$(curl -k -u $APIUSER:$APIPASS -s https://$ROUTER/rest/system/resource | jq '.["architecture-name"]' | sed 's/\"//g')

        # Get our current version number and filename
        UPGRADE_VERSION=$(ls -1t /root/routeros/upgrade/$ARCHITECTURE/ |  head -n1 | sed 's/routeros-\(.*\)-.*/\1/')
        UPGRADE_FILE=$(ls -1t /root/routeros/upgrade/$ARCHITECTURE/ | head -n1)

        # Check we have an upgrade file
        if [[ -z "$UPGRADE_FILE" ]]; then
            ERROR_MSG="${ERROR_MSG} No upgrade firmware found. "
            IS_UPGRADABLE="No"
        fi

        # Check running version same as upgrade version
        if [ "$UPGRADE_VERSION" = "$CURRENT_VERSION" ]; then
            ERROR_MSG="${ERROR_MSG} Upgrade not required.  "
            IS_UPGRADABLE="No"
        fi

        # Check running version is not an old v6
        if [[ "$CURRENT_VERSION" =~ ^6 ]]; then
            ERROR_MSG="${ERROR_MSG} Not version 7. "
            IS_UPGRADABLE="No"
        fi

        # Router info from API
        echo " Router model = $PLATFORM"
        echo " RouterOS version = $CURRENT_VERSION"
        echo " Architecture = $ARCHITECTURE"
        echo " Upgrade version = $UPGRADE_VERSION"

        # Proceed with upgrade
        if [ "$IS_UPGRADABLE" != "No" ]; then
            echo " Can be upgraded with upgrade/$ARCHITECTURE/$UPGRADE_FILE"
            read -p " Proceed to upgrade and reboot the router? (y or n) " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo ; echo " Copying $UPGRADE_FILE"
                sshpass -p "$SSHPASS" scp /root/routeros/upgrade/$ARCHITECTURE/$UPGRADE_FILE $SSHUSER@$ROUTER:/. > /dev/null 2>&1
                if [ "$?" = "0" ]; then
                    echo " File copied, router now rebooting to start upgrade!"
                    curl -k -u $APIUSER:$APIPASS -s -X POST https://$ROUTER/rest/system/reboot  > /dev/null 2>&1
                else
                    echo " File copy failed!"
                fi
            else
                echo ; echo " Upgrade aborted"
            fi
        else
            echo " $ERROR_MSG"
        fi
    else
        echo " $ERROR_MSG"
    fi
done
