hombre(fernandoI).
hombre(fernandoII).
hombre(fernandoIII).
hombre(leandro).
hombre(miguelII).
hombre(miguelIV).
hombre(tomas).
hombre(juanIII).
hombre(juanIV).
hombre(ignacio).

mujer(carmenI).
mujer(carmenII).
mujer(paloma).
mujer(victoria).
mujer(montserrat).
mujer(isabel).
mujer(idoia). 
mujer(mercedesI).
mujer(mercedesII).   

% Carmen I y Fernando I 
progenitor(carmenI, paloma).
progenitor(fernandoI, paloma).

progenitor(carmenI, carmenII).
progenitor(fernandoI, carmenII).

progenitor(carmenI, victoria).
progenitor(fernandoI, victoria).

progenitor(carmenI, montserrat).
progenitor(fernandoI, montserrat).

progenitor(carmenI, fernandoII).
progenitor(fernandoI, fernandoII).

% Leandro y Mercedes I 
progenitor(leandro, miguelII).
progenitor(mercedesI, miguelII).

progenitor(leandro, mercedesII).
progenitor(mercedesI, mercedesII).

% Carmen II y Miguel II

progenitor(carmenII, fernandoIII).
progenitor(miguelII, fernandoIII).

progenitor(carmenII, juanIII).
progenitor(miguelII, juanIII).

% Isabel y Fernando II 
progenitor(isabel, miguelIV).
progenitor(fernandoII, miguelIV).

progenitor(isabel, tomas).
progenitor(fernandoII, tomas).

% Juan III e Idoia 
progenitor(juanIII, juanIV).
progenitor(idoia, juanIV).

progenitor(juanIII, ignacio).
progenitor(idoia, ignacio).

matrimonio_base(fernandoI, carmenI).
matrimonio_base(leandro, mercedesI).
matrimonio_base(miguelII, carmenII).
matrimonio_base(fernandoII, isabel).
matrimonio_base(juanIII, idoia).

matrimonio(X, Y) :- matrimonio_base(X, Y).
matrimonio(X, Y) :- matrimonio_base(Y, X).

padre(Padre, Hijo) :- hombre(Padre), progenitor(Padre, Hijo).
madre(Madre, Hijo) :- mujer(Madre), progenitor(Madre, Hijo).

hermano(Hermano1, Hermano2) :-
    hombre(Hermano1),
    progenitor(Padre, Hermano1),
    progenitor(Padre, Hermano2),
    Hermano1 \= Hermano2.

hermana(Hermana1, Hermana2) :-
    mujer(Hermana1),
    progenitor(Padre, Hermana1),
    progenitor(Padre, Hermana2),
    Hermana1 \= Hermana2.

hermanos(Hermano1, Hermano2) :-
    progenitor(Padre, Hermano1),
    progenitor(Padre, Hermano2),
    Hermano1 \= Hermano2.

esposo(Esposo, Esposa) :-
    hombre(Esposo),
    mujer(Esposa),
    progenitor(Esposo, Hijo),
    progenitor(Esposa, Hijo).

esposa(Esposa, Esposo) :-
    mujer(Esposa),
    hombre(Esposo),
    progenitor(Esposa, Hijo),
    progenitor(Esposo, Hijo).

nieto(Nieto, Abuelo) :-
    hombre(Nieto),
    hombre(Abuelo),
    progenitor(Abuelo, Progenitor),
    progenitor(Progenitor, Nieto).

nieta(Nieta, Abuela) :-
    mujer(Nieta),
    mujer(Abuela),
    progenitor(Abuela, Progenitor),
    progenitor(Progenitor, Nieta).