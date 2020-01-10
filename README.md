# Simple scripts to create a Komodo Smart Chain using a single node for testing

This repository automates the steps described in the doc: https://developers.komodoplatform.com/basic-docs/smart-chains/smart-chain-tutorials/creating-a-smart-chain-on-a-single-node.html

**Assumes Ubuntu desktop environment, may need tweaks for others**

Clone the repository and navigate into it.

## Step 1

Create a file named `data` and add the following contents:

```bash
name=<SMARTCHAIN-NAME>
srcdir=/home/<USER>/komodo/src
launch="komodod -ac_name=$name -ac_supply=10"
datadir=/home/<USER>/coinData
```

- `name` is the Smart Chain's desired name
- `srcdir` is the absolute location of the directory which contains `komodod` and `komodo-cli`
- `launch` is the custom launch parameters of the Smart Chain, don't include `-pubkey` or `-addnode`
- `datadir` is the absolute location of the directory to which the data directories of the second daemons are saved, no need to create it, the script will do it for you

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

Execute the `create-assetchain.sh` script, it will launch two terminals each with a daemon running.
It also imports the `privkey` corresponding to the `pubkey` for the respective daemons.
Use the scripts `c1` and `c2` to interact with the 1st and 2nd daemons respectively.

Example:

```bash
./c1 getinfo # Get info of the first daemon
./c2 setgenerate true 1 # Start mining with the second daemon
./c2 getbalance # Get balance of the second daemon
```

Use the `stop` method to gracefully stop the daemons.

The script can be used to both create new Smart Chains or to launch an existing one.

**Note:** Executing `create-assetchain.sh explorer` installs the explorer too

## Start

Once the initial launch is done and the daemons have been shut down, the `start.sh` script can be used to launch the daemons and start mining on the first daemon

## Stop

To stop both the daemons, use the `stop.sh` script

## Reindex

For the first time any of the indexes: `address,transaction,spent` are added to the `conf` file, a reindex is needed. Use the `reindex.sh` script to do that. It also opens the `debug.log` corresponding to the daemon being reindexed in a new terminal.

Example:

```bash
./reindex.sh # reindexes both daemons
./reindex.sh 1 # reindexes the first daemon
./reindex.sh 2 # reindexes the second daemon
```

## Explorer

Use `install-explorer.sh` to install the explorer for your assetchain. You can use the command `./start.sh explorer` to start the explorer along with the coin daemons after it has been installed.

## Cleanup

To remove the Smart Chain completely, execute the `cleanup.sh` script. It removes the data directories of both the daemons, the explorer script and explorer installation. This is typically done to start another Smart Chain with the same name.
To target the removal of a Smart Chain other than the one described in the `data` file, use `./cleanup.sh SMARTCHAIN-NAME`

## Collect backtrace

Use the `./gdb-start.sh` script to start both the daemons using `gdb`


