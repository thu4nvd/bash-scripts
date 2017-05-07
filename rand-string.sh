#!/bin/bash
# rand-string.sh
# Generating an 8-character "random" string.
if [ -n "$1" ]
then
str0="$1"
else
str0="$$"
fi
POS=2
LEN=8
# If command-line argument present,
#+ then set start-string to it.
#
#Else use PID of script as start-string.
# Starting from position 2 in the string.
# Extract eight characters.
str1=$( echo "$str0" | md5sum | md5sum )
# Doubly scramble
#^^^^^^
#^^^^^^
#+ by piping and repiping to md5sum.
randstring="${str1:$POS:$LEN}"
# Can parameterize ^^^^ ^^^^
echo "$randstring"
exit $?
# bozo$ ./rand-string.sh my-password
# 1bdd88c4
# No, this is is not recommended
#+ as a method of generating hack-proof passwords.
