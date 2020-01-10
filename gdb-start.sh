#!/bin/bash

. data
. keys

name=$name
srcdir=$srcdir
launch=$launch
pubkey1=$pubkey1
pubkey2=$pubkey2
privkey1=$privkey1
privkey2=$privkey2
datadir=$datadir

gnome-terminal -e "bash -c \"echo '$launch -pubkey=$pubkey1'; gdb -args $srcdir/$launch -pubkey=$pubkey1\""
echo "started the first daemon in a new terminal"

gnome-terminal -e "bash -c \"echo '$launch -pubkey=$pubkey2 -datadir=$datadir/$name -addnode=localhost'; gdb -args $srcdir/$launch -pubkey=$pubkey2 -datadir=$datadir/$name -addnode=localhost\""
echo "started the second daemon in a new terminal"
