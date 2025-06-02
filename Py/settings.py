import os, pathlib, dotenv, sys

# Vuelvo el path absoluto de la carpeta que contiene el Script
BASE_DIR = pathlib.Path(__file__).resolve().parent
ENV_DIR = f"{BASE_DIR}\\.env"

# Agregando el path de la carpeta modules para importar los modulos
# sys.path.append(str(BASE_DIR / "Modules"))

# Cargando las varaibles de entorno si Existen
dotenv.load_dotenv(ENV_DIR)

CHROME_PATH = os.getenv("CHROME_PATH", r"C:\Program Files\Google\Chrome\Application\chrome.exe")

CHROME_USER_DATA = os.getenv("CHROME_USER_DATA", r"C:\ChromeDebug")

LOG_PATH = BASE_DIR / "logs"

# Asegura que el directorio de logs existe
LOG_PATH.mkdir(parents=True, exist_ok=True)