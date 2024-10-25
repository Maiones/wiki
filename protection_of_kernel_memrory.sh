#!/bin/bash

if [ $(whoami) = root ] ; then 
	echo 
	else 
	echo -en "$color1b Нужно открыть скрипт рутом! Установка прервана. $color1e"
	exit 1
fi

# Alt linux/Astra linux
# ФСТЭК «Рекомендации по обеспечению безопасной настройки операционных систем Linux» от 25 декабря 2022

# alt/astra +
random=$(/sbin/sysctl -a | grep kernel.randomize_va_space | awk '{print$3}')

if [[ $random != 2 ]]; then
	printf "Рандомизация адресного пространства имеет не безопасное значение kernel.randomize_va_space= ${random}\n"
else
	printf "+ Рандомизация адресного пространства в порядке.\n"
fi		

# alt/astra +
symbol=$(/sbin/sysctl -a | grep fs.protected_symlinks | awk '{print$3}')

if [[ $symbol != 1 ]]; then
	printf "Не безопасные варианты прохода по символическим ссылкам - не безопасное значение fs.protected_symlinks= $symbol\n"
else
	printf "+ Ограничены не безопасные варианты прохода по символическим ссылкам.\n"
fi

# alt/astra -
# устанавливает полный запрет трассировки ptrace; 2 оставляет трасировку для рута.
cptrace=$(/sbin/sysctl -a | grep kernel.yama.ptrace_scope | awk '{print$3}')

if [[ $cptrace != 3 ]]; then
	printf "Подключение к другим процессам с помощью ptrace не настроено kernel.yama.ptrace_scope= $cptrace\n"
	printf "Настроить(2)? yes/no: \n"
	read inputval
	if [[ $inputval == yes ]]; then
		/sbin/sysctl -w kernel.yama.ptrace_scope=2
		echo 'kernel.yama.ptrace_scope = 2' >> /etc/sysctl.conf
		# grub
		if grep -q /etc/default/grub | grep GRUB_CMDLINE_LINUX_DEFAULT | grep lsm=yama; then
			sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/ s/'$/ lsm=yama'/" /etc/default/grub
		fi
	fi
else
	printf "+ Подключение к другим процессам с помощью ptrace настроено.\n"
fi

# alt/astra +
h_symbol=$(/sbin/sysctl -a | grep  fs.protected_hardlinks | awk '{print$3}')

if [[ $h_symbol != 1 ]]; then
	printf "Не безопасные варианты прохода по символическим ссылкам - не безопасное значение fs.protected_hardlinks= $h_symbol\n"
else
	printf "+ Ограничины небезопасные варианты работы с жёсткими ссылками.\n"
fi

# alt/astra -
# Помогает снизить влияние ошибок, связанных с обращением к нулевым указателям ядра.
m_virtual=$(/sbin/sysctl -a | grep  vm.mmap_min_addr | awk '{print$3}')

if [[ $m_virtual != 4096 ]]; then
	printf "Минимальный виртуальный адрес, который разрешено использовать для mmap, имеет не безопасное значение vm.mmap_min_addr= $m_virtual\n"
	printf "Настроить(4096)? yes/no: \n"
	read inputval_m
	if [[ $inputval_m == yes ]]; then
		/sbin/sysctl -w vm.mmap_min_addr=4096
		echo 'vm.mmap_min_addr = 4096' >> /etc/sysctl.conf
	fi
else
	printf "+ Минимальный виртуальный адрес используемый nmap имеет безопасное значение.\n"
fi

# alt/astra +
kexec=$(/sbin/sysctl -a | grep kernel.kexec_load_disabled | awk '{print$3}')

if [[ $kexec != 0 ]]; then
	printf "Cистемный вызов kexec_load не отключен kexec_load_disabled= $kexec\n"
else
	printf "+ Cистемный вызов kexec_load не отключен.\n"
fi

