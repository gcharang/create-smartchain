#!/bin/bash

. data

echo "Stopping the first daemon if it is running"
./c1 stop 2>/dev/null
echo "Stopping the second daemon if it is running"
./c2 stop 2>/dev/null

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