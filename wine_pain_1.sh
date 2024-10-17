#!/bin/bash
LANG=C


export pluscolor=$(tput setab 8)
export nocolor=$(tput sgr 0)

while true; do
	echo -n "IP мед пк: "
	read inputval
	if [ -z "$inputval" ];then
		echo "Введите IP!"
	else
		break
	fi
done
	
echo -n "Порт мед пк: "
read inputval2

# Если введена пустая строка, устанавливаем значение по умолчанию 22
if [ -z "$inputval2" ]; then
    inputval2=22
fi

tis_gz=tis-service3.tar.gz

read -p "$pluscolor Удалить префикс wine и починить все что можно 'pupa'
Удалить пакет wine 'lupa'
wine no word 'noword'
Обновление wine до 9.0.15 'winep'
Тис-Гис запуск (1300) 'mtu'
Тис переустановка 'ttis'
Ядро 5.18.14 'oreh'
Canon_lbp 'conon'
Пантум v4 'srantum'
Принтер из ТИСа 'ptis'
Установить lpu 'lpu'
Установка Expert 'exp'
Обновить заставу на лин пк до 9 'podstava'
Обновить заставу на лин пк до 9 (без TCP FOrce) 'podstava2'
Смена плагина на ГОСТ 'podstava3'
Добавляем смену пароля (6 мес.) 'slick_1'
Wine 4.9 не пашет word 'woo':"$nocolor decision1


case "$decision1" in
	"pupa")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_gis_bottle.sh
		;;
	"lupa")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_gis_rpm.sh
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
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_tis.sh
		;;		
	"ptis")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_web_print.sh
		;;
	"conon")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/canon_lbp.sh
		;;
	"srantum")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_pantum.sh
		;;
	"srantum2")
		scp -P $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey -r /home/user/kva-kva/printers/SRANTUM/tk_pantum_1.1.84x32_P2510/ root@$inputval:/tmp/
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_pantum2.sh
		;;
	"woo")
		scp -P $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey -r /home/user/kva-kva/med_linux/word/Star_wine.tar.gz root@$inputval:/tmp/
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_5.sh
		;;
	"sprecord")
		scp -P $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey -r /home/user/kva-kva/sprecord/sprecord-1.2.0.151-alt1.repacked.with.epm.2.x86_64.rpm root@$inputval:/tmp/
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_sprecord.sh
		;;
	"exp")
		scp -P $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey /home/user/kva-kva/med_linux/Expert.tar.gz root@$inputval:/tmp/
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_expert.sh
		;;
	"lpu")
		scp -P $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey -r /home/user/kva-kva/med_linux/lpu/ root@$inputval:/tmp/
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/lpu_pain.sh
		;;
	"podstava3")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_zastava_linux11.sh
		;;		
	"podstava2")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_zastava_linux10.sh
		;;
	"podstava")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_zastava_linux9.sh
		;;
	"slick_1")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_slick-g1.sh
		;;		
	"winep")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_wine_9.0.15.sh
		;;		
	"noword")
		ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey root@$inputval 'bash -s' < /home/user/kva-kva/scripts/wine_pain_gis_no_word.sh
		;;		
	*)
		 echo "Некорректный ввод"
		 ;;
esac

