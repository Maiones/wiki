#!/bin/bash

user1=$(who | grep '(:0)' | cut -d " " -f1)
dir1=$(ls /home/$user1/.wine/drive_c/users/$user1/| wc -l)
salt1=$(systemctl is-active salt-minion)

if [ $salt1 != active ]; then
	systemctl restart salt-minion
	echo $salt1
fi

# Проверяем бутылку и версию wine 
check1=$(wine --version | cut -d " " -f1)

#Проверка версии wine:
if [ "$check1" != "wine-8.0.6-alt0.M80P.1" ]; then
	echo $check1 не подходит для скрипта	
	exit 0
fi

#Проверяем контрольную сумму контрольной суммы?
test_sha256=/root/etersoft-repo/wine-etersoft-install.sha256

if [ ! -f $test_sha256 ]; then 
	wget -nv --no-cache http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_8.0.6/wine-etersoft-install.sha256
fi

#Проверка всех контрольных сумм из массива (wine_bottle_8.0.6.tar.gz нет контрольной суммы -_-):
wine_files=(wine32-etersoft-8.0.6-alt0.M80P.1.i586.rpm wine-etersoft-8.0.6-alt0.M80P.1.x86_64.rpm wine-etersoft-common-8.0.6-alt0.M80P.1.noarch.rpm wine-etersoft-gecko-2.47.3-alt2.M80P.3.noarch.rpm wine-etersoft-network-7.0.8-alt0.M80P.1.x86_64.rpm wine-etersoft-programs-8.0.6-alt0.M80P.1.x86_64.rpm wine-etersoft-winetricks-20230212-alt0.M80P.1.noarch.rpm)

result_message1=""

for file in "${wine_files[@]}"; do
	cd /root/etersoft-repo/
	expected_sum=$(grep "$file" /root/etersoft-repo/wine-etersoft-install.sha256 | awk '{print $1}')
	if [ -e "$file" ]; then
		actual_sum=$(sha256sum "$file" | awk '{print $1}')	
		if [ "$expected_sum" != "$actual_sum" ]; then
         cd /root/etersoft-repo/
      	rm -rf $file
         wget -nv --no-cache http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_8.0.6/$file
      	result_message1="$file: Сумма SHA-256 не совпала! Загружено заново."
      	result_message1="Сравнение сумм успешно выполнено."
      fi
	else
		result_message1="$file: Файл не найден."
	fi
done

#Удаляем старый wine и распаковываем новый в skel
new_bottle=/root/etersoft-repo/wine_bottle_8.0.6.tar.gz

if [ ! -e "$new_bottle" ]; then
    cd /root/etersoft-repo/
    wget -nv --no-cache http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_8.0.6/wine_bottle_8.0.6.tar.gz
fi

rm -rf /etc/skel/.wine
cd /etc/skel/
tar -xf /root/etersoft-repo/wine_bottle_8.0.6.tar.gz

#Удаляем библиотеки wine
rpm -ev libwine libwine-gl wine wine-cpcsp_proxy

#разрешение wine
chmod +rwxr+xr+x /usr/bin/wine
	
#Проверка фсс-aids-spectator приблуд?
check2=/home/$user1/.wine/drive_c/AIDSNET59
check3=/home/$user1/.wine/drive_c/spectator
check4=/home/$user1/.wine/drive_c/FssArmErs
check5=/home/$user1/.wine/drive_c/FssTools
check6=/home/$user1/.wine/drive_c/Radiant

#Бекап старой бутылки и переустановка её
result_message2=""

if [ -d $check2 ] || [ -d $check3 ] || [ -d $check4 ] || [ -d $check5 ] || [ -d $check6 ]; then
	if [ -d .wine.special ]; then
		i=1
	while [ -d .wine.special$i ]; do
		i=$((i+1))
	done
	result_message2="n-копия чего-то там"
	su - "$user1" -c "wineserver -k; sleep 3; mv .wine .wine.special$i; cp -r /etc/skel/.wine ."
  else
	result_message2="1 копия чего-то там"
	su - "$user1" -c "wineserver -k; sleep 3; mv .wine .wine.special; cp -r /etc/skel/.wine ."
  fi
else
	result_message2="Приблуды не найдены"
	su - "$user1" -c "wineserver -k; sleep 3; rm -rf .wine.bak; mv .wine .wine.bak; cp -r /etc/skel/.wine ."
fi

#Проверка пользовательской папки user на необходимые для запуска ГИСа файлы

if [ ${dir1} -le 22 ]; then 
	su - ${user1} -c "mkdir /home/$user1/.wine/drive_c/users/'$user1'"
	yes | cp -r /etc/skel/.wine/drive_c/users/user/* /home/$user1/.wine/drive_c/users/$user1/
	chown $user1:$user1 -R /home/$user1/.wine/drive_c/users/$user1
fi

#Проверяем папку для .lnk файлов
check7=/home/$user1/.wine/drive_c/users/'$user1'/Recent
if [ -d "$check7" ]; then
	su - '$user1' -c "mkdir /home/$user1/.wine/drive_c/users/'$user1'/Recent/"
	su - '$user1' -c "mv *.lnk /tmp/"
fi

env -i salt-call state.apply | tail -n 7
echo "$result_message1"
echo "$result_message2"
