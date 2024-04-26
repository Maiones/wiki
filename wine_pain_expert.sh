#!/bin/bash

user1=$(who | grep '(:0)' | cut -d " " -f1)

su - "$user1" -c "cp -r /home/$user1/.wine /home/$user1/.wine.expert"
su - "$user1" -c "rm -rf /home/$user1/.wine.expert/drive_c/Vitacore/"
su - "$user1" -c "cd /home/$user1/.wine.expert/drive_c/ && tar -xf /tmp/Expert.tar.gz ."
su - "$user1" -c "cp /home/$user1/.wine.expert/drive_c/EXPERT/Expert.desktop /home/$user1/Рабочий стол/"

mv home/$user1/.wine.expert/drive_c/EXPERT/run_expert.sh /usr/bin/
chmod +x /usr/bin/run_expert.sh
rm -f /tmp/Expert.tar.gz

