#!/bin/bash

user1=$(who | grep '(:0)' | cut -d " " -f1)
user_net=$(ip a | grep  'inet 10.*' | awk '{print$7}')

systemctl stop vpnclient
ike-scan -v -2 10.224.85.130 #Для ГИСа
sleep 5
ike-scan -v -2 10.8.63.70 #Для ТИСа
sleep 5
systemctl start vpnclient

ip link set mtu 1300 dev $user_net
#echo -e "mtu 1300" > /etc/net/ifaces/$user_net/iplink
systemctl restart network
