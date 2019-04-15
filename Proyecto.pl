%Primero genero los corrales ya que estos necesitan formar un grafo
%Las posiciones donde van los corrales y los ninos inicialmente puedem ser iguales
%
ambiente_inicial(N,M,PS,PO,PN):-(PS+PO+(2*PN))<100,
                                    ambiente(N,M,T),
                                        C is N*M,
                                            cantidad(PN,C,PN_1),
                                                cantidad(PS,C,PS_1),
                                                    cantidad(PO,C,PO_1),
                                                        generar_obstaculos(T,C,RO,PO_1),
                                                            generar_conexo(RO,corral,PN_1,S),
                                                                generar(RO,ninos,_,PN_1),
                                                                    generar(S,sucia,_,PS_1),
                                                                        generar(RO,robot,_,1),dynamic(estado/1),robot(X,Y),ninos(X,Y),assert(estado(carga)).
cantidad(P,T,C):-C is (P*T)//100.
ambiente(N,M,T):-findall((X,Y),
                            (N_1 is N-1,M_1 is M-1,
                                numlist(0,N_1,L1),numlist(0,M_1,L2),member(X,L1),member(Y,L2),assert(posicion(X,Y))
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
ady2((X,Y),(X_1,Y)):-X_1 is X+2.                                        
ady2((X,Y),(X_1,Y)):-X_1 is X-2.
ady2((X,Y),(X,Y_1)):-Y_1 is Y+2.
ady2((X,Y),(X,Y_1)):-Y_1 is Y-2.
generar_obstaculos(T,C,Rest,PO):-NPO is C-PO,
                                    generar_conexo(T,vacio,NPO,RestC),
                                        findall((X,Y),vacio(X,Y),Rest),
                                            retractall(vacio(X,Y)),
                                                findall((X,Y),(member((X,Y),RestC),assert(obstaculo(X,Y))),_).

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

swapPos((Xr,Yr),(X,Y),F):-Cr=..[F,Xr,Yr],retract(Cr),C=..[F,X,Y],assert(C).                                           
movrobot(Xr,Yr,X,Y):-estado(carga),!,not(
                                            (
                                                not(ady((Xr,Yr),(X,Y))),
                                                not(ady2((Xr,Yr),(X,Y)))
                                            )
                                        ),
                                        not(obstaculo(X,Y)),
                                        not(ninos(X,Y)),
                                            posicion(X,Y),
                                                swapPos((Xr,Yr),(X,Y),robot),swapPos((Xr,Yr),(X,Y),ninos).
movrobot(Xr,Yr,X,Y):-ninos(X,Y),!,
                        ady((Xr,Yr),(X,Y)),
                            not(obstaculo(X,Y)),
                                posicion(X,Y),
                                    swapPos((Xr,Yr),(X,Y),robot),assert(estado(carga)).
movrobot(Xr,Yr,X,Y):-ady((Xr,Yr),(X,Y)),
                            not(obstaculo(X,Y)),
                                posicion(X,Y),
                                    swapPos((Xr,Yr),(X,Y),robot).

limpiar(Xr,Yr):-sucia(Xr,Yr),retract(sucia(Xr,Yr)).
% acciones
accion(robot(Xr,Yr),limpiar,_,_):-limpiar(Xr,Yr).
accion(robot(Xr,Yr),moverse,X,Y):-movrobot(Xr,Yr,X,Y).
%Casillas que pueden estar juntas
% sucio,niño
% sucio,robot
% corral,niño,robot