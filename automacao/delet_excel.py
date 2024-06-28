from openpyxl import workbook
import pandas as pd

pdd = pd.read_excel('c:\\Users\\hianny.urt\\Downloads\\ConsultaNFeEmitidasRecebidas1698850537765.xls')

df = pd.DataFrame(pdd)
print(df.shape)
df.drop(labels=0)
df.drop(labels=1)
df.drop(labels=2)
df.drop(labels=3)
print(df)

'''excel = ('C:\\Users\\hianny.urt\\Documents\\excel_teste.xlsx')
excel_sheet = workbook()
excel_sheet = excel.active

excel_sheet.delete_rows(idx=1)
excel_sheet.delete_rows(idx=2)
excel_sheet.delete_rows(idx=3)
excel_sheet.delete_rows(idx=4)
excel_sheet.delete_rows(idx=5)
'''