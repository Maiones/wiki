 #!/bin/bash

if [ $(whoami) = root ] ; then 
	echo 
	else 
	echo -en "$color1b Нужно открыть скрипт рутом! Установка прервана. $color1e"
	exit 1
fi

LOGFILE=/tmp/fss_install_astra.log
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

#################################################

echo -en "$color2b Устанавливаем локальную бд: yes/no?? $color2e"
read inputval2
if test "$inputval2" == "no" 
then
	echo

elif test "$inputval2" == "yes"
	then

env -i apt install -y postgresql-13 postgresql-client-13
systemctl stop postgresql
rm -rf /var/lib/postgresql/11/main/*
su - postgres -c "touch ~/.bashrc"
su - postgres -c "echo 'export PATH=$PATH:/usr/lib/postgresql/13/bin' > ~/.bashrc"
su - postgres -c "echo 'export PGDATA="$HOME/13/main"' >> ~/.bashrc"
su - postgres -c "source ~/.bashrc"
su - postgres -c "initdb --locale=ru_RU.utf8 --lc-messages=ru_RU.utf8"

#редактируем /etc/postgresql/13/main/pg_hba.conf, добавляем в конец файла
#host all all 10.0.0.0/24 md5
#где 10.0.0.0/24 - CIDR вашей сети или внешнего хоста, которому разрешается доступ
sed -i 's/5432/5433/g' /etc/postgresql/11/main/postgresql.conf
sed -i 's/peer/trust/' /etc/postgresql/11/main/pg_hba.conf

systemctl daemon-reload
systemctl enable postgresql && systemctl start postgresql

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

********
********
********




##################################################

cat << '_EOF_' >  /usr/bin/run_fss.sh
#!/bin/bash
/opt/cprocsp/bin/amd64/certmgr -delete -all -store uMy
/opt/cprocsp/bin/amd64/csptestf -absorb -certs
/opt/cprocsp/bin/amd64/certmgr -inst -store uMy -file "/opt/certs/cert.cer"
env WINEPREFIX=$HOME/.wine.fss wine reg delete 'HKEY_CURRENT_USER\Software\Microsoft\SystemCertificates\My\Certificates\' /f
env WINEPREFIX=$HOME/.wine.fss wine /usr/lib32/i386-linux-gnu/wine-etersoft/i386-unix/cpcsp_proxy_setup.exe.so one1 two1 three1
cd "$HOME/.wine.fss/drive_c/FssTools/"
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

	rm -rf /home/${user1}/.wine.fss.bak 
	mv /home/${user1}/.wine.fss /home/${user1}/.wine.fss.bak 
	su - ${user1} -c "XAUTHORITY=/var/run/lightdm/'$user1'/xauthority WINEPREFIX=/home/'$user1'/.wine.fss WINEARCH=win32 wine wineboot"
	su - ${user1} -c "XAUTHORITY=/var/run/lightdm/'$user1'/xauthority WINEPREFIX=/home/'$user1'/.wine.fss wine /usr/lib32/i386-linux-gnu/wine-etersoft/i386-unix/cpcsp_proxy_setup.exe.so"
	su - ${user1} -c "cd /home/'$user1'/.wine.fss/drive_c/windows/system32/ && ln -svf /usr/lib32/i386-linux-gnu/wine-etersoft/i386-unix/cpcsp_proxy.dll.so"
	su - ${user1} -c "XAUTHORITY=/var/run/lightdm/'$user1'/xauthority WINEPREFIX=/home/'$user1'/.wine.fss winetricks dotnet40"
	su - ${user1} -c "XAUTHORITY=/var/run/lightdm/'$user1'/xauthority WINEPREFIX=/home/'$user1'/.wine.fss winetricks ie8"
	su - ${user1} -c "XAUTHORITY=/var/run/lightdm/'$user1'/xauthority WINEPREFIX=/home/'$user1'/.wine.fss winetricks gdiplus"



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
mv /home/$user1/Рабочий\ стол/СФР\ АРМ\ ЛПУ.desktop /tmp/

check3=$(/home/${user1}/.wine.fss/drive_c/FssTools)
check4=$(/home/${user1}/.wine.fss/drive_c/FssArmErs)

su - ${user1} -c "cp /home/'$user1'/.wine.fss/drive_c/windows/Microsoft.NET/Framework/v4.0.30319/RegAsm.exe /home/'$user1'/.wine.fss/drive_c/Fss*"
su - ${user1} -c "cd /home/'$user1'/.wine.fss/drive_c/Fss* && WINEPREFIX=~/.wine.fss wine C:/Windows/Microsoft.NET/Framework/v4.0.30319/RegAsm.exe /registered GostCryptography.dll"

if [ test -e ${check3} ]; then
	sed -i 's/5CB0_fsslogo.0/FEAB_fss_mo.0/g' /usr/bin/run_fss.sh
fi

if [ test -e ${check4} ]; then
	sed -i 's/FssTools/FssArmErs/g' /usr/bin/run_fss.sh
fi

echo 
echo "ФСС Установлено!"
echo -e $final1
echo $result_message_wine
