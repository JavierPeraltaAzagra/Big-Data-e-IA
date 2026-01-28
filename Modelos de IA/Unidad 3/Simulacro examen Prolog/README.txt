1. Base vs motor:
¿Qué predicados consideras que forman parte de la base de conocimiento y cuáles forman parte del motor / interfaz? Pon ejemplos concretos de tu código (nombres de predicados).
El predicado de la base de conocimiento en mi código es opcion_transporte, sirve para definir qué características definen cada transporte.
Un predicado del motor puede ser limpiar_memoria, sirve para borrar los datos guardados de anteriores ejecuciones.

2. Comparación con Mini-Zoo (UT3_A3):
Indica al menos 3 similitudes y 3 diferencias entre tu sistema de transporte y el sistema “Mini-Zoo”:
a nivel de estructura (ficheros, predicados de entrada, etc.),
- En Mini-Zoo había la opción de multiconsulta y en el de transporte no.
- El funcionamiento en general es igual o muy parecido.
a nivel de diálogo con el usuario (preguntas / respuestas),
- En Mini-Zoo había la opción de contestar ns/nc y en el de transporte no.
- El funcionamiento de las respuestas si/no/porque es igual.
a nivel de dominio (animales vs transporte).
- Las características de ambos son completamente diferentes.
- El funcionamiento es el mismo.

3. Predicados dinámicos:
¿Por qué es necesario declarar algún predicado como dynamic en tu solución? Explica para qué lo usas y qué podría pasar si no lo declarases dinámico.
Sirve para recoger respuestas del usuario en tiempo de ejecución. Si no lo declaras dinámico, las respuestas del usuario no se podrían guardar.

4. Listas y recursión:
¿En qué parte de tu código recorres una lista con recursión (por ejemplo, la lista de condiciones de un medio de transporte)? Copia ese predicado y explícalo brevemente (qué hace en cada cláusula).
El código llega aquí cada vez que el usuario responde a una pregunta.
diag_loop([], []):- !.
Cuando llega aquí, si no ha llegado a ninguna conclusión, devuelve una lista vacía.
diag_loop([A], [A]) :- !.
Cuando llega aquí, si únicamente es posible recomendar un transporte, devuelve ese transporte.
diag_loop(Candidatos, Candidatos) :-
    Candidatos \= [],
    no_mas_preguntas(Candidatos),
    !.
Cuando llega aquí, si hay varias conclusiones, devuelve una lista con todos los posibles transportes.
5. Adaptación a otro dominio:
¿Qué cambios mínimos harías para convertir tu sistema experto de transporte en un sistema que recomiende tipo de plan de ocio (cine, deporte, quedar con amigos, juego online, etc.)? No hace falta que lo programes: describe qué cambiarías a grandes rasgos.
Cambiaría los nombres de las variables, predicados y textos para que tenga lógica.