#!/bin/bash

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
check2=$(ls /home/$user1/Загрузки/fss_e*.exe | wc -c)

if [ ${check1} -eq 0 ]; then

echo -en "$color1b В папке /home/$user1/Загрузки/ нет сертификата ФСС. $color1e"
final1=$("$color1b В папке /home/$user1/Загрузки/ нет сертификата ФСС. $color1e")
echo

else 
	mkdir /opt/certs
	chmod 777 /opt/certs
	cp /home/$user1/Загрузки/cert.cer /opt/certs

fi

if [ ${check2} -eq 0 ]; then

echo -en "$color1b В папке /home/$user1/Загрузки/ нет установщика. Установка отменяется. $color1e"
exit 1

fi

##################################################

if [ $(whoami) = root ] ; then 
	echo 
	else 
	echo -en "$color1b Нужно открыть скрипт рутом! Установка прервана. $color1e"
	exit 1
fi

##################################################

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
echo -n "Бд создается для ЭЛН(eln) или ЭРС(ers)? "
read inputval3
if test "$inputval3" != "eln"
then
	wget https://github.com/Maiones/wiki/blob/master/database/backup_enl_null.sql
	psql -p 5433 -U postgres -d "fss" -f /tmp/backup_enl_null.sql
	psql -p 5433 -U postgres -c "ALTER DATABASE "fss" OWNER TO "fss";" 

elif test "$inputval3" == "ers"
	then
		wget https://github.com/Maiones/wiki/blob/master/database/backup_ers_empty.sql
		psql -p 5433 -U postgres -d "fss" -f /tmp/backup_ers_empty.sql
		psql -p 5433 -U postgres -c "ALTER DATABASE "fss" OWNER TO "fss";"

fi
fi

##################################################

cd /usr/bin/
touch run_fss.sh
chmod 755 run_fss.sh
echo '#!/bin/bash' > run_fss.sh
echo '/opt/cprocsp/bin/amd64/certmgr -delete -all -store uMy' >> run_fss.sh
echo '/opt/cprocsp/bin/amd64/csptestf -absorb -certs' >> run_fss.sh
echo '/opt/cprocsp/bin/amd64/certmgr -inst -store uMy -file "/opt/certs/cert.cer"' >> run_fss.sh
echo "env WINEPREFIX=$HOME/.wine.fss wine reg delete 'HKEY_CURRENT_USER\Software\Microsoft\SystemCertificates\My\Certificates\' /f" >> run_fss.sh
echo 'env WINEPREFIX=$HOME/.wine.fss wine /usr/lib/wine/cpcsp_proxy_setup.exe.so one1 two1' >> run_fss.sh
echo 'cd "$HOME/.wine.fss/drive_c/FssTools/"' >> run_fss.sh
echo 'env WINEPREFIX=$HOME/.wine.fss wine fss_mo.exe' >> run_fss.sh

path1="/home/$user1/Рабочий стол/"
name1="АРМ ЛПУ.desktop"
path2=$path1$name1

su - ${user1} -c "touch '$path2'"
su - ${user1} -c "echo '[Desktop Entry]' > '$path2'"
su - ${user1} -c "echo 'Version=1.0' >> '$path2'"
su - ${user1} -c "echo 'Type=Application' >> '$path2'"
su - ${user1} -c "echo 'Name=АРМ ЛПУ' >> '$path2'"
su - ${user1} -c "echo 'Exec=/usr/bin/run_fss.sh' >> '$path2'"
su - ${user1} -c "echo 'Icon=F53C_fss_mo.0' >> '$path2'"
su - ${user1} -c "echo 'StartupNotify=true' >> '$path2'"
su - ${user1} -c "echo 'Path=/usr/bin/' >> '$path2'"
su - ${user1} -c "chmod +x '$path2'"

rm -rf /home/${user1}/.wine.fss.bak 
mv /home/${user1}/.wine.fss /home/${user1}/.wine.fss.bak 
su - user -c "XAUTHORITY=/var/run/lightdm/'$user1'/xauthority WINEPREFIX=/home/'$user1'/.wine.fss WINEARCH=win32 wine wineboot"
su - user -c "XAUTHORITY=/var/run/lightdm/'$user1'/xauthority WINEPREFIX=/home/'$user1'/.wine.fss winetricks dotnet40"

select1=$(find /home/*/Загрузки/fss_e*.exe)
echo -en "$color2b Указываем какую программу необходимо установить (выбрав цифру)  $color2e"
select prog in ${select1}
do	
	break
done

su - user -c "XAUTHORITY=/var/run/lightdm/'$user1'/xauthority WINEPREFIX=/home/'$user1'/.wine.fss wine '$prog'"
mv /home/$user1/Рабочий\ стол/СФР\ АРМ\ ЛПУ.desktop /tmp/

check3=$(ls 2>/dev/null /home/${user1}/.wine.fss/drive_c/FssTools| wc -c)
check4=$(ls 2>/dev/null /home/${user1}/.wine.fss/drive_c/FssArmErs| wc -c)

if [ ${check3} -ne 0 ]; then
cd /home/${user1}/.wine.fss/drive_c/FssTools/
su - ${user1} -c "cd /home/'$user1'/.wine.fss/drive_c/FssTools && WINEPREFIX=~/.wine.fss wine C:/Windows/Microsoft.NET/Framework/v4.0.30319/RegAsm.exe /registered GostCryptography.dll"
fi

#ставить ли?
#WINEPREFIX=~/.wine.fss wineserver -k


if [ ${check4} -ne 0 ]; then
cd /home/${user1}/.wine.fss/drive_c/FssArmErs
su - ${user1} -c "cd /home/'$user1'/.wine.fss/drive_c/FssArmErs && WINEPREFIX=~/.wine.fss wine C:/Windows/Microsoft.NET/Framework/v4.0.30319/RegAsm.exe /registered GostCryptography.dll"
fi

echo 
echo "ФСС Установлено!"
echo -e $final1




