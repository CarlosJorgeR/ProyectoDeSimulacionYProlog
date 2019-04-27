% Aqui se implementa el agente
random_agent(limpiar,[((X,Y),0)],_,_):-
    robot(X,Y),
    sucia(X,Y),
    !.
% Aqui hacemos mover el agente a una posicion random y si es un corral se deja el nino si se esta cargando
random_agent(moverse,[((X,Y),D)],_,_):-
    robot(Xr,Yr),
    findall(
        (Xm,Ym),
        ifmovrobot((Xr,Yr),(Xm,Ym)),
        L
    ),
    random_select((X,Y),L,_),
    select_mode_random_agent((X,Y),D),
    !.
% Dada una posicion que el robot se va a mover se determina en caso de cargar un nino si lo deja o no
select_mode_random_agent((X,Y),0):-
    corral(X,Y),
    ninos(X,Y),
    !.
select_mode_random_agent((X,Y),1):-
    corral(X,Y),
    !.
select_mode_random_agent((_,_),0).
% agente_limpiador(limpiar,(X,Y),0,_,_):-robot(X,Y),sucia(X,Y),!.
% agente_limpiador(moverse,(X,Y),1,_,_):-robot(Xr,Yr),bfs((Xr,Yr),sucia,[(X,Y1)|R]).

%Agente greedy
greedy_agent(limpiar,[((X,Y),0)],_,_):-
    robot(X,Y),
    sucia(X,Y),
    not(estado(carga)),
    !.
greedy_agent(moverse,L,_,_):-
    robot(X,Y), 
    get_path(X,Y,P),
    walk(P,L).
    

get_path(X,Y,P):- estado(carga),!,
    bfs((X,Y),corral_sin_ninos,P).
get_path(X,Y,P):- 
    bfs((X,Y),ninos_fuera,R),
    bfs((X,Y),sucia,F),selection(R,F,P).
selection([],B,B):-!.
selection(A,[],A):-!.
selection(A,B,B):- 
    length(A,C),
    length(B,D),
    C >= D,
    !.
selection(A,B,A).

walk([],[]):-!.
walk([(X1,Y1),(X2,Y2)|_],[((X1,Y1),D1),((X2,Y2),D2)]):- 
    estado(carga),
    !,
    select_mode_random_agent((X1,Y1),D1),
    select_mode_random_agent((X2,Y2),D2).
walk([(X1,Y1)|_],[((X1,Y1),D1)]):-
    select_mode_random_agent((X1,Y1),D1).

