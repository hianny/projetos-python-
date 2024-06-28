import os
import pandas as pd
import testerpa

#le o excel e converte em csv
read = pd.read_excel(fr"C:\Users\hianny.urt\Downloads\{testerpa.ult_arq[1]}")
read.to_csv(fr"C:\Users\hianny.urt\Downloads\Consulta.csv", index=False)
#le as linhas do csv
df = pd.read_csv(fr"C:\Users\hianny.urt\Downloads\Consulta.csv",index_col=None)

# Exclui as 5 primeiras linhas
df = df.iloc[5:]
df.replace(' " ', "")

# Salva o DataFrame modificado em um novo arquivo CSV
df.to_csv(fr"C:\Users\hianny.urt\Downloads\Consulta.csv", header=False, index=False, sep=';')

os.remove(fr"C:\Users\hianny.urt\Downloads\{testerpa.ult_arq[1]}")
