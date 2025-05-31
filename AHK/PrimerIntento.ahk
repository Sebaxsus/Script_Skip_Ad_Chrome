; Hotkey (Combinacion de Teclas) Ctrl + 1 que verificara que exita el proceso Chrome.exe y que tenga en el Titulo * - Youtube
^1::
{
    if WinExist("ahk_exe chrome.exe")  ; Para que pueda tener un bloque dentro del if se usa el {}
        {
            ChromeId := WinGetID("ahk_exe chrome.exe")
            regEx := "i)[a-zA-Z1-9] - YouTube"
            ; MsgBox "Se encontro almenos un proceso de Chrome, ID: " . ChromeId . " Titulo de la Ventana: " . WinGetTitle("ahk_id " . ChromeId)
            ; Obteniendo la Posicion Actual del Mouse x,y
            MouseGetPos(&currentX, &currentY)
            ; MsgBox "Lo que sea que este en CurrentPos " . currentX . " " . currentY
            
            ; Mas o menos la poscion Hardcodeada en mi Segunda Pantalla del Boton de Skip
            ButtonPos := [3720, 720] ; La Primera Posicion es el 1, Es decir el indice empieza en 1 y NO en 0
            
            MouseMove(ButtonPos[1], ButtonPos[2], 40)
            Sleep(2000)
            MouseMove(currentX, currentY, 40)
        }
    else
        MsgBox "No se encontro Ningun proceso de Chrome"
}

/*
--- Metadatos Dentro de un video de YouTube en Segunda Pantalla y Sobre el Boton de Omitir/Saltar ---

Mouse Position:
    Screen:	3367, 586
    Window:	3375, 594
    Client:	3367, 586 (default)
    Color:	FEEFE4 (Red=FE Green=EF Blue=E4)

Control Under Mouse Position:
    ClassNN:	Chrome_RenderWidgetHostHWND1
    Text:	Chrome Legacy Window
    Screen:	x: 1920	y: 121	w: 1536	h: 695
    Client:	x: 0	y: 121	w: 1536	h: 695

Active Window Position:
    Screen:	x: 1913	y: -7	w: 1550	h: 830
    Client:	x: 1920	y: 0	w: 1536	h: 816
*/