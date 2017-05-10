#!/bin/bash

if [[ $# == 0 ]] ; then
    echo "at least 1 param"
    exit 1
fi

if [ -f $1 ] ;then
    cat $1
    exit 1
else
    echo "Khong ton tai file"
    exit 1
fi
echo done
exit 1
