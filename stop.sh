#!/bin/bash

./c1 stop &>/dev/null
echo "Stopping the first daemon"
./c2 stop &>/dev/null
echo "Stopping the second daemon"