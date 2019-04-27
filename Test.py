from pyswip import Prolog,call

prolog=Prolog()
prolog.consult("Proyecto.pl")
prolog.consult("conexidad.pl")
prolog.consult("ambiente.pl")
prolog.consult("clusters.pl")
N=10
M=10
PS=10
PO=30
PN=20
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
def BFS(prolog):
    X,Y=Pos(prolog)    
    print("({0},{1})".format(X,Y))
    for i in list(prolog.query("bfs(({0},{1}),ninos,Y)".format(X,Y))):
        for j in i['Y']:
            print(j)
def clusters(prolog):
    L=list(prolog.query("k_means_algorithm(4,R)"))
    for i in L[0]['R']:
        print(i)
    # print(L[0]['R'])
    for i in list(prolog.query("centroid(X,Y)")):
        print(i)
    print('----------------------------------------')
    for i in list(prolog.query("c((X,Y),(Xl,Yl))")):
         print(i)
def BFS3(prolog):
    L=list(prolog.query("robot(X,Y),bfs3([(X,Y)],[],R)"))
    print("X : {0}".format(L[0]['X']))
    print("Y : {0}".format(L[0]['Y']))
    for i in L[0]['R']:
        print(i)
def BFS4(prolog):
    L=list(prolog.query("robot(X,Y),bfs4(R),length(R,L)"))
    print("L : {0}".format(L[0]['L']))
    print("X : {0}".format(L[0]['X']))
    print("Y : {0}".format(L[0]['Y']))
    for i in L[0]['R']:
        print(i)
    # print('////////////////////////////////////////')
    # print(bool(list(prolog.query("recalculate_centriodes()"))))
    # for i in list(prolog.query("centroid(X,Y)")):
    #     print(i)
    # print('----------------------------------------')
    # for i in list(prolog.query("c((X,Y),(Xl,Yl))")):
    #      print(i)
generar_ambiente(prolog)
graficar_ambiente(prolog)

# BFS4(prolog)
clusters(prolog)
# ProbarUnSoloTurnoDelAgente(prolog)
# ProbarUnSoloTurnoDelAgente(prolog)
#Test2Mov(prolog)
#MovimientosDisponibles(prolog)
