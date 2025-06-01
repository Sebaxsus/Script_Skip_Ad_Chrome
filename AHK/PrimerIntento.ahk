#Requires AutoHotkey v2.0


DllCall("SetProcessDpiAwarenessContext", "ptr", -4)

GetProcessDpi(procId) {
    return DllCall("user32\GetDpiForWindow", "ptr", procId, "uint")
}

GetYouTubeID(site) {
    idList := WinGetList("ahk_exe chrome.exe")
    WindowID := false
    ; Establesco un RegExPatter par que busque Dentro de un Texto " - YouTube"
    regEx := "i)(" site ")"

    for id in idList {
        if RegExMatch(WinGetTitle("ahk_id " id), regEx) {
            ; MsgBox "Se encontro! " WinGetTitle("ahk_id " id)
            WindowID := id
        }
    }

    return WindowID
}

SetMousePos(x, y) {
    DllCall("SetCursorPos", "int", x, "int", y)
}

RecorrerUnProcesso() {
    idList := WinGetList("ahk_exe chrome.exe")
    list := ""
    WindowID := false
    for id in idList  {
        list := list " " id
        if RegExMatch(WinGetTitle("ahk_id " id), "i)(YouTube)") {
            MsgBox "Se encontro! " WinGetTitle("ahk_id " id)
            WindowID := id
        }
    }
    MsgBox list " Total: " WinGetCount("ahk_exe chrome.exe")
}

; ShortCut para obtener el Escalado de la GUI en la Posicion actual del Mouse
^3::{
    MouseGetPos(&x, &y, &id)
    dpi := GetProcessDpi(id)
    MsgBox "DPI X: " dpi " Scale: " dpi / 96 " X " Round(x * (dpi / 96)) - 25
}

