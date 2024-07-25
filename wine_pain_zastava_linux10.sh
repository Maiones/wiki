#!/bin/bash

version=$(rpm -q --qf='[%{version}\n]' ZASTAVAclient)
cert=$(/opt/ZASTAVAclient/bin/vpnconfig -l cert | grep 'CN=pc' -B2 | awk '/Id: / {print $2}')

if [ $version == '9.0.23667' ]; then
	echo "Новая застава клиент 9.0.23667 уже установлена!" 
	exit 0
else
	cd /tmp/
	env -i apt-get install -y http://10.11.128.115/.pcstuff/zastava/ZASTAVAclient-9.0.23667-fsb-5.18.14-un-def-alt1-x86_64.rpm
	rm /tmp/ZASTAVAclient-9.0.23667-fsb-5.18.14-un-def-alt1-x86_64.rpm
	/opt/ZASTAVAclient/bin/vpnconfig -a lsp system pmp "$cert" DN zastmgmt.medtatar 1
	/opt/ZASTAVAclient/bin/plg_ctl -i /opt/ZASTAVAclient/etc/cp_plg_gost.cfg
	/opt/ZASTAVAclient/bin/plg_ctl -d cp_plg_cpro
	/opt/ZASTAVAclient/bin/vpnmonitor -p
fi

