#!/bin/bash

if [ $# -eq 1 ]; then
  name=$1
elif [ $# -eq 0 ]; then  
  source data
else
  echo "Received more arguments than expected; received:$# expected:1"
  exit 1
fi  

echo "Stopping the first daemon if it is running"
./c1 stop 2>/dev/null
echo "Stopping the second daemon if it is running"
./c2 stop 2>/dev/null


while ./c1 stop &>/dev/null
do
  echo "waiting for the first daemon to stop"
  sleep 5
done

rm -rf /home/$USER/.komodo/$name/                                                                                                                                                           Monday 20 May 2019 05:46:17 PM IST

while ./c2 stop &>/dev/null
do
  echo "waiting for the second daemon to stop"
  sleep 5
done
rm -rf /home/$USER/coinData/$name/

echo "removed the directories: '/home/$USER/.komodo/$name/' and '/home/$USER/coinData/$name/'"

rm $name* &>/dev/null
echo "removed $name*"
rm -rf ./explorers/$name* &>/dev/null
echo "removed ./explorers/$name*"