; ShortCut para
^2::{
    ; MsgBox "Version Actual: " A_AhkVersion
    MouseGetPos(&currentX, &currentY, &currentId)

    ChromeId := GetYouTubeID("YouTube")

    WinMoveTop("ahk_id " ChromeId)

    scale := GetProcessDpi(ChromeId) / 96

    ; Si la scala es 1 Significa que se Activo el Script desde la Pantalla Principal
    ToolTip(" " currentX " " currentY)
    if (GetProcessDpi(currentId) / 96) > 1 {
        RealX := Round(1435 * scale) - 30 
        RealY := Round(580 * scale)
        currentX := Round(currentX * scale)
        currentY := Round(currentY * scale)
    } else {
        RealX := 1920 + (Round(1435 * scale) - 30 )
        RealY := Round(580 * scale)
    }


    Click(RealX,RealY)

    WinActivate("ahk_id " currentId)

    MouseMove(currentX, currentY)
    
}
; Hotkey (Combinacion de Teclas) Ctrl + 1 que verificara que exita el proceso Chrome.exe y que tenga en el Titulo * - Youtube
^1::
{
    ; ChromeIdList := WinGetList("ahk_exe chrome.exe")

    if WinExist("ahk_exe chrome.exe")  ; Para que pueda tener un bloque dentro del if se usa el {}
        {
            ; Obtengo el ID del Proceso crhome.exe
            ChromeId := GetYouTubeID("YouTube")
            
            ; Establesco el comportamiento de Matching en los Titulos de Procesos a "RegEx"
            SetTitleMatchMode('RegEx')

            ; Guardo la Posicion actual del Mouse
            MouseGetPos(&currentX, &currentY, &currentWin)

            ; MsgBox "Current: " currentX " " currentY " id " currentWin

            ; Si Buscando con el Patron RegEx Encuentra al menos un Titulo que encaje con el patron Entra al bloque
            if (ChromeId) {
                ; MsgBox "Activando el proceso con Id: " ChromeId

                ; WinShow("ahk_id " ChromeId)
                WinMoveTop("ahk_id " ChromeId)
                Sleep(400)
                ; Muestro en la consola la Info
                OutputDebug("Se encontro una Ventana con el Titulo Youtube " . WinGetTitle("ahk_id " . ChromeId))

                ; Inicializo las Variables que guardan la Posicion dentro de el Boton "Skip\Omitir\Saltar" dentro del cliente
                ButtonX := 0
                ButtonY := 0

                ; Obtengo los datos de la Ventana del Proceso chrome.exe https://www.autohotkey.com/docs/v2/lib/WinGetPos.htm
                WinGetClientPos(&windowX, &windowY, &windowW, &windowH, "ahk_id " . ChromeId)

                ; Probando el Calculo del Escalado DPI en la Segunda Pantalla
                scale := GetProcessDpi(ChromeId) / 96 ; 96 = 100%


                RealX := 1920 + Round(1435 * scale)
                RealY := Round(580 * scale)

                ; MsgBox("Second Monitor W: " windowW " H: " windowH " offSetX: " Window_offSetx " offSetY: " Window_offSetY " Real X " RealX " Y " RealY)

                ; Probando el ImagaSearch
                try {
                    ; MsgBox("Buscando Imagen entre X1: " windowX " Y1: " windowY " X2 " A_ScreenWidth * 2 " Y2: " A_ScreenHeight)
                    if ImageSearch(&foundX, &foundY, windowX, windowY, A_ScreenWidth * 2, A_ScreenHeight, "*20 C:\Users\sebax\Desktop\Universidad\Proyectos_aleatorios\Extension_Skip_Ad_Chrome\AHK\Skip_Button_es.bmp") {
                        ; MsgBox("Se encontro la Imagen en X: " foundX " Y: " foundY)
                        ButtonX := foundX + 8
                        ButtonY := foundY + 5
                        ; Moviendo el Mouse de manera Relativa a el X y Y de la Ventana
                        Click(ButtonX,ButtonY)

                        WinActivate("ahk_id " currentWin)

                        ; MsgBox "Devolviendose a " currentX " " currentY
                        ; Moviendo a la pos Original
                        MouseMove(currentX,currentY)
                    } else if ImageSearch(&foundX, &foundY, windowX, windowY, A_ScreenWidth * 2, A_ScreenHeight, "*20 C:\Users\sebax\Desktop\Universidad\Proyectos_aleatorios\Extension_Skip_Ad_Chrome\AHK\Saltar_Activated(1).bmp") {
                        ; MsgBox("Se encontro la Imagen en X: " foundX " Y: " foundY)
                        ButtonX := foundX + 8
                        ButtonY := foundY + 5
                        ; Moviendo el Mouse de manera Relativa a el X y Y de la Ventana
                        Click(ButtonX,ButtonY)

                        WinActivate("ahk_id " currentWin)

                        ; MsgBox "Devolviendose a " currentX " " currentY
                        ; Moviendo a la pos Original
                        MouseMove(currentX,currentY)
                    }  else {
                        ; MsgBox("No se encontro la Imagen")
                        ButtonX := RealX
                        ButtonY := RealY
                    }
                } catch as e {
                    MsgBox("No se pudo buscar la Imagen o Fallo!, Error: ", e.Message)
                    ButtonX := RealX
                    ButtonY := RealY
                }

                ; Estableciendo la posicion del Boton en la Ventana
                ; Para calcular el offset utilizo como Base la resolucion 1920x1080 y le resto el ancho y alto real para obtener el valor real que necesito restar a 1920
                ; ButtonPosicions := [ButtonX, ButtonY]

                ; ButtonPos := [windowX +  windowW, windowY +  windowH]
                ; MsgBox("Moviendo a " . ButtonX . " " . ButtonY . " | " . windowW . " " . windowH)
            }
            else {

                MsgBox("No se encontro una Ventana con el titulo necesitado " )
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

; Probando el Calculo del Escalado DPI en la Segunda Pantalla
hDC := DllCall("GetDC", "ptr", WinGetID("ahk_id " . ChromeId, , regEx), "ptr")
dpi := DllCall("GetDeviceCaps", "ptr", hDC, "int", 88) ; 88 = LOGPIXELSX
DllCall("ReleaseDC", "ptr", 0, "ptr", hDC)
scale := dpi / 96 ; 96 = 100%
MsgBox "Scale Factor: " . scale
*/

/*
--- Metadatos Dentro de un video de YouTube en Segunda Pantalla y Sobre el Boton de Omitir/Saltar ---

Datos Ventana Chrome.exe:

W: 1536 H: 816 offSetX: 384 offSetY: 264

Posicion Con offset Hardcodeada

X: 3754 Y: 844

Posicion Obtenida con ImageSearch

X: 3678 Y: 722

Seleccionado dentro de la Segunda Pantalla

Mouse Position:
    Screen:	3380, 582
    Window:	1467, 589
    Client:	1460, 582 (default)
    Color:	8E949E (Red=8E Green=94 Blue=9E)

Control Under Mouse Position:
    ClassNN:	Chrome_RenderWidgetHostHWND1
    Text:	Chrome Legacy Window
    Screen:	x: 1920	y: 121	w: 1536	h: 695
    Client:	x: 0	y: 121	w: 1536	h: 695

Active Window Position:
    Screen:	x: 1913	y: -7	w: 1550	h: 830
    Client:	x: 1920	y: 0	w: 1536	h: 816

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

---------------- Seleccionado desde la Pantalla Principal

Mouse Position:
    Screen:	3370, 590
    Window:	3378, 598
    Client:	3370, 590 (default)
    Color:	8E949E (Red=8E Green=94 Blue=9E)

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