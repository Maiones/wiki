import os
import subprocess
from OpenSSL import crypto

certs_folder = "/home/user/medbot/new_certs/"


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

