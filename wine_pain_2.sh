#!/bin/bash
LANG=C

exec 2> /dev/null

user1=$(who | grep '(:0)' | cut -d " " -f1)
dir1=$(ls /home/$user1/.wine/drive_c/users/$user1/| wc -l)

#Удаляем неудачные бекапы
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

# Проверяем бутылку и версию wine 
result_message2=""
check8=$(wine --version | cut -d " " -f1)
check9=/root/etersoft-repo/wine_bottle_8.0.6.tar.gz
wine --version | cut -d " " -f1


########Проверяем бутылку
if [ "$check8" == "wine-8.0.5-alt0.M80P.1" ]; then
	echo
	if [ -e "$check9" ]; then 
	echo
	else
		cd /root/etersoft-repo/
	   wget -nv --no-cache http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_8.0.6/wine_bottle_8.0.6.tar.gz
    	cd /etc/skel/
		rm -rf .wine
		tar -xvf /root/etersoft-repo/wine_bottle_8.0.6.tar.gz
		result_message2=$(wine --version); Не было wine_bottle_8.0.6 - поставил. 
	fi
	else
		result_message2="$(wine --version)"
fi

#АААААА засрал лог в телеге!
#Если вдруг бутылки нет, мы её выше проверили и теперь из скелетона добавим
wine_bottle=$(/home/$user1/.wine/drive_c/Vitacore)
if [ -d $wine_bottle ]; then
	echo
else
	su - "$user1" -c "cp -r /etc/skel/.wine ."
fi


#Проверка фсс-aids-spectator приблуд?
check2=/home/$user1/.wine/drive_c/AIDSNET59
check3=/home/$user1/.wine/drive_c/spectator
check4=/home/$user1/.wine/drive_c/FssArmErs
check5=/home/$user1/.wine/drive_c/FssTools
check6=/home/$user1/.wine/drive_c/Radiant

#Бекап бутылки
result_message1=""

if [ -d $check2 ] || [ -d $check3 ] || [ -d $check4 ] || [ -d $check5 ] || [ -d $check6 ]; then
  if [ -d .wine.special ]; then
    i=1
    while [ -d .wine.special$i ]; do
      i=$((i+1))
    done
    result_message1="n-копия чего-то там"
    su - "$user1" -c "wineserver -k; sleep 3; mv .wine .wine.special$i; cp -r /etc/skel/.wine ."
  else
    result_message1="1 копия чего-то там"
    su - "$user1" -c "wineserver -k; sleep 3; mv .wine .wine.special; cp -r /etc/skel/.wine ."
  fi
else
  result_message1="Приблуды не найдены"
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

#Обновляемся из salt 
####Вывести проверку доступности
salt1=$(systemctl is-active salt-minion >/dev/null 2>&1 && echo YES || echo NO)

if [ $salt1 == NO ]; then
	systemctl restart salt-minion
	echo mimi $salt1
elif [ $salt1 == YES ]; then
	echo
fi

#разрешение wine
chmod +rwxr+xr+x /usr/bin/wine


env -i salt-call state.apply | tail -n 7
echo "$result_message1"
echo "$result_message2"

