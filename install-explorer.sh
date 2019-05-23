#!/bin/bash

source data

if [ ! -f "/home/$USER/.komodo/$name/$name.conf" ]; then
  echo "create the assetchain with name: $name and shut down the daemons before trying to install the explorer"
  echo "Exiting"
  exit 1  
fi

CUR_DIR=$(pwd)

pidfile="$HOME/.komodo/$name/komodod.pid"  

if [ -f $pidfile ]; then
  echo "The first daemon is running, it needs to be shutdown to install the explorer"
  echo "This script will now try to shut down the daemon"
  read -p "Should we proceed? (y/n) "  answer
  while [ "$answer" != "y" ] && [ "$answer" != "n" ]; do
    echo "Please answer either 'y' for yes or 'n' for no"
    read -p "Should we proceed? (y/n) "  answer
  done
  
  if [ "$answer" = "n" ]; then
    echo "Exiting the script, please shutdown the first daemon using './c1 stop' and try again"
    exit 1
  elif [ "$answer" = "y" ]; then
    echo "Proceeding to shut down the daemon and install the explorer"
    ./c1 stop 2>/dev/null
    while ./c1 stop &>/dev/null
    do
      echo "waiting for the first daemon to stop"
      sleep 5
    done
    echo "first daemon has been stopped"
  fi
else
  echo "First daemon is not running"
fi

echo "Launching the daemons to mine a few blocks"
./start.sh
blocks=$(./c1 getinfo | jq -r '.blocks')
while [ $blocks -lt 5 ]; do
  sleep 5
  echo "waiting for atleast 5 blocks to be mined"
done  
echo "Stopping the daemons to install the explorer"
./stop.sh 

if [ ! -d "$CUR_DIR/explorers"]; then
  echo "Cloning the explorer installer repository"
  success=0
  count=1
  while [ $success -eq 0 ]; do
    echo "[Try $count] Cloning the explorer installer repository"
    git clone https://github.com/gcharang/komodo-install-explorer explorers && success=1 || success=0
    sleep 4
    count=$((count+1))
  done
else
  echo "A directory named 'explorers' already exists; assuming it is cloned from the repo: https://github.com/gcharang/komodo-install-explorer , trying to install the explorer inside it"
fi

cd $CUR_DIR/explorers
if [ ! -d "./node_modules/bitcore-node-komodo" ]; then
  echo "Setting up the explorer directory and installing dependencies" 
  ./setup-explorer-directory.sh
else
  echo "Looks like the initial setup of the explorers directory and installation of dependencies has been done"
fi

./install-assetchain-explorer.sh $name noweb

echo "Launching first daemon to reindex the blocks"
cd $CUR_DIR

gnome-terminal -e "bash -c \"echo '$launch -pubkey=$pubkey1 -reindex'; $srcdir/$launch -pubkey=$pubkey1 -reindex\""
echo "started the first daemon in a new terminal with '-reindex'"
echo "waiting for reindexing to finish"
tail -f /home/$USER/.komodo/$name/debug.log | while read LOGLINE
do
  [[ "${LOGLINE}" == *"Reindexing finished"* ]] && pkill -P $$ tail
done
sleep 3
echo "the daemon has finished reindexing; shutting down the daemon"
./c1 stop
while ./c1 stop &>/dev/null
do
  echo "waiting for the first daemon to stop"
  sleep 5
done

echo "Use the 'start.sh' script to start the daemons"
echo "Execute 'start.sh explorer' script to start the daemons along with the explorer"
