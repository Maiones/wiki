#!/bin/bash

error1=$(lpinfo -v | grep -i pantum| wc -c)
if [ ${error1} -eq 0 ]; then
  echo "Не найден подключенный принтер! Отмена"
  exit 0
fi

yes | cp -r /tmp/tk_pantum_1.1.84x32_P2510/* /

printer_del=$(lpstat -v | cut -d " " -f3 | sed 's/:$//') | grep -i pantum
for printer in "${printer_del[@]}"; do
	lpadmin -x "$printer"
done

printer=$(lpinfo -v | grep -i "direct usb"| grep -oh -i pantum)
printer_model_n=$(lpinfo -v | grep -i "direct usb"| grep -i pantum | cut -d "/" -f4 | cut -d "?" -f1)
printer_usb=$(lpinfo -v | grep -i pantum | cut -d " " -f2 | cut -d "?" -f1)
printre_name=$printer_$printer_model

#находит несколько ppd fix=yes?
printer_model=$(lpinfo -m | grep $printer_model_n | grep -i $printer | cut -d " " -f1 ) 

lpadmin -p $printre_name -v $printer_usb -m $printer_model -E
lpadmin -d $printre_name
