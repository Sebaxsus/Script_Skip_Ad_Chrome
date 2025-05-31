from playwright.sync_api import sync_playwright
import time

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)  # Puedes usar headless=True para no mostrar la ventana
    context = browser.new_context()
    page = context.new_page()
    
    # Ir a un video de YouTube
    page.goto("https://www.youtube.com/watch?v=IYOfGK5Zos4")

    # Esperar un poco para que cargue el anuncio
    time.sleep(5)

    # Intentar hacer clic repetidamente en el botón "Saltar anuncio"
    for _ in range(100):
        try:
            button = page.query_selector("button.ytp-skip-ad-button")
            if button:
                print("🎯 Botón encontrado, intentando clic...")
                button.click()
                break
            else:
                print("🔍 Botón no encontrado, reintentando...")
        except Exception as e:
            print("⚠️ Error al hacer clic:", e)
        time.sleep(1)

    # Esperar para observar el resultado
    time.sleep(5)
    browser.close()
