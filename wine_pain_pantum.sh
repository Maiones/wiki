#!/bin/bash

rpm_pack=$(rpm -qa | grep pantum)
rpm_pack_good=pantum-1.1.99-alt4
if [ "$rpm_pack" != "$rpm_pack_good" ]; then
	cd /tmp/
	apt-get install -y http://10.11.128.115/.pcstuff/test/pantum-1.1.99-alt4.x86_64.rpm
fi


test_cups=$(lpinfo -v | grep 'Неправильный дескриптор файла')
if [ -n "$test_cups" ]; then
	systemctl restart cups
fi

# | sed -r 's|\%.||' объединить | sed -r 's|\?.+||'
printer_usb=$(lpinfo -v | grep -i "direct usb"| grep -i pantum | awk '{print$2}' | sed -r 's|\?.+||')
printer_name=$(lpinfo -v | grep -i "direct usb"| grep -i pantum | sed 's|.*//||' | sed 's|/|_|' | sed 's|[?%].*||')
printer_ppd=$(lpinfo -v | grep -i "direct usb"| grep -i pantum | sed 's|.*/||' | sed 's|.*//||'  | sed -r 's|\-.+||' | sed 's|[?%].*||')
printer_ppd2=$(lpinfo -m | grep -i pantum | grep $printer_ppd)

lpadmin -p $printer_name -m $printer_ppd2 -v $printer_usb -E
lpadmin -p $printer_name

echo "Принтер srantum установлен!"
