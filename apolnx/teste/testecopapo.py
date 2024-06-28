from subprocess import run

def script():
    apphn = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/apohianny/"] 
    run(apphn)

    apphg = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/apohigor/"] 
    run(apphg)

    appj = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/apojob/"] 
    run(appj)

    appm = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/apomayara/"] 
    run(appm)

    appr = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/aporest/"] 
    run(appr)

    appsc = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/aposchedule/"] 
    run(appsc)

    appsm = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/aposimon/"] 
    run(appsm)

    appwl = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/apowilson/"] 
    run(appwl)

    appwr = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/apoworkflow/"] 
    run(appwr)

    appws = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,"/totvs/protheus/apo/apows/"] 
    run(appws)

    return script()

if __name__=='__main__':
    script()