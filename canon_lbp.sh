#!/bin/bash

LOGFILE=lbp_install.log
exec > >(tee -a $LOGFILE)
exec 2>&1

#проверка на суперпользователя
if [ $(whoami) = root ] ; then 
	echo 
	else 
	echo "Нужно открыть скрипт рутом! Установка прервана."
	exit 1
fi

#Проверяем есть ли пакеты для принтера в системе, устанавливаем, если нет.
if rpm -qa | grep -q cndrvcups-common; then 
	echo 
else
	cd /tmp/
	wget http://10.11.128.115/.pcstuff/print/canon_lbp_64/cndrvcups-common-3.21-1.x86_64.rpm
	env -i apt-get install -y ./cndrvcups-common-3.21-1.x86_64.rpm
fi

if rpm -qa | grep -q cndrvcups-capt; then 
	echo 
else
	cd /tmp/
	wget http://10.11.128.115/.pcstuff/print/canon_lbp_64/cndrvcups-capt-2.71-1.x86_64.rpm
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

#Продвинутый поиск принтера
printer=$(lpinfo -v | grep -i "direct usb"| grep -i canon | grep -i LBP)
if [ -n "$printer" ]; then
    printer_usb=$(echo $printer | cut -d "/" -f3)
    printer_model=$(echo $printer | cut -d "/" -f4)
    if [ $printer_model == LBP6030 ]; then
    	printer_model=LBP6000
    fi
    printer_name=$printer_usb'_'$printer_model
fi

#Продвинутый поиск драйвера для принтера
printer_ppd=$(lpinfo -m | grep $printer_model | cut -d " " -f1 | head -n 1)
lpadmin -p $printer_name -m $printer_ppd -v ccp:/var/ccpd/fifo0 -E

#Модуль ядра
modprobe usblp

echo "Проверка доступа к lp0"
if ls /dev/usb* | grep lp0 ; then 
	echo "Продолжаем установку..."
else
	echo "Следует перезапустить принтер, устройство lp0 не найдено! Установка отменена :с"
	exit 1
fi

#Регистрация принтера в демоне ccpd
ccpdadmin -p $printer_name -o /dev/usb/lp0

cd /etc/init.d/
if grep -q 'mkdir -p /var/captmon' ccpd &&
	grep -q 'chmod 777 /var/captmon' ccpd &&
	grep -q 'modprobe usblp' ccpd; then
	echo
else
	sed -i '1s/^/mkdir -p \/var\/captmon\n/' ccpd
	sed -i '2s/^/chmod 777 \/var\/captmon\n/' ccpd
	sed -i '3s/^/modprobe usblp\n/' ccpd	
fi

#Фиксируем/делаем запуск служб
chkconfig --add ccpd
chkconfig ccpd on
service ccpd restart
service cups restart

lpadmin -d $printer_name

echo "Принтер canon lbp установлен!"