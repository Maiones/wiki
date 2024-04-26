#!/usr/bin/expect -f

expect -c '
set pass1 "admin"
set pass2 "resu"
set user1 "user"

spawn su -
expect "Password:"
send -- "$pass1\r"
expect "#"
send -- "passwd $user1\r"
expect "Enter new password:"
send -- "$pass2\r"
expect "Retype new password:"
send -- "$pass2\r"
expect "#"
send -- "exit\r"
'




