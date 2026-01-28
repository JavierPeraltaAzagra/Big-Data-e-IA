% UT3_A5_transporte_conocimiento.pl
% Base de conocimiento de modos de transporte

% opcion_transporte(Medio, ListaDeCondiciones).

opcion_transporte(a_pie,
    ['distancia_corta',
     'no_tiene_prisa',
     'quiere_ejercicio',
     'presupuesto_muy_bajo']).

opcion_transporte(bicicleta,
    ['distancia_media',
     'quiere_ejercicio',
     'tiene_bicicleta',
     'no_hace_mal_tiempo']).

opcion_transporte(autobus,
    ['distancia_media_o_larga',
     'no_quiere_conducir',
     'presupuesto_bajo',
     'hay_transporte_publico']).

opcion_transporte(coche_compartido,
    ['distancia_media_o_larga',
     'tiene_coche_o_amigos_con_coche',
     'quiere_ir_rapido',
     'no_le_importa_trafico']).

opcion_transporte(tren,
    ['distancia_larga',
     'prefiere_comodidad',
     'hay_estacion_cerca',
     'presupuesto_medio_o_alto']).

% Sistema experto

%:- ['UT3_A5_transporte_conocimiento'].

% respuesta(Condicion, Valor).    % Valor ∈ {si, no}
:- dynamic respuesta/2.
elige_transporte :- 
    limpiar_memoria,
    write('=== Sistema experto de recomendación de transporte ==='), nl, nl,
    findall(A, opcion_transporte(A, _), CandidatosIni),
    diagnosticar(CandidatosIni, CandidatosFin),
    mostrar_resultado(CandidatosFin),
    limpiar_memoria.
limpiar_memoria :-
    retractall(conocido(_, _)).
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
    elegir_caracteristica(CandidatosIn, Caracteristica, VehRef),
    preguntar_responder(VehRef, Caracteristica, RespCanonica),
    asserta(respuesta(Caracteristica, RespCanonica)),
    filtrar_candidatos(CandidatosIn, Caracteristica, RespCanonica, CandidatosNext),
    diag_loop(CandidatosNext, CandidatosOut).
no_mas_preguntas(Candidatos) :-
    \+ (
        member(A, Candidatos),
        opcion_transporte(A, Caracteristicas),
        member(C, Caracteristicas),
        \+ respuesta(C, _)
    ).
elegir_caracteristica(Candidatos, Caracteristica, VehRef) :-
    member(VehRef, Candidatos),
    opcion_transporte(VehRef, Caracteristicas),
    member(Caracteristica, Caracteristicas),
    \+ respuesta(Caracteristica, _),
    !.
preguntar_responder(VehRef, Caracteristica, RespCanonica) :-
    nl,
    write('¿En tu caso se cumple: '), write(Caracteristica), write('?'), nl,
    write('Responde si/no/porque: '),
    read(Raw),
    normalizar_respuesta(Raw, VehRef, Caracteristica, RespCanonica).
normalizar_respuesta(Raw, VehRef, Caracteristica, RespCanonica) :-
    (   Raw == porque
    ->  nl,
        format('Estoy comprobando si el medio de transporte adecuado es ~w.~n', [VehRef]),
        format('Para ello necesito saber si es cierto que: "~w".~n', [Caracteristica]),
        preguntar_responder(VehRef, Caracteristica, RespCanonica)

    ;   Raw == si
    ->  RespCanonica = si

    ;   Raw == no
    ->  RespCanonica = no

    ;   nl,
        format('Respuesta "~w" no valida. Por favor, responde solo si/no/porque.~n', [Raw]),
        preguntar_responder(VehRef, Caracteristica, RespCanonica)
    ).
filtrar_candidatos([], _, _, []).

filtrar_candidatos([A | Resto], Caracteristica, Resp, [A | RFiltrado]) :-
    keep_based_on_resp(A, Caracteristica, Resp),
    !,
    filtrar_candidatos(Resto, Caracteristica, Resp, RFiltrado).

filtrar_candidatos([_A | Resto], Caracteristica, Resp, RFiltrado) :-
    filtrar_candidatos(Resto, Caracteristica, Resp, RFiltrado).

% - si: el transporte debe tener esa caracteristica
% - no: el transporte no debe tener esa caracteristica

keep_based_on_resp(Transporte, Caracteristica, si) :-
    opcion_transporte(Transporte, Caracteristicas),
    member(Caracteristica, Caracteristicas).

keep_based_on_resp(Transporte, Caracteristica, no) :-
    opcion_transporte(Transporte, Caracteristicas),
    \+ member(Caracteristica, Caracteristicas).

keep_based_on_resp(_Transporte, _Caracteristica, desconocido).
mostrar_resultado([]) :-
    nl,
    write('No he podido asignar un medio de transporte con la informacion disponible.'), nl.

mostrar_resultado([Transporte]) :-
    nl,
    format('Mi conclusion es que el medio de transporte mas adecuado es: ~w.~n', [Transporte]),
    explicar_si_quiere(Transporte).
mostrar_resultado(ListaTransportes) :-
    nl,
    write('Hay varias posibles soluciones (medios de transporte compatibles con tus respuestas):'), nl,
    write('  '), write(ListaTransportes), nl.
explicar_si_quiere(Transporte) :-
    nl,
    write('¿Quieres que te explique el razonamiento? (si/no): '),
    read(Resp),
    (   Resp == si
    ->  explicacion(Transporte)
    ;   true
    ).

explicacion(Transporte) :-
    opcion_transporte(Transporte, Caracteristicas),
    nl,
    format('He llegado a la conclusion de que es ~w a partir de estas caracteristicas confirmadas:~n',
           [Transporte]),
    listar_caracteristicas_si(Caracteristicas).

listar_caracteristicas_si([]).
listar_caracteristicas_si([C | R]) :-
    (   respuesta(C, si)
    ->  format('  [SI] ~w~n', [C])
    ;   true
    ),
    listar_caracteristicas_si(R).
