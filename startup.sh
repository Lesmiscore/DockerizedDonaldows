#!/bin/bash

/usr/sbin/sshd -D &
echo Please connect to this by using \"ssh donaldows@localhost -p 3304 -X\"
echo Use \"mcdonald\" as password.

while :
do
true
done
