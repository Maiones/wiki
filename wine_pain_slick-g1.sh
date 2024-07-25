#!/bin/bash

release=$(rpm -q --qf='[%{Release}\n]' slick-greeter)

if [ $release == alt1.M80P.1 ]; then
	cd /tmp/
	apt-get remove -y slick-greeter
	env -i wget http://10.11.128.115/.pcstuff/test/slick-greeter-1.0.8-alt1.M80C.2.x86_64.rpm
	rpm -Uh slick-greeter-1.0.8-alt1.M80C.2.x86_64.rpm
	rm slick-greeter-1.0.8-alt1.M80C.2.x86_64.rpm
	sed -i 's/autologin-user=/#autologin-user=/g' /etc/lightdm/lightdm.conf
		for user in $(awk -F: '{if ($3>=500 && $3<=1000) print $1}' /etc/passwd); do
			chage --mindays -1 --maxdays 150 --warndays 4 $user
			chage -d 2024-01-01 $user
		done
else 
	exit 0
fi



