# gastos.py

def agregar_gasto(concepto, cantidad):
    """Añade un gasto a la lista."""
    with open('gastos.txt', 'a') as archivo:
        archivo.write(f"{concepto}: {cantidad}\n")

def listar_gastos():
    """Muestra todos los gastos."""
    try:
        with open('gastos.txt', 'r') as archivo:
            print(archivo.read())
    except FileNotFoundError:
        print("No hay gastos registrados.")

def calcular_total():
    """Calcula el total gastado."""
    try:
        with open('gastos.txt', 'r') as archivo:
            total = sum(float(line.split(': ')[1]) for line in archivo)
            print(f"Total gastado: {total}")
    except FileNotFoundError:
        print("No hay gastos registrados.")

def menu():
    """Muestra el menú de consola."""
    while True:
        print("\nMenú:")
        print("1. Añadir gasto")
        print("2. Listar gastos")
        print("3. Calcular total")
        print("4. Salir")
        opcion = input("Elige una opción: ")

        if opcion == '1':
            concepto = input("Concepto del gasto: ")
            cantidad = float(input("Cantidad del gasto: "))
            agregar_gasto(concepto, cantidad)
        elif opcion == '2':
            listar_gastos()
        elif opcion == '3':
            calcular_total()
        elif opcion == '4':
            break
        else:
            print("Opción no válida. Inténtalo de nuevo.")

if __name__ == "__main__":
    menu()