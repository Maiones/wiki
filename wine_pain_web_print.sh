#!/bin/bash

# Устанавить разделитель строк в качестве IFS (важно для цикла)
IFS=$'\n'
lpstat_check=$(lpstat -v | grep 631)

cp /etc/cups/printers.conf /tmp/

# Ошибка при пересоздании нескольких принтеров если один принтер не доступен!
for printer_q in $lpstat_check; do
    printer_name=$(echo "$printer_q" | awk '{print $3}' | sed 's/:$//')
    printer_address=$(echo "$printer_q" | awk '{print $4}')
    printer_change=$(echo "$printer_address" | sed 's/ipp/http/g')
    test_ping=$(lpstat -v | awk '{print $4}'| cut -d ':' -f2 | sed 's|//||')
	result=$(ping -c 1 -W  1 -q  $test_ping | grep transmitted)
	pattern="0 received"

if [[ "$result" =~ "$pattern" ]]; then
    echo "Нет связи с $test_ping, принтер не перенастроен."
else
    lpadmin -x "$printer_name"  
	if lpadmin -p "$printer_name" -v "$printer_change" -m driverless:"$printer_change" -E -o PageSize=A4; then
        echo "Принтер $printer_name успешно пересоздан $printer_change."
    else
        echo "Ошибка при создании принтера $printer_name."
    fi
fi
done
