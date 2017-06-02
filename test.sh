#!/bin/bash

list=$@

newlist=()

for l in $list; do

        newlist+=($l)

done

echo "new"
echo $newlist
