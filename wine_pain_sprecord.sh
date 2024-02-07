#!/bin/bash


#rpm -qp --scripts /tmp/sprecord-1.2.0.151-alt1.repacked.with.epm.2.x86_64.rpm
rpm -Uvh /tmp/sprecord/sprecord-1.2.0.151-alt1.repacked.with.epm.2.x86_64.rpm
chmod 777 /var/log/sprecord /var/cache/sprecord -R

cat << '_EOF_' > /usr/bin/sprecord-autostart.sh
#!/bin/sh

while true;do
        /usr/bin/sprecord
        sleep 1
done
_EOF_

chmod +x /usr/bin/sprecord-autostart.sh
mkdir -p /var/lib/sprecord/records/$(date +"%Y_%m")
