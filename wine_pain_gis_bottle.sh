#!/bin/bash
LANG=C

#exec 2> /dev/null

user1=$(who | grep '(:0)' | cut -d " " -f1)
dir1=$(ls /home/$user1/.wine/drive_c/users/$user1/| wc -l)

# Определение функции переустановки бутылки в skel
extract_wine_bottle() {
    rm -rf /etc/skel/.wine
    tar -C /etc/skel/ -xf /root/etersoft-repo/wine_bottle_8.0.6.tar.gz
}

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
fi

if [[ $(df -h / | awk 'NR==2 {print $5}' | tr -d '%') == 100 ]]; then
    result_message_root_size="Файловая система полностью заполнена, прерываю скрипт."
    exit 0
fi

#Проверка битых пакетов
ldconfig 2>&1| awk '{print $3}' | env -i   xargs -- apt-get install -y --reinstall

##Блокируем запуск на время выполнения скрипта /usr/bin/run_vita.sh
chmod -x /usr/bin/run_vita.sh


# Проверяем бутылку и версию wine 
check8=$(wine --version | cut -d " " -f1)
check9=/root/etersoft-repo/wine_bottle_8.0.6.tar.gz
chek_ether_bottle=ef4c17eee3764500fc9200602cea9f66
chek_ether_bottle2=$(md5sum /root/etersoft-repo/wine_bottle_8.0.6.tar.gz | awk '{print $1}')

# Проверяем md5sum бутылки, в случае несоотвествия переустанавливаем бутылку в skel.
if test -d /root/etersoft-repo/ ; then
    if [ ! "$chek_ether_bottle" = "$chek_ether_bottle2" ]; then
	    rm -f /root/etersoft-repo/wine_bottle_8.0.6.tar.gz
	    env -i wget -P /root/etersoft-repo/ http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_8.0.6/wine_bottle_8.0.6.tar.gz
	    extract_wine_bottle
	    result_message_md5="md5sum wine_bottle_8.0.6.tar.gz не верна."
	  fi
  else
    result_message_md5_2="/root/etersoft-repo отсуствует"   
fi 

#Проверка wrapper, если гис в скелетоне остался старый
if [ ! -f "/etc/skel/.wine/wrapper.cfg" ]; then
	extract_wine_bottle
	result_message_wr="Бутылка с 4.9 заменена."
fi

# Чек прав на папку .wine в skel
stat_check=$(stat -c %u /etc/skel/.wine)
if [ "$stat_check" = 0 ]; then
	extract_wine_bottle
	result_message_stat="Исправлены права в skel на wine."
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
check_wsp=/home/$user1/.wine.special

#Бекап старой бутылки и переустановка её
result_message1=""

if [[  $(ls /home/$user1/.wine/drive_c | wc -l) > 5 ]]; then
  if [ -d $check_wsp ]; then
    i=1
    while [ -d $check_wsp$i ]; do
      i=$((i++))
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
check_lnk=/home/$user1/.wine/drive_c/users/'$user1'/Recent
if [ -d "$check_lnk" ]; then
	su - '$user1' -c "mkdir /home/$user1/.wine/drive_c/users/'$user1'/Recent/"
fi

#'Удаляем' мусорные ссылки
trash1=$(/home/$user1/*.lnk)
trash2=$(/home/$user1/Документы/*.lnk)

# не сработал !
if [ -f $trash1 ] || [ -f $trash2 ]; then
	su - '$user1' -c "rm /home/$user1/*.lnk"
	su - '$user1' -c "rm /home/$user1/Документы/*.lnk"
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

##Разблокируем запуск /usr/bin/run_vita.sh
chmod +x /usr/bin/run_vita.sh

#разрешение wine
chmod 0755 /usr/bin/wine

#Обновляемся из salt 
####Вывести проверку доступности
salt1=$(systemctl is-active salt-minion >/dev/null 2>&1 && echo YES || echo NO)

if [ $salt1 == NO ]; then
	systemctl restart salt-minion
	echo $salt1
fi

#Проверка mtu и заставы
#grep -E 'inet [0-9]+\.' | grep 10.* | awk '{print $2}'
zastava_check=$(/opt/ZASTAVAclient/bin/vpnmonitor -p)

env -i salt-call state.apply | tail -n 7
echo "$result_message_root_size"
echo "$result_message1"
echo "$result_message_bak"
echo "$result_message_wr"
echo "$result_message_stat"
echo "$result_message_pr"
echo "$zastava_check"
echo "$result_message_md5"
echo "$result_message_md5_2"



