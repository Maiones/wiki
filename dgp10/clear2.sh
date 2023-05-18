#!/bin/bash

exec 2>/dev/null
user1=$(who | grep '(:0)' | cut -d " " -f1)
check1=/home/$user1/check_exist_vita.sh
ip=$(ip a | grep "inet 10." | cut -d '/' -f1)

rm -rf /home/$user1/.wine/drive_c/Vitacore/AS
rm /root/reinstprinter.sh 
rm /root/check.sh

lsof -i | grep 10.14.198.190 | awk '{print $2}' | xargs pkill

if test -e "$check1" ; then 
	echo "$ip скрипт обнаружен"
fi

cd /home/$user1
pkill -f check_exist_vita.sh; pkill -f zabol2020.sh; pkill -f reinstprinter.sh; pkill -f script.sh; pkill -f vita_second.sh; pkill -f vita.sh; pkill -f auto_upd_vita.sh; pkill -f setupTF.sh

chattr -i -R check_exist_vita.sh script.sh vita_second.sh vita.sh auto_upd_vita.sh reinstprinter.sh setupTF.sh zabol2020.sh
rm -rf check_exist_vita.sh script.sh vita_second.sh vita.sh auto_upd_vita.sh reinstprinter.sh setupTF.sh zabol2020.sh
su - $user1 -c "crontab -r"
crontab -r

