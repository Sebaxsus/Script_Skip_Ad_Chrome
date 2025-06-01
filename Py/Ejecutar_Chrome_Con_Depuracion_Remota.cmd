@echo off
title Instancia de Chrome - Ejecutando

echo Ejecutando chrome.exe --remote-debugging-port=9222 --user-data-dir="C:\ChromeDebug"

"C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --user-data-dir="C:\ChromeDebug"

echo.
echo El script ha terminado. Presiona cualquier tecla para cerrar.
pause >nul