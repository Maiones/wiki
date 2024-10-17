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

echo -n "$pluscolor Путь откуда: $nocolor"
read inputval3

echo -n "$pluscolor Путь куда: $nocolor"
read inputval4

# Если введена пустая строка, устанавливаем значение по умолчанию 22
if [ -z "$inputval2" ]; then
    inputval2=22
fi

if [ -z "$inputval4" ]; then
    inputval4=/tmp/
fi

scp -O -P $inputval2 -i /home/user/key/medkey -r $inputval3 admin1@$inputval:$inputval4
