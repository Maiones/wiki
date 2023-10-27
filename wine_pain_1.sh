#!/bin/bash
LANG=C

export pluscolor=$(tput setab 8)
export nocolor=$(tput sgr 0)

echo -n "IP мед пк: "
read inputval

tis_gz=tis-service3.tar.gz

read -p $pluscolor"Удалить префикс wine и починить все что можно 'pupa'
Удалить пакет wine 'lupa'
Тис-Гис запуск (1300) 'mtu'
Тис переустановка 'ttis'
Ядро 5.18.14 'oreh'
Canon_lbp 'conon'
Принтер из ТИСа 'ptis'
#добавить тис переустановку
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
   "ttis")
		scp -o "StrictHostKeyChecking=no" -i /home/user/medkey -r /home/user/kva-kva/med_linux/tis/$tis_gz root@$inputval:/tmp/
		ssh -o "StrictHostKeyChecking=no" -i /home/user/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_9.sh
		;;		
	"ptis")
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

