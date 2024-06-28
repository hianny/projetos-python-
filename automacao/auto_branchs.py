from datetime import datetime

branch = '843266_msgnfcomerc'

amb_rep = 'foi compilado em ambiente homologacao replicacao'
amb_rest = 'foi compilado em ambiente homologacao rest'
amb_tss = 'foi compilado em ambiente homologacao tss'
amb_h = 'foi compilado em ambiente homologacao higor'

with open(fr"D:\compila homol\branch_ambientes.txt", 'a') as log:
    log.write(f"\n{datetime.now().strftime('%Y-%m-%d %H:%M:%S ')}{branch}- {amb_rep}\n")
    print('adicionado mais um branch \n')