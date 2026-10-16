@echo off
setlocal
title Paso 2 - Entrenar el LoRA de Ava
set "AITK=C:\ai-toolkit"

REM Evita que otro Python instalado en el sistema se meta en medio
set PYTHONPATH=
set PYTHONHOME=
set VIRTUAL_ENV=
set CONDA_PREFIX=

REM ---- Elegir la configuracion segun la memoria de la tarjeta (VRAM) ----
REM Menos de 12 GB usa la de 8 GB. Se puede forzar con:
REM   2_ENTRENAR.bat 8gb     o     2_ENTRENAR.bat 16gb
set "CFG=ava_zimage_turbo.yaml"
set "VRAM=0"
for /f "usebackq tokens=1" %%M in (`nvidia-smi --query-gpu^=memory.total --format^=csv^,noheader^,nounits 2^>nul`) do if "%VRAM%"=="0" set "VRAM=%%M"
if %VRAM% GTR 0 if %VRAM% LSS 12000 set "CFG=ava_zimage_turbo_8gb.yaml"
if /i "%~1"=="8gb" set "CFG=ava_zimage_turbo_8gb.yaml"
if /i "%~1"=="16gb" set "CFG=ava_zimage_turbo.yaml"
echo VRAM detectada: %VRAM% MB  -  configuracion elegida: %CFG%

if not exist "%AITK%\config\%CFG%" (
    echo [ERROR] No encuentro %AITK%\config\%CFG%. Ejecuta primero 1_INSTALAR.bat
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
echo   - Tarda aprox. 1.5 a 3 horas con 16 GB, o 3 a 6 horas con 8 GB.
echo   - Cada 250 pasos guarda un LoRA (y imagenes de prueba) en:
echo       %AITK%\output\ava_zimage_turbo_v1
echo   - Para pausar: Ctrl+C (espera a que no este guardando).
echo     Al volver a abrir este archivo continua donde se quedo.
echo ============================================================
echo.

cd /d "%AITK%"
"%PY%" run.py "config\%CFG%"

echo.
echo Entrenamiento terminado (o detenido). Abre 3_VER_RESULTADOS.bat
pause
