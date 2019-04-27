agent1(limpiar,[((X,Y),0)],_,_):-
    robot(X,Y),
    sucia(X,Y),
    not(estado(carga)),
    !.
agent1(moverse,L,_,_):-
    robot(X,Y), 
    get_path1(X,Y,P),
    walk(P,L).
get_path1(X,Y,P):- estado(carga),!,
    bfs((X,Y),corral_sin_ninos,P).
get_path1(X,Y,P):- 
    bfs((X,Y),ninos_fuera,R),
    select_agent1((X,Y),R,P).
select_agent1((X,Y),[],R):-
    !,
    bfs((X,Y),sucia,R).
select_agent1((X,Y),R,R).