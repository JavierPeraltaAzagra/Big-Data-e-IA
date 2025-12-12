% Hechos básicos
clima(soleado).
clima(nublado).
clima(lluvioso).
clima(frio).

clima_actual(frio).

actividad(playa).
actividad(cine).
actividad(senderismo).
actividad(museo).
actividad(videojuegos).
actividad(correr).
actividad(compras).

aire_libre(playa).
aire_libre(senderismo).
aire_libre(correr).
interior(cine).
interior(museo).
interior(videojuegos).
interior(compras).

% Propiedades
prefiere(ana, interior).
prefiere(juan, aire_libre).
prefiere(lucia, aire_libre).
prefiere(lucia, interior).

% Reglas
actividad_apropiada(Actividad) :- clima_actual(Clima), actividad(Actividad), (   
                                                             (Clima = soleado, aire_libre(Actividad));
                                                             (Clima = nublado, (aire_libre(Actividad), Actividad \= playa));
                                                             (Clima = lluvioso, interior(Actividad));
                                                             (Clima = frio, (interior(Actividad), Actividad \= cine), Actividad \= compras)
                                                                             ).
