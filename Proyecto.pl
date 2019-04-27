%Primero genero los corrales ya que estos necesitan formar un grafo
%Las posiciones donde van los corrales y los ninos inicialmente puedem ser iguales
swapPos((Xr,Yr),(X,Y),ninos):-
    estado(carga),
    corral(Xr,Yr),
    !,
    assert(ninos(X,Y)).
swapPos((Xr,Yr),(X,Y),F):-
    Cr=..[F,Xr,Yr],
    retract(Cr),
    C=..[F,X,Y],
    assert(C).
dejo(1):-
    retract(estado(carga)),
    write('Dejo a un nino'),
    nl.
dejo(0).
%este predicado verifica si se puede mover el robot de la pos Xr,Yr a la X,Y en esta posicion
ifmovrobot((Xr,Yr),(X1,Y1)):-
    estado(carga),
    !,
    ady((Xr,Yr),(X1,Y1)),
    not(obstaculo(X1,Y1)),
    (not(ninos(X1,Y1));(ninos(X1,Y1),corral(X1,Y1))).
ifmovrobot((Xr,Yr),(X1,Y1)):-
    ady((Xr,Yr),(X1,Y1)),
    not(obstaculo(X1,Y1)).

movrobot((Xr,Yr),(X,Y),D):-
    estado(carga),
    !,
    ifmovrobot((Xr,Yr),(X,Y)),
    swapPos((Xr,Yr),(X,Y),robot),
    swapPos((Xr,Yr),(X,Y),ninos),
    write('Se movio con un nino cargado'),
    nl,
    dejo(D).
movrobot((Xr,Yr),(X,Y),_):-
    (ninos(X,Y),not(corral(X,Y))),
    !,
    ifmovrobot((Xr,Yr),(X,Y)),
    swapPos((Xr,Yr),(X,Y),robot),
    assert(estado(carga)),
    write('Se movio y cargo un nino'),
    nl.
movrobot((Xr,Yr),(X,Y),_):-
    ifmovrobot((Xr,Yr),(X,Y)),
    swapPos((Xr,Yr),(X,Y),robot),
    write('Se movio'),
    nl.

limpiar(Xr,Yr):-
    sucia(Xr,Yr),
    retract(sucia(Xr,Yr)).
% acciones
accion(_,[],0).
accion(limpiar,_,1):-
    robot(Xr,Yr),
    not(estado(carga)),
    limpiar(Xr,Yr).
accion(moverse,[((X,Y),D)],1):-
    robot(Xr,Yr),
    movrobot((Xr,Yr),(X,Y),D).
accion(moverse,[((X1,Y1),D1),((X2,Y2),D2)],1):-
    robot(Xr,Yr),
    movrobot((Xr,Yr),(X1,Y1),D1),
    movrobot((X1,Y1),(X2,Y2),D2).

%Por ciento de casillas sucias.
p_casillas_sucias(P):-findall((X,Y), sucia(X,Y), Ls),findall((X,Y), posicion(X,Y), Lp),length(Ls,Cs),length(Lp,Cp),P is Cs/Cp.

%  en el turno falta la talla de los ninos
turno(T_p,T,D):-
    % random_agent(Accion,L,T_p,T),
    agent1(Accion,L,T_p,T),
    accion(Accion,L,D),
    % ninos_turno(),
    graficar().
% El ultimo valor de simulacion determina si se termina la simulacion o no
simulacion(_,_,_,_,_,_,_,_,0):-!.
simulacion(_,_,_,_,_,T,0,T,_):-
    !.
simulacion(N,M,PS,PO,PN,T,C,T,_):-
    !,
    C_1 is C-1,
    clear1(),
    ambiente_inicial(N,M,PS,PO,PN),
    simulacion(N,M,PS,PO,PN,T,C_1,0,1).
simulacion(N,M,PS,PO,PN,T,C,T_p,1):-
    p_casillas_sucias(P),
    P<0.6,!,
    turno(T_p,T,D),
    % graficar(),
    T_p_1 is T_p+1,
    simulacion(N,M,PS,PO,PN,T,C,T_p_1,D).
simulacion(_,_,_,_,_,_,_,_,1):-
    assert(estado(despedido)),
    write('Despedido'),
    nl.

program(N,M,PS,PO,PN,T,C):-
    consult('ambiente.pl'),
    consult('conexidad.pl'),
    consult('agentes.pl'),
    consult('agente1.pl'),
    consult('agente2.pl'),
    consult('graficar.pl'),
    consult('kid_move.pl'),
    ambiente_inicial(N,M,PS,PO,PN),
    graficar().
    % simulacion(N,M,PS,PO,PN,T,C,0,1).
    % clear1().