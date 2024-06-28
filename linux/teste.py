import paramiko
import commandos
import pysftp as sftp


address = '10.194.0.110'
username = 'opc'

#abre a conexao com o ssh
ssh = paramiko.SSHClient()


ssh.load_system_host_keys()

#aceita a conexao com um servidor que a maquina nao conhece
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

ssh.connect(hostname=address, username=username, key_filename=fr'D:\keys\srvprimlinux.pem')

#ss =sftp.Connection(host=address, username=username, key_filename=fr'D:\keys\srvprimlinux.pem')

#tentar mandar um arquivo para os ervidor remoto
#ss.put('D:\chuuras.jpeg','/home/opc/teste/' )

#acessar esse diretorio no servidor remoto
#ssh.exec_command('cd /usr/local/mesh_services/meshagent/')

#tentar mandar um arquivo para os ervidor remoto
#ssh.exec_command('scp -p HIANNY.URT@192.168.1.108:D:\chuuras.jpeg opc@10.194.0.110:/home/opc/teste/')
coman = (commandos.comando4, commandos.comando5)

for comando in coman:
   stdin, stdout, stderr = ssh.exec_command(coman)

#sftp = ssh.open_sftp()
#sftp.put('')

#fc = ssh.open_sftp()
#fnames = fc.listdir()
#stdin.close()
#stdin.write(command)
#print(stdout.read().decode())

if stderr.channel.recv_exit_status() != 0:
   print (stderr.read(),)
else:
   print (stdout.readlines())