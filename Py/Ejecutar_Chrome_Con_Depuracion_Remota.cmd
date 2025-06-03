@echo off
setlocal

:: Buscando Chrome en la Unidad c:

for /f "delims=" %%C in ("where /r %ProgramFiles%\Google\Chrome\Application chrome.exe") do (
    set "CHROME_PATH=%%C"
    if exist "c:\ChromeDebug" (
        set "CHROME_USER_DATA=C:\ChromeDebug"
    ) else (
        echo Se encontro chrome pero no ChromeDebug, Creando el Directorio...
        set "CHROME_USER_DATA=C:\ChromeDebug"
    )
    goto found
)

echo Chrome no fue encontrado
goto end

:found
echo Chrome encontrado en: %CHROME_PATH%

:: set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
:: set "CHROME_USER_DATA=C:\ChromeDebug"
set "VENV_PYTHON=C:\Users\sebax\Desktop\Universidad\Proyectos_aleatorios\Extension_Skip_Ad_Chrome\Py\EnvVirtual\Scripts\python.exe"
set "SCRIPT_PATH=C:\Users\sebax\Desktop\Universidad\Proyectos_aleatorios\Extension_Skip_Ad_Chrome\Py\main.py"

title Iniciando Chrome y Script de Playwright

echo Iniciando Chrome con puerto de depuración...
start "" "%CHROME_PATH%" --remote-debugging-port=9222 --user-data-dir="%CHROME_USER_DATA%"

echo Esperando que Chrome cargue...
timeout /t 5 >nul

echo Iniciando script de Python...
"%VENV_PYTHON%" "%SCRIPT_PATH%"



:end
pause