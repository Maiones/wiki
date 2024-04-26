import re
from collections import defaultdict

# Функция для подсчета адресов в каждой подсети
def count_ips(subnet_list):
    ip_counts = defaultdict(int)
    
    # Регулярное выражение для извлечения префикса IP-адреса
    ip_pattern = re.compile(r"^\d+\.\d+\.")

    # Проходим по каждой строке в списке подсетей
    for subnet_str in subnet_list:
        # Находим префикс IP-адреса
        match = ip_pattern.match(subnet_str)
        if match:
            ip_prefix = match.group()
            # Увеличиваем счетчик для найденного префикса
            ip_counts[ip_prefix] += 1
    
    return ip_counts

# Чтение подсетей из файла
subnets = []
with open('subnet_list.txt', 'r') as file:
    subnets = file.readlines()

# Подсчет количества IP-адресов в каждой подсети
ip_counts = count_ips(subnets)

# Вывод результатов
for subnet, count in ip_counts.items():
    print(f"{subnet}-{count}")
