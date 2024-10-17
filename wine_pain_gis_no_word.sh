#!/bin/bash
LANG=C

exec 2> /dev/null

user1=$(who | grep '(:0)' | cut -d " " -f1)
dir1=$(ls /home/$user1/.wine/drive_c/users/$user1/| wc -l)

if ! rpm -qa | grep wine64-cpcsp_proxy; then
	mkdir /tmp/wine_no_word && cd /tmp/wine_no_word
	env -i wget http://10.11.128.115/.pcstuff/test/wine64-cpcsp_proxy-0.6.0-alt3.x86_64.rpm
	env -i wget http://10.11.128.115/.pcstuff/test/wine_no_word.tar.gz
	env -i wget http://10.11.128.115/.pcstuff/test/regs.tar.gz
	apt-get install -y wine64-cpcsp_proxy-0.6.0-alt3.x86_64.rpm
	tar -xvf regs.tar.gz && mv opt/wine /opt/wine_no_word
fi

check_wsp=/home/$user1/.wine.special
result_message1=""

if [[  $(ls /home/$user1/.wine/drive_c) | wc -l > 5 ]]; then
  if [ -d $check_wsp ]; then
    i=1
    while [ -d $check_wsp$i ]; do
      i=$((i+1))
    done
    result_message1="n-копия чего-то там"
    su - "$user1" -c "wineserver -k; sleep 3; mv .wine .wine.special$i; cp -r /etc/skel/.wine ."
  else
    result_message1="1 копия чего-то там"
    su - "$user1" -c "wineserver -k; sleep 3; mv .wine .wine.special; cp -r /etc/skel/.wine ."
  fi
else
  result_message1="Приблуды не найдены"
  su - "$user1" -c "wineserver -k; sleep 3; rm -rf .wine.bak; mv .wine .wine.bak; tar -xvf /tmp/wine_no_word/wine_no_word.tar.gz"
fi

rm -rf /tmp/wine_no_word
echo "$result_message1"