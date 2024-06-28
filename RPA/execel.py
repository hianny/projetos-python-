import pandas as pd
from pathlib import Path 

tabela =pd.read_excel(fr"C:\Users\hianny.urt\Downloads\ConsultaNFeEmitidas.xlsx")
print(tabela)
tabela.drop(index=1)
print(tabela)

sz = Path(fr"C:\Users\hianny.urt\Downloads\ConsultaNFeEmitidas.xlsx").stat().st_size 
  
print(sz) 