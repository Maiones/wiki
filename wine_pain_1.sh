#!/bin/bash
LANG=C

echo -n "IP мед пк: "
read inputval

read -p "Удалить префикс wine и починить все что можно 'pupa'; удалить пакет wine 'lupa'; ядро 5.18.14 'oreh'; wine 4.9 не пашет word 'woo': " decision1 

case "$decision1" in
	"pupa")
		ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_2.sh
		;;
	"lupa")
		ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_3.sh
		;;
	"oreh")
		ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_4.sh
		;;
	"woo")
		scp -o "StrictHostKeyChecking=no" -i /home/user/medkey -r /home/user/kva-kva/med_linux/word/Star_wine.tar.gz root@$inputval:/tmp/
		ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_5.sh
		;;
	*)
		 echo "Некорректный ввод"
		 ;;
esac

