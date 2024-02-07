#!/bin/bash
echo 'NEED FOR UPD'


user1=$(who | grep '(:0)' | cut -d " " -f1)
dir1=$(ls /home/$user1/.wine/drive_c/users/$user1/| wc -l)

su - ${user1} -c "mkdir /home/$user1/.wine/drive_c/users/$user1/Recent/"
su - ${user1} -c "mkdir -p /home/$user1/.wine/drive_c/users/$user1/AppData/Roaming/Microsoft/Windows/"
su - ${user1} -c "cd .wine/drive_c/users/$user1/AppData/Roaming/Microsoft/Windows/ && tar -xvf /tmp/Star_wine.tar.gz"

chown $user1:$user1 -R /home/$user1/.wine

exit 0



