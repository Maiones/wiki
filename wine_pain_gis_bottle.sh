#!/bin/bash
LANG=C

exec 2> /dev/null

user1=$(who | grep '(:0)' | cut -d " " -f1)
dir1=$(ls /home/$user1/.wine/drive_c/users/$user1/| wc -l)

#Удаляем неудачные бекапы
if [ ! -f "/.*[0-9]*" ]; then
	rm -rf /.*[0-9]*
	result_message_bak="Неудачные бекапы удалены."
fi

#Чек размера диска и log cups чистка (>1Gb) 
check_log=/var/log/cups/error_log
size_log=$(du -b "$check_log" | awk '{print $1}')

if [[ "$size_log" -gt 1073741824 ]]; then
    truncate -s 0 "$check_log"
    cupsctl --no-debug-logging
else
    echo
fi

if [[ $(df -h / | awk 'NR==2 {print $5}' | tr -d '%') == 100 ]]; then
    result_message_root_size="Файловая система полностью заполнена, прерываю скрипт."
    exit 0
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

#Если вдруг бутылки нет, мы её выше проверили и теперь из скелетона добавим
wine_bottle=$(/home/$user1/.wine/drive_c/Vitacore)
if [ ! -d $wine_bottle ]; then
	su - "$user1" -c "cp -r /etc/skel/.wine ."
	result_message_bt="Бутылку в skel положили."
fi

#Добавить проверку wrapper, если гис в скелетоне остался старый
if [ ! -f "/etc/skel/.wine/wrapper.cfg" ]; then
	rm -rf /etc/skel/.wine/
	cd /etc/skel/
	tar -xvf /root/etersoft-repo/wine_bottle_8.0.6.tar.gz
	result_message_wr="Бутылка с 4.9 заменена."
fi


if [ ! -f "/usr/bin/prepare_bottle.sh" ]; then
	cat << '_EOF_' > /usr/bin/prepare_bottle.sh
#!/bin/sh
grep -q -m1 "%user%" "$HOME"/.wine/{user.reg,system.reg,userdef.reg} && sed "s/%user%/$USER/g" -i "$HOME"/.wine/{user.reg,system.reg,userdef.reg}
[ -d "$HOME/.wine/drive_c/users/$USER/" ] || cp -r "$HOME/.wine/drive_c/users/user/" "$HOME/.wine/drive_c/users/$USER/"e
_EOF_
	chmod +x /usr/bin/prepare_bottle.sh
	result_message_pr="prepare_bottle добавлен!"
fi	

#Проверка фсс-aids-spectator приблуд?
check2=/home/$user1/.wine/drive_c/AIDSNET59
check3=/home/$user1/.wine/drive_c/spectator
check4=/home/$user1/.wine/drive_c/FssArmErs
check5=/home/$user1/.wine/drive_c/FssTools
check6=/home/$user1/.wine/drive_c/Radiant
check_wsp=/home/$user1/.wine.special

# Чек доступа бутылки
if [ ! -d $wine_bottle ]; then
	su - "$user1" -c "cp -r /etc/skel/.wine ."
	result_message_bt="Бутылку в skel положили."
fi

#Бекап старой бутылки и переустановка её
result_message1=""

if [ -d $check2 ] || [ -d $check3 ] || [ -d $check4 ] || [ -d $check5 ] || [ -d $check6 ]; then
  if [ -d $check_wsp ]; then
    i=1
    while [ -d $check_wsp$i ]; do
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
fi

#'Удаляем' мусорные ссылки
trash1=$(/home/$user1/*.lnk)
trash2=$(/home/$user1/Документы/*.lnk)

if [ -f $trash1 -o -f $trash2  ]; then
	su - '$user1' -c "mv /home/$user1/*.lnk /tmp/"
	su - '$user1' -c "mv /home/$user1/Документы/*.lnk /tmp/"
fi

#Проверка пользовательской папки user на необходимые для запуска ГИСа файлы		
if [ ${dir1} -le 22 ]; then 
	su - ${user1} -c "mkdir /home/'$user1'/.wine/drive_c/users/'$user1'"
	yes | cp -r /etc/skel/.wine/drive_c/users/user/* /home/$user1/.wine/drive_c/users/$user1/
	chown $user1:$user1 -R /home/$user1/.wine/drive_c/users/$user1
fi	

#Правильный запуск
sed -i "5c\Exec=/usr/bin/run_vita.sh" /etc/skel/Рабочий\ стол/as_rmiac.desktop
sed -i "s|<\wine\>|wine_noproxy.sh|g" /etc/skel/Рабочий\ стол/AIS_LPU_RDS.desktop

#Обновляемся из salt 
####Вывести проверку доступности
salt1=$(systemctl is-active salt-minion >/dev/null 2>&1 && echo YES || echo NO)

if [ $salt1 == NO ]; then
	systemctl restart salt-minion
	echo $salt1
fi

#разрешение wine
chmod 0755 /usr/bin/wine

env -i salt-call state.apply | tail -n 7
echo "$result_message_root_size"
echo "$result_message1"
echo "$result_message2"
echo "$result_message_bak"
echo "$result_message_wr"
echo "$result_message_bt"
cho "$result_message_pr"


