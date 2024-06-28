from subprocess import run

def script():
    name =['apohianny/','apohigor/','apojob/','apomayara/','aporest/','aposchedule/','aposimon/','apowilson/','apoworkflow/','apows/']

    for apo in name:
        apphn = ["y","|","cp","-rf","/totvs/protheus/apo/apo01/*" ,f"/totvs/protheus/apo/{apo}"] 
        run(apphn)

    return script()

if __name__=='__main__':
    script()