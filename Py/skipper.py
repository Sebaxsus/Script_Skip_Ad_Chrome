"""
Crea una instancia nueva de chrome usando PlayWright,
Luego abre YouTube y Empieza a buscar el boton con la clase `.ytp-skip-ad-button`
Para hacerle Click si alterar tus tareas Actuales o Sacarte de tu Aplicacion actual.

Usando la API sincrona de playwright, Lanza la instancia (Proceso) de Chrome

**No usar todavia en Desarrollo**

"""

from playwright.sync_api import sync_playwright
import time, json
import playwright.sync_api
from Extractor_Cookies import CookiesPath

def BuscarBoton(page: playwright.sync_api.Page) -> bool:
    Flag = True
    # Intentar hacer clic repetidamente en el botón "Saltar anuncio"
    while Flag:
        try:
            button = page.query_selector("button.ytp-skip-ad-button")
            if button:
                print("🎯 Botón encontrado, intentando clic...")
                button.click()
                Flag = False
                return False
                break
            else:
                print("🔍 Botón no encontrado, reintentando...")
        except Exception as e:
            if ("context or browser has been closed" in e):
                return True
            print("⚠️ Error al hacer clic:", e)
        time.sleep(1)


with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)  # Puedes usar headless=True para no mostrar la ventana
    context = browser.new_context()

    # Cargando Las Cookies Guardadas
    with open(CookiesPath(), "r", encoding="utf-8") as f:
        cookies = json.load(f)
        context.add_cookies(cookies=cookies)
        print(json.dumps(context.cookies(), indent=2))

    page = context.new_page()
    
    # Ir a YouTube
    page.goto("https://www.youtube.com/")

    # Esperar un poco para que cargue el anuncio
    time.sleep(5)
    Pagina_Cerrada = False
    while Pagina_Cerrada == False:
        Pagina_Cerrada = BuscarBoton(page)
        # Esperar para observar el resultado
        time.sleep(60)

    browser.close()
