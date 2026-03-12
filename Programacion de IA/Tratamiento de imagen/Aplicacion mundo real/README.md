# Detección de Parking

Proyecto de IA para clasificar plazas de aparcamiento como `Libre` u `Ocupado` a partir de imágenes y video.

## Descripción

El notebook `Deteccion_parking.ipynb` entrena un modelo **KNN** con recortes de plazas etiquetadas y aplica la detección:

- Sobre una imagen de ejemplo (`images/parkings_ejemplos/carpark_frame.png`).
- Sobre un video completo (`videos/carpark.mp4`) generando un resultado anotado.

Cada plaza se define con coordenadas en `xml/carpark_coords.xml` y se dibuja en color:

- Verde: `Libre`
- Rojo: `Ocupado`

## Resultado
![alt text](result.png)

## Estructura del proyecto

```text
Aplicacion mundo real/
|-- Deteccion_parking.ipynb
|-- README.md
|-- images/
|   |-- parking_ocupado/
|   |-- parking_vacio/
|   `-- parkings_ejemplos/
|       `-- carpark_frame.png
|-- videos/
|   |-- carpark.mp4
|   `-- carpark_resultado.mp4
`-- xml/
    `-- carpark_coords.xml
```

## Tecnologías

- Python
- OpenCV (`cv2`)
- NumPy
- Matplotlib
- scikit-learn
- Jupyter Notebook

## Flujo del notebook

1. Carga librerias y funciones auxiliares.
2. Lee coordenadas de plazas desde XML.
3. Preprocesa recortes de parking (escala de grises, resize 128x128, inversión, normalización).
4. Construye dataset con imágenes `ocupado` y `vacío`.
5. Entrena un clasificador KNN.
6. Evalúa con matriz de confusión.
7. Aplica detección a una imagen de ejemplo.
8. Procesa video frame a frame y guarda el resultado en `videos/carpark_resultado.mp4`.

## Requisitos

Instala dependencias con:

```bash
pip install numpy opencv-python matplotlib scikit-learn jupyter
```

## Ejecución

1. Abre la carpeta `Aplicacion mundo real` en VS Code.
2. Abre `Deteccion_parking.ipynb`.
3. Ejecuta las celdas en orden, de arriba a abajo.
4. Revisa:

- La matriz de confusión.
- La imagen con las predicciones de la IA.
- El video de salida con las predicciones de la IA `videos/carpark_resultado.mp4`.

## Salidas esperadas

Al finalizar el procesamiento del video, el notebook muestra:

- Ruta del video de entrada.
- Cantidad de frames procesados.
- Ruta del video generado.
- Numero de plazas libres y ocupadas en el ultimo frame.

## Notas

- Las rutas son relativas al directorio del notebook.
- Si cambias de dataset o video, mantén la estructura de carpetas o ajusta las rutas en el notebook.