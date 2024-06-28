from subprocess import run


def script():
    entrar = ["vi","/totvs/pythonscript/teste3.txt"] 
    run(entrar)
    achar =["find","-name","samba"]
    run(achar)
    print(achar)
    return script()

def scri():
    con = ["","/totvs/pythonscript/teste3.txt"] 

    exec2 = run(con)

    return exec2

def scrip():
    entrar = ["vi","/totvs/pythonscript/teste3.txt"] 

    exec3 = run(entrar)

    return exec3

if __name__=='__main__':
    script()