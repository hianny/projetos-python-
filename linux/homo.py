import subprocess
resposta = ''

print('BOM DIA O QUE VOCÊ QUER FAZER HOJE? \n')
while resposta != '0':
    resposta = ''
    print('DIGITE O NUMERO QUE DESEJAR!')
    print('PARA SAIR DIGITE: 0\n')

    print('SUBIR REPLICACAO : 1  |  PARAR REPLICACAO : 2 |  STATUS REPLICACACAO : 3')
    print('SUBIR DBACESS :    4  |  PARAR DBACESS :    5 |  STATUS DBACESS :      6')
    print('SUBIR SERVICOS :   7  |  PARAR SERVICOS :   8 |  STATUS SERVICOS :     9')
    print('\nSCRIPT PYTHON COPIA APO : 11')
    resposta = input('\n qual sua resposta? ' + resposta)

    if resposta == '1':
        print('subi')
        cmd = ('sudo /etc/init.d/totvsappreplicacao start')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')

    elif resposta == '2':
        print('parei')
        cmd = ('sudo /etc/init.d/totvsappreplicacao stop')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')
    
    elif resposta == '3':
        print('ta tudo em cima')
        cmd = ('sudo /etc/init.d/totvsappreplicacao status')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')
    
    elif resposta == '4':
        print('subi')
        cmd = ('sudo /etc/init.d/totvsdbaccess start')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')
    
    elif resposta == '5':
        print('parei')
        cmd = ('sudo /etc/init.d/totvsdbaccess stop')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')
    

    elif resposta == '6':
        print('ta tudo em cima')
        cmd = ('sudo /etc/init.d/totvsdbaccess status')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')
    
    elif resposta == '7':
        print('subi')
        cmd = ('sudo /etc/init.d/totvsservices start')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')
    

    elif resposta == '8':
        print('parei')
        cmd = ('sudo /etc/init.d/totvsservices stop')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')
    
    elif resposta == '9':
        print('ta tudo em cima')
        cmd = ('sudo /etc/init.d/totvsservices status')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')

    elif resposta == '11':
        print('ta tudo em cima')
        cmd = ('sudo python /totvs/pythonscript/coprep.py')
        subprocess.Popen(cmd,shell=True)
        print('PARA VOLTAR NO MENU: 10\n')
