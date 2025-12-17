import numpy as np
import matplotlib.pyplot as plt

class Perceptron:
    """
    PRÁCTICA 1: Implementación de una Neurona Artificial.
    Tu objetivo es completar los métodos 'net_input', 'predict' y el bucle de 'fit'.
    """
    def __init__(self, learning_rate=0.1, n_iter=10):
        self.learning_rate = learning_rate
        self.n_iter = n_iter
        self.weights = None
        self.bias = None
        self.errors_ = []

    def fit(self, X, y):
        """
        Entrena el modelo.
        X: Matriz de muestras [n_muestras, n_caracteristicas]
        y: Vector de objetivos [n_muestras]
        """
        n_samples, n_features = X.shape
        
        # Inicializamos pesos y bias a 0
        self.weights = np.zeros(n_features)
        self.bias = 0
        
        # Bucle de épocas (iteraciones sobre todo el dataset)
        for _ in range(self.n_iter):
            errors = 0
            
            for idx, x_i in enumerate(X):
                # --- TU CÓDIGO AQUÍ (TODO 1) ---
                # 1. Haz una predicción usando el método predict() que has programado abajo
                y_predicted = self.predict(x_i)
                
                # 2. Calcula la actualización (update)
                # Fórmula: tasa_aprendizaje * (valor_real - valor_predicho)
                update = self.learning_rate * (y[idx] - y_predicted)
                
                # 3. Actualiza los pesos y el sesgo
                # Fórmula pesos: peso_actual + (update * entrada)
                # Fórmula bias: bias_actual + update
                self.weights = self.weights + (update * x_i)
                self.bias = self.bias + update
                
                # -------------------------------
                
                # (No tocar) Registro de errores para la gráfica
                # Si update es 0, no hubo error. Si es distinto, sumamos 1 error.
                if update != 0.0:
                    errors += 1
            
            self.errors_.append(errors)
        return self

    def net_input(self, X):
        """
        Calcula la entrada neta (z).
        Fórmula: z = (X · w) + b
        Pista: Usa np.dot() para el producto escalar.
        """
        # --- TU CÓDIGO AQUÍ (TODO 2) ---
        z = np.dot(X, self.weights) + self.bias
        return z

    def predict(self, X):
        """
        Función de activación (Escalón).
        Devuelve 1 si la entrada neta es >= 0, de lo contrario devuelve 0.
        Pista: Usa np.where() o un if/else simple.
        """
        # --- TU CÓDIGO AQUÍ (TODO 3) ---
        prediction = np.where(self.net_input(X) >= 0, 1, 0)
        return prediction

# --- ZONA DE PRUEBAS (NO MODIFICAR) ---
if __name__ == "__main__":
    X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
    y = np.array([0, 0, 0, 1]) # AND

    print("Entrenando Perceptrón...")
    ppn = Perceptron(learning_rate=0.1, n_iter=10)
    
    try:
        ppn.fit(X, y)
        print("¡Entrenamiento finalizado sin errores de ejecución!")
        print(f"Pesos finales: {ppn.weights}")
        print(f"Bias final: {ppn.bias}")
        
        test_val = np.array([1, 1])
        print(f"Prueba [1, 1]: {ppn.predict(test_val)} (Esperado: 1)")

        #TODO Mostrar los resultados en un gráfico scatter
        plt.scatter(X, y, label = "0", color = "blue")
        #plt.scatter(x2, y2, label = "1", color = "red")

        plt.title("Gráfico de dispersión")
        plt.xlabel("Eje X")
        plt.ylabel("Eje Y")
        plt.legend()

        plt.show()
        
    except Exception as e:
        print(f"\nERROR: Algo falta por implementar.\nMensaje: {e}")