#!/bin/bash


cd /tmp/
env -i apt-get install -y http://10.11.128.115/.pcstuff/zastava/ZASTAVAclient-9.0.23667-fsb-5.18.14-un-def-alt1-x86_64.rpm
rm /tmp/ZASTAVAclient-9.0.23667-fsb-5.18.14-un-def-alt1-x86_64.rpm

/opt/ZASTAVAclient/bin/vpnconfig -a lsp system pmp 0/0 DN medvpn2.tatarstan.ru 1
/opt/ZASTAVAclient/bin/vpnconfig -s ike 1 2
/opt/ZASTAVAclient/bin/plg_ctl -i /opt/ZASTAVAclient/etc/cp_plg_cpro.cfg
/opt/ZASTAVAclient/bin/plg_ctl -d cp_plg_gost
systemctl restart vpnclient.service
