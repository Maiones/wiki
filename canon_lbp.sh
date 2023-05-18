#!/bin/bash

#проверка на суперпользователя

if [ $(whoami) = root ] ; then 
	echo 
	else 
	echo "Нужно открыть скрипт рутом! Установка прервана."
	exit 1
fi

############################Проверяем есть ли пакеты для принтера в системе, устанавливаем, если нет.
cd /tmp/lbp_auto
#if uname -r  


if rpm -qa | grep -q cndrvcups-capt cndrvcups-common ; then 
	echo 
else
	env -i apt-get install -y ./cndrvcups-common-3.21-1.x86_64.rpm ./cndrvcups-capt-2.71-1.x86_64.rpm
fi

#Настройка спулинга печати
mkdir /var/ccpd
mkfifo /var/ccpd/fifo0
chmod -R 777 /var/ccpd

#Продвинутый поиск принтера
printer=$(lpinfo -v | grep -i "direct usb")
if [ -n "$printer" ]; then
    printer_usb=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | cut -d '/' -f1)
    printer_model=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | sed -n "s/.*\///p" | cut -d '%' -f1)
    printer_name=$printer_usb'_'$printer_model
fi

#Продвинутый поиск драйвера для принтера
printer_ppd=$(lpinfo -m | grep $printer_model | cut -d " " -f1)
lpadmin -p $printer_name -m $printer_ppd -v ccp:/var/ccpd/fifo0 -E

#Модуль ядра
modprobe usblp

#проверка доступа к lp0
if ls /dev/usb* | grep lp0 ; then 
	echo "Продолжаем установку..."
else
	echo "Следует перезапустить принтер, устройство lp0 не найдено! Установка отменена :с"
	exit 1
fi

#Нужно удалить все подключенные принтеры?
#Регистрация принтера в демоне ccpd
ccpdadmin -p $printer_name -o /dev/usb/lp0

cd /etc/init.d/
sed -i '2s/^/# ccpd          Canon Printing for CUPS\n/' ccpd
sed -i '3s/^/# chkconfig:    2345 65 35\n/' ccpd
sed -i '4s/^/# description:  Canon Printing for CUPS\n/' ccpd
sed -i '5s/^/# processname:  ccpd\n/' ccpd
sed -i '6s/^/# config:       \/etc\/ccpd.conf\n/' ccpd
sed -i '7s/^/###             BEGIN INIT INFO\n/' ccpd
sed -i '8s/^/# Provides:     ccpd\n/' ccpd
sed -i '9s/^/# Required-Start: $local_fs $remote_fs $syslog $network $named\n/' ccpd
sed -i '10s/^/# Should-Start:  $ALL\n/' ccpd
sed -i '11s/^/# Required-Stop: $syslog $remote_fs\n/' ccpd
sed -i '12s/^/# Default-Start: 2 3 4 5\n/' ccpd
sed -i '13s/^/# Default-Stop:  0 1 6\n/' ccpd
sed -i '14s/^/# Description:   Start Canon Printer Daemon for CUPS\n/' ccpd
sed -i '15s/^/###              END INIT INFO\n/' ccpd
sed -i '16s/^/mkdir -p \/var\/captmon\n/' ccpd
sed -i '17s/^/chmod 777 \/var\/captmon\n/' ccpd
sed -i '18s/^/modprobe usblp\n/' ccpd

#Фиксируем/делаем запуск служб
chkconfig --add ccpd
chkconfig ccpd on
service ccpd start
service cups restart

lpadmin -d $printer_name

echo "Принтер canon lbp установлен!"