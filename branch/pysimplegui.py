import PySimpleGUI as sg

layout = [
    [sg.Text('TEXT',enable_events=True ,key='t'),sg.Spin(['item 1','item 2'])],
    [sg.Button('BUTTON',key = "but")],
    [sg.Input()],
    [sg.Text('teste'), sg.Button('button',key="but2")]
]

window = sg.Window("converter",layout)

while True:
    event, values = window.read()
    
    if event == sg.WIN_CLOSED:
        break
    if event == "but":
        print('botao 1 presionado ')
    if event == "but2":
        print("botao 2 presionado")