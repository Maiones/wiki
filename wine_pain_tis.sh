#!/bin/bash

#потерял актуальность

tis_chek1=/opt/tis-service.bak
tis_chek2=/opt/tis-service
tis_gz=tis-service3.tar.gz

if [ -d $tis_chek2 ]; then
	i=1
	while [ -d $tis_chek1$i ]; do
		i=$((i+1))
	done
	mv /opt/tis-service /opt/tis-service.bak$i
else
	mv /opt/tis-service /opt/tis-service.bak
fi

systemctl stop tis-local.service
cd /opt/
tar -xf /tmp/$tis_gz
rm -rf /tmp/$tis_gz

if [ ! -f /opt/tis-service/install_check.txt ]; then
	cd /tmp/;
   wget -nv --no-cache http://10.11.128.115/.pcstuff/tis/update_tis.tar.gz;
   cp -r /opt/tis-service /opt/tis-service.bak;
   cd /opt/tis-service/;
   tar xf /tmp/update_tis.tar;
   sed -i 's/3.1.4/3.1.9/' /opt/tis-service/src/config.json;
	rm -rf /tmp/update_tis.tar
fi	
systemctl restart tis-local.service
