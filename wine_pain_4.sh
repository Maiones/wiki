#!/bin/bash

cd /tmp/ 
wget -nv --no-cache http://10.11.128.115/.pcstuff/kernel/un-def-5.18.14-c8/x86_64/kernel-image-un-def-5.18.14-alt1.x86_64.rpm 
wget -nv --no-cache http://10.11.128.115/.pcstuff/kernel/un-def-5.18.14-c8/x86_64/kernel-modules-drm-ancient-un-def-5.18.14-alt1.x86_64.rpm 
wget -nv --no-cache http://10.11.128.115/.pcstuff/kernel/un-def-5.18.14-c8/x86_64/kernel-modules-drm-nouveau-un-def-5.18.14-alt1.x86_64.rpm 
wget -nv --no-cache http://10.11.128.115/.pcstuff/kernel/un-def-5.18.14-c8/x86_64/kernel-modules-drm-un-def-5.18.14-alt1.x86_64.rpm 
wget -nv --no-cache http://10.11.128.115/.pcstuff/kernel/un-def-5.18.14-c8/x86_64/kernel-modules-virtualbox-un-def-6.1.36-alt1.332302.1.x86_64.rpm 
wget -nv --no-cache http://10.11.128.115/.pcstuff/kernel/un-def-5.18.14-c8/vbox/virtualbox-6.1.36-alt0.M80C.1.x86_64.rpm 
wget -nv --no-cache http://10.11.128.115/.pcstuff/kernel/un-def-5.18.14-c8/vbox/virtualbox-common-6.1.36-alt0.M80C.1.x86_64.rpm 
wget -nv --no-cache http://10.11.128.115/.pcstuff/kernel/un-def-5.18.14-c8/8821cu.ko_5.18.14_c8.tar.gz 
mkdir -p /lib/modules/5.18.14-un-def-alt1/updates/ && cd /lib/modules/5.18.14-un-def-alt1/updates/ && tar xf /tmp/8821cu.ko_5.18.14_c8.tar.gz 
cd /tmp/ 
LANG=ru_RU.UTF-8 LC_ALL=ru_RU.UTF-8 apt-get -y install /boot/vmlinuz-5.18.14-un-def-alt1- ./kernel-*5.18.14*.rpm ./kernel-modules-virtualbox-un-def-6.1.36* && grub-set-default 'ALT 8 SP Workstation, 5.18.14-un-def-alt1' 
apt-get -y install ./virtualbox-*6.1.36*.rpm 
apt-get -y remove virtualbox-guest-utils- virtualbox-guest-additions- $(rpm -qa --qf='[%{name}\n]'| grep ZASTAVAclient)
systemctl enable virtualbox 
rm -f ./kernel-*un-def*.rpm ./*virtualbox-*6.1.36*.rpm ./8821cu.ko_5.18.14_c8.tar.gz

wget -nv --no-cache http://10.11.128.115/.pcstuff/zastava/rootca-gost2012.cer
wget -nv --no-cache http://10.11.128.115/.pcstuff/kernel/un-def-5.18.14-c8/x86_64/ZASTAVAclient-6.80.23213-fsb-5.18.14-un-def-alt1-x86_64.rpm && apt-get -y install ./ZASTAVAclient-6.80.23213-fsb-5.18.14-un-def-alt1-x86_64.rpm; rm -f ./ZASTAVAclient-6.80.23213-fsb-5.18.14-un-def-alt1-x86_64.rpm

