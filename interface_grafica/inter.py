import tkinter 

janela = tkinter.Tk()
janela.geometry("500x300")

def clique():
    print("fazer login")

texto = tkinter.Label(janela, text="fazer login")
texto.pack(padx=10,pady=10)

botao = tkinter.Button(janela, text="login", command=clique)
botao.pack(padx=10,pady=10)

janela.mainloop()