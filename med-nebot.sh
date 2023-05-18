#!/bin/bash

echo -n "С какого номера создаст сертификаты в Заставе: "
read inputval

echo -n "Какая по счету выгрузка: "
read inputval1

cd /home/user/medbot/new_certs/ && n=$inputval; for i in *;do 
echo $n=$i;n=$((n+1));
done > /home/user/medbot/list$inputval1.txt && unix2dos /home/user/medbot/list$inputval1.txt
cd ..
mv new_certs new_certs$inputval1
cp list$inputval1.txt create_user_v6.txt



