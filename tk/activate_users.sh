#!/bin/bash

HOSTS="
uslon_0
uslon_1
uslon_2
"

for ii in $HOSTS
do
        for i in $(seq 21 30);do
                ssh ts$i "chage -E -1 $ii"
        done
done
