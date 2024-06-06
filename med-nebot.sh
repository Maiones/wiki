#!/bin/bash

#mkdir /home/user/medbot/new_certs_vrca
#mv /home/user/medbot/new_certs/medvrca* /home/user/medbot/new_certs_vrca/

while true; do
	echo -n "С какого номера создаст сертификаты в Заставе: "
	read inputval
	if [[ "$inputval" =~ ^[0-9]+$ ]];then
		break
	else
		echo "Введите число!"
	fi
done

while true; do
	echo -n "Какая по счету выгрузка: "
	read inputval1
		if [[ "$inputval1" =~ ^[0-9]+$ ]];then
		break
	else
		echo "Введите число!"
	fi
done

cd /home/user/medbot/new_certs/ && n=$inputval; for i in *;do 
echo pc$n=$i;n=$((n+1));
done > /home/user/medbot/list$inputval1.txt && unix2dos /home/user/medbot/list$inputval1.txt
cd ..
mv new_certs new_certs$inputval1
cp list$inputval1.txt create_user_v6.txt



