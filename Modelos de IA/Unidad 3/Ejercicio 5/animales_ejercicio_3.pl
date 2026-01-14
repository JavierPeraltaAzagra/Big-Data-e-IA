/* Base de conocimiento */
conocimiento('guepardo',
['es un mamífero', 'es carnívoro', 'tiene color leonado', 'tiene puntos negros']).
conocimiento('tigre',
['es un mamífero', 'es carnívoro', 'tiene color leonado', 'tiene rayas negras']).
conocimiento('jirafa',
['es un mamífero', 'es ungulado', 'tiene el cuello largo', 'tiene las piernas largas']).
conocimiento('cebra',
['es un mamífero', 'es ungulado', 'tiene rayas negras']).
conocimiento('avestruz',
['es un ave', 'no vuela', 'tiene el cuello largo']).
conocimiento('pingüino',
['es un ave', 'no vuela', 'sabe nadar', 'tiene color blanco con negro']).
conocimiento('albatros',
['es un ave', 'tiene hábitos marinos', 'vuela bien']).
conocimiento('cocodrilo',
['es un reptil', 'es carnívoro', 'sabe nadar', 'tiene un cuerpo escamoso']).
conocimiento('águila',
['es un ave', 'es carnívoro', 'vuela bien', 'tiene un pico ganchudo']).
conocimiento('hipopótamo',
['es un mamífero', 'es herbívoro', 'tiene color marrón', 'tiene las patas cortas']).

/* Sistema experto */
:- dynamic conocido/1.
consulta:- haz_diagnostico(X), escribe_diagnostico(X),
ofrece_explicacion_diagnostico(X),
clean_scratchpad.
consulta:- write('No hay suficiente conocimiento para elaborar un
diagnostico.'), clean_scratchpad.
haz_diagnostico(Diagnosis):- obten_hipotesis_y_caracteristicas(Diagnosis,
ListaDeCaracteristicas),
prueba_presencia_de(Diagnosis, ListaDeCaracteristicas).
obten_hipotesis_y_caracteristicas(Diagnosis, ListaDeCaracteristicas):-
conocimiento(Diagnosis, ListaDeCaracteristicas).
prueba_presencia_de(Diagnosis, []).
prueba_presencia_de(Diagnosis, [Head | Tail]):- prueba_verdad_de(Diagnosis,
Head),
prueba_presencia_de(Diagnosis, Tail).
prueba_verdad_de(Diagnosis, Caracteristica):- conocido(Caracteristica).
prueba_verdad_de(Diagnosis, Caracteristica):- not(conocido(is_false(Caracteristica))),
pregunta_sobre(Diagnosis, Caracteristica, Reply), Reply = si.
pregunta_sobre(Diagnosis, Caracteristica, Reply):- write('¿El animal que estoy intentando identificar ('),
write(Diagnosis), write(') cumple la caracteristica: "'), write(Caracteristica), write('"? '), nl,
write('Responde si/no/porque: '),
read(Respuesta), process(Diagnosis, Caracteristica, Respuesta, Reply).
process(Diagnosis, Caracteristica, si, si):- asserta(conocido(Caracteristica)).
process(Diagnosis, Caracteristica, no, no):- asserta(conocido(is_false(Caracteristica))).
process(Diagnosis, Caracteristica, porque, Reply):- nl,
write('Estoy comprobando si el animal puede ser '),
write(Diagnosis), write('.'), nl, write('Para esto necesito saber si es cierto que: "'),
write(Caracteristica), write('".'), nl, pregunta_sobre(Diagnosis, Caracteristica, Reply).
process(Diagnosis, Caracteristica, Respuesta, Reply):- Respuesta \== no,
Respuesta \== si, Respuesta \== porque, nl,
write('Debes contestar si, no o porque.'), nl,
pregunta_sobre(Diagnosis, Caracteristica, Reply).
escribe_diagnostico(Diagnosis):- write('Mi conclusion es que el animal es: '),
write(Diagnosis), write('.'), nl.
ofrece_explicacion_diagnostico(Diagnosis):-
pregunta_si_necesita_explicacion(Respuesta),
actua_consecuentemente(Diagnosis, Respuesta).
pregunta_si_necesita_explicacion(Respuesta):-
write('¿Quieres que te explique el razonamiento? (si/no): '),
read(RespuestaUsuario),
asegura_respuesta_si_o_no(RespuestaUsuario, Respuesta).
asegura_respuesta_si_o_no(si, si).
asegura_respuesta_si_o_no(no, no).
asegura_respuesta_si_o_no(_, Respuesta):- write('Debes contestar si o no.'),
pregunta_si_necesita_explicacion(Respuesta).
actua_consecuentemente(Diagnosis, no).
actua_consecuentemente(Diagnosis, si):- conocimiento(Diagnosis,
ListaDeCaracteristicas),
write('He llegado a la conclusion de que es '), write(Diagnosis),write(' a partir de estas caracteristicas:'), nl, escribe_lista_de_caracteristicas(ListaDeCaracteristicas).
escribe_lista_de_caracteristicas([]).
escribe_lista_de_caracteristicas([Head | Tail]):-
write(Head), nl, escribe_lista_de_caracteristicas(Tail).
clean_scratchpad:- retract(conocido(X)), fail.
clean_scratchpad.
conocido(_):- fail.
not(X):- X,!,fail.
not(_).