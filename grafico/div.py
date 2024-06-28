import requests
from bs4 import BeautifulSoup

link = 'https://www.google.com/finance/quote/BTC-BRL'
req  = requests.get(link)

site = BeautifulSoup(req.text,"html.parser")

pesquisa = site.find('div', class_="YMlKec fxKbKc")
print(pesquisa)