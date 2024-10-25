#!/bin/bash

# Сканирует диапазон ip удаляя каждый раз из списка адреса, до которых есть пинг
# Для выполнения bash скриптов на пк, которые ранее были не доступны

hosts_base=/tmp/hosts_base

HOSTS="
10.10.11.14
10.10.11.111
10.10.11.119
"

if ! test -f $hosts_base; then
	touch $hosts_base
	
	for i in $HOSTS
	do
		echo "$i status:---" >> "$hosts_base"
		ping -c 3 $i > /dev/null 2>&1

	if [ $? != 0 ]; then
		sed -i "/$i/s/---/DOWN/" $hosts_base
	else 
		sed -i "/$i/s/---/UP/" $hosts_base
		sed -i "/UP/d" $hosts_base
	fi
	done

else
	for i in $HOSTS
	do
		ping -c 3 $i > /dev/null 2>&1
	if [ $? != 0 ]; then
		sed -i "/$i/s/:.*/:DOWN/" $hosts_base
	else 
		sed -i "/$i/s/:.*/:UP/" $hosts_base
		sed -i "/UP:/d" $hosts_base
	fi

	done

fi


