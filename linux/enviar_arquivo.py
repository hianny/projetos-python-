import paramiko    

username = 'opc'
comandos = fr'scp -i C:\Users\hianny.urt\Documents\keys\homollnx.pem D:\comandos-linux\*  opc@10.192.0.95:/home/opc/teste_env_arq/'
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\Users\hianny.urt\Documents\keys\homollnx.pem")
stdin, stdout, stderr = ssh.exec_command(comandos)
if stderr.channel.recv_exit_status() != 0:
   print (stderr.read())
else:
   print (stdout.readlines())
