#!/bin/bash

x11vnc -storepasswd 'м0й+h0вый+пар0лb' /root/.vnc/passwd
systemctl restart x11vnc.service

exit 0


