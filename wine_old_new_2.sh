#!/bin/bash

ip=$(ip a | grep "inet 10.14" | cut -d '/' -f1)
wine=$(rpm -qa | grep wine-etersoft-8.0.5)
if [ "$wine" = "wine-etersoft-8.0.5-alt0.M80P.1" ]; then 

	mount -o remount,size=4G /tmp
	cd /tmp
	env -i wget http://10.11.128.115/.pcstuff/wine/import_certs.sh
	cat import_certs.sh > /usr/bin/import_certs.sh
	chmod -x /usr/bin/wine
	killall AKUZ.UserArm.exe winedevice.exe explorer.exe winedevice.exe plugplay.exe services.exe rpcss.exe 
	rpm -qa --qf='[%{name}\n]'|grep wine|xargs -- apt-get remove -y
	env -i salt-call state.apply

else

	exit 0

fi
exit 0
