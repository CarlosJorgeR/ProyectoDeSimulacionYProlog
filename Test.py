from pyswip import Prolog,call

prolog=Prolog()
prolog.consult("Proyecto.pl")
prolog.consult("conexidad.pl")
prolog.consult("ambiente.pl")
N=9
M=9
PS=10
PO=20
PN=30
def d():
    return (0,10)
def Pos(prolog):
    XY=list(prolog.query("robot(X,Y)"))[0]
    X=XY['X']
    Y=XY['Y']
    return (X,Y)
def generar_ambiente(prolog):
    print("ambiente inicial {0}".format(bool(list(prolog.query("ambiente_inicial({0},{1},{2},{3},{4})".format(N,M,PS,PO,PN))))))
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
def Test2Mov(prolog):
    generar_ambiente(prolog)
    print("carga al principio {0}".format(bool(list(prolog.query("estado(carga)")))))
    graficar_ambiente(prolog)
    XY=list(prolog.query("robot(X,Y)"))[0]
    X=XY['X']
    Y=XY['Y']
    print(bool(list(prolog.query("estado(carga)"))))
    if(bool(list(prolog.query("movrobot({0},{1},{2},{3},1)".format(X,Y,X+1,Y))))):
        print("Se pudo 1")
        if(bool(list(prolog.query("movrobot({0},{1},{2},{3},0)".format(X+1,Y,X+2,Y))))):
            print("Se pudo 2")
        else:
            print("No se pudo 2")
    else:
        print("No se pudo 1")
    graficar_ambiente(prolog)
def MovimientosDisponibles(prolog):
    XY=list(prolog.query("robot(X,Y)"))[0]
    X=XY['X']
    Y=XY['Y']
    print("({0},{1})".format(X,Y))
    for i in list(prolog.query("ifmovrobot({0},{1},X,Y)".format(X,Y))):
        print(i)
def ProbarUnSoloTurnoDelAgente(prolog):

    X,Y=Pos(prolog)
    MovimientosDisponibles(prolog)
    print(list(prolog.query("turno(1,1)")))
    graficar_ambiente(prolog)
    #print(list(prolog.query("accion(moverse,({0},{1}),0)".format(X+1,Y))))
generar_ambiente(prolog)
graficar_ambiente(prolog)
ProbarUnSoloTurnoDelAgente(prolog)
ProbarUnSoloTurnoDelAgente(prolog)
#Test2Mov(prolog)
#MovimientosDisponibles(prolog)
