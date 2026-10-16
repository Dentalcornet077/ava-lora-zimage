@echo off
set "OUT=C:\ai-toolkit\output\ava_zimage_turbo_v1"
if not exist "%OUT%" (
    echo Todavia no hay resultados. Ejecuta primero 2_ENTRENAR.bat
    pause
    exit /b 1
)
REM Abre la carpeta con los LoRA (.safetensors) y la carpeta "samples" con las imagenes de prueba
start "" explorer "%OUT%"
if exist "%OUT%\samples" start "" explorer "%OUT%\samples"
