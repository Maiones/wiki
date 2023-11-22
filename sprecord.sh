#!/bin/bash

XUSER=$(who | grep '(:0)' | awk '{ print $1 }')

#kill $(pgrep "SpRecord.exe" < /dev/null)

if ! pgrep "SpRecord.exe" > /dev/null; then
        su - user -c "wineserver -k";
        /etc/init.d/sprexsrv stop;
        su - user -c "DISPLAY=:0 XAUTHORITY=/var/run/lightdm/'$XUSER'/xauthority /usr/bin/sprecord";
        /etc/init.d/sprexsrv start
fi

 /etc/init.d/sprexsrv stop
libfbclient.so.2.5.1" or "libgds.so" or "libfbembed.so.2.5"
