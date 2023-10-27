#!/bin/bash

rpm -Uvh libftdi-0.19-1.i386.rpm --nodeps
rpm -Uvh sprecorddrv-1.0.0-2.i386.rpm --nodeps

/etc/init.d/sprexsrv stop
/etc/init.d/sprexsrv start