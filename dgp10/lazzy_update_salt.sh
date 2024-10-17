#!/bin/bash

HOSTS="

"
for i in $HOSTS
do

scp -O -o "StrictHostKeyChecking=no" -i /home/user/key/medkey /home/user/kva-kva/scripts/dgp10/update-alt.sh root@$i:/tmp/
ssh -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$i 'nohup /bin/bash /tmp/update-alt.sh > /dev/null 2>&1 &' &


done
