#!/bin/bash

source data
source keys

./c1 stop

while ./c1 stop &>/dev/null
do
  echo "waiting for the first daemon to stop"
  sleep 5
done

./c2 stop

while ./c2 stop &>/dev/null
do
  echo "waiting for the second daemon to stop"
  sleep 5
done

if [ $1 -eq 1 ] ; then
  gnome-terminal -e "bash -c \"echo '$launch -pubkey=$pubkey1 -reindex'; $srcdir/$launch -pubkey=$pubkey1 -reindex; exec bash\""
  echo "started the first daemon in a new terminal with '-reindex' option"
  gnome-terminal -e "bash -c \"echo 'tail -f ~/.komodo/$name/debug.log'; tail -f ~/.komodo/$name/debug.log; exec bash\""
  echo "opened debug.log in a new terminal"
elif [ $1 -eq 2 ] ; then
  gnome-terminal -e "bash -c \"echo '$launch -pubkey=$pubkey2 -reindex -datadir=$datadir/$name -addnode=localhost'; $srcdir/$launch -pubkey=$pubkey2 -reindex -datadir=$datadir/$name -addnode=localhost; exec bash\""
  echo "started the second daemon in a new terminal with '-reindex' option" 
  gnome-terminal -e "bash -c \"echo 'tail -f $datadir/$name/debug.log'; tail -f $datadir/$name/debug.log; exec bash\""
  echo "opened debug.log in a new terminal"
else
  gnome-terminal -e "bash -c \"echo '$launch -pubkey=$pubkey1'; $srcdir/$launch -pubkey=$pubkey1; exec bash\""
  echo "started the first daemon in a new terminal with '-reindex' option"
  gnome-terminal -e "bash -c \"echo 'tail -f ~/.komodo/$name/debug.log'; tail -f ~/.komodo/$name/debug.log; exec bash\""
  echo "opened debug.log in a new terminal"
  gnome-terminal -e "bash -c \"echo '$launch -pubkey=$pubkey2 -reindex -datadir=$datadir/$name -addnode=localhost'; $srcdir/$launch -pubkey=$pubkey2 -reindex -datadir=$datadir/$name -addnode=localhost; exec bash\""
  echo "started the second daemon in a new terminal with '-reindex' option" 
  gnome-terminal -e "bash -c \"echo 'tail -f $datadir/$name/debug.log'; tail -f $datadir/$name/debug.log; exec bash\""
  echo "opened debug.log in a new terminal"
fi
  