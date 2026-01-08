% nombres de personas
persona(alfonso).
persona(ana).
persona(carlos).
persona(carmen).
persona(fernando).
persona(isabel).
persona(luis).
persona(maria).

% deportes
deporte(marcha).
deporte(vallas).
deporte(cross).
deporte(disco).
deporte(martillo).
deporte(salto).
deporte(esqui_alpino).
deporte(esqui_fondo).
deporte(snowboard).
deporte(trineo).
deporte(futbol).
deporte(baloncesto).
deporte(balonmano).
deporte(voleibol).
deporte(waterpolo).

% deportes y su clasificacion
tipo_deporte(marcha,atletismo).
tipo_deporte(vallas,atletismo).
tipo_deporte(cross,atletismo).
tipo_deporte(disco,atletismo).
tipo_deporte(martillo,atletismo).
tipo_deporte(salto,nieve).
tipo_deporte(esqui_alpino,nieve).
tipo_deporte(esqui_fondo,nieve).
tipo_deporte(snowboard,nieve).
tipo_deporte(trineo,nieve).
tipo_deporte(futbol,equipo).
tipo_deporte(baloncesto,equipo).
tipo_deporte(balonmano,equipo).
tipo_deporte(voleibol,equipo).
tipo_deporte(waterpolo,equipo).

% deporte que practica cada uno y nivel
practica(alfonso,categoria(baloncesto,nba)).
practica(ana,categoria(vallas,regional)).
practica(carlos,categoria(marcha,nacional)).
practica(carmen,categoria(futbol,tercera)).
practica(fernando,categoria(baloncesto,aficionado)).
practica(isabel,categoria(cross,regional)).
practica(luis,categoria(snowboard,aficionado)).
practica(maria,categoria(waterpolo,aficionado)).

