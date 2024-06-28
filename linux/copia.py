def scrip():
    with open('/totvs/pythonscript/teste3.txt','r') as arquivo:
        arq = arquivo.readlines()
        print(arq)
        pal = "juca"
        if pal in arq:
            print('achei o juca') 
        else:
            print('nao achei o juca') 

def script():
    with open('/totvs/pythonscript/teste3.txt','r') as arquivo:
        arq = arquivo.readlines()
        aa='samba'
        achar = arq.index(aa)
        print(achar)

def script():
    with open('/totvs/pythonscript/teste3.txt','w') as arquivo:
        arq = arquivo.readlines()
        ar = arquivo.writable('comecou')
        print(ar)

with open('/totvs/pythonscript/teste3.txt','r') as arquivo:
        arqu = arquivo.readlines()
        with open('/totvs/pythonscript/teste3.txt','w') as arquiv:
            for linha in arqu:
                if "povo" in linha:
                     print()
                                      
with open('/totvs/pythonscript/teste3.txt','r') as arquivo:
    arqu = arquivo.readlines()
    povo = "povo"
    for linha in arqu:
            if povo in linha:
                    print(linha)
    with open('/totvs/pythonscript/teste3.txt','w') as arqui:
        for linha in arqu:
            if povo in linha:
                 arqui.write('pessoa')


if __name__=='__main__':
    script()