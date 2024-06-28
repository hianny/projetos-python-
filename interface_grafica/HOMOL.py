import tkinter
import paramiko
from tkinter import messagebox
from tkinter import *

janela = tkinter.Tk()
janela.geometry("500x400")
janela.config(bg='#dde')



username = 'opc'
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

def subrep():
    comandos = 'sudo /etc/init.d/totvsappreplicacao start'
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    ssh.exec_command(comandos)
    messagebox.showinfo('','replica subiu')
        
def subser():
    comandos = 'sudo /etc/init.d/totvsservices start'
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    ssh.exec_command(comandos)
    messagebox.showinfo('','os servicos subiram')

        
def subdb():
    comandos = 'sudo /etc/init.d/totvsdbaccess start'
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    ssh.exec_command(comandos)
    messagebox.showinfo('','dbaccess subiu')
        
def janelinha():
        
    comandos = '/etc/init.d/totvsservices status'

    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    stdin, stdout, stderr = ssh.exec_command(comandos)

    if stderr.channel.recv_exit_status() != 0:
        print (stderr.read())
    else:
        for line in stdout.readlines():
            print (line)

def starep():
        
    comandos = '/etc/init.d/totvsappreplicacao status'

    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    stdin, stdout, stderr = ssh.exec_command(comandos)

    if stderr.channel.recv_exit_status() != 0:
        print (stderr.read())
    else:
        for line in stdout.readlines():
            print (line)

def stadb():
        
    comandos = '/etc/init.d/totvsdbaccess status'

    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    stdin, stdout, stderr = ssh.exec_command(comandos)

    if stderr.channel.recv_exit_status() != 0:
        print (stderr.read())
    else:
        for line in stdout.readlines():
            print (line)


def parser():
    comandos = 'sudo /etc/init.d/totvsservices stop'
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    ssh.exec_command(comandos)
    messagebox.showinfo('','os servicos pararam')

def parrep():
    comandos = 'sudo /etc/init.d/totvsappreplicacao stop'
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    ssh.exec_command(comandos)
    messagebox.showinfo('','replicacao parou')

def pardb():
    comandos = 'sudo /etc/init.d/totvsdbaccess stop'
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    ssh.exec_command(comandos)
    messagebox.showinfo('','dbacess parou')


#def copapo():
#    comandos = 'sudo python /totvs/pythonscript/coprep.py'
#    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
#    ssh.exec_command(comandos)
#    messagebox.showinfo('','copia apo rodou')

def copm():
    comandos = 'sudo tree -hD /totvs/protheus/apo/'
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    stdin, stdout, stderr = ssh.exec_command(comandos)

    if stderr.channel.recv_exit_status() != 0:
        print (stderr.read())
    else:
        for line in stdout.readlines():
            print (line)

def copv():
    comandos = 'sudo fuser /totvs/protheus/apo/apo01/custom.rpo'
    ssh.connect(hostname='10.192.0.95', username=username, key_filename=fr"C:\keys\homollnx.pem")
    stdin, stdout, stderr = ssh.exec_command(comandos)

    if stderr.channel.recv_exit_status() != 0:
        print (stderr.read())
    else:
        for line in stdout.readlines():
            print (line)



texto = tkinter.Label(janela, text="ambiente homologacao", height=2)
texto.pack(padx=10,pady=10)

botaosp = tkinter.Button(janela, width=15, height=2 ,text="subir replicacao", command=subrep, bg ='#00FF7F')
botaosp.place(x=70,y=50)

botaosv = tkinter.Button(janela, width=15, height=2 ,text="subir servicos", command=subser, bg ='#00FF7F')
botaosv.place(x=70,y=120)

botaosdb = tkinter.Button(janela, width=15, height=2 ,text="subir dbacess", command=subdb, bg ='#00FF7F')
botaosdb.place(x=70,y=190)

botaopr = tkinter.Button(janela, width=15, height=2 , text="parar replicacao", command=parrep , bg ='#B22222')
botaopr.place(x=206,y=50)

botaops = tkinter.Button(janela, width=15, height=2 , text="parar servicos", command=parser, bg ='#B22222')
botaops.place(x=206,y=120)

botaopdb = tkinter.Button(janela, width=15, height=2 , text="parar dbacess", command=pardb, bg ='#B22222')
botaopdb.place(x=206,y=190)

botaostp = tkinter.Button(janela, width=15, height=2 ,text="status dos replica", command=starep, bg ='#FFD700')
botaostp.place(x=340,y=50)

botaostdb = tkinter.Button(janela, width=15, height=2 ,text="status dbacess", command=stadb, bg ='#FFD700')
botaostdb.place(x=340,y=190)

botaoss = tkinter.Button(janela, width=15, height=2 ,text="status dos servicos", command=janelinha, bg ='#FFD700')
botaoss.place(x=340,y=120)

#'''
#botaocop = tkinter.Button(janela, width=15, height=2 ,text="copia apo", command=copapo, bg ='#FF6103')
#botaocop.place(x=70,y=260)'''

botaocopm = tkinter.Button(janela, width=15, height=2 , text="ver apo", command=copm, bg ='#FF6103')
botaocopm.place(x=206,y=260)

botaocopv = tkinter.Button(janela, width=15, height=2 , text="Fuser", command=copv, bg ='#FF6103')
botaocopv.place(x=340,y=260)



janela.mainloop()