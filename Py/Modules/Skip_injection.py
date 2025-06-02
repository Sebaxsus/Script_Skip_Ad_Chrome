import time, playwright.sync_api, os, logging
from playwright.sync_api import sync_playwright

class Skip_Script:
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

    **Constructor**
        **logger:** `(object logging.Logger)`

    **Metodos Disponibles:**
        clearScreen()
        BuscarBoton()
        main()
    """
    def __init__(self, logger: logging.Logger):
        self.logger = logger
        self.Anuncios_Saltados = 0

    def clearScreen(self):
        """Borra la pantalla en Windows o Linux/Mac."""
        if os.name == 'nt': # Windows
            os.system('cls')
        else: # Linux/Mac
            os.system('clear')

    def BuscarBoton(self, page: playwright.sync_api.Page) -> bool:
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

        Flag = True
        # Intentar hacer clic repetidamente en el botón "Saltar anuncio"
        while Flag:
            try:
                button = page.query_selector("button.ytp-skip-ad-button")
                if button:
                    self.clearScreen()
                    self.logger.debug("🎯 Botón encontrado, intentando clic...")
                    button.click()
                    self.Anuncios_Saltados += 1
                    Flag = False
                    return False
                else:
                    # logger.debug("🔍 Botón no encontrado, reintentando...")
                    pass
            except Exception as e:
                if "context or browser has been closed" in str(e):
                    self.clearScreen()
                    self.logger.info(f"🚪 Contexto o navegador cerrado.\nAnuncios Saltados: {self.Anuncios_Saltados}")
                    return True
                elif "Execution context was destroyed" in str(e):
                    # Si la pagina ya no es de YouTube Cerrando el Script :)
                    if "youtube.com" not in page.url:
                        self.logger.info(f"La página ya no es YouTube.\nAnuncios Saltados: {self.Anuncios_Saltados}")
                        return True
                    self.logger.warning("⚠️ El contexto de ejecución fue destruido. La página probablemente cambió o recargó. Reintentando en breve...")
                else:  
                    self.logger.exception(msg="⚠️ Error al hacer clic:",exc_info=e)
            time.sleep(1)

    def Buscar_pestañaYT(self, browser: playwright.sync_api.Browser) -> playwright.sync_api.Page | None:
        """
        Metodo para buscar una pestaña de YouTube dentro 
        de las pestañas de una Instancia de Chrome,

        Si encuentra una Devuelve el objeto `playwright.sync_api.Page`
        Si no encuentra una Devuelve `None`.

        **Parametros/Argumentos:**
            **browser:** `(object playwright.sync_api.BrowserContext)`

        **Retornar/Devuelve:**
            `(object playwright.sync_api.Page | None)`
        """
        for context in browser.contexts:
            print(f"Context: ", context.pages)
            for page in context.pages:
                if "youtube.com" in page.url:
                    return page
            
        return None

    def main(self):
        with sync_playwright() as p:
            # Intentando conectarse al socket de Chrome DevTools Protocol
            # Hace 5 intentos con una espera de 30 segundos entre intento
            for _ in range(5):
                try:
                    self.logger.debug("Contectando al WebSocket http://localhost:9222/ ...")
                    # Conectar con el navegador ya abierto
                    browser = p.chromium.connect_over_cdp("http://localhost:9222/")
                    self.logger.info("Se conecto al WebSocket de CDP: http://localhost:9222/")
                    self.logger.debug(f"Datos encontrados")
                    # Si se conecta sale de el Loop
                    break
                except Exception as e:
                    self.logger.debug("No se pudo conectar al WebSocket, Reintentando en 10 Segundos...")
                    time.sleep(10)
            # Si no se conecta correctamente y obtiene un browser Termina el Loop
            if not browser or not browser.is_connected():
                self.logger.exception(msg="No se pudo conectar al WebSocket",exc_info=e)
                return
            
            # Buscando la pestaña con YouTube
            # En caso de no encontrarla lo reintenta depues de 30 segundos 5 veces
            for _ in range(5):
                browser = p.chromium.connect_over_cdp("http://localhost:9222/")
                self.logger.debug(f"Buscando una pestaña de YouTube")
                youtube_page = self.Buscar_pestañaYT(browser)
                # self.logger.debug(f"Termino de buscar {youtube_page}")
                if not youtube_page:
                    self.logger.debug(f"No se encontro ninguna pestaña de YouTube, Reintentando en 30 segundos")
                    time.sleep(30)
                else:
                    self.logger.debug("Se encontro una pestaña con YouTube")
                    break
            
            # Verificando que halla encontrado una pestaña de YouTube
            # Si no la encontro Termina el Loop
            if not youtube_page:
                self.logger.info("No se encontro ninguna pestaña de YouTube, Cerrando Programa.")
                return
            
            youtube_page.bring_to_front()

            while True:
                if self.BuscarBoton(youtube_page):
                    break
                # Esperar 30 Segundos antes de Volver a buscar el boton de Skip.
                self.logger.debug("Se salto un anuncio Con exito!")
                time.sleep(30)
            
            return