#!/bin/bash

test_p="/tmp/failed_ping_test.txt"
echo "" > $test_p

HOSTS="
10.14.199.201
"
for i in $HOSTS
do

ping -c 3 $i > /dev/null 2>&1
if [ $? != 0 ]; then
	echo "$i is DOWN" >> $test_p
	else 
	echo "$i is UP" >> $test_p
fi

ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$i 'bash -s' < /home/user/kva-kva/scripts/wine_dir_create.sh

done
