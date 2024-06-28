class Cliente:
    def __init__(self, nome, email, plano):
        self.noe = nome
        self.email = email

        lista_planos = ["basic","premium"]
        if plano in lista_planos:
            self.plano = plano
            
        else:
            raise Exception("plano invalido")
    
    def mudar_plano(self,novo_plano):
        if novo_plano in self.lista_planos:
            self.plano =novo_plano
        else:
            print("plano invalido")

    def ver_filme(self,filme,plano_filme):
        if self.plano == plano_filme:
            print(f"ver filme{filme}")
        elif self.plano == "premium":
            print(f"ver filme{filme}")
        elif self.plano == "basic" and plano_filme == "premium":
            print(f"faca o upgrade para o plano premium")
        else:
            print("plano invalido")


cliente =Cliente("hianny","hianny@gmail.com","basic")
print(cliente.plano)
cliente.ver_filme("harry potter","premium")