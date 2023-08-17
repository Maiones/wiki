#!/bin/bash
LANG=C

user1=$(who | grep '(:0)' | cut -d " " -f1)
dir1=$(ls /home/$user1/.wine/drive_c/users/$user1/| wc -l)

#Удаляем неудачные обновы
rm -rf /.*[0-9]*

#Чек размера диска и log cups чистка 
check1=/var/log/cups/error_log
size1=$(du -b "$check10" | awk '{print $1}')

if [[ "$size1" -gt 1073741824 ]]; then
    truncate -s 0 "$check1"
    cupsctl --no-debug-logging
else
    echo
fi

#Проверка битых пакетов
ldconfig 2>&1| awk '{print $3}' | env -i   xargs -- apt-get install -y --reinstall

#Проверка фсс-aids-spectator приблуд?
check2=/home/$user1/.wine/drive_c/AIDSNET59
check3=/home/$user1/.wine/drive_c/spectator
check4=/home/$user1/.wine/drive_c/FssArmErs
check5=/home/$user1/.wine/drive_c/FssTools
check6=/home/$user1/.wine/drive_c/Radiant

#Бекап бутылки
if [ -d $check2 ] || [ -d $check3 ] || [ -d $check4 ] || [ -d $check5 ] || [ -d $check6 ]; then
  if [ -d .wine.special ]; then
    i=1
    while [ -d .wine.special$i ]; do
      i=$((i+1))
    done
        echo "n-копия чего-то там"
    su - "$user1" -c "wineserver -k; sleep 3; mv .wine .wine.special$i; cp -r /etc/skel/.wine ."
  else
      	echo "1 копия чего-то там"
    su - "$user1" -c "wineserver -k; sleep 3; mv .wine .wine.special; cp -r /etc/skel/.wine ."
  fi
else
    	echo "Приблуды не найдены"
  su - "$user1" -c "wineserver -k; sleep 3; rm -rf .wine.bak; mv .wine .wine.bak; cp -r /etc/skel/.wine ."
fi



#Проверяем папку для .lnk файлов
check7=/home/$user1/.wine/drive_c/users/'$user1'/Recent
if [ -d "$check7" ]; then
	su - '$user1' -c "mkdir /home/$user1/.wine/drive_c/users/'$user1'/Recent/"
	su - '$user1' -c "mv *.lnk /tmp/"
else
	echo
fi

#'Удаляем' мусорные ссылки
su - '$user1' -c "mv /home/$user1/*.lnk /tmp/"
		
if [ ${dir1} -le 22 ]; then 
	su - ${user1} -c "mkdir /home/'$user1'/.wine/drive_c/users/'$user1'"
	yes | cp -r /etc/skel/.wine/drive_c/users/user/* /home/$user1/.wine/drive_c/users/$user1/
	chown $user1:$user1 -R /home/$user1/.wine/drive_c/users/$user1
	echo "$ip changed dir"
else
	echo
fi	

#Правильный запуск
sed -i "5c\Exec=/usr/bin/run_vita.sh" /etc/skel/Рабочий\ стол/as_rmiac.desktop
##! Не работает!!!
# Проверяем бутылку и версию wine 
check8=/etc/skel/.wine/wrapper.cfg
check9=/root/etersoft-repo/wine_bottle_8.0.6.tar.gz
check10=/usr/bin/import_certs.sh

########Проверяем бутылку и конфиг import_certs.sh#
#if [ "$wine" == "wine-etersoft-8.0.5-alt0.M80P.1" ]; then

#if grep -q "wine /usr/lib/wine/i386-unix/cpcsp_proxy_setup.exe.so one1 two1 three1" "$check10"; then
 #   sed -i 's|wine /usr/lib/wine/i386-unix/cpcsp_proxy_setup.exe.so one1 two1 three1|wine /usr/lib/wine/cpcsp_proxy_setup.exe.so one1 two1|g' "$check10"
#else
 #   echo
#fi

    if test -e "$check8"; then
			echo
    else
    if test -e "$check9"; then
	echo
else
	cd /root/etersoft-repo/
	wget http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_8.0.6/wine_bottle_8.0.6.tar.gz
    		cd /etc/skel/
			rm -rf .wine
			tar -xvf /root/etersoft-repo/wine_bottle_8.0.6.tar.gz
	  fi
	fi

#Обновляемся из salt
salt1=$(systemctl is-active salt-minion >/dev/null 2>&1 && echo YES || echo NO)

if [ $salt1 == NO ]; then
	systemctl restart salt-minion
	echo mimi $salt1
elif [ $salt1 == YES ]; then
	echo
fi

#разрешение wine
chmod +rwxr+xr+x /usr/bin/wine


env -i salt-call state.apply

