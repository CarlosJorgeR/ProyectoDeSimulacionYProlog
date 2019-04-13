from pyswip import Prolog,call

prolog=Prolog()
prolog.consult("Proyecto.pl")
N=5
M=5
PS=20
PO=20
PN=20

tablero=""
list(prolog.query("ambiente_inicial({0},{1},{2},{3},{4})".format(N,M,PS,PO,PN)))
for i in range(N):
    for j in range(M):
        if(bool(list(prolog.query("corral({0},{1})".format(i,j))))):
            if(bool(list(prolog.query("ninos({0},{1})".format(i,j))))):
                tablero+="| N |"
            else:
                tablero+="|   |"
        elif(bool(list(prolog.query("ninos({0},{1})".format(i,j))))):
            if(bool(list(prolog.query("sucia({0},{1})".format(i,j))))):
                tablero+="##N##"
            else:
                tablero+="  N  "
        elif(bool(list(prolog.query("sucia({0},{1})".format(i,j))))):
            tablero+="#####"
        elif(bool(list(prolog.query("obstaculo({0},{1})".format(i,j))))):
            tablero+="@@@@@"
        else:
            tablero+="     "
    tablero+="\n"
print(tablero)