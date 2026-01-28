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
    write("=== Sistema experto de recomendación de transporte ==="), nl,
    busca_transporte,
    limpiar_memoria.

limpiar_memoria :-
    retractall(respuesta(_, _)).

busca_transporte :-
    