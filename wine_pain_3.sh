#!/bin/bash


#не актуален!
user1=$(who | grep '(:0)' | cut -d " " -f1)
dir1=$(ls /home/$user1/.wine/drive_c/users/$user1/| wc -l)
salt1=$(systemctl is-active salt-minion >/dev/null 2>&1 && echo YES || echo NO)

if [ $salt1 == NO ]; then
	systemctl restart salt-minion
	echo mimi $salt1
elif [ $salt1 == YES ]; then
	echo
fi

su - ${user1} -c 'wineserver -k; sleep 3; rm -rf .wine.bak ;mv .wine .wine.bak; cp -r /etc/skel/.wine .'
su - ${user1} -c "/home/$user1/.wine/drive_c/users/'$user1'/Recent/"

if [ ${dir1} -le 22 ]; then 
	su - ${user1} -c "mkdir /home/$user1/.wine/drive_c/users/'$user1'"
	yes | cp -r /etc/skel/.wine/drive_c/users/user/* /home/$user1/.wine/drive_c/users/$user1/
	chown $user1:$user1 -R /home/$user1/.wine/drive_c/users/$user1
	echo "$ip changed dir"
else
	echo
fi

rpm -ev libwine libwine-gl wine wine-cpcsp_proxy; env -i salt-call state.apply



