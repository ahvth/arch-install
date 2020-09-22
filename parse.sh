#!/bin/bash

while read line; do
  if [[ "$line" =~ ^[^#]*= ]]; then
    key=`echo $line | sed 's/=.*//g'`
    value=`echo $line | sed 's/^.*.=//g'`
    export "$key"="$value"
    ((i++))
  fi
done < archconfig
