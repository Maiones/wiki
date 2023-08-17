#!/usr/bin/expect -f

#меняем пароль от VNC
expect -c '

set pass1 "admin"
set vnc1 "telenok"

spawn su -
expect "Password:"
send -- "$pass1\r"
expect "#"
send -- "x11vnc -storepasswd '$vnc1' /root/.vnc/passwd\r"
expect "#"
send -- "exit\r"
'

