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
:- dynamic conocido/2.
% conocido(Caracteristica, Valor).
% Valor in {si, no, desconocido}
limpiar_memoria :-
    retractall(conocido(_, _)).
consulta :-
    limpiar_memoria,
    write('== Sistema experto: identificacion de animales =='), nl, nl,
    findall(A, conocimiento(A, _), CandidatosIni),
    diagnosticar(CandidatosIni, CandidatosFin),
    mostrar_resultado(CandidatosFin),
    limpiar_memoria.
consulta_multi :-
    consulta,
    nl,
    write('¿Quieres diagnosticar otro animal? (si/no): '),
    read(Resp),
    (   Resp == si
    ->  consulta_multi
    ;   true
    ).
diagnosticar(CandidatosIni, CandidatosFin) :-
    diag_loop(CandidatosIni, CandidatosFin).
diag_loop([], []):- !.
diag_loop([A], [A]) :- !.
diag_loop(Candidatos, Candidatos) :-
    Candidatos \= [],
    no_mas_preguntas(Candidatos),
    !.
diag_loop(CandidatosIn, CandidatosOut) :-
    CandidatosIn \= [],
    elegir_caracteristica(CandidatosIn, Caracteristica, AnimalRef),
    preguntar_responder(AnimalRef, Caracteristica, RespCanonica),
    asserta(conocido(Caracteristica, RespCanonica)),
    filtrar_candidatos(CandidatosIn, Caracteristica, RespCanonica, CandidatosNext),
    diag_loop(CandidatosNext, CandidatosOut).
no_mas_preguntas(Candidatos) :-
    \+ (
        member(A, Candidatos),
        conocimiento(A, Caracteristicas),
        member(C, Caracteristicas),
        \+ conocido(C, _)
    ).
elegir_caracteristica(Candidatos, Caracteristica, AnimalRef) :-
    member(AnimalRef, Candidatos),
    conocimiento(AnimalRef, Caracteristicas),
    member(Caracteristica, Caracteristicas),
    \+ conocido(Caracteristica, _),
    !.
preguntar_responder(AnimalRef, Caracteristica, RespCanonica) :-
    nl,
    format('¿El animal que estoy intentando identificar (~w) cumple la caracteristica: "~w"?~n',
           [AnimalRef, Caracteristica]),
    write('Responde si/no/porque/no_se/nsnc: '),
    read(Raw),
    normalizar_respuesta(Raw, AnimalRef, Caracteristica, RespCanonica).
normalizar_respuesta(Raw, AnimalRef, Caracteristica, RespCanonica) :-
    (   Raw == porque
    ->  nl,
        format('Estoy comprobando si el animal puede ser ~w.~n', [AnimalRef]),
        format('Para ello necesito saber si es cierto que: "~w".~n', [Caracteristica]),
        preguntar_responder(AnimalRef, Caracteristica, RespCanonica)

    ;   Raw == si
    ->  RespCanonica = si

    ;   Raw == no
    ->  RespCanonica = no

    ;   Raw == no_se
    ->  RespCanonica = desconocido

    ;   Raw == nsnc
    ->  RespCanonica = desconocido

    ;   nl,
        format('Respuesta "~w" no valida. Por favor, responde solo si/no/porque/no_se/nsnc.~n', [Raw]),
        preguntar_responder(AnimalRef, Caracteristica, RespCanonica)
    ).
filtrar_candidatos([], _, _, []).

filtrar_candidatos([A | Resto], Caracteristica, Resp, [A | RFiltrado]) :-
    keep_based_on_resp(A, Caracteristica, Resp),
    !,
    filtrar_candidatos(Resto, Caracteristica, Resp, RFiltrado).

filtrar_candidatos([_A | Resto], Caracteristica, Resp, RFiltrado) :-
    filtrar_candidatos(Resto, Caracteristica, Resp, RFiltrado).

% - si: el animal debe tener esa caracteristica
% - no: el animal no debe tener esa caracteristica
% - desconocido: se mantienen todos los candidatos

keep_based_on_resp(Animal, Caracteristica, si) :-
    conocimiento(Animal, Caracteristicas),
    member(Caracteristica, Caracteristicas).

keep_based_on_resp(Animal, Caracteristica, no) :-
    conocimiento(Animal, Caracteristicas),
    \+ member(Caracteristica, Caracteristicas).

keep_based_on_resp(_Animal, _Caracteristica, desconocido).
mostrar_resultado([]) :-
    nl,
    write('No he podido identificar el animal con la informacion disponible.'), nl.

mostrar_resultado([Animal]) :-
    nl,
    format('Mi conclusion es que el animal es: ~w.~n', [Animal]),
    explicar_si_quiere(Animal).
mostrar_resultado(ListaAnimales) :-
    nl,
    write('Hay varias posibles soluciones (animales compatibles con tus respuestas):'), nl,
    write('  '), write(ListaAnimales), nl.
explicar_si_quiere(Animal) :-
    nl,
    write('¿Quieres que te explique el razonamiento? (si/no): '),
    read(Resp),
    (   Resp == si
    ->  explicacion(Animal)
    ;   true
    ).

explicacion(Animal) :-
    conocimiento(Animal, Caracteristicas),
    nl,
    format('He llegado a la conclusion de que es ~w a partir de estas caracteristicas confirmadas:~n',
           [Animal]),
    listar_caracteristicas_si(Caracteristicas).

listar_caracteristicas_si([]).
listar_caracteristicas_si([C | R]) :-
    (   conocido(C, si)
    ->  format('  [SI] ~w~n', [C])
    ;   true
    ),
    listar_caracteristicas_si(R).
