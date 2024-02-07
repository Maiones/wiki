#!/bin/bash

# Устанавить разделитель строк в качестве IFS (важно для цикла)
IFS=$'\n'
lpstat_check=$(lpstat -v | grep 631)

cp /etc/cups/printers.conf /tmp/

for printer_q in $lpstat_check; do
    printer_name=$(echo "$printer_q" | awk '{print $3}' | sed 's/:$//')
    printer_address=$(echo "$printer_q" | awk '{print $4}')
    printer_change=$(echo "$printer_address" | sed 's/ipp/http/g')

    if lpadmin -x "$printer_name"; then
        echo "Принтер $printer_name успешно удален."
    else
        echo "Ошибка при удалении принтера $printer_name."
    fi

    if lpadmin -p "$printer_name" -v "$printer_change" -m driverless:"$printer_change" -E -o PageSize=A4; then
        echo "Принтер $printer_name успешно пересоздан $printer_change."
    else
        echo "Ошибка при создании принтера $printer_name."
    fi
done
