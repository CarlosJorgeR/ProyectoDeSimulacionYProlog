ninos_turno():-
    findall(
        (X,Y),
        (ninos(X,Y),mover_nino(X,Y)),
    _).

%carga en vez de robot
mover_nino(X,Y):-
    not(corral(X,Y)),
    not(robot(X,Y)),
    direction(X1,Y1),
    ensuciar(X,Y),
    mover(X,Y,X1,Y1).

direction(X,Y):- 
    random_select((X,Y),[(-1,1),(-1,-1),(1,1),(1,-1),(0,1),(0,-1),(1,0),(-1,0)],_).


mover(X,Y,X1,Y1):-
    V is X + X1, 
    W is Y + Y1,
    write(X1),
    write(Y1),
    nl,
    obstaculo(V,W),
    write('mover obstaculo'),
    nl,
    mover_obstaculos(V,W,X1,Y1),
    !,
    retract(ninos(X,Y)),
    assert(ninos(V,W)).
mover(X,Y,X1,Y1):- 
    V is X + X1,
    W is Y + Y1,
    not(obstaculo(V,W)),
    not(corral(V,W)),
    not(robot(V,W)),
    not(ninos(V,W)),
    posicion(V,W),
    !,
    write('no hay obstaculo'),
    nl,
    retract(ninos(X,Y)),
    assert(ninos(V,W)).
mover(_,_,_,_).


mover_obstaculos(X,Y,X1,Y1):- 
    V is X + X1,
    W is Y + Y1,
    not(obstaculo(V,W)),
    !,
    posicion(V,W),
    not(ninos(V,W)),
    not(robot(V,W)),
    not(sucia(V,W)),
    not(corral(V,W)),
    retract(obstaculo(X,Y)),
    assert(obstaculo(V,W)).
mover_obstaculos(X,Y,X1,Y1):- 
    V is X + X1,
    W is Y + Y1,
    obstaculo(X,Y),
    write('dale'),
    nl,
    mover_obstaculos(V,W,X1,Y1),
    retract(obstaculo(X,Y)),
    assert(obstaculo(V,W)).

ensuciar(X,Y):- 
    write('ensucio'),
    nl,
    findall(
        (X1,Y1),
        (
            ady((X,Y),(X1,Y1)),ninos(X1,Y1)
        ),
        L
    ),
    length(L,Z),
    write('>>>>'),
    write(Z),
    nl,
    Z < 2,
    !,
    findall(
        (X1,Y1),
        ady((X,Y),(X1,Y1)),
        L1
    ),
    append([(X,Y)],L1,L2),
    Z_1 is Z+1,
    ensucio(L2,Z_1).
ensuciar(X,Y):-
    findall(
            (X1,Y1),
            ady((X,Y),(X1,Y1)),
            L2
    ),
    ensucio(L2,6).
ensucio(L,0):-
    !.
ensucio(L,Z):-
    random_select((X,Y),L,R),
    ensucio2(X,Y),
    Z_1 is Z-1,
    ensucio(R,Z_1).
% Este predicado ensucia una posicion especifica si puede
ensucio2(X,Y):-
    not(obstaculo(X,Y)),
    !,
    assert(sucia(X,Y)).
ensucio2(X,Y).
