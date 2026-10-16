@echo off
setlocal
title Paso 1 - Instalar AI-Toolkit para el LoRA de Ava
set "REPO=%~dp0"
set "AITK=C:\ai-toolkit"

echo.
echo ============================================================
echo   PASO 1: Instalar AI-Toolkit y preparar las fotos de Ava
echo ============================================================
echo.

REM ---- 1. Comprobar Git ----
where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git no esta instalado.
    echo         Descargalo de https://git-scm.com/download/win
    echo         instalalo con las opciones por defecto y vuelve a abrir este archivo.
    pause
    exit /b 1
)
echo [OK] Git encontrado.

REM ---- 2. Comprobar la tarjeta NVIDIA ----
where nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo [AVISO] No se encontro nvidia-smi. Actualiza el driver de NVIDIA antes de seguir.
) else (
    echo [OK] Tarjeta grafica detectada:
    nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader
)
echo.

REM ---- 3. Descargar AI-Toolkit en C:\ai-toolkit ----
if exist "%AITK%\run_windows.bat" (
    echo [OK] AI-Toolkit ya esta descargado en %AITK%
) else (
    echo Descargando AI-Toolkit en %AITK% ...
    git clone https://github.com/ostris/ai-toolkit.git "%AITK%"
    if errorlevel 1 (
        echo [ERROR] No se pudo descargar AI-Toolkit. Revisa tu conexion a internet.
        pause
        exit /b 1
    )
)

REM ---- 4. Copiar las fotos y sus descripciones ----
if not exist "%AITK%\datasets\ava" mkdir "%AITK%\datasets\ava"
copy /Y "%REPO%dataset\*.png" "%AITK%\datasets\ava\" >nul
copy /Y "%REPO%dataset\*.txt" "%AITK%\datasets\ava\" >nul
echo [OK] Fotos copiadas a %AITK%\datasets\ava

REM ---- 5. Copiar las configuraciones (16 GB y 8 GB) con la ruta correcta ----
set "DS=%AITK:\=/%/datasets/ava"
for %%F in ("%REPO%config\*.yaml") do (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "$t = [IO.File]::ReadAllText('%%~fF').Replace('__DATASET__','%DS%');" ^
      "[IO.File]::WriteAllText('%AITK%\config\%%~nxF', $t, (New-Object Text.UTF8Encoding $false))"
    if errorlevel 1 (
        echo [ERROR] No se pudo copiar la configuracion %%~nxF
        pause
        exit /b 1
    )
    echo [OK] Configuracion copiada: %AITK%\config\%%~nxF
)
echo.

REM ---- Modo sin interfaz (para Codex u otros asistentes): 1_INSTALAR.bat sinui ----
if /i "%~1"=="sinui" goto :sinui

REM ---- 6. Instalar dependencias y abrir la interfaz ----
echo ============================================================
echo   Ahora se instala Python, PyTorch y todo lo demas.
echo   La primera vez tarda entre 10 y 30 minutos. NO cierres esta ventana.
echo.
echo   Cuando termine se abrira el navegador en http://localhost:8675
echo   Si ves esa pagina: la instalacion FUNCIONO. Ya puedes cerrar
echo   el navegador y esta ventana, y seguir con 2_ENTRENAR.bat
echo ============================================================
echo.
call "%AITK%\run_windows.bat"
exit /b

:sinui
echo Instalando dependencias sin abrir la interfaz web...
set PYTHONPATH=
set PYTHONHOME=
set VIRTUAL_ENV=
set CONDA_PREFIX=
set "PY="
for %%C in (python.exe py.exe) do (
    if not defined PY (
        %%C -c "import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)" >nul 2>&1
        if not errorlevel 1 set "PY=%%C"
    )
)
if not defined PY (
    echo [ERROR] No hay Python 3.9+ en el sistema. Instala Python 3.12
    echo         ^(winget install -e --id Python.Python.3.12^) o usa: 1_INSTALAR.bat  sin parametros.
    exit /b 1
)
cd /d "%AITK%"
"%PY%" -m manager install
if errorlevel 1 (
    echo [ERROR] Fallo la instalacion. Revisa los mensajes de arriba.
    exit /b 1
)
echo [OK] Instalacion terminada. Ahora ejecuta 2_ENTRENAR.bat
exit /b 0
