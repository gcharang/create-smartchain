#!/bin/bash

source data

./c1 stop
./c2 stop

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

rm $name*