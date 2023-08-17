import os

def generate_install_commands(base_path, current_path):
    install_commands = []
    
    for item in os.listdir(current_path):
        item_path = os.path.join(current_path, item)
        
        if os.path.isdir(item_path):
            mkdir_command = f"mkdir -p %buildroot/{item_path[len(base_path):]}"
            install_commands.append(mkdir_command)
            install_commands.extend(generate_install_commands(base_path, item_path))
        elif os.path.isfile(item_path):
            relative_path = os.path.dirname(item_path[len(base_path):])
            relative_path2 = item_path[len(base_path):]
            install_command = f"install -c -m0644 {relative_path2} %buildroot{relative_path}/"
            install_commands.append(install_command)
    
    return install_commands

def save_to_file(filename, commands):
    with open(filename, 'w') as file:
        for command in commands:
            file.write(command + '\n')

def find_available_filename(base_filename):
    num = 1
    while os.path.exists(f"{num}.spec"):
        num += 1
    return f"/tmp/{num}.spec"

user_input_path = input("Введите путь к папке: ")
base_path = user_input_path.strip()

install_commands = generate_install_commands(base_path, base_path)

base_filename = "output"
output_filename = find_available_filename(base_filename)
save_to_file(output_filename, install_commands)

print(f"Файл {output_filename} успешно создан.")
