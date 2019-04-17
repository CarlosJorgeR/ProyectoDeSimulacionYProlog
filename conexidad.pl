module(conexidad,[generar_conexo/4,generar_conexo1/4]).

% este predicado sirve para saber si dos posiciones son adyacentes
ady((X,Y),(X_1,Y)):-X_1 is X+1.                                        
ady((X,Y),(X_1,Y)):-X_1 is X-1.
ady((X,Y),(X,Y_1)):-Y_1 is Y+1.
ady((X,Y),(X,Y_1)):-Y_1 is Y-1.

ady2((X,Y),(X_1,Y)):-X_1 is X+2.                                        
ady2((X,Y),(X_1,Y)):-X_1 is X-2.
ady2((X,Y),(X,Y_1)):-Y_1 is Y+2.
ady2((X,Y),(X,Y_1)):-Y_1 is Y-2.
ady2((X,Y),(X_1,Y_1)):-ady((X,Y),(X_1,Y_1)).
%este predicado sirve para a partir de una lista de puntos, y una funcion F se genera una lista de puntos random R con una cantidad CC que es conexa
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

