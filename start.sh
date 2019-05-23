#!/bin/bash

. data

./c1 stop
./c2 stop

while ./c1 stop &>/dev/null
do
  echo "waiting for the first daemon to stop"
  sleep 5
done

while ./c2 stop &>/dev/null
do
  echo "waiting for the second daemon to stop"
  sleep 5
done


./create-assetchain.sh

./c1 setgenerate true 1
echo "mining started in the first daemon"

if [ "$1" = "explorer" ]; then
  cd explorers
  . $name-webaccess 
  echo "Visit http://localhost:$webport to access the explorer"
  ./$name-explorer-start.sh
fi 