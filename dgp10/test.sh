#!/bin/bash

test_p="/tmp/failed_ping_test.txt"
echo "" > $test_p

HOSTS="
10.14.198.109
10.14.198.107
10.14.198.106
10.14.198.105
10.14.198.104
10.14.198.103
10.14.198.102
"
for i in $HOSTS
do

ping -c 3 $i > /dev/null 2>&1
if [ $? != 0 ]; then
	echo "$i is DOWN" >> $test_p
	else 
	echo "$i is UP" >> $test_p
fi

ssh -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$i 'bash -s' < /home/user/kva-kva/scripts/dgp10/kasper_.sh

done
