%Primero genero los corrales ya que estos necesitan formar un grafo
%Las posiciones donde van los corrales y los ninos inicialmente puedem ser iguales
%
ambiente_inicial(N,M,PS,PO,PN):-(PS+PO+(2*PN))<100,
                                    ambiente(N,M,T),
                                        C is N*M,
                                            cantidad(PN,C,PN_1),
                                                cantidad(PS,C,PS_1),
                                                    cantidad(PO,C,PO_1),
                                                        generar_conexo(T,corral,PN_1,S),
                                                            generar(T,ninos,RT,PN_1),
                                                                generar(S,sucia,RS,PS_1),
                                                                    intersection(RT,RS,I),generar(I,obstaculo,_,PO_1).
cantidad(P,T,C):-C is (P*T)//100.

ambiente(N,M,T):-findall((X,Y),
                            (N_1 is N-1,M_1 is M-1,
                                numlist(0,N_1,L1),numlist(0,M_1,L2),member(X,L1),member(Y,L2)
                            ),
                                T).

%voy seleccion PS posiciones random de T y les aplica el predicado F a cada una de esas posiciones
generar(T,_,T,0):-!.
generar(T,F,Rest,PS):-random_select((X,Y),T,RestT),
                                C=..[F,X,Y],
                                assert(C),
                                    PS_1 is (PS-1),
                                            generar(RestT,F,Rest,PS_1).
ady((X,Y),(X_1,Y)):-X_1 is X+1.                                        
ady((X,Y),(X_1,Y)):-X_1 is X-1.
ady((X,Y),(X,Y_1)):-Y_1 is Y+1.
ady((X,Y),(X,Y_1)):-Y_1 is Y-1.
generar_conexo(T,_,0,T):-!.
generar_conexo(T,F,CC,R):-CC_1 is CC-1,
                    random_select((X,Y),T,T_1),
                        C=..[F,X,Y],
                            assert(C),
                                generar_conexo1(T_1,F,CC_1,R).
generar_conexo1(T,_,0,T):-!.
generar_conexo1(T,F,CC,R):-CC_1 is CC-1,
                                findall((X_1,Y_1),
                                        %Verificamos todos los (X,Y) que cumplen F que son ady (X_1,Y_1) que no cumplen F
                                            (XY=..[F,X,Y],XY,ady((X,Y),(X_1,Y_1)),member((X_1,Y_1),T),XY_1=..[F,X_1,Y_1],not(XY_1)),
                                Adys),
                                random_select((X_r,Y_r),Adys,_),
                                    select((X_r,Y_r),T, T_1),
                                        C=..[F,X_r,Y_r],
                                            assert(C),
                                                generar_conexo1(T_1,F,CC_1,R).


ninos_turno(N,M):-findall((X,Y),(ninos(X,Y),mover_nino(X,Y,N,M)),_).

mover_nino(X,Y,N,M):-not(corral(X,Y)),not(robot(X,Y)),direction(X1,Y1),mover(X1,Y1,X,Y).

inside(X,Y,N,M):- X>=0, X<N, Y>=0, Y<M.

direction(X,Y):- random_select((X,Y),[(-1,1),(-1,-1),(1,1),(1,-1),(0,1),(0,-1),(1,0),(-1,0)],_).

mover(X,Y,X1,Y1):-no_obstaculo(X,Y,X1,Y1),!, si_obstaculo(X,Y,X1,Y1).
no_obstaculo(X,Y,X1,Y1):- V is X + X1, W is Y + Y1,inside(V,W),not(obstaculo(V,W)),retract(nino(X,Y)),assert(nino(V,W)).

si_obstaculo(X,Y,X1,Y1):- mover_obstaculos(X,Y,X1,Y1),no_obstaculo(X,Y,X1,Y1).
ensuciar(X,Y):- Z is len(findall((X,Y),(ady(X,Y),nino(X,Y1)),_)),Z < 3, ensucio(ady(X,Y),Z)!.
ensuciar(X,Y):- ensucio(ady(X,Y),6).
ensucio(X,0):-
ensucio(X,Z):-random_select((V,W),X,R), not(sucia(X,Y)), retract(sucia(X,Y)), assert(sucia(X,Y)),K is Z-1,ensucio(R,K).


mover_obstaculos(X,Y,X1,Y1):- V is X + X1, W is Y + Y1,inside(V,W), not(obstaculo(X,Y)),!,not(nino(X,Y)),not(robot(X,Y)),
                                not(sucia(X,Y)),retract(obstaculo(X,Y)), assert(obstaculo(V,W)).
mover_obstaculos(X,Y,X1,Y1):- V is X + X1, W is Y + Y1, mover_obstaculos(V,W,X1,Y1).



%Casillas que pueden estar juntas
%sucio,niño
%sucio,robot
%corral,niño,robot