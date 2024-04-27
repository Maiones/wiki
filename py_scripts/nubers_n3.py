import sys
import re
from collections import defaultdict

# Функция для подсчета адресов в каждой подсети
def count_ips(filename):
    ip_counts = defaultdict(int)
    
    # Регулярное выражение для извлечения префикса IP-адреса
    ip_pattern = re.compile(r"^\d+\.\d+\.")

    # Чтение подсетей из файла
    with open(filename, 'r') as file:
        subnets = file.readlines()

    # Проходим по каждой строке в списке подсетей
    for subnet_str in subnets:
        # Находим префикс IP-адреса
        match = ip_pattern.match(subnet_str)
        if match:
            ip_prefix = match.group()
            # Увеличиваем счетчик для найденного префикса
            ip_counts[ip_prefix] += 1
    
    return ip_counts

if __name__ == "__main__":
    # Проверяем, что передан ровно один аргумент (имя файла)
    if len(sys.argv) != 2:
        print("Usage: python script_name.py filename")
        sys.exit(1)

    filename = sys.argv[1]
    ip_counts = count_ips(filename)

    # Вывод результатов
    for subnet, count in ip_counts.items():
        print(f"{subnet}-{count}")
