#!/bin/bash

SCRIPTS_DIR=$(dirname "$0")
mod1=$(ls /usr/share/cups/model | wc -c)
mod2=$(ls /usr/share/cups/model/Kyocera | wc -c)

if [ $(whoami) = root ] ; then 
	echo 
	else 
	echo "Нужно открыть скрипт рутом! Установка прервана"
	exit 1
fi

if [ ${mod1} -eq 0 ]; then
mkdir /usr/share/cups/model
fi

if [ ${mod2} -eq 0 ]; then
mkdir /usr/share/cups/model/Kyocera
fi

cd $SCRIPTS_DIR
cp Kyocera_FS-1040GDI.ppd /usr/share/cups/model/Kyocera/Kyocera_FS-1040GDI.ppd
cp Kyocera_FS-1020MFPGDI.ppd /usr/share/cups/model/Kyocera/Kyocera_FS-1020MFPGDI.ppd
cp Kyocera_FS-1025MFPGDI.ppd /usr/share/cups/model/Kyocera/Kyocera_FS-1025MFPGDI.ppd
cp Kyocera_FS-1120MFPGDI.ppd /usr/share/cups/model/Kyocera/Kyocera_FS-1120MFPGDI.ppd
cp Kyocera_FS-1125MFPGDI.ppd /usr/share/cups/model/Kyocera/Kyocera_FS-1125MFPGDI.ppd
cp Kyocera_FS-1060DNGDI.ppd /usr/share/cups/model/Kyocera/Kyocera_FS-1060DNGDI.ppd 
cp rastertokpsl /usr/lib/cups/filter/rastertokpsl
systemctl restart cups

echo "Installation completed"




