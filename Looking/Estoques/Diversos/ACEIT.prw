#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

User Function ACEIT()
cStatus:="*"
nAceit:=0
//  alert(nAceit)	
DbSelectArea("SZ6")
DbSetOrder(2)

nErro:= M->Z6_ZZERROM
cNum := M->Z6_ZZNUM

DbSelectArea("SZ5")
DbSetOrder(2)

nAceit:=Posicione("SZ5",1,XFilial("SZ5")+cNum,"Z5_ZZCRITE")
//ALERT(nAceit)
If nErro <= nAceit

  cStatus:="A"
MsgInfo("Instrumento está Aprovado para uso.")
else 
cStatus:= "R"  

MsgInfo("Instrumento Reprovado enviar para Manutenção / Calibração.") 

EndIf


return(cStatus)	