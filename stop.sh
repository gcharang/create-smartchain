#!/bin/bash

echo "Stopping the first daemon if it is running"
./c1 stop 2>/dev/null

while ./c1 stop &>/dev/null
do
  echo "waiting for the first daemon to stop"
  sleep 5
done

echo "Stopping the second daemon if it is running"
./c2 stop 2>/dev/null

while ./c2 stop &>/dev/null
do
  echo "waiting for the second daemon to stop"
  sleep 5
done
rm -rf /home/$USER/coinData/$name/