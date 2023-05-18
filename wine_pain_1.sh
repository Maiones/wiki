#!/bin/bash
LANG=C

echo -n "IP мед пк: "
read inputval

echo -n "Удалить префикс wine и починить все что можно 'pupa'; удалить пакет wine 'lupa': "
read inputval1

if test "$inputval1" == "pupa"
then
	ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_2.sh
fi

if test "$inputval1" == "lupa"
then
	ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_3.sh
fi

#if test "$inputval1" == "zavod"
#then
#	scp -o "StrictHostKeyChecking=no" -i /home/user/medkey /home/user/kva-kva/med_linux/offce_good.tar.gz	root@$inputval:/tmp/
#	scp -o "StrictHostKeyChecking=no" -i /home/user/medkey /home/user/kva-kva/med_linux/Star_wine.tar.gz	root@$inputval:/tmp/
#	ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_4.sh
#fi


