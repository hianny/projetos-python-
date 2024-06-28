

def calc_medida_do_tringulo(x1,x2,x3,y1,y2,y3):
    a = (((x2-x1)**2)+((y3-y1**2)))**.5
    b = (((x3-x2)**2)+((y3-y1**2)))**.5
    a = (((x3-x1)**2)+((y2-y1**2)))**.5
    
    a = ((x2 - x1)**2 + (y2 - y1)**2)**0.5
    b = ((x3 - x2)**2 + (y3 - y2)**2)**0.5
    c = ((x3 - x1)**2 + (y3 - y1)**2)**0.5
    
    
    perimetro = a+b+c
    p = perimetro/2
    area = (p*(p-a)*(p-b)*(p-c))**.5
    
    return perimetro, area   