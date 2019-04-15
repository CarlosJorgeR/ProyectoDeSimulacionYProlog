from pyswip import Prolog,call

prolog=Prolog()
prolog.consult("Proyecto.pl")
N=7
M=7
PS=20
PO=10
PN=30
# tablero=""
# list(prolog.query("ambiente({0},{1},T),generar_obstaculos(T,25,R,10)".format(N,M)))
# for i in range(N):
#     for j in range(M):
#         if(bool(list(prolog.query("obstaculo({0},{1})".format(i,j))))):
#                 tablero+="@@@@@"
#         else:
#             tablero+="     "
#     tablero+="\n"
# print(tablero)
# for i in list(prolog.query("vacio(X,Y)")):
#     print(i)
def generar_ambiente(prolog):
    list(prolog.query("ambiente_inicial({0},{1},{2},{3},{4})".format(N,M,PS,PO,PN)))
def graficar_ambiente(prolog):
    tablero=""
    for i in range(N):
        for j in range(M):
            if(bool(list(prolog.query("corral({0},{1})".format(i,j))))):
                if(bool(list(prolog.query("ninos({0},{1})".format(i,j)))) and bool(list(prolog.query("robot({0},{1})".format(i,j))))):
                    tablero+="|B R|"
                elif(bool(list(prolog.query("ninos({0},{1})".format(i,j))))):
                    tablero+="| B |"
                elif(bool(list(prolog.query("robot({0},{1})".format(i,j))))):
                    tablero+="| R |"
                else:
                    tablero+="|   |"
            elif(bool(list(prolog.query("ninos({0},{1})".format(i,j))))):
                if(bool(list(prolog.query("sucia({0},{1})".format(i,j)))) and bool(list(prolog.query("robot({0},{1})".format(i,j))))):
                    tablero+="#B#R#"
                elif(bool(list(prolog.query("sucia({0},{1})".format(i,j))))):
                    tablero+="##B##"
                elif(bool(list(prolog.query("robot({0},{1})".format(i,j))))):
                    tablero+=" B R "
                else:
                    tablero+="  B  "
            elif(bool(list(prolog.query("sucia({0},{1})".format(i,j))))):
                if(bool(list(prolog.query("robot({0},{1})".format(i,j))))):
                    tablero+="##R##"
                else:
                    tablero+="#####"
            elif(bool(list(prolog.query("obstaculo({0},{1})".format(i,j))))):
                tablero+="@@@@@"
            elif(bool(list(prolog.query("robot({0},{1})".format(i,j))))):
                    tablero+="  R  "
            else:
                tablero+="     "
        tablero+="\n"
    print(tablero)
generar_ambiente(prolog)
graficar_ambiente(prolog)
XY=list(prolog.query("robot(X,Y)"))[0]
X=XY['X']
Y=XY['Y']
if(bool(list(prolog.query("movrobot({0},{1},{2},{3})".format(X,Y,X+1,Y))))):
    print("Se pudo")
else:
    print("No se pudo")
graficar_ambiente(prolog)