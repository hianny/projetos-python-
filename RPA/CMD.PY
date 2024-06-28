import subprocess

cmd = "scp -i C:\\Users\\hianny.urt\\Documents\\keys\\homollnx.pem D:\\comandos-linux\\* opc@10.192.0.95:/home/opc/teste_env_arq/ "

returned_value = subprocess.call(cmd, shell=True)  # returns the exit code in unix
print('returned value:', returned_value)