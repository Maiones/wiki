#!/bin/bash

user1=$(who | grep '(:0)' | cut -d " " -f1)
name1="Расход_ЭТ.desktop"
path1=/home/$user1/Рабочий\ стол/
path2=$path1$name1


cat << '_EOF_' > "$path2"
[Desktop Entry]
Version=1.0
Type=Link
Name=Расход_ЭТ
Icon=development_debugger_section
URL=https://uzgkzn.onlyoffice.eu/Products/Files/DocEditor.aspx?fileid=7143635&doc=MW83bTk2UlVOanVtallscFY3TDFySG9kYWV4TEkzaE5tNmc0Tk8xOEFmaz0_IjcxNDM2MzUi0
_EOF_

chown $user1:$user1 "$path2"
chmod +x "$path2"

exit 0
