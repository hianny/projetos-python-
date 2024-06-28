import requests
from bs4 import BeautifulSoup
import time
from datetime import datetime
import re
import matplotlib.pyplot
a = [1,2,3,4,5,6,7,8,9,10]
mes = [1,2,3,4,5,6,7,8,9,10]

x=True
while x == True:
    
    i = 1
    while i < 10:
        data_e_hora_atuais = datetime.now()
        data_e_hora_em_texto = data_e_hora_atuais.strftime('%d/%m/%Y %H:%M')
        
        link = 'https://www.google.com/finance/quote/BTC-BRL'
        req  = requests.get(link)

        site = BeautifulSoup(req.text,"html.parser")

        pesquisa1 = site.find('div', class_="YMlKec fxKbKc")
        pp1 = str(pesquisa1)
        print(mes[i] ,pp1[27:-6])

        time.sleep(10)

        pesquisa2 = site.find('div', class_="YMlKec fxKbKc")
        pp2 = str(pesquisa2)
        #print(pp2[27:-6])

        en = int(re.sub('[^a-zA-Z0-9]', '',(pp2[27:-6])))




        mes[i] = data_e_hora_em_texto
        print(mes[i] ,pp2[27:-6])
        

        a[i] = en
        soma = sum(a)
        media = soma/len(a)
        #print((media))
        #print(data_e_hora_em_texto, ' ',pp[45:-7])
        
        if en <=media:
            print('o valor esta abaixando')

        elif en >=media:
            print('o preco aumentou')

        #matplotlib.pyplot.plot(mes, media)
        #matplotlib.pyplot.show()

        time.sleep(60)

        i =+ i
        if i == 10:
            i = 1
    #print(en)


