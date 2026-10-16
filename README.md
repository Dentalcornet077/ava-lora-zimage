# LoRA de "Ava" para Z-Image Turbo

Todo lo necesario para entrenar, **en tu propia PC con Windows**, un LoRA del personaje
*Ava* (pelirroja, pelo rizado) y usarlo después en ComfyUI con Z-Image Turbo.

> **¿Qué es un LoRA?** Un archivo pequeño (unos 80–170 MB) que "enseña" al modelo de imágenes
> a dibujar siempre a la misma persona. Después, en ComfyUI, escribes `ava_lora` en el prompt
> y sale Ava.

Este repo ya trae:

| Carpeta / archivo | Qué es |
|---|---|
| `dataset/` | Las 30 fotos de Ava + un `.txt` por foto con su descripción (ya escritas) |
| `config/ava_zimage_turbo.yaml` | Ajustes del entrenamiento para tarjetas de **12–16 GB o más** (ej. RTX 4080) |
| `config/ava_zimage_turbo_8gb.yaml` | Ajustes para tarjetas de **8 GB** (ej. RTX 3060 Ti, 3070, 4060) |
| `CODEX_PROMPT.md` | Prompt listo para que **Codex** haga la instalación por ti |
| `1_INSTALAR.bat` | Instala todo (doble clic) |
| `2_ENTRENAR.bat` | Entrena el LoRA (doble clic). Detecta solo si tu tarjeta es de 8 o de 16 GB |
| `3_VER_RESULTADOS.bat` | Abre la carpeta con los LoRA y las imágenes de prueba |

