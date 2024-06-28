import subprocess
resposta = [0,1,2,3,4,5,6,7,8,9]

def runMatch():
    print('BOM DIA O QUE VOCÊ QUER FAZER HOJE? \n')

    print('DIGITE O NUMERO QUE DESEJAR!')
    print('PARA SAIR DIGITE: 0\n')
    print('SUBIR REPLICACAO : 1  |  PARAR REPLICACAO : 2 |  STATUS REPLICACACAO : 3')
    print('SUBIR DBACESS :    4  |  PARAR DBACESS :    5 |  STATUS DBACESS :      6')
    print('SUBIR SERVICOS :   7  |  PARAR SERVICOS :   8 |  STATUS SERVICOS :     9')

    resposta = str(input('\n qual sua resposta? ' + resposta))

    match resposta:
        case '1':
            print('subi')
            cmd = ('sudo /etc/init.d/totvsappreplicacao start')
            subprocess.Popen(cmd,shell=True)
