#!/bin/bash

package_name="название_пакета"  # RPM-пакета
target_directory="/tmp/пакет"   # целевая папка

if [ ! -d "$target_directory" ]; then
  mkdir -p "$target_directory"
fi

rpm -ql "$package_name" | while read -r file_path; do
  if [ -e "$file_path" ]; then

    target_path="$target_directory$(dirname "$file_path")"
    mkdir -p "$target_path"
    
    cp -a "$file_path" "$target_path"
  fi
done

echo "Содержимое пакета $package_name скопировано в $target_directory"
