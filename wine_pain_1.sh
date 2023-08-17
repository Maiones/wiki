#!/bin/bash
LANG=C

echo -n "IP мед пк: "
read inputval

echo -n "Удалить префикс wine и починить все что можно 'pupa'; удалить пакет wine 'lupa'; ядро 5.18.14 'oreh'; wine 4.9 не пашет word 'woo': "
read inputval1

if test "$inputval1" == "pupa"
then
	ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_2.sh
fi

if test "$inputval1" == "lupa"
then
	ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_3.sh
fi

if test "$inputval1" == "oreh"
then
	ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_4.sh
fi

if test "$inputval1" == "woo"
then
   scp -o "StrictHostKeyChecking=no" -i /home/user/medkey -r /home/user/kva-kva/med_linux/word/Star_wine.tar.gz root@$inputval:/tmp/
	ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_5.sh
fi

