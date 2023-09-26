#!/bin/bash

#Проверяем есть ли пакеты для принтера в системе, устанавливаем, если нет.
if rpm -qa | grep -q cndrvcups-common; then 
	echo 
else
	cd /tmp/
	wget -nv --no-cache http://10.11.128.115/.pcstuff/print/canon_lbp_64/cndrvcups-common-3.21-1.x86_64.rpm
	env -i apt-get install -y ./cndrvcups-common-3.21-1.x86_64.rpm
fi

if rpm -qa | grep -q cndrvcups-capt; then 
	echo 
else
	cd /tmp/
	wget -nv --no-cache http://10.11.128.115/.pcstuff/print/canon_lbp_64/cndrvcups-capt-2.71-1.x86_64.rpm
	env -i apt-get install -y ./cndrvcups-capt-2.71-1.x86_64.rpm
fi

#Настройка спулинга печати
mkdir /var/ccpd
mkfifo /var/ccpd/fifo0
chmod -R 777 /var/ccpd

#Удаляем все установленные принтеры(иначе засрётся FIFO path):
printer_del=$(lpstat -v | cut -d " " -f3 | sed 's/:$//')
lpadmin -x $printer_del
for printer in "${printer_del[@]}"; do
	lpadmin -x "$printer"
done

#Продвинутый косячный поиск принтера
printer=$(lpinfo -v | grep -i "direct usb"| grep -i canon | grep -i LBP)
if [ -n "$printer" ]; then
    printer_usb=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | cut -d '/' -f1)
    printer_model=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | sed -n "s/.*\///p" | cut -d '%' -f1)
    if [ $printer_model == LBP6030 ]; then
    	printer_model=LBP6000
    fi
    printer_name=$printer_usb'_'$printer_model
fi

#Продвинутый поиск драйвера для принтера
printer_ppd=$(lpinfo -m | grep $printer_model | cut -d " " -f1 | head -n 1)
lpadmin -p $printer_name -m $printer_ppd -v ccp:/var/ccpd/fifo0 -E

#Модуль ядра #не отрабатывает?
modprobe usblp

echo "Проверка доступа к lp0"
if ls /dev/usb* | grep lp0 ; then 
	echo "lp0 проверка успешно"
else
	echo "Следует перезапустить принтер, устройство lp0 не найдено! Установка отменена :с"
	exit 1
fi

#Регистрация принтера в демоне ccpd (на тк по умолчанию modprobe)
ccpdadmin -p $printer_name -o /dev/usb/lp0

#Включаем поддержку chkconfig
cd /tmp/
wget -nv --no-cache http://10.11.128.115/.pcstuff/test/ccpd
cp ccpd /etc/init.d/
chmod +rwxr+xr+x /etc/init.d/ccpd

#Фиксируем/делаем запуск служб
chkconfig --add ccpd
chkconfig ccpd on
service ccpd restart
service cups restart

lpadmin -d $printer_name

echo "Принтер canon lbp установлен!"