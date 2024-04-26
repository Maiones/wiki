#!/usr/bin/expect -f


#Отключить автологин
sed -i '/^[[:space:]]*autologin-user/ s/^/#/' /etc/lightdm/lightdm.conf

#добавить с разделителями, сделать столбцом
alluser1=$(ls /home/ "lost+found" "root")

n=0
pass=d@p_

for i in $alluser1; do 

if [ -d "/home/" ]; then

		
	new_pass="$pass$((n+1))"
	
	
#меняем пароль от учетки user
expect -c '

set pass1 admin
#Добавить в пароль ((n+1))
tt=$((n+1))
set pass2 d@p10_$tt
set user1 $alluser1

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

n=$((n+1))

  fi
done



