#!/bin/bash

# Проверяем связь до пула адресов с выводом в файл результата проверки.

hosts_base=/tmp/hosts_base

HOSTS="
10.11.11.111
10.13.13.111
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
	fi

	done

fi


