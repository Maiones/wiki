#!/bin/bash

test_p="/tmp/failed_ping_zastava_gates.txt"
echo "" > $test_p

HOSTS="

"
for i in $HOSTS
do

ping -c 3 $i > /dev/null 2>&1
if [ $? != 0 ]; then
	echo "$i is DOWN" >> $test_p
	else 
	echo "$i is UP" >> $test_p
fi

#scp -o "StrictHostKeyChecking=no" -i /home/user/key/id_rsa_med_servers -r /home/user/medbot/certs/калугасауауа.cer  root@$i:/tmp/
ssh -o "StrictHostKeyChecking=no" -i /home/user/key/id_rsa_med_servers root@$i 'bash -s <<EOF
/opt/ZASTAVAoffice/bin/vpnconfig -add cert /tmp/калугасауауа.cer pin 12345678
EOF
'
done
