#Requires AutoHotkey v2.0
DllCall("SetProcessDpiAwarenessContext", "ptr", -4)

; Hotkey (Combinacion de Teclas) Ctrl + 1 que verificara que exita el proceso Chrome.exe y que tenga en el Titulo * - Youtube
^1::
{
    ; ChromeIdList := WinGetList("ahk_exe chrome.exe")

    if WinExist("ahk_exe chrome.exe")  ; Para que pueda tener un bloque dentro del if se usa el {}
        {
            ; Obtengo el ID del Proceso crhome.exe
            ChromeId := WinGetID("ahk_exe chrome.exe")
            ; Establesco un RegExPatter par que busque Dentro de un Texto " - YouTube"
            regEx := "i)$[\w\s]+ - YouTube$"
            ; Establesco el comportamiento de Matching en los Titulos de Procesos a "RegEx"
            SetTitleMatchMode('RegEx')
            ; Si Buscando con el Patron RegEx Encuentra al menos un Titulo que encaje con el patron Entra al bloque
            if (WinGetCount("ahk_id " . ChromeId, , regEx) >= 1) {

                MsgBox("Se encontro una Ventana con el Titulo Youtube " . WinGetTitle("ahk_id " . ChromeId, , regEx) . " " . WinGetCount("ahk_id " . ChromeId, , regEx) . " Moviendo el Mouse")
                ; Muestro en la consola la Info
                OutputDebug("Se encontro una Ventana con el Titulo Youtube " . WinGetTitle("ahk_id " . ChromeId))

                ; Inicializo las Variables que guardan la Posicion dentro de el Boton "Skip\Omitir\Saltar" dentro del cliente
                ButtonX := 0
                ButtonY := 0

                ; Guardo la Posicion actual del Mouse
                MouseGetPos(&currentX, &currentY)
                
                ; Obtengo los datos de la Ventana del Proceso chrome.exe https://www.autohotkey.com/docs/v2/lib/WinGetPos.htm
                WinGetClientPos(&windowX, &windowY, &windowW, &windowH, "ahk_id " . ChromeId)
                Window_offSetx := 1920 - windowW
                Window_offSetY := 1080 - windowH

                MsgBox("Second Monitor W: " windowW " H: " windowH " offSetX: " Window_offSetx " offSetY: " Window_offSetY)

                ; Probando el ImagaSearch
                try {
                    MsgBox("Buscando Imagen entre X1: " windowX " Y1: " windowY " X2 " A_ScreenWidth * 2 " Y2: " A_ScreenHeight)
                    if ImageSearch(&foundX, &foundY, windowX, windowY, A_ScreenWidth * 2, A_ScreenHeight, "*n C:\Users\sebax\Desktop\Universidad\Proyectos_aleatorios\Extension_Skip_Ad_Chrome\AHK\Skip_Button_es.bmp") {
                        MsgBox("Se encontro la Imagen en X: " foundX " Y: " foundY)
                        ButtonX := foundX
                        ButtonY := foundY
                    } else {
                        MsgBox("No se encontro la Imagen")
                        ButtonX := 1450 + Window_offSetx + windowX
                        ButtonY := 580 + Window_offSetY + windowY
                    }
                } catch as e {
                    MsgBox("No se pudo buscar la Imagen o Fallo!, Error: ", e.Message)
                    ButtonX := 1450 + Window_offSetx + windowX
                    ButtonY := 580 + Window_offSetY + windowY
                }

                ; Estableciendo la posicion del Boton en la Ventana
                ; Para calcular el offset utilizo como Base la resolucion 1920x1080 y le resto el ancho y alto real para obtener el valor real que necesito restar a 1920
                ButtonPosicions := [ButtonX, ButtonY]

                ; ButtonPos := [windowX +  windowW, windowY +  windowH]
                MsgBox("Moviendo a " . ButtonPosicions[1] . " " . ButtonPosicions[2] . " | " . windowW . " " . windowH)

                ; Moviendo el Mouse de manera Relativa a el X y Y de la Ventana
                MouseMove(ButtonPosicions[1],ButtonPosicions[2], 40)

                ; Esperando 2 Seg antes de Volver a la pos Original
                Sleep(5000)

                ; Moviendo a la pos Original
                MouseMove(currentX, currentY, 40)
                ToolTip()

            }
            else {

                MsgBox("No se encontro una Ventana con el titulo necesitado " . WinGetTitle("ahk_id " . ChromeId))
            }
            ; ; MsgBox "Se encontro almenos un proceso de Chrome, ID: " . ChromeId . " Titulo de la Ventana: " . WinGetTitle("ahk_id " . ChromeId)
            ; ; Obteniendo la Posicion Actual del Mouse x,y
            ; MouseGetPos(&currentX, &currentY)
            ; ; MsgBox "Lo que sea que este en CurrentPos " . currentX . " " . currentY
            
            ; ; Mas o menos la poscion Hardcodeada en mi Segunda Pantalla del Boton de Skip
            ; ButtonPos := [3720, 720] ; La Primera Posicion es el 1, Es decir el indice empieza en 1 y NO en 0
            
            ; MouseMove(ButtonPos[1], ButtonPos[2], 40)
            ; Sleep(2000)
            ; MouseMove(currentX, currentY, 40)
        }
    else
        MsgBox "No se encontro Ningun proceso de Chrome"
}

/* -- Deprecated

; Obtengo los pixeles de derecha y izquierda del monitor
MonitorGetWorkArea(2,&leftMon,&topMon,&rightMon,&bottomMon)
MsgBox("Segundo Monitor Izquierda: " leftMon " Derecha: " rightMon " Arriba: " topMon " Abajo: " bottomMon)

*/

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

----------------

Screen:	3363, 587
Window:	1450, 594
Client:	1443, 587 (default)
Color:	123C82 (Red=12 Green=3C Blue=82)
*/