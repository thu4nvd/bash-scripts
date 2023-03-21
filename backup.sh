#!/usr/bin/env bash
# This script for backup file : copy and append extension ".bakup" + date
# Author: thuanvd@outlook.com

old_fname=$1
now=$(date +"%Y-%m-%d-%S")
new_fname="$old_fname.backup.$now"
cp -rav $old_fname $new_fname 
echo "Already backup file to $new_fname"
