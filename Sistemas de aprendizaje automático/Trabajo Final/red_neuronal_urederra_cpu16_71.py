import os
import torch
import torch.nn as nn
import torch.optim as optim
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

# Número de hilos CPU que utilizará PyTorch
num_cpus = int(os.environ.get("SLURM_CPUS_PER_TASK", 16))
torch.set_num_threads(num_cpus)

# Mostramos el número de hilos activos
print("CPUs asignadas por Slurm:", num_cpus)

# Lectura del archivo csv y conversión a un dataframe
df = pd.read_csv('/data/scratch/008/IA_BigData/trabajo71/datasets71/TotalFeatures-ISCXFlowMeter.csv', delimiter = ',')

# Conversión de datos: de pandas a tensores en PyTorch
X = df.drop(columns=['class'])
y = df['class']
y = y.astype(str).str.strip().str.lower()

# Convertimos las clases categóricas a números
y = y.map({
    'benign': 0,
    'adware': 1,
    'generalmalware': 1,
    'ge': 1
})

# Convertimos los valores anteriores a Numpy
X_np = X.to_numpy()
y_np = y.to_numpy()

# transformamos los datos de Numpy a tensores de PyTorch
X_tensor = torch.tensor(X_np, dtype=torch.float32)
y_tensor = torch.tensor(y_np, dtype=torch.float32)

# Para nuestro modelo (salida 1 neurona) y debe tener forma (n, 1)
y_tensor = y_tensor.view(-1, 1)  # también reshape(-1,1)

# Definimos el modelo de red neuronal
modelo = nn.Sequential(
    
    # CAPA 1
    # 79 entradas y 128 neuronas
    nn.Linear(X.shape[1], 128, bias=True, dtype=torch.float32),
    
    # Función de activación ReLU
    nn.ReLU(),

    
    # CAPA 2
    # 128 entradas y 64 neuronas
    nn.Linear(128, 64, bias=True, dtype=torch.float32),
    
    # Función de activación ReLU
    nn.ReLU(),

    
    # CAPA 3
    # 64 entradas y 32 neuronas
    nn.Linear(64, 32, bias=True, dtype=torch.float32),
    
    # Función de activación ReLU
    nn.ReLU(),

    
    # CAPA DE SALIDA
    # 32 entradas y 1 neurona
    nn.Linear(32, 1, bias=True, dtype=torch.float32),
    
    # Sigmoid para clasificación binaria
    nn.Sigmoid()
)

# definimos la función de pérdida
loss_fn = nn.BCELoss()
# definimos el optimizador
optimizador = optim.Adam(modelo.parameters(), lr = 0.001)


# Dividir en entrenamiento y prueba
X_train, X_test, y_train, y_test = train_test_split(
    X_tensor,                # Matriz de características de entrada (features)-atributos de entrada-variables predictoras
    y_tensor,                # Vector/serie con la variable objetivo (labels-en este caso: outcome)
    test_size=0.2,           # Proporción para el conjunto de prueba y bel conjunto de entrenamiento: 20% test, 80% train
    random_state=42,         # Semilla para que la división sea reproducible
    shuffle=True,            # Barajar aleatoriamente antes de dividir (recomendado si no hay una serie temporal)
    stratify=y_tensor        # garantiza que la distribución de clases de la variable objetivo se mantiene en los conjuntos de entrenamiento y prueba
)


# Instanciamos un objeto StandardScaler
scaler_std = StandardScaler()

# Ajustamos el escalador SÓLO con los datos de entrenamiento
X_train_scaled = scaler_std.fit_transform(X_train)

# Aplicar la transformación al conjunto de prueba (sin volver a ajustar)
X_test_scaled = scaler_std.transform(X_test)

# Convertimos arrays de numpy a tensor.
X_train = torch.tensor(X_train_scaled, dtype=torch.float32)
X_test  = torch.tensor(X_test_scaled, dtype=torch.float32)

