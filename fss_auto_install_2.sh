 #!/bin/bash
 
if [ $(whoami) = root ] ; then 
	echo 
	else 
	echo -en "$color1b Нужно открыть скрипт рутом! Установка прервана. $color1e"
	exit 1
fi

LOGFILE=/tmp/fss_install.log
exec > >(tee -a $LOGFILE)
exec 2>/dev/null
#exec 2>&1

color1b="\033[37;1;41m"
color1e="\033[0m"
color2b="\033[37;1;42m"
color2e="\033[0m"

echo -e "Установка АРМ ФСС. Для установки необходимо скачать установщик и сертификат ФСС в папку Загрузки."
echo -en "$color2b Введите 'yes' для продолжения: $color2e"
read inputval
if test "$inputval" != "yes"
	then
	echo -en "$color1b Установка отменена :с $color1e"
	exit 1
fi

user1=$(who | grep '(:0)' | cut -d " " -f1)
check1=$(ls /home/$user1/Загрузки/cert.cer | wc -c)
check2=$(ls /home/$user1/Загрузки/fss_*.exe | wc -c)

mkdir /opt/certs
chmod 777 /opt/certs

if [ ${check1} -eq 0 ]; then

echo -en "$color1b В папке /home/$user1/Загрузки/ нет сертификата ФСС. $color1e"
final1=$("$color1b В папке /home/$user1/Загрузки/ нет сертификата ФСС. $color1e")
echo

else 
	
	cp /home/$user1/Загрузки/cert.cer /opt/certs/

fi

if [ ${check2} -eq 0 ]; then

echo -en "$color1b В папке /home/$user1/Загрузки/ нет установщика. Установка отменяется. $color1e"
exit 1

fi

if rpm -qa | grep -q postgresql9.4 ; then 
	echo "Уже имеется postgresql старой версии нужно удалить её и сделать бекап"
	echo -n " 'yes' для отмены установки или 'del' для удаления postgresql9.4 (бекапы не делаются):"
read inputval1
if test "$inputval1" == "yes" 
then
	echo -en "$color1b Установка отменена :с $color1e"
	exit 1
elif test "$inputval1" == "del"
then
	apt-get remove -y postgresql-common postgresql9.4
fi
fi

##################################################

echo -en "$color2b Устанавливаем локальную бд: yes/no?? $color2e"
read inputval2
if test "$inputval2" == "no" 
then
	echo

elif test "$inputval2" == "yes"
	then

env -i apt-get update; env -i apt-get -y dist-upgrade
env -i apt-get install -y postgresql10-server

/etc/init.d/postgresql initdb

echo listen_addresses = "'*'" >> /var/lib/pgsql/data/postgresql.conf
sed -i 's/5432/5433/g' /lib/systemd/system/postgresql.service
systemctl daemon-reload

systemctl enable postgresql; systemctl restart postgresql

psql -p 5433 -U postgres -c "CREATE USER fss WITH SUPERUSER LOGIN;"
psql -p 5433 -U postgres -c "CREATE DATABASE fss WITH ENCODING='UTF-8';"

#####Пустая бд пострегреса.
cd /tmp/
echo -en "$color2b Бд создается для ЭЛН(eln) или ЭРС(ers)?$color2e"
read inputval3

####Добавить бекап локальной бд!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

if test "$inputval3" == "eln"
then
		cd /tmp/; wget -nv --no-cache http://10.11.128.115/.pcstuff/test/backup_enl_null.sql	
		psql -p 5433 -U postgres -d "fss" -f /tmp/backup_enl_null.sql
		psql -p 5433 -U postgres -c "ALTER DATABASE "fss" OWNER TO "fss";" 

elif test "$inputval3" == "ers"
	then
		cd /tmp/; wget -nv --no-cache http://10.11.128.115/.pcstuff/test/backup_ers_empty.sql	
		psql -p 5433 -U postgres -d "fss" -f /tmp/backup_ers_empty.sql
		psql -p 5433 -U postgres -c "ALTER DATABASE "fss" OWNER TO "fss";"

echo -en "$color2b Если нужна была только БД, то можно прервать установку, прерываем? $color2e"
echo -n " 'cancel' для отмены установки или 'go' для продолжения:"
read inputvalBD
if test "$inputvalBD" == "cancel" 
then
	exit 1
elif test "$inputvalBD" == "yes"
	then
	echo
fi
fi
fi

##################################################

cat << '_EOF_' >  /usr/bin/run_fss.sh
#!/bin/bash
/opt/cprocsp/bin/amd64/certmgr -delete -all -store uMy
/opt/cprocsp/bin/amd64/csptestf -absorb -certs
/opt/cprocsp/bin/amd64/certmgr -inst -store uMy -file "/opt/certs/cert.cer"
env WINEPREFIX=$HOME/.wine.fss wine reg delete 'HKEY_CURRENT_USER\Software\Microsoft\SystemCertificates\My\Certificates\' /f
if [ -f /usr/lib/wine/i386-unix/cpcsp_proxy_setup.exe.so ];then
 	WINEPREFIX=$HOME/.wine.fss wine /usr/lib/wine/i386-unix/cpcsp_proxy_setup.exe.so one1 two1 three1	
