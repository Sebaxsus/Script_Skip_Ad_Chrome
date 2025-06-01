"""
Este script se creo con la intencion de Inyectarse a una Instancia de Google Chrome,
En lugar de eso se termino conectando a una Instancia de Chrome con un `puerto de Depuracion` **Activo**

Gracias a esto se puede conectar a Chrome por medio de un `WebSocket` con el Puerto `9222`.

El Flujo de este script es
    -> Se ejecuta el Script.
    -> Se intenta Conectar a una Instancia de Chrome usando Chrome DevTools Protocol.
    -> Extrae la primera Instancia/Contexto que encuentre.
    -> Busca dentro de las Pestañas/Ventanas la que este en la URL `https://youtube.com` dentro de la Instancia.
    -> Establece la Pestaña/Ventana de YouTube Como la principal (La que esta seleccionada)
-----> Empieza el Loop Principal
|   -> Llama la funcion `BuscarBoton` que devuelve `False` al Clickear el Boton y `True` al Detectar que se cerro la Instancia.
|   -> Limpia la consola al Encontrar un Boton
|   -> Activa la funcion Nativa de un Boton Click()
|   -> devuelve `False`
| <-|    

**Metodos Disponibles:**
    clearScreen()
    BuscarBoton()
    main()
"""

import asyncio, time, playwright.sync_api, os
from playwright.sync_api import sync_playwright

Anuncios_Saltados = 0

def clearScreen():
    """Borra la pantalla en Windows o Linux/Mac."""
    if os.name == 'nt': # Windows
        os.system('cls')
    else: # Linux/Mac
        os.system('clear')

def BuscarBoton(page: playwright.sync_api.Page) -> bool:
    """
    Usando una Pagina de Chrome busca un Elemento de HTML `button`
    con la clase `ytp-skip-ad-button`.

    Si encuentra el boton:
        Limpia la consola.
        Muestra el mensaje '🎯 Botón encontrado, intentando clic...'
        hace Click al boton usando el metodo Nativo del Elemento .click()
        Devuelve `(bool) False`
    Si no encuentra el boton:
        Vuelve a buscar el boton tras pasar 1 segundo

    **Parametros/Argumentso:**
        **page:**
    """
    global Anuncios_Saltados
    Flag = True
    # Intentar hacer clic repetidamente en el botón "Saltar anuncio"
    while Flag:
        try:
            button = page.query_selector("button.ytp-skip-ad-button")
            if button:
                clearScreen()
                print("🎯 Botón encontrado, intentando clic...")
                button.click()
                Anuncios_Saltados += 1
                Flag = False
                return False
                break
            else:
                print("🔍 Botón no encontrado, reintentando...")
        except Exception as e:
            if ("context or browser has been closed" in str(e)):
                clearScreen()
                print("🚪 Contexto o navegador cerrado.\nAnuncios Saltados: ", Anuncios_Saltados)
                return True
            print("⚠️ Error al hacer clic:", e)
        time.sleep(1)

def main():
    with sync_playwright() as p:
        try:
            print("Contectando al WebSocket http://localhost:9222/ ...")
            # Conectar con el navegador ya abierto
            browser = p.chromium.connect_over_cdp("http://localhost:9222/")
            context = browser.contexts[0]

            print("Datos encontrados ", context.pages)
        except Exception as e:
            print("No se pudo conectar al WebSocket")
            return

        # Buscando la pestaña con YouTube
        youtube_page = None
        for page in context.pages:
            if "youtube.com" in page.url:
                youtube_page = page
                break

        if not youtube_page:
            print("No se encontro ninguan pestaña de YouTube")
            return
        
        youtube_page.bring_to_front()

        while True:
            if BuscarBoton(youtube_page):
                break
            time.sleep(5)

main()