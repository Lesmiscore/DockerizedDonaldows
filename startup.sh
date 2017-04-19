#!/bin/bash

/usr/sbin/sshd -D &
echo Please connect to this by using \"ssh donaldows:mcdonald@localhost:3304 -X\"
while :
do
true
done