# alt/astra +
# функционал ядра, позволяющий выполнять виртуализацию этого атрибута для каждого процесса.
namespaces=$(/sbin/sysctl -a | grep user.max_user_namespaces | awk '{print$3}')

if [[ $namespaces != 0 ]]; then
	printf "Использование user namespaces не ограничено user.max_user_namespaces= $namespaces\n"
	printf "Настроить? yes/no: \n"
	read inputval_nm
	if [[ $inputval_nm == yes ]]; then
		/sbin/sysctl -w user.max_user_namespaces=0
		echo 'user.max_user_namespaces = 0' >> /etc/sysctl.conf
	fi		
else
	printf "+ Использование user namespaces ограничено.\n"
fi

# alt/astra +
jkernel=$(/sbin/sysctl -a | grep  kernel.dmesg_restrict | awk '{print$3}')

if [[ $jkernel != 1 ]]; then
	printf "Доступ к журналу ядра не ограничен kernel.dmesg_restrict=' $jkernel\n"
else
	printf "+ Доступ к журналу ядра ограничен.\n"
fi

# alt/astra -
# просматривать адресацию функций может только root = 1; никто не может просматривать = 2.
bkallsyms=$(/sbin/sysctl -a | grep  kernel.kptr_restrict | awk '{print$3}')

if [[ $bkallsyms != 2 ]]; then
	printf "Блокирование утечки информации об адресном пространстве не настроено kernel.kptr_restrict= $bkallsyms\n"
	printf "Настроить(только root=1)? yes/no: \n"
	read inputval_bk
	if [[ $inputval_bk == yes ]]; then
		/sbin/sysctl -w kernel.kptr_restrict=1
		echo 'kernel.kptr_restrict = 1' >> /etc/sysctl.conf
	fi	
else
	printf "+ Блокирована утечка информации об адресном пространстве.\n"
fi

# alt/astra -
# Включить защиту от непреднамеренной записи в FIFO-объект.
pfifos=$(/sbin/sysctl -a | grep fs.protected_fifos | awk '{print$3}')

if [[ $pfifos != 2 ]]; then
	printf "Защита от непреднамеренной записи в FIFO-объект не настроена fs.protected_fifos= $pfifos\n"
	printf "Настроить? yes/no: \n"
	read inputval_pf
	if [[ $inputval_pf == yes ]]; then
		/sbin/sysctl -w fs.protected_fifos=2
		echo 'fs.protected_fifos = 2' >> /etc/sysctl.conf
	fi	
else
	printf "+ Защита от непреднамеренной записи в FIFO-объект включена.\n"
fi

# alt/astra -
# Включить защиту от непреднамеренной записи в файл.
pregular=$(/sbin/sysctl -a | grep fs.protected_regular | awk '{print$3}')
if [[ $pregular != 2 ]]; then
	printf "Защита от непреднамеренной записи в файл не настроена fs.protected_regular= $pregular\n"
	printf "Настроить? yes/no: \n"
	read inputval_pr
	if [[ $inputval_pr == yes ]]; then
		/sbin/sysctl -w fs.protected_regular=2
		echo 'fs.protected_regular = 2' >> /etc/sysctl.conf
	fi		
else
	printf "+ Защита от непреднамеренной записи в файл включена.\n"
fi

# alt/astra -
# Запретить создание core dump для исполняемых файлов с флагом suid.
rkptr=$(/sbin/sysctl -a | grep fs.suid_dumpable | awk '{print$3}')
if [[ $rkptr != 1 ]]; then
	printf "Создание core dump для исполняемых файлов с флагом suid не настроено fs.suid_dumpable= $rkptr\n"
	printf "Настроить(только root)? yes/no: \n"
	read inputval_rkp
	if [[ $inputval_rkp == yes ]]; then
		/sbin/sysctl -w fs.suid_dumpable=1
		echo 'fs.suid_dumpable = 1' >> /etc/sysctl.conf
	fi		
else
	printf "+ Создание core dump для исполняемых файлов с флагом suid запрещено.\n"
fi
