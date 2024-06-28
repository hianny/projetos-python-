import subprocess
name = ['apo01','apoanderson','apocristiano','apoheuly','apohianny','apohigor','apojob','apokleber','apomayara','aporest','aposchedule','aposimon','apowilson','apoworkflow','apows']

for x in name:
    cmd = ("yes | cp -rf /totvs/protheus/apo/aporeplicacao/* /totvs/protheus/apo/"+x)

    subprocess.Popen(cmd,shell=True)

#import subprocess

#cmd = 'yes | cp -rf /totvs/protheus/apo/apo01/* /totvs/protheus/apo/apohianny'
#name = ['apo01',  'apoanderson',  'apocristiano',  'apoheuly',  'apohianny',  'apohigor',  'apojob',  'apokleber',  'apomayara', 'aporest',  'aposchedule',  'aposimon',  'apowilson',  'apoworkflow', 'apows']
#subprocess.Popen(cmd,shell=True)