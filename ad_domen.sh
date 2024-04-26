#/bin/bash

export pluscolor=$(tput setab 2)
export nocolor=$(tput sgr 0)

#hostname
my_hostname=$(hostname | cut -d "." -f1)

#ввести ip домена\ чек пинга?\ прерываем
read -p "Введите IP-адрес домена: " inputval
domen_ip=$inputval

#ввести рабочую группу домена
read -p "Введите рабочую группу домена: " inputval2
domen_work=$inputval2

#ввести имя домена
read -p "Имя домена: " inputval3
my_domen=$inputval3

#Добавляем в hosts\ добавить проверку если уже это есть
echo -e "$domen_ip\t$my_domen" | tee -a /etc/hosts
echo -e "127.0.0.1\t$my_hostname.$my_domen $my_hostname" | tee -a /etc/hosts
#Перезапускаем службу, чтобы hosts определился
systemctl restart network

#Меняем меню входа
sed -i 's/#greeter-show-manual-login=false/greeter-show-manual-login=true/g' /etc/lightdm/lightdm.conf
sed -i 's/#greeter-hide-users=false/greeter-hide-users=false/g' /etc/lightdm/lightdm.conf
sed -i 's/autologin-user=user/#autologin-user=user/g' /etc/lightdm/lightdm.conf
sed -i 's/autologin-user-timeout=0/#autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf

#Исправляем смену раскладки при авторизации:
mv /etc/X11/xinit/Xkbmap /etc/X11/xinit/Xkbmap.bak
sed -i 's/caps_toggle,grp:switch/alt_shift_toggle/g' /etc/X11/xorg.conf.d/95-input-keyboard.conf
sed -i 's/^#//g' /etc/X11/xorg.conf.d/95-input-keyboard.conf

#Отключаем авахи
systemctl disable --now avahi-daemon.service


#Файл-маркер чтобы обновы не трогали samba:
touch /root/donttouchsamba.txt

#Ставим самбу:
apt-get install -y samba alterator-auth sssd-ad samba-common-tools task-auth-ad-sssd
Активируем службу:
systemctl enable --now smb

#Ввод в домен:
echo $pluscolor"Пароль и учетная запись администратора домена: "$nocolor

#Логин
read -p "Введите логин админа домена: " inputval4
domen_admin=$inputval4

#пароль
read -p "Введите пароль админа домена: " inputval5
domen_pass=$inputval5

#/usr/sbin/system-auth write ad мой.домен имя_лин_пк рабочая_группа имя_пользователя пароль
/usr/sbin/system-auth write ad $my_domen $my_hostname $domen_work $domen_admin $domen_pass

#Добавляем роль всем пользователям для работы из сетевых папок в wps
roleadd users fuse

echo $pluscolor"Ввод в домен завершен. Нужен ребут!"$nocolor
