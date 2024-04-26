#!/bin/bash

konsole -e "bash -c 'echo \"ВНИМАНИЕ! Производится обновление пк\"; sleep 15; env -i salt-call state.apply; exec bash'"
#if Failed:      0 then Все обновления успешно применены!
#поставить в автозапуск  с последующим удалением скрипта.\

Скрипт для установки .pki для юзера совершившего вход, с последующим удалением скрипта:
#!/bin/sh
currentscript="$0"
pkill chromium-gost
cp -r /media/sert_2/.pki  /home/$(logname)
chown $(logname):$(logname) -R  /home/$(logname)/.pki
chmod +rw+r++r++ -R /home/$(logname)/.pki
rm /home/media/sert_2
rm -rf /etc/profile.d/pki_reboot.sh
________________________________________________________
#!/bin/sh
chmod +x /etc/profile.d/pki_reboot.sh
________________________________________________________
s1="10.14.198."
for i in $(seq 83 83); do
scp -o "StrictHostKeyChecking=no" -i /home/user/medkey.txt -r "/tmp/pki_reboot.sh" root@$s1$i:"/etc/profile.d/"
ssh -i /home/user/medkey.txt root@$s1$i 'bash -s' < /tmp/pki.sh
scp -o "StrictHostKeyChecking=no" -i /home/user/medkey.txt -r "/tmp/sert_2" root@$s1$i:"/media"
done
