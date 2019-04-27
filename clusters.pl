
select_pos_random(_,0):-!.
select_pos_random(L,K):-K_1 is K-1,
                        random_select((X,Y), L, Lr),
                                assert(centroid(X,Y)),select_pos_random(Lr,K_1).

sum_pos([(X,Y)],(X,Y)):-!.
sum_pos([(X,Y)|R],(Xr,Yr)):-sum_pos(R,(Xs,Ys)),Xr is Xs+X,Yr is Ys+Y.
aveg_pos(R,(X,Y)):-sum_pos(R,(Xs,Ys)),length(R,L),X is Xs/L,Y is Ys/L.

recalculate_centroid(X,Y):-findall(
                                (Xl,Yl),
                                    (c((Xl,Yl),(X,Y))),
                                        L),
                                        aveg_pos(L,(Xa,Ya)),
                                            retractall(c((_,_),(X,Y))),
                                                retract(centroid(X,Y)),
                                                    assert(centroid(Xa,Ya)),
                                                        forall(member((Xl,Yl),L),
                                                            assert(c((Xl,Yl),(Xa,Ya)))).
                                                
recalculate_centriodes():-findall((X,Y),(centroid(X,Y),
                            recalculate_centroid(X,Y)),_).
min_centoid(X,Y):-retractall(c((X,Y),(Xl,Yl))),
                        findall(dxy(D,(Xc,Yc)),
                            (centroid(Xc,Yc),D is ((X-Xc)^2+(Y-Yc)^2)^0.5),
                                L)
                                    ,min_member(dxy(_,(Xl,Yl)),L),
                                        assert(c((X,Y),(Xl,Yl))).

% Este predicado itera por todos los puntos y les asigna el centroide mas cercano, con el predicado min_centroid
centrar(L):-findall((X,Y),(member((X,Y), L),min_centoid(X,Y)),_).
repeat(_,0):-!.
repeat(L,K):-K_1 is K-1,centrar(L),recalculate_centriodes(),repeat(L,K_1).

k_means_algorithm(K,R1):-  findall((Xl,Yl),(posicion(Xl,Yl)),L),
                            select_pos_random(L,K),
                                findall((Xl,Yl),(posicion(Xl,Yl),ninos(Xl,Yl)),Lr),
                                    dynamic(c/2),repeat(Lr,20),
                                        bfs4(R),
                                            min_list_respect(R,R1).

min_list_respect([],[]):-!.
min_list_respect(L,R):-findall((X,Y),centroid(X,Y),C),min_list_respect(L,C,R).
min_list_respect(_,[],[]):-!.
min_list_respect(L,[(X,Y)|P],[(Xr,Yr)|R]):-findall((D,(Xl,Yl)),
                                (member((Xl,Yl),L),X_1 is (Xl-X)^2,Y_1 is (Yl-Y)^2,D is (X_1+Y_1)^0.5),
                                L_1),min_member((_,(Xr,Yr)),L_1),min_list_respect(L,P,R).