# incio del entrenamiento
# número de recorridos del dataset completo
n_epocas = 50

# número de filas del dataset que componen un batch
tamanho_batch = 64

# número de batches (enteros) que hay en una época. Ignora los datos sobrantes
batches_por_epoca = len(X_train) // tamanho_batch  

# Listas para guardar la evolución de las métricas
lista_loss_train = []
lista_acc_train = []
lista_acc_test = []

# Repite todo el entrenamiento n_epocas veces
for epoca in range(n_epocas):

    # MODELO EN MODO ENTRENAMIENTO
    modelo.train()

    # acumuladores para calcular métricas medias
    loss_acumulada = 0.0
    acc_acumulada = 0.0
    
    # Recorremos todos los batches de esta época. i es el número de batch
    for i in range(batches_por_epoca):
         
        # Calculamos el índice inicial del batch actual
        # Si i = 0, empieza en 0
        # Si i = 1, empieza en 10
        # Si i = 2, empieza en 20
        inicio_batch = i * tamanho_batch
    
        # Calculamos el índice final del batch actual
        fin_batch = inicio_batch + tamanho_batch
        
        # Seleccionamos un subconjunto de datos (batch)
        X_batch = X_train[inicio_batch : fin_batch ]
    
        # Seleccionamos las etiquetas reales correspondientes al batch
        y_batch = y_train[inicio_batch : fin_batch]
        
        # El modelo hace una predicción (forward propagation).
        # En la primera pasada actualiza aleatoriamente los parámetros del modelo.
        # # Los pesos solo se actualizan después de loss.backward() y optimizador.step()
        y_pred  = modelo(X_batch)
        
        # Calculamos el error entre predicción y valor real
        loss    = loss_fn(y_pred, y_batch)
        
        # PyTorch acumula gradientes, no los reemplaza. Borra gradientes anteriores
        # Pone a cero (borra) en este batch los gradientes acumulados en todos los parámetros del modelo
        # En PyTorch los gradientes no se reemplazan, se acumulan. Quiero SOLO el gradiente de este batch
        optimizador.zero_grad()
        
        # Backward propagation: Cálculo del gradiente. Matemáticamente: dL/dW
        # calculamos automáticamente las derivadas de la pérdida respecto a los parámetros del modelo
        loss.backward()
        
        # Actualizamos los pesos del modelo  W = W - learning_rate * gradiente(derivadas)
        optimizador.step()
    
        acc = (y_pred.round() == y_batch).float().mean()
    
        loss_acumulada += loss.item()
        acc_acumulada += acc.item()

    # métricas medias de entrenamiento de la época
    loss_media = loss_acumulada / batches_por_epoca
    acc_media = acc_acumulada / batches_por_epoca
            
    # MODELO EN MODO EVALUACIÓN
    
    # Cambia el modelo a modo evaluación (inferencia) con el conjunto de test. Durante el entrenamiento, el modelo aprende ajustando sus pesos.
    # Ahora ya no queremos aprender, solo queremos hacer predicciones sobre X_test, compararlas con las etiquetas reales y_test
    # y calcular la exactitud (accuracy)
    modelo.eval()

    # No calculamos gradientes, más rápido y menos memoria.
    # Ejecuta el modelo sin calcular ni almacenar gradientes, solo se quiere predecir
    with torch.no_grad():
        y_pred_test = modelo(X_test)
        acc_test = (y_pred_test.round() == y_test).float().mean()

    # Guardamos métricas de la época
    lista_loss_train.append(loss_media)
    lista_acc_train.append(acc_media)
    lista_acc_test.append(acc_test.item())

    # mostramos métricas del modelo para el conjunto de test
    print(
        f"Época {epoca}: "
        f"loss_train={loss_media:.4f}, "
        f"acc_train={acc_media:.4f}, "
        f"acc_test={acc_test:.4f}"
    )       