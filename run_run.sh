#!/bin/bash

if [ $(whoami) = root ] ; then 
	echo 
	else 
	echo "Need root"
	exit 1
fi

user1=$(who | grep '(:0)' | cut -d " " -f1)
SCRIPTS_DIR=$(dirname "$0")
cd $SCRIPTS_DIR

cp *.sh /usr/bin/
cp -r micord /etc/
cp wine.tar.gz /home/$user1
cp as_rmiac.desktop /home/$user1/Рабочий\ стол

cd /usr/bin/
chmod 755 wine_noproxy.sh run_vita.sh import_certs.sh

su - ${user1} -c "cd /home/'$user1'; tar -xvf wine.tar.gz"
rm -rf /home/$user1/wine.tar.gz

exit 0
