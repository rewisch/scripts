#!/usr/bin/env bash

hexip2dec() {
  ip=$1
  echo $((16#${ip:6:2})).$((16#${ip:4:2})).$((16#${ip:2:2})).$((16#${ip:0:2}))
}

# Flags: 1=link (directly), 3=via gateway; Metric: cost (lower wins)

{
  read -r _
  while read -r Iface Destination Gateway Flags RefCnt Use Metric Mask MTU Window IRTT; do
    echo "$(hexip2dec $Destination) on $Iface via $(hexip2dec $Gateway) (Flags: $Flags  Metric: $Metric)"
  done
} </proc/net/route
