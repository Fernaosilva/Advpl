#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

User Function pcali()
dData:=""
nErro:=0
nFreq:=0
cAceit:=0
dProx:=""

//DbSelectArea("SZ6")
//DbSetOrder(1)

dData := M->Z6_ZZDATA
nErro:= M->Z6_ZZERROM
cNum:=M->Z6_ZZNUM

DbSelectArea("SZ5")
DbSetOrder(1)

nFreq:=posicione("SZ5",1,XFilial("SZ5")+cNum,"Z5_ZZFREQ")
nAceit:=posicione("SZ5",1,XFilial("SZ5")+cNum,"Z5_ZZCRITE")

If nErro > nAceit

dProx:= dData

else

dProx:= dData + nFreq 

MsgInfo("A proxima Calibração será: " + dtoc(dProx))

EndIf

return(dProx)	