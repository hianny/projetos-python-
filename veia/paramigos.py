from tkinter import *
import tkinter 

janela = tkinter.Tk()
janela.geometry("400x600")
bg = PhotoImage(file = "veia\\veia.png")

def clique():
    label1 = Label( janela, image = bg)
    label1.pack(padx=10,pady=10)

texto = tkinter.Label(janela, font="-weight bold -size 10", text="oi amgs")
texto.pack(padx=10,pady=10)

botao = tkinter.Button(janela, width=15, text="clica aqui!", height=2, font="-weight bold -size 10", command=clique)
botao.pack(padx=10,pady=30)

janela.mainloop()