#!/bin/bash

cd /tmp/
wget -nv --no-cache http://10.11.128.115/.pcstuff/test/pantum-1.1.96-alt2.x86_64.rpm
env -i apt-get install -y ./pantum-1.1.96-alt2.x86_64.rpm

printer=$(lpinfo -v | grep -i "direct usb"| grep -i pantum)
if [ -n "$printer" ]; then
    printer_usb=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | cut -d '/' -f1)
    printer_model=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | sed -n "s/.*\///p" | cut -d '%' -f1)
    printer_name=$printer_usb'_'$printer_model
fi

printer_ppd=$(lpinfo -m | grep $printer_model | cut -d " " -f1 | head -n 1)
printer_v=$(lpinfo -v | grep -i pantum | sed -n "s/direct//p" | cut -d "?" -f1)
lpadmin -p $printer_name -m $printer_ppd -v $printer_v -E
lpadmin -p $printer_name

echo "Принтер srantum установлен!"