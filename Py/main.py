import subprocess, sys, logging, time
from settings import CHROME_PATH,CHROME_USER_DATA,LOG_PATH
from Modules.Skip_injection import Skip_Script
from Modules.Logger import Script_Logger

def run_chrome(logger: logging.Logger):
    CHROME_ARGS = ["--remote-debugging-port=9222",f"--user-data-dir={CHROME_USER_DATA}"]
    try:
        subprocess.Popen([CHROME_PATH,*CHROME_ARGS])

        logger.info("Se inicio Chrome con el Puerto de depuracion correctamente!")
    except Exception as e:
        logger.exception(msg="No se pudo iniciar Chrome Cerrando el Programa!: ", exc_info=e)

        sys.exit(1)

if __name__ == "__main__":
    # Inicializando la clase Script_Logger y obteniendo el Objeto logger generado
    logger = Script_Logger(logPath=LOG_PATH).get_Logger()
    # Inicializando la Clase Skip_Script
    script = Skip_Script(logger)
    # Ejecutando un subproceso de chrome
    run_chrome(logger)
    # Esperando 5 segundos para permitir que se instancie Chrome
    time.sleep(5)
    # Ejecutando el Script para Saltar Anuncios en YouTube
    script.main()

    logger.info("Se termino la ejecucion!")
