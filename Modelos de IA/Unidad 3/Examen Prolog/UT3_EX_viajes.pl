%% BASE DE CONOCIMIENTO
% viaje(TipoViaje, ListaDeCondiciones).

viaje(playa_relax,
    [le_gusta_playa,
     quiere_relajarse,
     presupuesto_medio,
     no_le_importa_calor]).

viaje(playa_fiesta,
    [le_gusta_playa,
     quiere_fiesta_nocturna,
     presupuesto_medio_o_alto,
     no_le_importan_multitudes]).

viaje(ciudad_cultural,
    [le_gusta_ciudad,
     le_gusta_cultura,
     presupuesto_medio_o_alto,
     no_le_importan_multitudes]).

viaje(montana_senderismo,
    [le_gusta_montana,
     le_gusta_naturaleza,
     quiere_moverse_mucho,
     no_le_importa_frio]).

viaje(turismo_rural_relax,
    [quiere_tranquilidad,
     le_gusta_naturaleza,
     presupuesto_medio,
     no_le_importa_coche]).

viaje(roadtrip_coche,
    [tiene_coche,
     le_gusta_conducir,
     quiere_ver_varios_sitios,
     presupuesto_flexible]).

viaje(viaje_internacional_lowcost,
    [le_gusta_viajar_lejos,
     presupuesto_bajo,
     no_le_importa_alojamiento_sencillo,
     le_gusta_improvisar]).

viaje(parque_atracciones,
    [le_gustan_atracciones,
     le_gusta_adrenalina,
     presupuesto_medio,
     no_le_importan_colas]).

%% MOTOR/INTERFAZ

:- dynamic respuesta/2.
% respuesta(Condicion, Valor).    % Valor ∈ {si, no}

limpiar_memoria :-
    retractall(respuesta(_, _)).

recomienda_viaje :-
    limpiar_memoria,
    write('== Sistema experto: recomendacion de viaje =='), nl, nl,
    findall(A, viaje(A, _), CandidatosIni),
    recomendar(CandidatosIni, CandidatosFin),
    mostrar_resultado(CandidatosFin),
    limpiar_memoria.

recomienda_viaje_multi :-
    recomienda_viaje,
    nl,
    write('¿Quieres buscar otro viaje? (si/no): '),
    read(Resp),
    (   Resp == si
    ->  recomienda_viaje_multi
    ;   true
    ).

recomendar(CandidatosIni, CandidatosFin) :-
    recom_loop(CandidatosIni, CandidatosFin).

recom_loop([], []):- !.
recom_loop(Candidatos, Candidatos) :-
    Candidatos \= [],
    no_mas_preguntas(Candidatos),
    !.
recom_loop(CandidatosIn, CandidatosOut) :-
    CandidatosIn \= [],
    elegir_caracteristica(CandidatosIn, Caracteristica, ViajeRef),
    preguntar_responder(ViajeRef, Caracteristica, RespCanonica),
    asserta(respuesta(Caracteristica, RespCanonica)),
    filtrar_candidatos(CandidatosIn, Caracteristica, RespCanonica, CandidatosNext),
    recom_loop(CandidatosNext, CandidatosOut).

no_mas_preguntas(Candidatos) :-
    \+ (
        member(A, Candidatos),
        viaje(A, Caracteristicas),
        member(C, Caracteristicas),
        \+ respuesta(C, _)
    ).

elegir_caracteristica(Candidatos, Caracteristica, ViajeRef) :-
    member(ViajeRef, Candidatos),
    viaje(ViajeRef, Caracteristicas),
    member(Caracteristica, Caracteristicas),
    \+ respuesta(Caracteristica, _),
    !.

preguntar_responder(ViajeRef, Caracteristica, RespCanonica) :-
    nl,
    format('¿En tu caso se cumple: "~w"?~n',
           [Caracteristica]),
    write('Responde si/no/porque: '),
    read(Raw),
    normalizar_respuesta(Raw, ViajeRef, Caracteristica, RespCanonica).

normalizar_respuesta(Raw, ViajeRef, Caracteristica, RespCanonica) :-
    (   Raw == porque
    ->  nl,
        format('Estoy comprobando si el viaje que te recomiende puede ser ~w.~n', [ViajeRef]),
        format('Para ello necesito saber si es cierto que: "~w".~n', [Caracteristica]),
        preguntar_responder(ViajeRef, Caracteristica, RespCanonica)

    ;   Raw == si
    ->  RespCanonica = si

    ;   Raw == no
    ->  RespCanonica = no

    ;   nl,
        format('Respuesta "~w" no valida. Por favor, responde solo si/no/porque.~n', [Raw]),
        preguntar_responder(ViajeRef, Caracteristica, RespCanonica)
    ).

filtrar_candidatos([], _, _, []).

filtrar_candidatos([A | Resto], Caracteristica, Resp, [A | RFiltrado]) :-
    keep_based_on_resp(A, Caracteristica, Resp),
    !,
    filtrar_candidatos(Resto, Caracteristica, Resp, RFiltrado).

filtrar_candidatos([_A | Resto], Caracteristica, Resp, RFiltrado) :-
    filtrar_candidatos(Resto, Caracteristica, Resp, RFiltrado).

keep_based_on_resp(Viaje, Caracteristica, si) :-
    viaje(Viaje, Caracteristicas),
    member(Caracteristica, Caracteristicas).

keep_based_on_resp(Viaje, Caracteristica, no) :-
    viaje(Viaje, Caracteristicas),
    \+ member(Caracteristica, Caracteristicas).

mostrar_resultado([]) :-
    nl,
    write('No puedo recomendar ningun tipo de viaje con la informacion actual.'), nl.

mostrar_resultado([Viaje]) :-
    nl,
    format('Mi recomendacion es: ~w.~n', [Viaje]),
    explicar_si_quiere(Viaje).
mostrar_resultado(ListaViajes) :-
    nl,
    write('Hay varias posibles recomendaciones:'), nl,
    write('  '), write(ListaViajes), nl.

explicar_si_quiere(Viaje) :-
    nl,
    write('¿Quieres que te explique el razonamiento? (si/no): '),
    read(Resp),
    (   Resp == si
    ->  explicacion(Viaje)
    ;   true
    ).

explicacion(Viaje) :-
    viaje(Viaje, Caracteristicas),
    nl,
    format('He llegado a la conclusion de que es ~w a partir de estas caracteristicas confirmadas:~n',
           [Viaje]),
    listar_caracteristicas_si(Caracteristicas).

listar_caracteristicas_si([]).
listar_caracteristicas_si([C | R]) :-
    (   respuesta(C, si)
    ->  format('  [COND] ~w~n', [C])
    ;   true
    ),
    listar_caracteristicas_si(R).
