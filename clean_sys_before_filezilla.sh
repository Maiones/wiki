#!/bin/bash

# For Astra linux
# Удалить строку с генерированным hostname из /etc/hosts
# Написать HOSTNAME=localhost.localdomain в /etc/sysconfig/network

apt clean
systemctl stop salt-minion
rm -rfv /etc/salt/pki/minion/*
> /etc/salt/minion_id

rm -rf /home/admin1/.config/chromium
rm -rf /home/user/.config/chromium

swapoff -a; rm -fv /swapfile
rm -rfv /var/opt/cprocsp/keys/pc*
rm -rfv /var/opt/cprocsp/keys/adm*
rm -rf /var/cache/salt/minion/files/base/files/*

> /root/.ssh/known_hosts
> /home/admin1/.ssh/known_hosts

systemctl enable salt-minion
dpkg --purge klnagent64

hostnamectl set-hostname aamedpc-000001

> /home/admin1/.bash_history
> /home/user/.bash_history
> /root/.bash_history

