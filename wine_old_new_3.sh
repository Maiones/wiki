#!/bin/bash


ip=$(ip a | grep "inet 10.14" | cut -d '/' -f1)

wine1=$(rpm -qa | grep -w 'wine-4.9.1-alt0.M80C.2')
wine2=$(wine --version | cut -d " " -f1)

if [ "$wine1" = "wine-4.9.1-alt0.M80C.2" ]; then 
	echo "good wine ${ip}"
else
	echo "${wine2} ${ip}"
fi	

exit 0
