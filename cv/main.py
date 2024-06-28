import pytesseract
import cv2
img = input("nome da foto: ")
imagem = cv2.imread({img})

caminho = rf"C:\Users\Python\AppData\Local\Programs\Tesseract-OCR"
pytesseract.pytesseract.tesseract_cmd = caminho + rf'\tesseract.exe'
texto = pytesseract.image_to_string(imagem, lang="por") 
print(texto)