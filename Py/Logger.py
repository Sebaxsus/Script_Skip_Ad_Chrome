import logging, pathlib

# Creando el logger
# logger = logging.getLogger(__name__)

# Configurando el Logger
# Se establece el Nombre de el Archivo, el Formato de Impresion "Fecha - Hora -> (Nivel de Gravedad): Mensaje", Formato de Fecha y hora, codificacion del texto, Nivel de Gravedad


class Script_Logger:
    """
    
    """
    def __init__(self):
        # Inicializando un Logger y estableciendo el Nivel minimo de Escucha
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(level=logging.DEBUG)
        # logging.basicConfig(format='%(asctime)s -> %(levelname)s: %(message)s', datefmt='%m-%d %I:%M %p', encoding="utf-8", level=logging.DEBUG)
        self.formatter = logging.Formatter(fmt='%(asctime)s - %(name)s - Type: [%(levelname)s] - Msg: %(message)s', datefmt='%m-%d %I:%M %p')
        self.LogPath = pathlib.Path(__file__).parent.parent / "DataText"

        # Creando el Logger Handler para la consola
        ConsoleLogger = logging.StreamHandler()
        ConsoleLogger.setLevel(level=logging.DEBUG)
        ConsoleLogger.setFormatter(fmt=self.formatter)

        # Creando el Logger Handler para escribir los Logs en un Archivo.log
        FileLogger = logging.FileHandler(filename=f"{self.LogPath}/Skip_Ad_Logs.log")
        FileLogger.setLevel(level=logging.INFO)
        FileLogger.setFormatter(fmt=self.formatter)

        # Agregando los objetos handler al objeto Logger
        self.logger.addHandler(hdlr=ConsoleLogger)
        self.logger.addHandler(hdlr=FileLogger)

        self.logger.info("Se inicializo el Logger!")

    def get_Logger(self) -> logging.Logger:

        return self.logger
    