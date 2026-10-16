@echo off
setlocal
title Paso 2 - Entrenar el LoRA de Ava
set "AITK=C:\ai-toolkit"

REM Evita que otro Python instalado en el sistema se meta en medio
set PYTHONPATH=
set PYTHONHOME=
set VIRTUAL_ENV=
set CONDA_PREFIX=

if not exist "%AITK%\config\ava_zimage_turbo.yaml" (
    echo [ERROR] No encuentro la configuracion. Ejecuta primero 1_INSTALAR.bat
    pause
    exit /b 1
)

set "PY="
if exist "%AITK%\.venv\Scripts\python.exe" set "PY=%AITK%\.venv\Scripts\python.exe"
if not defined PY if exist "%AITK%\venv\Scripts\python.exe" set "PY=%AITK%\venv\Scripts\python.exe"
if not defined PY (
    echo [ERROR] AI-Toolkit no esta instalado del todo. Ejecuta primero 1_INSTALAR.bat
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   PASO 2: Entrenando el LoRA de Ava (3000 pasos)
echo.
echo   - La primera vez descarga el modelo Z-Image Turbo (~20 GB).
echo   - Despues veras una barra de progreso con los pasos.
echo   - En una RTX 4080 tarda aprox. 1.5 a 3 horas.
echo   - Cada 250 pasos guarda un LoRA y unas imagenes de prueba en:
echo       %AITK%\output\ava_zimage_turbo_v1
echo   - Para pausar: Ctrl+C (espera a que no este guardando).
echo     Al volver a abrir este archivo continua donde se quedo.
echo ============================================================
echo.

cd /d "%AITK%"
"%PY%" run.py config\ava_zimage_turbo.yaml

echo.
echo Entrenamiento terminado (o detenido). Abre 3_VER_RESULTADOS.bat
pause
