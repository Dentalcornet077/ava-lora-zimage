# Prompt para instalar y entrenar con Codex

Copia **todo** el bloque de abajo y pégalo en Codex (con permisos de *acceso completo*,
ver la sección "Opción B" del README).

```text
Háblame siempre en español y con palabras sencillas: no sé de programación, solo estoy ayudando.

OBJETIVO
Instalar y ejecutar en esta PC con Windows el entrenamiento de un LoRA del personaje "Ava" para
Z-Image Turbo, usando este repo, que ya trae todo preparado (fotos, descripciones, configuraciones
y scripts): https://github.com/Dentalcornet077/ava-lora-zimage
Lee primero su README.md completo. Usa los scripts del repo; no inventes otro método.

REGLAS
- Haz UN paso a la vez. Al terminar cada paso dime en 2-3 líneas qué hiciste, cómo comprobaste
  que funcionó y espera a que yo diga "sigue" antes del siguiente.
- No cambies los ajustes de entrenamiento (pasos, lr, rango, captions) salvo que haga falta por
  falta de memoria, y avísame antes.
- No borres nada fuera de C:\ai-toolkit y de la carpeta del repo. Pregúntame antes de borrar
  cualquier cosa o de instalar programas en el sistema (Git, Python, drivers).
- No me pidas contraseñas ni tokens: el modelo es público y no hace falta cuenta de Hugging Face.
- Los comandos largos (instalación de 10-30 min, entrenamiento de horas) ejecútalos en segundo
  plano o en una ventana aparte, y comprueba el avance mirando archivos, no esperando sin más.

PASO 0 - Diagnóstico (solo leer, no instalar nada)
Dime: modelo de tarjeta NVIDIA, VRAM y versión del driver (nvidia-smi), RAM total, espacio libre
en C:, y si están instalados git y python (versiones).
Mínimos: NVIDIA con 8 GB de VRAM o más, 32 GB de RAM recomendados, 60 GB libres en C:.
Si algo no llega, dímelo y explícame qué hacer antes de seguir.
Con menos de 12 GB de VRAM se usará la configuración de 8 GB (el script la elige solo).

PASO 1 - Descargar el repo
git clone https://github.com/Dentalcornet077/ava-lora-zimage.git en el Escritorio del usuario.
Comprueba: la carpeta dataset tiene 60 archivos (30 .png y 30 .txt) y config tiene 2 .yaml.

PASO 2 - Instalar AI-Toolkit
Ejecuta desde la carpeta del repo:  1_INSTALAR.bat sinui
(clona AI-Toolkit en C:\ai-toolkit, copia fotos y configuraciones, e instala Python/PyTorch.
El modo "sinui" necesita Python 3.9+ en el sistema; si no hay, pídeme permiso para instalarlo con
winget install -e --id Python.Python.3.12 , o ejecuta 1_INSTALAR.bat sin parámetros, que lo
instala solo pero al final abre la web http://localhost:8675 y se queda abierto).
Comprueba:
  a) C:\ai-toolkit\.venv\Scripts\python.exe existe.
  b) C:\ai-toolkit\.venv\Scripts\python.exe -c "import torch; print(torch.__version__, torch.cuda.is_available(), torch.cuda.get_device_name(0))"
     debe decir True y el nombre de la tarjeta.
  c) C:\ai-toolkit\datasets\ava tiene 60 archivos.
  d) C:\ai-toolkit\config tiene ava_zimage_turbo.yaml y ava_zimage_turbo_8gb.yaml, y su
     folder_path es "C:/ai-toolkit/datasets/ava".
Si algo falla, ejecuta en C:\ai-toolkit:  python -m manager doctor  y explícame el resultado.

PASO 3 - Entrenar
Ábrelo en una ventana aparte para que siga aunque cierres la sesión:
  start "Entrenar Ava" cmd /k "cd /d <carpeta del repo> && 2_ENTRENAR.bat"
Explícame que primero descarga ~20 GB (el modelo) y luego empiezan 3000 pasos.
Comprueba cada cierto tiempo:
  - que crece %USERPROFILE%\.cache\huggingface\hub\models--Tongyi-MAI--Z-Image-Turbo (descarga),
  - que aparece C:\ai-toolkit\output\ava_zimage_turbo_v1 con imágenes en samples\ y
    archivos .safetensors cada 250 pasos.
Pregúntame qué muestra la ventana si no ves avance en 20 minutos.

SI SALE "CUDA out of memory"
  - Con 16 GB: cierra la ventana y relanza con  2_ENTRENAR.bat 8gb
  - Con 8 GB: en C:\ai-toolkit\config\ava_zimage_turbo_8gb.yaml sube
    layer_offloading_transformer_percent de 0.6 a 0.8 (o 1.0); si sigue, cambia
    resolution: [512, 768] por resolution: [512]. Avísame antes de cambiarlo.
  - Al relanzar, el entrenamiento continúa desde el último guardado.

PASO 4 - Resultado
Cuando termine, lista los .safetensors de C:\ai-toolkit\output\ava_zimage_turbo_v1 y ayúdame a
elegir el mejor mirando las imágenes de samples (el número del nombre es el paso; suele ser el de
2000-3000). Pregúntame dónde está ComfyUI y copia el elegido a ComfyUI\models\loras.
Luego explícame cómo usarlo según la sección "Paso 5" del README.
```
