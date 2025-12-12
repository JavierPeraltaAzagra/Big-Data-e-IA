% -------------------------------------------------------------
% 02_recomendador.pl
% Sistema simple de recomendación de actividades según clima
% -------------------------------------------------------------

% -------------------------------------------------------------
% 1. HECHOS BÁSICOS
% -------------------------------------------------------------

% Tipos de clima posibles (informativo, no imprescindible para la lógica)
clima(soleado).
clima(nublado).
clima(lluvioso).
clima(frio).

% Clima actual (cámbialo para probar otros casos)
% Puedes comentar uno y descomentar otro según el día que quieras simular.

% clima_actual(soleado).
% clima_actual(nublado).
% clima_actual(lluvioso).
clima_actual(frio).

% Actividades disponibles
actividad(playa).
actividad(cine).
actividad(senderismo).
actividad(museo).
actividad(videojuegos).
actividad(correr).
actividad(compras).

% Clasificación: aire libre / interior
aire_libre(playa).
aire_libre(senderismo).
aire_libre(correr).

interior(cine).
interior(museo).
interior(videojuegos).
interior(compras).

% Preferencias personales
% prefiere(Persona, TipoPreferencia).

prefiere(ana, interior).
prefiere(juan, aire_libre).
prefiere(lucia, ambos).

% -------------------------------------------------------------
% 2. REGLAS
% -------------------------------------------------------------
% A) Actividades apropiadas según el clima
% -------------------------------------------------------------
% actividad_apropiada(Actividad).

% Clima soleado: cualquier actividad de aire libre es apropiada.
actividad_apropiada(A) :-
    clima_actual(soleado),
    aire_libre(A).

% Clima nublado: senderismo o correr sí, playa no.
actividad_apropiada(A) :-
    clima_actual(nublado),
    aire_libre(A),
    A \= playa.

% Clima lluvioso: solo actividades de interior.
actividad_apropiada(A) :-
    clima_actual(lluvioso),
    interior(A).

% Clima frío: solo museo o videojuegos (actividades de interior "tranquilas").
actividad_apropiada(A) :-
    clima_actual(frio),
    ( A = museo ; A = videojuegos ).

% -------------------------------------------------------------
% B) Recomendación personalizada
% -------------------------------------------------------------
% recomendar(Persona, Actividad).

% Persona que prefiere interior:
recomendar(P, A) :-
    prefiere(P, interior),
    interior(A),
    actividad_apropiada(A).

% Persona que prefiere aire libre:
recomendar(P, A) :-
    prefiere(P, aire_libre),
    aire_libre(A),
    actividad_apropiada(A).

% Persona que prefiere ambos tipos:
recomendar(P, A) :-
    prefiere(P, ambos),
    actividad_apropiada(A).

% -------------------------------------------------------------
% 3. EJEMPLOS DE CONSULTAS ESPERADAS
% (para probar en el intérprete)
% -------------------------------------------------------------
%
% Listar actividades apropiadas según el clima actual:
%   ?- actividad_apropiada(X).
%
% Recomendar actividades a ana:
%   ?- recomendar(ana, X).
%
% Recomendar actividades a juan:
%   ?- recomendar(juan, X).
%
% Preguntar si lucia puede ir a la playa:
%   ?- recomendar(lucia, playa).
%
% Actividades NO apropiadas con el clima actual:
%   ?- actividad(X), \+ actividad_apropiada(X).
%
% Para probar otros climas, cambia el hecho clima_actual/1
% comentando uno y descomentando otro.
%
% -------------------------------------------------------------
