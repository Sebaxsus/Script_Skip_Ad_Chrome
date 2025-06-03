# Este Proyecto esta pensado para automatizar el comportamiento de "Saltar" un anuncio en la Plataforma de YouTube

> [!IMPORTANT]
> **DISCLAIMER**
>
> Este proyecto no esta pensado para el publico en general,
> Actualmente requiere conocimientos tecnicos para su correcta configuracion y manejo

> [!WARNING]
> **Aviso de Manejo de Datos**
>
> Para poder utilizar una instancia de Chrome con el puerto de depuracion abierto con la Sesion de YouTube en Python puede llegar a usarse las **COOKIES** de tu sesion en YouTube.
>
> Por ende este **Aviso** se hace con la finalidad de **INFORMAR** que se pueden estar extrayendo las **COOKIES** de tu sesion local, Esto **NO** quiere decir que se subira a la nube o se enviara a un servidor, Las Cookies se almacenan en la misma Carpeta del Proyecto Bajo el Directorio `./Extension_Skip_Ad_Chrome/DataText/youtube_cookies.json`.

---

## Tabla de Contenidos

1. [Disclaimer.](#este-proyecto-esta-pensado-para-automatizar-el-comportamiento-de-saltar-un-anuncio-en-la-plataforma-de-youtube)
2. [Tabla de Contenidos.](#tabla-de-contenidos)
3. [Requisitos.](#Requisitos)
4. [Instalación.](#Instalación)
5. [Configuración.](#Configuración)

---

## Requisitos

**Para ejecutar el script de AHK:**
- Se necesita tener instalado en la maquina **HOST** [AutoHotKey V 2.0^](https://www.autohotkey.com/)

**Para ejecutar el script de Python:**
- Tener Python [3.12.0^](https://www.python.org/downloads/)
- Tener un Navegador basado en **Chromium**
- Poder Obtener la Ruta (Path) de el Ejecutable de tu navegador basado en **Chromium**
- Poder activar el **Puerto de depuración remota**

---

## Instalación

1. **Clona el repositorio**

```bash
git clone https://github.com/Sebaxsus/Script_Skip_Ad_Chrome.git
cd Script_Ad_Chrome/
```

2. **Crear un Entorno Virtual**

> [!TIP]
>
> Crear el entorno virtual es **OPCIONAL** pero es muy recomendable ya que
> las librerias y dependencias se descargarian ahi, Esto permite mantener tu maquina segura en contra de vulnerabilidades que puedan tener las Librerias/Dependencias.

```bash
python -m venv .Nombre_del_entorno
.Nombre_del_entorno\Scripts\activate
```

**Ó**

```bash
uv venv .Nombre_del_entorno
.Nombre_del_entorno\Scripts\activate
```

3. **Instalar las dependencias**

```bash
:: Con un entorno virtal de Python.
pip install -r requirements.txt

:: Con un entorno virtual de UV
uv pip install -r requirements.txt
```

---

## Configuración

Se debe definir las siguientes variables de entorno `.env` o en `settings.py`:

> [!TIP]
>
> Si se necesita verificar si esta instalado en la unidad/disco `C` Usa:
>
> ```bash
>   where /r "c:\Program Files\Google\Chrome\Application" chrome.exe
> ```

- `CHROME_PATH`: La ruta absoluta al directorio en donde esta el ejecutable de chrome `chrome.exe`.
- `CHROME_USER_DATA:`: La ruta absoluta al directorio en donde esta la Carpeta `ChromeDebug` **Normalmente esta a nivel de Unidad** `C:\ChromeDebug`.
- `ENV_PATH`: **OPCIONAL** Ruta absoluta al ejecutable del entorno Virtual `Unidad:\Path\Entorno_Virtual\Scripts\python.exe`.
- `SCRIPT_PATH`: **OPCIONAL** Ruta absoluta al `main.py` del proyecto.

---

# To do
- [x] Toda la doc de Python y su Instalacion
- [ ] Manual de Instalacion para AHK
- [ ] Usar UV en lugar de `python -m venv` 🫠
## Tener En cuenta que el Script se Diseño para ser Usado en un Segunda Pantalla

- Se requiere tener AHK 2.0^