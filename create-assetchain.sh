#!/bin/bash

source data
source keys
name=$name
srcdir=$srcdir
launch=$launch
pubkey1=$pubkey1
pubkey2=$pubkey2
privkey1=$privkey1
privkey2=$privkey2
datadir=$datadir

if [ ! -d "$datadir" ]; then
  mkdir $datadir
  echo "created $datadir"
else 
  echo "$datadir already exists"  
fi

if [ ! -d "$datadir/$name" ]; then
  mkdir "$datadir/$name"
  echo "created $datadir/$name"
else 
  echo "$datadir/$name already exists"  
fi  

gnome-terminal -e "bash -c \"echo '$launch -pubkey=$pubkey1'; $srcdir/$launch -pubkey=$pubkey1; exec bash\""
echo "started the first daemon in a new terminal"


while [ ! -f "/home/$USER/.komodo/$name/$name.conf" ]
do
   sleep 2
   echo "waiting for first daemon's conf file to be created"
done

rand1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 24 | head -n 1)
rand2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 24 | head -n 1)

source ~/.komodo/$name/$name.conf
cat <<EOF > $datadir/$name/$name.conf
rpcuser=user$rand1
rpcpassword=pass$rand2
rpcport=$((rpcport+4))
port=$((rpcport+3))
server=1
txindex=1
rpcworkqueue=256
rpcallowip=127.0.0.1
EOF

gnome-terminal -e "bash -c \"echo '$launch -pubkey=$pubkey2 -datadir=$datadir/$name -addnode=localhost'; $srcdir/$launch -pubkey=$pubkey2 -datadir=$datadir/$name -addnode=localhost; exec bash\""
echo "started the second daemon in a new terminal"

until $srcdir/komodo-cli -ac_name=$name getinfo &>/dev/null
do
   echo "waiting for the first daemon to accept rpc calls"
   sleep 1
done

$srcdir/komodo-cli -ac_name=$name importprivkey $privkey1
echo "imported privkey of first daemon"

until $srcdir/komodo-cli -ac_name=$name -datadir=$datadir/$name getinfo &>/dev/null
do
  echo "waiting for the second daemon to accept rpc calls"
  sleep 1
done

$srcdir/komodo-cli -ac_name=$name -datadir=$datadir/$name importprivkey $privkey2
echo "imported privkey of second daemon"