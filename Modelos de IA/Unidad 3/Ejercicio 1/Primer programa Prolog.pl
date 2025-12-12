% Hechos
vehiculo(coche).
vehiculo(moto).
vehiculo(bici).

% Propiedades
ruedas(coche, 4).
ruedas(moto, 2).
ruedas(bici, 2).

% Regla
es_de_dos_ruedas(V) :- vehiculo(V), ruedas(V, 2).