#!/bin/sh#!/bin/bash

(sleep 40 && sh +x /root/check.sh) &
(sleep 80 && sh +x /root/check.sh) &
(sleep 120 && sh +x /root/check.sh) &

# cat /root/check.sh
#!/bin/sh
err=$(cat /etc/cups/printers.conf|grep 'Reason'|cut -d' ' -f2)
if (echo $err|grep '.$');
	then
sh +x /root/reinstprinter.sh;


[root@syr05ped1 ~]# cat /root/reinstprinter.sh
#!/bin/sh
foomatic-configure -s cups -n HP1020s5 -R -q && foomatic-configure -s cups -n HP1020s5 -N HP\ LaserJet\ 1020 -L syr05ped1 -c hp:/usb/HP_LaserJet_1020?serial=JL1KV66 -d foo2zjs-z1 -p HP-LaserJet_1020 -q && foomatic-configure -s cups -n HP1020s5 -D -q && /usr/sbin/lpadmin -p HP1020s5 -o printer-error-policy=abort-job && /usr/sbin/lpadmin -p HP1020s5 -o PageSize=A4


#!/bin/sh
#mkdir /media/upload/.transfile && smbclient -U transfile%q12345Q //10.14.198.190/transfile -c 'lcd /media/upload/.transfile/; prompt; recurse;  mget transfile.sh' && chmod +x /media/upload/.transfile/transfile.sh && (crontab -l ; echo "@reboot /bin/sh /media/upload/.transfile/transfile.sh") | crontab -[root@medpc-d2d79b pro30lab1]