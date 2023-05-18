#!/bin/bash

printer=$(lpinfo -v | grep -i "direct usb")
printer2=$(lpinfo -v | grep -i "direct usb" | cut -d ' ' -f2)

#вывести название принтера с пробелами
lpinfo -v | awk -F'://' '/usb/{print $2}' | cut -d "?" -f1 | sed 's/%20/ /g; s/\// /g'

#выводим инфу для поиска
printer3=$(lpinfo -v | awk -F'://' '/usb/{print $2}' | cut -d "?" -f1 | sed 's/%20/ /g; s/\// /g' | cut -d " " -f1)
printer4=$(lpinfo -v | awk -F'://' '/usb/{print $2}' | cut -d "?" -f1 | sed 's/%20/ /g; s/\// /g' | cut -d " " -f2)
printer5=$(lpinfo -v | awk -F'://' '/usb/{print $2}' | cut -d "?" -f1 | sed 's/%20/ /g; s/\// /g' | cut -d " " -f3)

/usr/sbin/lpinfo -m | grep -i $printer3 | grep -i $printer4 | grep -i $printer5


if [ -n "$printer" ]; then
    printer_usb=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | cut -d '/' -f1)
    printer_model=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | sed -n "s/.*\///p" | cut -d '%' -f1)
    printer_name=$printer_usb'_'$printer_model
fi



exit 0


/usr/sbin/lpadmin -p $printer_name -v $printer2 -m
 -E -o PageSize=A4
_________________________________________________________________
lpinfo -v | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | sed -n "s/.*\///p" | cut -d '%' -f1 
lpinfo -v | 

lpinfo -v | awk -F'://' '/usb/{print $2}' | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | cut -d '/' -f1
lpinfo -v | awk -F'://' '/usb/{print $2}' |  sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | sed -n "s/.*\///p" | cut -d '%' -f1

_________________________________________________________________



#!/bin/bash

# Получаем список всех принтеров
printers=$(lpinfo -v | awk -F ':' '{print $2}' | sed 's/ //g')

# Выводим список принтеров
echo "Доступные принтеры:"
echo "$printers"
echo ""

# Запрашиваем у пользователя выбор принтера
read -p "Выберите принтер: " printer

# Получаем название драйвера принтера
driver=$(lpinfo -m | grep "$printer" | awk '{print $1}')

# Запрашиваем у пользователя настройки принтера
read -p "Введите название принтера (например, HP LaserJet 1020): " printer_name
read -p "Введите описание принтера: " printer_description
read -p "Введите IP-адрес или название хоста принтера: " printer_ip

# Устанавливаем принтер с выбранными настройками
lpadmin -p "$printer" -E -v "socket://$printer_ip" -m "$driver" -D "$printer_description" -L "$printer_name"
