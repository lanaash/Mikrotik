#!/bin/bash
DUT=$1                # Device under test
DIRECTION=$2          # 'receive', 'send' or 'both'
PROTOCOL=$3           # 'tcp' or 'udp'
SERVER="192.168.1.1"  # BW Test server

MY_JSON=$( /usr/bin/jq -n -c \
              --arg server "$SERVER" \
              --arg direction "$DIRECTION" \
              --arg protocol "$PROTOCOL" \
              --arg user "API_USER" \
              --arg pass "API_PASS" \
              --arg time "5" \
              '{address: $server, protocol: $protocol, direction: $direction, user: $user, password: $pass, duration: $time}' )

/usr/bin/curl -k -u 'LOCAL_USER:LOCAL_PASS' -X POST -H "Content-Type: application/json" -d $MY_JSON  https://$DUT/rest/tool/bandwidth-test | /usr/bin/jq
