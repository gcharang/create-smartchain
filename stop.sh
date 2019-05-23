#!/bin/bash

echo "Stopping the first daemon if it is running"
./c1 stop 2>/dev/null
echo "Stopping the second daemon if it is running"
./c2 stop 2>/dev/null