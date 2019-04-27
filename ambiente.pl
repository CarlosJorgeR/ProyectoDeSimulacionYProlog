ambiente_inicial(N,M,PS,PO,PN):-
    (PS+PO+(2*PN))<100,
    ambiente(N,M,T),
    C is N*M,
    cantidad(PN,C,PN_1),
    cantidad(PS,C,PS_1),
    cantidad(PO,C,PO_1),
    dynamic(corral/2),
    generar_conexo(T,corral,PN_1,RC),
    dynamic(obstaculo/2),
    generar(RC,obstaculo,RO,PO_1),
    dynamic(ninos/2),
    generar(RO,ninos,_,PN_1),
    dynamic(sucia/2),
    generar(RO,sucia,_,PS_1),
    generar_robot(RO,robot).
cantidad(P,T,C):-
    C is (P*T)//100.
ambiente(N,M,T):-
    findall((X,Y),
                (
                    N_1 is N-1,
                    M_1 is M-1,
                    numlist(0,N_1,L1),
                    numlist(0,M_1,L2),
                    member(X,L1),
                    member(Y,L2),
                    assert(posicion(X,Y))
                ),
                T).
%voy seleccion PS posiciones random de T y les aplica el predicado F a cada una de esas posiciones
generar(T,_,T,0):-!.
generar(T,F,Rest,PS):-
    random_select((X,Y),T,RestT),
    C=..[F,X,Y],
    assert(C),
    PS_1 is (PS-1),
    generar(RestT,F,Rest,PS_1).

generar_robot(RO,robot):-
    generar(RO,robot,_,1),
    robot(X,Y),
    ninos(X,Y),
    dynamic(estado/1),
    assert(estado(carga)).
generar_robot(_,_):-
    dynamic(estado/1).
% Borra el tablero dejando solo el robot y las posiciones
clear0():-
    retractall(corral(X,Y)),
    retractall(obstaculo(X,Y)),
    retractall(ninos(X,Y)),
    retractall(sucia(X,Y)).
clear1():-
    retractall(estado(X)),
    retractall(robot(X,Y)),
    retractall(posicion(X,Y)),
    clear0().
ninos_fuera(X,Y):-ninos(X,Y),not(corral(X,Y)).

corral_sin_ninos(X,Y):-corral(X,Y),not(ninos(X,Y)).
                                            