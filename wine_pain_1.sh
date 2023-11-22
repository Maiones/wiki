#!/bin/bash
LANG=C

export pluscolor=$(tput setab 8)
export nocolor=$(tput sgr 0)

echo -n "IP мед пк: "
read inputval

echo -n "Порт мед пк: "
read inputval2

# Если введена пустая строка, устанавливаем значение по умолчанию 22
if [ -z "$inputval2" ]; then
    inputval2=22
fi

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
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_2.sh
		;;
	"lupa")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_3.sh
		;;
	"pain")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_update.sh
		;;
	"oreh")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_4.sh
		;;
   "mtu")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_7.sh
		;;
   "ttis")
		scp -P $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey -r /home/user/kva-kva/med_linux/tis/$tis_gz root@$inputval:/tmp/
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_9.sh
		;;		
	"ptis")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_8.sh
		;;
	"conon")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/canon_lbp.sh
		;;
	"woo")
		scp -P $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey -r /home/user/kva-kva/med_linux/word/Star_wine.tar.gz root@$inputval:/tmp/
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_5.sh
		;;
	"sprecord")
		scp -P $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey -r /home/user/kva-kva/sprecord/sprecord-1.2.0.151-alt1.repacked.with.epm.2.x86_64.rpm root@$inputval:/tmp/
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_sprecord.sh
		;;
	*)
		 echo "Некорректный ввод"
		 ;;
esac

