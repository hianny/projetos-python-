import os
caminho = 'C:/Users/hianny.urt/Downloads'
lista = os.listdir(caminho)

lis_dat =[]
for arquivo in lista:
    data = os.path.getmtime(fr"{caminho}/{arquivo}")
    lis_dat.append((data, arquivo))


lis_dat.sort(reverse=True)
ult_arq = lis_dat[0]
with open(fr'C:\Users\hianny.urt\Documents\python\RPA\ultimo_arq.txt','w') as arquivo:
    arquivo.write(ult_arq[1])