Se usa **[AI-Toolkit de Ostris](https://github.com/ostris/ai-toolkit)**, la herramienta gratuita más
usada para entrenar LoRAs de Z-Image Turbo.

---

## Lo que necesitas

- Windows 10/11 con tarjeta **NVIDIA de 8 GB o más** de VRAM (memoria de video).
  - **8–11 GB:** se usa la configuración de 8 GB (más lenta: 3–6 horas). **Necesita 32 GB de RAM** sí o sí,
    porque parte del modelo se mueve a la RAM.
  - **12 GB o más:** configuración normal (1.5–3 horas en una RTX 4080).
  - Menos de 8 GB: no funciona.
- **Unos 60 GB libres en el disco C:** (el programa ~10 GB + el modelo ~20 GB + resultados).
- **32 GB de RAM** recomendados (con 16 GB puede ir muy lento o fallar).
- Internet (la primera vez se descargan unos 30 GB en total).
- 3–4 horas libres la primera vez (casi todo es esperar).

---

## Opción B — Que lo instale Codex por ti

Si tienes **Codex** (el asistente de OpenAI: app de escritorio, extensión de VS Code o `codex` en la terminal):

1. Ábrelo en cualquier carpeta (por ejemplo el Escritorio).
2. En los permisos elige **acceso completo / Full access** (si no, no puede descargar ni instalar en `C:\ai-toolkit`).
3. Abre [`CODEX_PROMPT.md`](CODEX_PROMPT.md), copia el bloque completo y pégalo en Codex.
4. Codex irá paso a paso y te pedirá confirmación entre cada paso. Responde "sigue" cuando esté bien.

Si prefieres hacerlo tú mismo, sigue los pasos de abajo (Opción A).

---

## Opción A — Paso a paso a mano

## Paso 0 — Preparar la PC

1. **Actualiza el driver de NVIDIA.** Abre la app *NVIDIA App* (o *GeForce Experience*) → Drivers → instala el más reciente.
   O descárgalo de <https://www.nvidia.com/Download/index.aspx>. Reinicia la PC después.
2. **Instala Git**: <https://git-scm.com/download/win> → descarga el instalador de 64 bits →
   siguiente, siguiente, siguiente (deja todo por defecto).

✅ **Comprueba:** abre el menú Inicio, escribe `cmd`, ábrelo y escribe:

```
git --version
nvidia-smi
```

Debe salir algo como `git version 2.x` y una tabla con el nombre de tu tarjeta y su memoria
(ej. **RTX 4080 … 16376MiB** o **RTX 4060 … 8188MiB**).
Si `nvidia-smi` da error, el driver no está bien instalado.

---

## Paso 1 — Descargar este repo

1. Arriba en esta página pulsa el botón verde **`<> Code`** → **Download ZIP**.
2. Ve a *Descargas*, clic derecho al ZIP → **Extraer todo…** → extráelo, por ejemplo, en el Escritorio.

✅ **Comprueba:** dentro de la carpeta extraída ves `1_INSTALAR.bat`, `2_ENTRENAR.bat` y la carpeta `dataset`
con 60 archivos (30 `.png` y 30 `.txt`).

---

## Paso 2 — Instalar AI-Toolkit

1. Doble clic en **`1_INSTALAR.bat`**.
   - Si Windows muestra *"Windows protegió su PC"*: pulsa **Más información → Ejecutar de todas formas**.
2. El script:
   - descarga AI-Toolkit en `C:\ai-toolkit`,
   - copia las fotos a `C:\ai-toolkit\datasets\ava`,
   - copia las dos configuraciones (16 GB y 8 GB) a `C:\ai-toolkit\config\`,
   - instala Python, PyTorch y lo demás (**10–30 minutos**, no cierres la ventana negra).
3. Al final se abre el navegador en `http://localhost:8675` (la interfaz web de AI-Toolkit).

✅ **Comprueba:** ves la página de AI-Toolkit en el navegador. **¡Instalación lista!**
Cierra el navegador y la ventana negra.

❌ **Si falla:** haz una captura de pantalla de la ventana negra (las últimas 20 líneas) y pide ayuda con ella.
Problemas típicos: sin espacio en disco, antivirus bloqueando la descarga, o driver de NVIDIA viejo.

---

## Paso 3 — Entrenar

1. Doble clic en **`2_ENTRENAR.bat`**.
2. La **primera vez** descarga el modelo Z-Image Turbo desde Hugging Face (~20 GB). Puede tardar un buen rato.
3. Luego prepara las fotos (unos minutos) y empieza una barra así:

   ```
   ava_zimage_turbo_v1:  12%|███▌        | 360/3000 [09:40<1:10:12, 1.6s/it, lr: 1.0e-04 loss: 3.2e-01]
   ```

   - `360/3000` = paso actual de 3000.
   - `1:10:12` = tiempo que falta (aprox.). Total: **1.5 – 3 horas** con 16 GB, **3 – 6 horas** con 8 GB.
   - Arriba del todo dice qué configuración eligió (`ava_zimage_turbo.yaml` o `ava_zimage_turbo_8gb.yaml`).
4. **Cada 250 pasos** guarda un LoRA. Las 4 imágenes de prueba se generan cada 250 pasos (16 GB) o cada 500 (8 GB).

✅ **Comprueba (a los ~15 min):** la barra avanza y el número de pasos sube.
Abre **`3_VER_RESULTADOS.bat`** → carpeta `samples`: verás las imágenes de prueba.

- **Puedes pausar** con `Ctrl + C` (espera a que no diga "Saving"). Al abrir otra vez `2_ENTRENAR.bat`
  sigue donde se quedó.
- ❌ **Si sale `CUDA out of memory`** (falta memoria en la tarjeta): cierra todo lo demás (juegos, ComfyUI,
  Chrome con muchas pestañas) y vuelve a abrir `2_ENTRENAR.bat`. Si sigue:
  - **Tarjeta de 12–16 GB:** usa la configuración de 8 GB. Abre `cmd` en la carpeta del repo y escribe
    `2_ENTRENAR.bat 8gb`.
  - **Tarjeta de 8 GB:** abre `C:\ai-toolkit\config\ava_zimage_turbo_8gb.yaml` con el Bloc de notas y cambia
    `layer_offloading_transformer_percent: 0.6` por `0.8` (o `1.0`). Si aún falla, cambia
    `resolution: [512, 768]` por `resolution: [512]`. Guarda y vuelve a abrir `2_ENTRENAR.bat`.
- ❌ **Si la PC se queda sin RAM o va lentísima** con 8 GB: necesitas 32 GB de RAM; cierra todos los demás programas.

---

## Paso 4 — Elegir el mejor LoRA

En `C:\ai-toolkit\output\ava_zimage_turbo_v1\` quedan archivos como:

```
ava_zimage_turbo_v1_000001500.safetensors   ← a los 1500 pasos
ava_zimage_turbo_v1_000002000.safetensors
ava_zimage_turbo_v1_000002500.safetensors
ava_zimage_turbo_v1.safetensors             ← el final (3000 pasos)
```

En `samples/` mira las imágenes de prueba de cada etapa (el número del nombre es el paso):

- **Pocos pasos** → no se parece mucho a Ava todavía.
- **Punto justo** → se parece a Ava *y* obedece el prompt (ropa, lugar, pose).
- **Demasiados pasos** → siempre la misma cara/pose, colores raros o "quemados", ignora el prompt.

Normalmente el mejor está entre **2000 y 3000** pasos. Quédate con 2 o 3 candidatos para probar en ComfyUI.

---

## Paso 5 — Usarlo en ComfyUI

1. Copia el `.safetensors` elegido a `ComfyUI\models\loras\` (puedes renombrarlo a `ava_lora.safetensors`).
2. Reinicia ComfyUI (o pulsa **R** para refrescar la lista).
3. En tu flujo de Z-Image Turbo añade un nodo **`LoraLoaderModelOnly`**:
   - Conecta la salida **MODEL** de tu cargador del modelo (`zomgZImageTurboSFW_v15_full_bf16`) a la entrada del LoRA.
   - Conecta la salida del LoRA al **KSampler** (en lugar del modelo directo).
   - `lora_name`: el archivo de Ava. `strength_model`: **0.8 – 1.0**.
   - El text encoder (`qwen_3_4b`) y el VAE (`ae.safetensors`) se quedan igual.

   ```
   [Load Diffusion Model / Checkpoint] --MODEL--> [LoraLoaderModelOnly] --MODEL--> [KSampler]
   ```

4. Ajustes del KSampler para Z-Image Turbo: **steps 8–9, cfg 1.0**, sampler `euler`, scheduler `simple`.
5. Prompt de ejemplo:

   ```
   ava_lora, a photo of a young woman sitting in a cafe by the window, wearing a cream sweater, soft smile, natural light
   ```

   Siempre empieza con **`ava_lora`**. No hace falta describir el pelo rojo, los rizos ni las pecas:
   eso ya lo aprende el LoRA. Describe ropa, lugar, pose y luz.

✅ **Comprueba:** la mujer generada se parece a Ava en distintas ropas y lugares.

> **Nota sobre tu checkpoint:** el LoRA se entrena sobre el **Z-Image Turbo oficial**
> (es lo recomendado y lo que funciona con el adaptador de entrenamiento). Funciona también sobre
> mezclas como `zomgZImageTurboSFW`. Si con esa mezcla la cara sale un poco distinta, sube la fuerza a 1.0–1.1
> o prueba otro de los LoRA guardados.

---

## Detalles técnicos (para quien le interese)

- **Herramienta:** AI-Toolkit (Ostris), arquitectura `zimage:turbo` con el adaptador
  `ostris/zimage_turbo_training_adapter` (v2), que evita que el entrenamiento rompa la destilación de Turbo.
- **LoRA:** rango 32 / alpha 32, AdamW 8-bit, lr 1e-4, 3000 pasos, batch 1, resoluciones 512/768/1024 con buckets.
- **Memoria (16 GB):** modelo y text encoder cuantizados a float8, `low_vram`, gradient checkpointing.
- **Memoria (8 GB):** además rango 16, resoluciones 512/768 (sin 1024), text embeddings cacheados (el text encoder
  sale de la VRAM) y `layer_offloading` del 60 % del transformer a la RAM. Muestras cada 500 pasos a 768×1152.
- **Captions:** cada `.txt` empieza con la palabra clave `ava_lora` y describe solo lo que *cambia* entre fotos
  (ropa, lugar, pose, peinado, gafas, luz). Lo fijo de Ava (pelo rojo rizado, pecas, ojos verdes) **no** se describe,
  para que el LoRA lo asocie a `ava_lora`.
- **Dataset:** 30 imágenes, casi todas 1024×1536. `ava_03.png` es pequeña (508×1024); si ves que afecta la calidad
  puedes borrarla (junto con su `.txt`) de `C:\ai-toolkit\datasets\ava`.
- Para usar la interfaz web en vez del `.bat`: ejecuta `C:\ai-toolkit\run_windows.bat`, abre `http://localhost:8675`,
  **New Job** → modelo *Z-Image Turbo (w/ Training Adapter)* → dataset `ava` → trigger `ava_lora` → mismos valores de arriba.

## Desinstalar

Borra la carpeta `C:\ai-toolkit`. El modelo descargado está en
`C:\Users\<tu usuario>\.cache\huggingface` (bórralo también si quieres recuperar los ~20 GB).
