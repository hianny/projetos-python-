from pathlib import Path

nome = input(' coloque o nome do arquivo:')
glo = list(Path(fr"C:\PROTHEUSSVN\branches").glob(fr"**\{nome}.prw "))
for x in glo:
    print(x)