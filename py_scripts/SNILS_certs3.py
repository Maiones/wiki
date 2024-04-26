import os
import sys
import subprocess
from OpenSSL import crypto

certs_folder = "/home/user/medbot/new_certs/"

def get_snils(filename):
    check_codirovka = subprocess.run(["openssl", "x509", "-in", filename, "-text"], stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
    if check_codirovka.returncode == 0:
        with open(filename, 'rb') as der_file:
            cert_Open = crypto.load_certificate(crypto.FILETYPE_PEM, der_file.read())
    else:
        with open(filename, 'rb') as der_file:
            cert_Open = crypto.load_certificate(crypto.FILETYPE_ASN1, der_file.read())
    
    # Получение информации о СНИЛС
    subject = cert_Open.get_subject()
    snils_unit = None
    for name, value in subject.get_components():
        if name.decode() == "SNILS":
            snils_unit = value.decode()
    
    return snils_unit

for filename in os.listdir(certs_folder):
    if filename.endswith('.cer'):
        full_path = os.path.join(certs_folder, filename)
        snils = get_snils(full_path)
        if snils:
            print(f"{snils}")
        else:
            print(f"СНИЛС в {filename} не найден.")

