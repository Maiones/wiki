#!/bin/bash

#*/5 * * * * [ ! -e /tmp/zastava_ike_restart ] && /usr/bin/zastava_ike_restart.sh
user1=$(who | grep '(:0)' | cut -d " " -f1)
dir2=/usr/bin/zastava_ike_restart.sh

touch $dir2
chmod +x $dir2

cat << '_EOF_' > $dir2
#!/bin/bash/
systemctl stop vpnclient
ike-scan -v -2 10.224.85.130 #Для ГИСа
ike-scan -v -2 10.8.63.70 #Для ТИСа
sleep 5
systemctl start vpnclient
user1=$(who | grep '(:0)' | cut -d " " -f1)
su - "$user1" -c "cd ~; rm -rf .wine/drive_c/Vitacore/AIS\ LPU\ Client/*/Temp/*"
touch /tmp/zastava_ike_restart
_EOF_

mtu_test=$(sysctl -a | grep 'net.ipv4.tcp_mtu_probing' | cut -d " " -f 3)

if [ $mtu_test -eq 1 ]; then
	sysctl net.ipv4.tcp_mtu_probing=1
fi

(crontab -l ; echo "*/5 * * * * [ ! -e /tmp/zastava_ike_restart ] && /usr/bin/zastava_ike_restart.sh") | crontab -

chmod +x $dir2
/bin/bash $dir2

#ip_sert=$(ip a | grep  'inet 10.*' | awk '{print$7}')
#echo -e "address aa:bb:cc:dd:ee:ff\nmtu 1410" > /etc/net/ifaces/$ip_sert/iplink
#systemctl restart network

exit 0



