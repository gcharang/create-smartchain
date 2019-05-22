# Simple scripts to create a Komodo assetchain using a single node for testing

This repository automates the steps described in the doc: https://docs.komodoplatform.com/assetchains/create-asset-chain-single-node.html

**Assumes Ubuntu desktop environment, may need tweaks for other environments**

Clone the repository and navigate into it.

## Step 1

Create a file named `data` and add the following contents:

```bash
name=<ASSETCHAIN-NAME>
srcdir=/home/<USER>/komodo/src
launch="komodod -ac_name=$name -ac_supply=10"
datadir=/home/<USER>/coinData
```

- `name` is the assetchain's desired name
- `srcdir` is the absolute location of the directory which contains `komodod` and `komodo-cli`
- `launch` is the custom launch parameters of the assetchain, don't include `-pubkey` or `-addnode`
- `datadir` is the directory to which the datadirectories of the second daemons are saved, no need to create it, the script will do it for you

## Step 2

Create a file named `keys` and add the following contents:

```bash
pubkey1=02xxxxxxxxxxxxxxxxxx
pubkey2=03xxxxxxxxxxxxxxxxxx
privkey1=Uxxxxxxxxxxxxxxxxxx
privkey2=Uxxxxxxxxxxxxxxxxxx
```

- `pubkey1` and `privkey1` are a pair of keys used to launch the first daemon
- `pubkey2` and `privkey2` are a pair of keys used to launch the second daemon

## Step 3

Execute the `create-assetchain.sh` script, it will launch two terminals each with a daemon running in them.
It also imports the `privkey` corresponding to the `pubkey` for the respective daemons.
Use the scripts `c1` and `c2` to interact with the 1st and 2nd daemons respectively.

Example:

```bash
./c1 getinfo
./c2 setgenerate true 1
./c2 getbalance
```

Use the `stop` method to gracefully stop the daemons.

The script can be used to both create new assetchains or to launch an existing one.

## Start

Once the initial launch is done and the daemons have been shut down, the `start.sh` script can be used to launch the daemons and start mining on the first daemon

## Stop

To stop both the daemons, use the `stop.sh` script

## Reindex

For the first time the any of the indexes: `address,transaction,spent` have been added to the `conf` file, a reindex is needed. Use the `reindex.sh` script to do that. It also opens the `debug.log` corresponding to the daemon being reindexed in a new terminal.

Example:

```bash
./reindex.sh # reindexes both daemons
./reindex.sh 1 # reindexes the first daemon
./reindex.sh 2 # reindexes the second daemon
```

## Cleanup

To remove the assetchain completely, execute the `cleanup.sh` script. It removes the datadirectories of both the daemons. This is typically done to start another assetchain with the same name.
