agent2(limpiar,[((X,Y),0)],_,_):-
    robot(X,Y),
    sucia(X,Y),
    not(estado(carga)),
    !.
agent2(moverse,L,_,_):-
    robot(X,Y), 
    get_path2(X,Y,P),
    walk(P,L).
get_path2(X,Y,P):- estado(carga),!,
    bfs((X,Y),corral_sin_ninos,P).
get_path2(X,Y,P):- 
    bfs((X,Y),sucia,R),
    select_agent2((X,Y),R,P).
select_agent2((X,Y),[],R):-
    !,
    bfs((X,Y),ninos_fuera,R).

select_agent2((X,Y),R,R).