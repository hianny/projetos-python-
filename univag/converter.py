letra = input('escreva uma letra: ')

valor_decimal = ord(letra)

valor_hexadecimal = hex(valor_decimal)

valor_binario = bin(valor_decimal)

print(f"Sua letra: {letra}")
print(f"Decimal: {valor_decimal}")
print(f"Hexadecimal: {valor_hexadecimal}")
print(f"Binário: {valor_binario}")