#!/bin/bash

user1=$(who | grep '(:0)' | cut -d " " -f1)

cp /tmp/lpu/run_lpu.sh /usr/bin/
chmod +x /usr/bin/run_lpu.sh

su - $user1 -c "cp /tmp/lpu/Lpu.desktop /home/$user1/Рабочий\ стол/"
su - $user1 -c "cd /home/$user1/.wine/drive_c && tar -xvf /tmp/lpu/lpu.tar.gz"