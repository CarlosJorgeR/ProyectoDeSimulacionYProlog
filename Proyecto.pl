%Primero genero los corrales ya que estos necesitan formar un grafo
%Las posiciones donde van los corrales y los ninos inicialmente puedem ser iguales

swapPos((Xr,Yr),(X,Y),F):-Cr=..[F,Xr,Yr],retract(Cr),C=..[F,X,Y],assert(C).
dejo(1):-retract(estado(carga)).
dejo(0).
%este predicado verifica si se puede mover el robot de la pos Xr,Yr a la X,Y en esta posicion
ifmovrobot(Xr,Yr,X,Y):-estado(carga),!,ady2((Xr,Yr),(X,Y)),
                                        not(obstaculo(X,Y)),
                                            not(ninos(X,Y)),
                                                posicion(X,Y).
ifmovrobot(Xr,Yr,X,Y):-not(estado(carga)),ady((Xr,Yr),(X,Y)),
                                    not(obstaculo(X,Y)),
                                        posicion(X,Y).

movrobot(Xr,Yr,X,Y,D):-estado(carga),!,
                                ifmovrobot(Xr,Yr,X,Y),
                                    swapPos((Xr,Yr),(X,Y),robot),swapPos((Xr,Yr),(X,Y),ninos),dejo(D).
movrobot(Xr,Yr,X,Y,_):-ninos(X,Y),!,
                            ifmovrobot(Xr,Yr,X,Y),
                                swapPos((Xr,Yr),(X,Y),robot),assert(estado(carga)).
movrobot(Xr,Yr,X,Y,_):-ifmovrobot(Xr,Yr,X,Y),
                                swapPos((Xr,Yr),(X,Y),robot).

limpiar(Xr,Yr):-sucia(Xr,Yr),retract(sucia(Xr,Yr)).
% acciones
accion(limpiar,_):-robot(Xr,Yr),not(estado(carga)),limpiar(Xr,Yr).
accion(moverse,(X,Y),D):-robot(Xr,Yr),movrobot(Xr,Yr,X,Y,D).

ninos_turno().

% Aqui se implementa el agente
agente(limpiar,(X,Y),0,_,_):-robot(X,Y),sucia(X,Y),!.
% Aqui hacemos mover el agente a una posicion random y si es un corral se deja el nino si se esta cargando
agente(moverse,(X,Y),1,_,_):-robot(Xr,Yr),findall((Xm,Ym),ifmovrobot(Xr,Yr,Xm,Ym),L),random_select((X,Y),L,_),corral(X,Y),!.
agente(moverse,(X,Y),0,_,_):-robot(Xr,Yr),findall((Xm,Ym),ifmovrobot(Xr,Yr,Xm,Ym),L),random_select((X,Y),L,_).
%  en el turno falta la talla de los ninos
turno(T_p,T):-agente(Accion,(X,Y),D,T_p,T),accion(Accion,(X,Y),D).
simulacion(T,0,T).
simulacion(T,C,T):-C_1 is C-1,simulacion(T,C_1,0).
simulacion(T,C,T_p):-turno(T_p,T),T_p_1 is T_p+1,simulacion(T,C,T_p_1).

program(N,M,PS,PO,PN,T):-ambiente_inicial(N,M,PS,PO,PN),simulacion(T,100,0).
