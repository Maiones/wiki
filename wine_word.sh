#!/bin/bash

user1=$(who | grep '(:0)' | cut -d " " -f1)
ip=$(ip a | grep "inet 10.14" | cut -d '/' -f1)
dir1=$(ls /home/$user1/.wine/drive_c/users/$user1/| wc -l)

if [ ${dir1} -le 4 ]; then 
	mv /home/$user1/.wine/drive_c/users/$user1 /tmp/
	cp -r /etc/skel/.wine/drive_c/users/user/ /home/$user1/.wine/drive_c/users/$user1
	chown $user1:$user1 -R /home/$user1/.wine/drive_c/users/$user1
	echo "$ip changed dir"
else
	echo "$ip good"
fi	

exit 0


