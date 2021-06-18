#!/bin/bash
issudo=$(id -u)
if [ "$issudo" -ne 0 ]
  then echo "Ejecuta como sudo"
  exit
fi
source ./config
currentUser="${user}"
i=0
while :; do
  echo "borrando $currentUser"
  killall --user $currentUser
  userdel "$currentUser" -r
  i=$((i + 1))
  currentUser="${user}_${i}"
  [[ "$i" -lt "$NUMUSERS" ]] || break
done