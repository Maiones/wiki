#!/bin/bash
LANG=C

export pluscolor=$(tput setab 14)
export nocolor=$(tput sgr 0)

echo -n "IP мед пк: "
read inputval

read -p $pluscolor"Удалить префикс wine и починить все что можно 'pupa'
Тис-Гис запуск (1410) 'mtu'
Удалить пакет wine 'lupa'
Ядро 5.18.14 'oreh'
Canon_lbp (lin PC) 'conon'
Принтер из ТИСа 'tis'
Wine 4.9 не пашет word 'woo':"$nocolor decision1

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
   "mtu")
		ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_7.sh
		;;
	"tis")
		ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_8.sh
		;;
	"conon")
		ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/canon_lbp.sh
		;;
	"woo")
		scp -o "StrictHostKeyChecking=no" -i /home/user/medkey -r /home/user/kva-kva/med_linux/word/Star_wine.tar.gz root@$inputval:/tmp/
		ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_5.sh
		;;
	*)
		 echo "Некорректный ввод"
		 ;;
esac

