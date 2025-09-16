#!/bin/bash
#
# Basic PoC for firewall filter management using API
# to show methods and example data format 
# Yes you will need to manage state/return traffic :-)
#

ACTION=$1
ROUTER="192.168.88.1"

case $ACTION in
print)
  curl -k -u admin:admin -X GET http://$ROUTER/rest/ip/firewall/filter | jq
  ;;

add)
  read -p "Destination Address: " DSTADDRESS
  read -p "Protocol: " PROTOCOL
  read -p "Destination Port: " DSTPORT
  read -p "Source Address: " SRCADDRESS
  read -p "Action: " ACTION

  MY_JSON=$( jq -n -c -s \
          --arg chain "forward" \
          --arg dstaddresskey "dst-address" \
          --arg dstaddress "$DSTADDRESS" \
          --arg dstportkey "dst-port" \
          --arg dstport "$DSTPORT" \
          --arg protocol "$PROTOCOL" \
          --arg srcaddresskey "src-address" \
          --arg srcaddress "$SRCADDRESS" \
          --arg action "$ACTION" \
          --arg placebeforekey "place-before" \
          --arg placebefore "0" \
          '{chain: $chain, ($placebeforekey): $placebefore, ($dstaddresskey): $dstaddress, ($dstportkey): $dstport, protocol: $protocol, ($srcaddresskey): $srcaddress, action: $action}' )

  curl -k -u admin:admin -X PUT -H "content-type: application/json" -d $MY_JSON http://$ROUTER/rest/ip/firewall/filter | jq
  ;;

modify)
  read -p "Modify what rule number? " RULENUM
  read -p "Modify what key(dst-address,dst-port,protocol,src-address,action)? " KEY
  read -p "New value? " VALUE

  MY_JSON=$( jq -n -c -s \
          --arg key "$KEY" \
          --arg value "$VALUE" \
          '{($key): $value}' )

  curl -k -u admin:admin -X PATCH -H "content-type: application/json" -d $MY_JSON http://$ROUTER/rest/ip/firewall/filter/*$RULENUM
  ;;

move)
  read -p "Move what rule number? " SRCRULENUM
  read -p "To where? " DSTRULENUM

  SRCRULENUM="*${SRCRULENUM}"
  DSTRULENUM="*${DSTRULENUM}"

  MY_JSON=$( jq -n -c \
          --arg src "$SRCRULENUM" \
          --arg dst "$DSTRULENUM" \
          '{numbers: $src, destination: $dst}' )

  curl -k -u admin:admin -X POST -H "content-type: application/json" -d $MY_JSON http://$ROUTER/rest/ip/firewall/filter/move | jq
  ;;

disable)
  read -p "Disable what rule number? " RULENUM
  curl -k -u admin:admin -X PATCH -H "content-type: application/json" -d '{"disabled":"true"}' http://$ROUTER/rest/ip/firewall/filter/*$RULENUM
  ;;

enable)
  read -p "Enable what rule number? " RULENUM
  curl -k -u admin:admin -X PATCH -H "content-type: application/json" -d '{"disabled":"false"}' http://$ROUTER/rest/ip/firewall/filter/*$RULENUM
  ;;

delete)
  read -p "Delete what rule number? " RULENUM
  curl -k -u admin:admin -X DELETE http://$ROUTER/rest/ip/firewall/filter/*$RULENUM | jq
 ;;

*)
  echo "Actions are print, add, modify, move, disable, enable or delete"
  ;;
esac

