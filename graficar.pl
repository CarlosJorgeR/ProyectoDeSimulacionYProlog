graficar(X,Y):-
    corral(X,Y),
    ninos(X,Y),
    robot(X,Y),
    !,
    write('|B R|').
graficar(X,Y):-
    corral(X,Y),
    ninos(X,Y),
    !,
    write('| B |').
graficar(X,Y):-
    corral(X,Y),
    robot(X,Y),
    !,
    write('| R |').
graficar(X,Y):-
    corral(X,Y),
    !,
    write('|   |').
graficar(X,Y):-
    ninos(X,Y),
    sucia(X,Y),
    robot(X,Y),
    !,
    write('#B#R#').
graficar(X,Y):-
    ninos(X,Y),
    sucia(X,Y),
    !,
    write('##B##').
graficar(X,Y):-
    ninos(X,Y),
    robot(X,Y),
    !,
    write(' B R ').
graficar(X,Y):-
    ninos(X,Y),
    !,
    write('  B  ').
graficar(X,Y):-
    sucia(X,Y),
    robot(X,Y),
    !,
    write('##R##').
graficar(X,Y):-
    sucia(X,Y),
    !,
    write('#####').
graficar(X,Y):-
    obstaculo(X,Y),
    !,
    write('@@@@@').
graficar(X,Y):-
    robot(X,Y),
    !,
    write('  R  ').
graficar(X,Y):-
    write('     ').
graficar():-
    setof(X, posicion(X,_),LN),
    setof(Y, posicion(_,Y),LM),
    foreach(member(X,LN),
        (
            foreach(
                member(Y,LM),
                graficar(X,Y)
            ),
            nl
        )
    ),
    write('-----------------------------'),
    nl
    .