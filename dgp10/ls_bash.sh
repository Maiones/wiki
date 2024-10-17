#!/bin/bash

touch /tmp/kesl-gui-ls.txt

#IFS= это установка Internal Field Separator на пустое значение, чтобы избежать проблем с пробелами в путях
while IFS= read -r i; do
    ls -la "$i" >> /tmp/kesl-gui-ls.txt
done < /tmp/kesl-gui
