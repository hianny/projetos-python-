from hashlib import sha256
import time

zero =3
def hash(texto):
    return sha256(texto.encode('ascii')).hexdigest()

def minerar(num_bloco, transacoes, hash_ant, ZEROS):
    qtd_zero = "0" * ZEROS

    naoachei =True
    nonce = 0
    while naoachei:
        hash_bloco = str(num_bloco) + transacoes +hash_ant + str(nonce)
        hash_atual = hash(hash_bloco)
        nonce+=1
        
        if hash_atual.startwith(qtd_zero):
            naoachei= False
            print(f"NONCE ENCONTRADO: {nonce}")
            return hash_atual