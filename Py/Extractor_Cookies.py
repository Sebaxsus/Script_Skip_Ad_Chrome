"""
Este Modulo es encarga de:
    1. Obtener la direccion absoluta de la carpeta `DataText`.
    2. Conectarse al `WebSocket` expuesto por Chrome usando la flag de ejecucion
        `--remote-debugging-port=9222`.
    3. Extraer la informacion en las Cookies del dominio `https://www.youtube.com`
    4. Crear y Escribir las Cookies en Formato JSON dentro de la ruta `/Extension_Skip_Ad_Chrome/DataText/youtube_cookies.json`.

**Funciones/Metodos Disponibles:**
    - ObtenerCookies
        **Parametros/Argumentos:**
            `None`
        **Retorna:**
            `None`
    - CookiesPath
        **Parametros/Argumentos:**
            `None`
        **Retorna:**
            `(str)` | Path
"""

from playwright.sync_api import sync_playwright
import json, pathlib

EXECPATH = pathlib.Path(__file__).parent.parent / "DataText"

def ObtenerCookies():
    with sync_playwright() as p:
        print("Contectando al WebSocket http://localhost:9222/ ...")
        browser = p.chromium.connect_over_cdp("http://localhost:9222")
        context = browser.contexts[0]  # Accede al contexto existente

        print("Datos encontrados ", context)

        # Accede a las cookies del dominio YouTube
        cookies = context.cookies("https://www.youtube.com")

        # Guarda cookies en archivo (opcional)
        with open(f"{EXECPATH}/youtube_cookies.json", "w", encoding="utf-8") as f:
            json.dump(cookies, f, indent=2)

        print("✅ Cookies extraídas de la sesión activa de YouTube.")

def CookiesPath() -> str:
    return f"{EXECPATH}/youtube_cookies.json"

ObtenerCookies()