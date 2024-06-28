from tkinter import *
from datetime import datetime
from tkinter import messagebox


janela = Tk()
janela.geometry("400x300")
janela.title("hianny é top")
janela.config(bg ='#CDAA7D')

texto = Label(janela, text='para hianny nao esquecer os ambientes\n das branchs que ela compila',bg='#8B6508',fg= 'white',font='12')
texto.place(x=70, y=30)

text = Label(janela, text='branch',bg='#8B7D6B',font='12')
text.place(x=130, y=90)

branchs1 = Entry(janela,font='12')
branchs1.place(x=100, y=120)

tex = Label(janela, text='ambiente aplicado',bg='#8B7D6B',font='12')
tex.place(x=110, y=150)

amb1 =Entry(janela,font='12')
amb1.place(x=100, y=180)


def botaopressionado():
    
    amb = amb1.get()
    br = branchs1.get()
    with open(fr"D:\compila homol\branch_ambientes.txt", 'a') as log:
        log.write(f" o branch  - {br} -  foi aplicado no ambiente homologacao  - {amb} -  no dia  -{datetime.now().strftime('%Y-%m-%d %H:%M:%S ')}\n")
    messagebox.showinfo('foi escrita','foi escrita no seu log')

botao = Button(janela, text='cadastrar', command=botaopressionado,bg='#8B7D6B',font='14')
botao.place(x=100, y=220)

def fechar():
    janela.destroy()
  
botao2 = Button(janela, text='fechar', command=fechar,bg='#8B7D6B',font='14')
botao2.place(x=200, y=220)


janela.mainloop()