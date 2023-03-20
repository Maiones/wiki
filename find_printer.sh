#!/bin/bash

printer=$(lpinfo -v | grep -i "direct usb")
printer=$(lpinfo -v | grep -i "direct usb")
if [ -n "$printer" ]; then
    printer_usb=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | cut -d '/' -f1)
    printer_model=$(echo $printer | sed -n "s/^.*usb:\/\/\([^?]*\).*$/\1/p" | sed -n "s/.*\///p" | cut -d '%' -f1)
    printer_name=$printer_usb'_'$printer_model
fi

exit 0