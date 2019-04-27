module(conexidad,[generar_conexo/4,generar_conexo1/4]).

% este predicado sirve para saber si dos posiciones son adyacentes
ady((X,Y),(X_1,Y)):-X_1 is X+1,posicion(X_1,Y).                                        
ady((X,Y),(X_1,Y)):-X_1 is X-1,posicion(X_1,Y).
ady((X,Y),(X,Y_1)):-Y_1 is Y+1,posicion(X,Y_1).
ady((X,Y),(X,Y_1)):-Y_1 is Y-1,posicion(X,Y_1).
ady((X,Y),(X_1,Y_1)):-X_1 is X+1,Y_1 is Y+1,posicion(X_1,Y_1).                                        
ady((X,Y),(X_1,Y_1)):-X_1 is X-1,Y_1 is Y-1,posicion(X_1,Y_1).
ady((X,Y),(X_1,Y_1)):-X_1 is X-1,Y_1 is Y+1,posicion(X_1,Y_1).
ady((X,Y),(X_1,Y_1)):-X_1 is X+1,Y_1 is Y-1,posicion(X_1,Y_1).

%este predicado sirve para a partir de una lista de puntos, y una funcion F se genera una lista de puntos random R con una cantidad CC que es conexa
generar_conexo(T,_,0,T):-!.
generar_conexo(T,F,CC,R):-
    CC_1 is CC-1,
    random_select((X,Y),T,T_1),
    C=..[F,X,Y],
    assert(C),
    generar_conexo1(T_1,F,CC_1,R).
generar_conexo1(T,_,0,T):-!.
generar_conexo1(T,F,CC,R):-
    CC_1 is CC-1,
    findall((X_1,Y_1),
    %Verificamos todos los (X,Y) que cumplen F que son ady (X_1,Y_1) que no cumplen F
    (XY=..[F,X,Y],XY,ady((X,Y),(X_1,Y_1)),member((X_1,Y_1),T),XY_1=..[F,X_1,Y_1],not(XY_1)),
    Adys),
    random_select((X_r,Y_r),Adys,_),
    select((X_r,Y_r),T, T_1),
    C=..[F,X_r,Y_r],
    assert(C),
    generar_conexo1(T_1,F,CC_1,R).

% casillas_conexas(L,R):-findall((X,Y),
%                             (select((X,Y),L,Lr),es_conexo(Lr)),
%                                 R).
% es_conexo([(X,Y)|R]):-length(R,L),bfs3([(X,Y)],[],R,R1),length(R1,L1),L+1=:=L1.

bfs((X,Y),F,R2):-
    bfs2([p((X,Y),[])],[],F,R1),
    ((R1=[],R2=[]);reverse(R1,[_|R2])).
bfs2([],_,_,[]):-!.
% write('Aqui2'),
% nl.
bfs2([p((X,Y),Rxy)|_],_,F,[(X,Y)|Rxy]):- 
    % write(X),write(Y),
    % nl,
    Fc=..[F,X,Y],Fc,!.
bfs2([p((X,Y),Rxy)|R],C,F,P):- 
    % write(X),write(Y),nl,
    findall(
        p((Xa,Ya),[(X,Y)|Rxy]),
        (ifmovrobot((X,Y),(Xa,Ya)),not(obstaculo(Xa,Ya)),not(member((Xa,Ya),C))),
    L),
    findall(
        (Xl,Yl),
        member(p((Xl,Yl),_),L),
    L2),
    append(C,L2,C2),
    append(R,L,R2),
    bfs2(R2,[(X,Y)|C2],F,P).

union_bfs4([],X,X).
union_bfs4([p((X,Y),Rest)|R1],Z,[p((X,Y),Rest)|R2]):-not(member(p((X,Y),_),Z)),!,union_bfs4(R1,Z,R2).
union_bfs4([p((X,Y),_)|R1],Z,R2):-union_bfs4(R1,Z,R2).


% % R es el grupo de puntos que representan al grafo y R1 todos los puntos que alcanza
% bfs3((X,Y),R,R1):-bfs3([(X,Y)],[],R,R1).
% bfs3([],_,_,[]):-!.
% bfs3([(X,Y)|R],C,A,[(X,Y)|R1]):-findall((Xa,Ya),
%                                 (ady((X,Y),(Xa,Ya)),member((Xa,Ya),A),not(member((Xa,Ya),C))),
%                                     L),
%                                         union(R,L,R2),
%                                             bfs3(R2,[(X,Y)|C],A,R1).

%Este bfs calcula todas las posiciones que puede alcanzar el robot
bfs4(R):-robot(Xr,Yr),bfs4([(Xr,Yr)],[],R). 
bfs4([],_,[]):-!.
bfs4([(X,Y)|R],C,[(X,Y)|R1]):-
                        write(X),write(Y),nl,
                            findall((Xa,Ya),
                                (ady((X,Y),(Xa,Ya)),not(obstaculo(Xa,Ya)),not(member((Xa,Ya),C))),
                                    L),
                                        union(R,L,R2),
                                            bfs4(R2,[(X,Y)|C],R1).