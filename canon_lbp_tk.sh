#!/bin/bash


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

#Регистрация принтера в демоне ccpd
ccpdadmin -p $printer_name -o /dev/usb/lp0

cd /etc/init.d/
sed -i '11c\mkdir -p \/var\/captmon' ccpd
sed -i '12s/^/chmod 777 \/var\/captmon\n/' ccpd
#sed -i '3s/^/modprobe usblp\n/' ccpd

#Фиксируем/делаем запуск служб

chkconfig --add ccpd
chkconfig ccpd on
service ccpd start
service cups restart

lpadmin -d $printer_name

echo "Принтер canon lbp установлен!"