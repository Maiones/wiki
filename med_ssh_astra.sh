#!/bin/bash
LANG=C

export pluscolor=$(tput setab 2)
export nocolor=$(tput sgr 0)

while true; do
	echo -n "$pluscolor IP мед пк: $nocolor"
	read inputval
	if [ -z "$inputval" ];then
		echo "$pluscolor Введите IP! $nocolor"
	else
		break
	fi
done
	
echo -n "$pluscolor Порт мед пк: $nocolor"
read inputval2

# Если введена пустая строка, устанавливаем значение по умолчанию 22
if [ -z "$inputval2" ]; then
    inputval2=22
fi

ssh -p $inputval2 -o "StrictHostKeyChecking=no" -i /home/user/key/medkey admin1@$inputval 