else
	WINEPREFIX=$HOME/.wine.fss wine /usr/lib/wine/cpcsp_proxy_setup.exe.so one1 two1	
fi
cd $HOME/.wine.fss/drive_c/Fss*
env WINEPREFIX=$HOME/.wine.fss wine fss_mo.exe
_EOF_

chmod 755 /usr/bin/run_fss.sh

cat << '_EOF_' >  /home/$user1/Рабочий\ стол/АРМ\ ЛПУ.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=АРМ ЛПУ
Exec=/usr/bin/run_fss.sh
Icon=5CB0_fsslogo.0
StartupNotify=true
Path=/usr/bin/
_EOF_

chown $user1:$user1 /home/$user1/Рабочий\ стол/АРМ\ ЛПУ.desktop
chmod +x /home/$user1/Рабочий\ стол/АРМ\ ЛПУ.desktop

#########################################################

#чек версии wine
check5=$(wine --version | head -n1  | awk '{print $1;}' | cut -d "-" -f2)
check6="8.0.6"
check_bottle=/home/$user1/.wine.fss

if [[ ${check5} == ${check6} ]]; then
  if [ -d $check_bottle ]; then
    i=1
    while [ -d $check_bottle$i ]; do
      i=$((i+1))
    done
	mv /home/${user1}/.wine.fss /home/${user1}/.wine.fss.bak$1
	cd /tmp/
	wget --progress=bar:force --no-cache http://10.11.128.115/.pcstuff/test/wine_fss_clean.tar.gz
	tar -xf /tmp/wine_fss_clean.tar.gz -C /home/${user1}/.wine.fss
	mv /home/${user1}/.wine.fss.g1 /home/${user1}/.wine.fss
	rm -rf /tmp/test/wine_fss_clean.tar.gz
  fi
else
	result_message_wine="wine $check5 - Версия wine не соответствует требуемой, установка прервана."
	exit 0
fi

##########################################################

echo -en "$color2b Указываем какую программу необходимо установить (прописать цифру)\n $color2e"
programs=(/home/*/Загрузки/fss_*.exe)

for ((i=0; i<${#programs[@]}; i++)); do
  echo "$((i+1)). ${programs[i]}"
done

read -p "Выберите номер программы: " choice

if [[ $choice =~ ^[1-${#programs[@]}]$ ]]; then
  selected_program="${programs[$((choice-1))]}"
  echo "Выбранная программа: $selected_program"
else
  echo "Некорректный выбор."
fi

su - ${user1} -c "XAUTHORITY=/var/run/lightdm/'$user1'/xauthority WINEPREFIX=/home/'$user1'/.wine.fss wine '$selected_program'"

check3=$(/home/${user1}/.wine.fss/drive_c/FssTools)

su - ${user1} -c "cp /home/'$user1'/.wine.fss/drive_c/windows/Microsoft.NET/Framework/v4.0.30319/RegAsm.exe /home/'$user1'/.wine.fss/drive_c/FssArmErs/"
su - ${user1} -c "cp /home/'$user1'/.wine.fss/drive_c/windows/Microsoft.NET/Framework/v4.0.30319/RegAsm.exe /home/'$user1'/.wine.fss/drive_c/FssTools"
su - ${user1} -c "cd /home/'$user1'/.wine.fss/drive_c/FssArmErs && WINEPREFIX=~/.wine.fss wine C:/Windows/Microsoft.NET/Framework/v4.0.30319/RegAsm.exe /registered GostCryptography.dll"
su - ${user1} -c "cd /home/'$user1'/.wine.fss/drive_c/FssTools && WINEPREFIX=~/.wine.fss wine C:/Windows/Microsoft.NET/Framework/v4.0.30319/RegAsm.exe /registered GostCryptography.dll"


rm -rf "/home/'$user1'/.local/share/applications/wine/Programs/СФР АРМ ЛПУ"
rm -rf "/home/'$user1'/.local/share/applications/wine/Programs/СФР АРМ ЛПУ(ЭРС)"
 \u0421\u0424\u0420 \u0410\u0420\u041c \u041b\u041f\u0423(\u042d\u0420\u0421).2.desktop
rm -rf "/home/$user1/.local/share/applications/wine/Programs/wine-Programs-СФР*
rm -rf /home/$user1/Рабочий\ стол/СФР\ АРМ\ ЛПУ.desktop
rm -rf /home/$user1/Рабочий\ стол/СФР\ АРМ\ ЛПУ(ЭРС\).desktop

echo 
echo "ФСС Установлено!"
echo -e $final1
echo $result_message_wine
