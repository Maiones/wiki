#!/bin/bash

apt-get install -y icoutils
cd /tmp/
env -i apt-get install -y http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_9.0.15/wine-etersoft-9.0.15-eter0.M80P.1.x86_64.rpm
env -i apt-get install -y http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_9.0.15/wine-etersoft-gecko-2.47.4-eter0.M80P.1.noarch.rpm
env -i apt-get install -y http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_9.0.15/wine-etersoft-programs-9.0.15-eter0.M80P.1.x86_64.rpm
env -i apt-get install -y http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_9.0.15/wine-etersoft-winetricks-20240223-eter2.M80P.3.noarch.rpm
env -i apt-get install -y http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_9.0.15/wine-etersoft-network-9.0.6-eter0.M80P.1.x86_64.rpm
env -i apt-get install -y http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_9.0.15/wine-etersoft-common-9.0.15-eter0.M80P.1.noarch.rpm
env -i apt-get install -y http://10.11.128.115/.pcstuff/wine/wine_etersoft_repo_9.0.15/wine32-etersoft-9.0.15-eter0.M80P.1.i586.rpm

cp -v /usr/lib/wine-etersoft/i386-windows/coml2.dll /home/*/.wine/drive_c/windows/system32/
echo disable > /home/*/.wine/.update-timestamp
