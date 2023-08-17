#Позволяет указывать пароли при использовании scp и ssh:
#apt-get install -y sshpass
#На пк юзера:
#apt-get install -y expect

#!/bin/bash

test_p="/tmp/failed_ping_pro.txt"
echo "" > $test_p

HOSTS="
10.10.19.189
"
for i in $HOSTS
do

ping -c 3 $i > /dev/null 2>&1
if [ $? != 0 ]; then
	echo "$i is DOWN" >> $test_p
	else 
	echo "$i is UP" >> $test_p
fi

sshpass -p "user" ssh -o "StrictHostKeyChecking=no" user@$i 'bash -s' < /home/user/kva-kva/scripts/dgp10/pass_change/change_admin_pass_4.sh

done

exit 0




#Новый пароль для VNC
#x11vnc -storepasswd 'dgp!10ADMIN!' /root/.vnc/passwd


#echo "admin" | su -c "passwd user"