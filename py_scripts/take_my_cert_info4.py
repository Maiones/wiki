import os
import subprocess
from OpenSSL import crypto

certs_folder = "/home/user/medbot/certs/blobs/pipi/"

def get_user(filename):
    check_codirovka = subprocess.run(
        ["openssl", "x509", "-inform", "der", "-text", "-noout", "-nameopt", "utf8", "-in", filename], 
        stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT
    )
    
    if check_codirovka.returncode == 0:
        with open(filename, 'rb') as der_file:
            cert_Open = crypto.load_certificate(crypto.FILETYPE_ASN1, der_file.read())
    else:
        with open(filename, 'rb') as der_file:
            cert_Open = crypto.load_certificate(crypto.FILETYPE_PEM, der_file.read())

    subject = cert_Open.get_subject()
    gn_name = None
    cn_name = None
    
    for name, value in subject.get_components():
        if name.decode() == "GN":
            gn_name = value.decode()   
        elif name.decode() == "CN":
            cn_name = value.decode()

    return gn_name, cn_name

def get_validity_info(filename):
    openssl_cmd = ["openssl", "x509", "-inform", "der", "-text", "-noout", "-in", filename]
    result = subprocess.run(openssl_cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        return None
    
    output_lines = result.stdout.splitlines()
    validity_info = []
    capture_next = False

    for line in output_lines:
        if "Validity" in line:
            capture_next = True
        elif capture_next and len(validity_info) < 2:
            validity_info.append(line.strip())
        elif len(validity_info) == 2:
            break
    return validity_info

for filename in os.listdir(certs_folder):
    if filename.endswith('.cer'):
        full_path = os.path.join(certs_folder, filename)

        # Получаем GN & CN
        gn_name, cn_name = get_user(full_path)

        # Получаем информацию о сроке действия сертификата
        validity_info = get_validity_info(full_path)
        
        cal_change = {
            'Jan': 'Январь', 'Feb': 'Февраль', 'Mar': 'Март', 
            'Apr': 'Апрель', 'May': 'Май', 'Jun': 'Июнь', 
            'Jul': 'Июль', 'Aug': 'Август', 'Sep': 'Сентябрь', 
            'Oct': 'Октябрь', 'Nov': 'Ноябрь', 'Dec': 'Декабрь'
         }

        if cn_name or gn_name:
            print(f"{cn_name} {gn_name}")

        if validity_info:
            for line in validity_info:
                for abbr, full_name in cal_change.items():
                    line = line.replace(abbr, full_name)
                
                line = line.replace("Not Before:", "C").replace("Not After :", "До").replace("GMT", "")
                print(line)

            print("-" * 30)