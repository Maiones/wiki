#!/bin/bash

#canon_4400 убрать из установки

#Проверяем есть ли пакеты для принтера в системе, устанавливаем, если нет.

cd /tmp/

if ! rpm -qa | grep -q cndrvcups-common; then
	env -i apt-get install -y http://10.11.128.115/.pcstuff/print/cndrvcups-common-3.40-1.x86_64.rpm
	rm -f cndrvcups-common-3.21-1.x86_64.rpm
fi

if ! rpm -qa | grep -q cndrvcups-capt; then
	env -i apt-get install -y http://10.11.128.115/.pcstuff/print/cndrvcups-capt-2.71-1.x86_64.rpm
	rm -f cndrvcups-capt-2.71-1.x86_64.rpm
fi

#Модуль ядра
modprobe usblp

echo "Проверка доступа к lp0"
if ls /dev/usb* | grep lp0 ; then 
	echo "lp0 проверка успешно"
else
	echo "Следует перезапустить принтер, устройство lp0 не найдено! Установка отменена :с"
	exit 1
fi

#Чистим старые конфиги, если есть:
ccpdad_del=$(ccpdadmin | grep /dev/usb/lp0 | cut -d ":" -f2)

if [ -d /var/ccpd/fifo0 ]; then
	for ccpd in {$ccpdad_del[@]}; do
		ccpdadmin -x $ccpd
	done
	rm -rf /var/ccpd
	chkconfig ccpd off
	service ccpd stop
fi

#Настройка спулинга печати
mkdir /var/ccpd
mkfifo /var/ccpd/fifo0
chmod -R 777 /var/ccpd

#Удаляем все установленные принтеры(иначе засрётся FIFO path):
printer_del=$(lpstat -v | grep ccp | awk '{print $3}' | sed 's/:$//')

for printer in "${printer_del[@]}"; do
	lpadmin -x "$printer"
done

#Удаляем принтеры из ccpdadmin
printer_del2=$(ccpdadmin | grep -i ccp |  awk '{print $3}' | sed -n '3p')

for printer in "${printer_del2[@]}"; do
	ccpdadmin -x "$printer"
done

printer1120=$(lpinfo -v | grep -i "direct usb" | grep -i "canon" | grep -o "LBP-1120")
if [ "$printer1120" == "LBP-1120" ]; then
	lpadmin -p LBP1120 -m CNCUPSLBP1120CAPTJ.ppd -v ccp:/var/ccpd/fifo0 -E
	ccpdadmin -p LBP1120 -o /dev/usb/lp0
	cd /tmp/
	wget -nv --no-cache http://10.11.128.115/.pcstuff/test/ccpd
	cp ccpd /etc/init.d/
	chmod +x /etc/init.d/ccpd
	chkconfig --add ccpd
	chkconfig ccpd on
	service ccpd restart
	service cups restart
	lpadmin -d LBP1120
	echo "Принтер canon lbp установлен!"
	exit 0
fi


#Продвинутый поиск принтера
printer=$(lpinfo -v | grep -i "direct usb"| grep -i canon | grep -i LBP)
if [ -n "$printer" ]; then
    printer_usb=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | cut -d '/' -f1)
    printer_model=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | sed -n "s/.*\///p" | cut -d '%' -f1)
    if [ $printer_model == 6018L ]; then
    	printer_model=LBP6000
    fi
    if [ $printer_model == LBP6030 ]; then
    	printer_model=LBP6000
    fi
    if [ $printer_model == LBP3050 ]; then
      printer_model=LBP3050
    fi
    if [ $printer_model == LBP-810 ]; then
      printer_model=LBP1120
    fi
    printer_name=$printer_usb'_'$printer_model
fi

#Продвинутый поиск драйвера для принтера
#CNCUPSLBP6018CAPTK.ppd
printer_ppd=$(lpinfo -m | grep $printer_model | cut -d " " -f1 | head -n 1)
if [ "$printer_model" == "6018L" ]; then
	lpadmin -p $printer_name -m CNCUPSLBP6018CAPTK.ppd -v ccp:/var/ccpd/fifo0 -E
fi

lpadmin -p $printer_name -m $printer_ppd -v ccp:/var/ccpd/fifo0 -E

#Регистрация принтера в демоне ccpd (на тк по умолчанию modprobe)
ccpdadmin -p $printer_name -o /dev/usb/lp0

#Включаем поддержку chkconfig
cd /tmp/
wget -nv --no-cache http://10.11.128.115/.pcstuff/test/ccpd
cp ccpd /etc/init.d/
chmod +rwxr+xr+x /etc/init.d/ccpd

# Добавляем порт для ccpd
port_check=$(cat /etc/ccpd.conf | grep 'PDATA_Port  59687')
if [ -z "$port_check" ]; then
	sed -i 's|UI_Port  59787|UI_Port  59787\nPDATA_Port  59687|' /etc/ccpd.conf
fi

#Фиксируем/делаем запуск служб
chkconfig --add ccpd
chkconfig ccpd on
service ccpd restart
service cups restart

lpadmin -d $printer_name

if ! grep -q 'ccpd_check.sh' /var/spool/cron/root; then
	printf '#!/bin/bash\nnetstat -tulnp | grep 59687 > /dev/null 2>&1 || systemctl restart cups && systemctl restart ccpd' > /root/ccpd_check.sh
	(crontab -l ; echo "*/4 * * * * /root/ccpd_check.sh") | crontab -
fi

echo "printer: $printer"
echo "printer usb:$printer_usb"
echo "printer model: $printer_model"
echo "printer ppd: $printer_ppd"
echo "Принтер canon lbp установлен!"
