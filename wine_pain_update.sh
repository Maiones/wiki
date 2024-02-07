#!/bin/bash

user1=$(who | grep '(:0)' | cut -d " " -f1)
ping_gis=$(ping -c 6 10.193.31.117)

su - "$user1" -c "wineserver -k"
su - "$user1" -c "rm -rf .wine/drive_c/Vitacore/AIS\ LPU\ Client/Update/Temp/*"

if $ping_gis %> /dev/null; then
    echo "ping UP"
else
    /opt/ZASTAVAclient/bin/vpnconfig -s ike 0 0
    sleep 5
    $ping_gis
fi


