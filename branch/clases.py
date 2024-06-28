class ControleRemoto:
    def __init__(self, cor, altura, profundidade, largura):
        self.cor = cor
        self.altura = altura
        self.profundidade = profundidade
        self.largura = largura

    def passar_canal(self,botao):
        if botao =="+":
            print("aumentar volume")

        elif botao =="-":
            print("diminuir volume ") 

controle1 = ControleRemoto("preto","10","2","2")
print(controle1.altura)
controle1.passar_canal()