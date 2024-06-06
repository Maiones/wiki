import os

def process_files(directory):
    for filename in os.listdir(directory):
        if filename.endswith('.ppd'):
            file_path = os.path.join(directory, filename)
            process_file(file_path)

def process_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    if len(lines) < 15:
        print(f'File {file_path} has less than 15 lines. Skipping.')
        return
    
    line_15 = lines[14]
    
    # Ensure there are at least 16 lines in the file
    if len(lines) < 16:
        lines.append('\n')
    
    # Insert the 15th line as the new 16th line
    lines.insert(15, line_15)
    
    # Modify the new 16th line: replace '-' with ' ' and ' ' with '-'
    modified_line_16 = line_15
    if '(' in modified_line_16 and ')' in modified_line_16:
        start = modified_line_16.find('(')
        end = modified_line_16.rfind(')')
        middle = modified_line_16[start+1:end]
        modified_middle = middle.replace('-', ' ').replace(' ', '-')
        modified_line_16 = modified_line_16[:start+1] + modified_middle + modified_line_16[end:]
    
    # Store the modified line back
    lines[15] = modified_line_16
    
    with open(file_path, 'w') as file:
        file.writelines(lines)

if __name__ == '__main__':
    directory = '/home/user/kva-kva/rpm_repack/pantum_6/usr/share/cups/model/Pantum/' 
    process_files(directory)
