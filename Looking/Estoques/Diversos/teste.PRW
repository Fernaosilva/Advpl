#include "rwmake.ch"

user function teste()

//DbSelectArea("SZ5")
//DbSetOrder(1)
cFreq:= posicione("SZ5",1,XFilial("SZ5")+"LK-033","Z5_ZZFREQ")
//DbCloseArea("SZ5")


//DbSelectArea("SZ6")
//DbSetOrder(1)
dData := posicione("SZ6",1,XFilial("SZ6")+"LK-033","Z6_ZZDATA")
//DbCloseArea("SZ6")

dProx:= dData + cFreq 
alert(dProx)
alert(dData)
alert(cFreq)

cTeste:= dtoc(dProx)
alert(cTeste)





return(cTeste)