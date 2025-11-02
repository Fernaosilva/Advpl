#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT010INC  ºAutor  ³Adriano Marson      º Data ³  17/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para trazer o proximo numero sequencial de          º±±
±±º          ³ produtos, Ordens de producao e orcamento                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT010INC()

Local cProxNum 	:= ""
Local cAtu		:= ""
Local cTipo		:= ""
Local cGrupo	:="" 

cGrupo	:= SB1->B1_GRUPO	

If SB1->B1_TIPO $ "PA"
	cTipo	:= "10"
ElseIf SB1->B1_TIPO $ "PI"
	cTipo	:= "20"
ElseIf SB1->B1_TIPO $ "MR"
	cTipo	:= "12"
ElseIf SB1->B1_TIPO $ "MP"
	cTipo	:= "30"
ElseIf SB1->B1_TIPO $ "GG"
	cTipo	:= "99"
ElseIf SB1->B1_TIPO $ "SV"
	cTipo	:= "11"
Else SB1->B1_TIPO $ "SA"
	cTipo	:= "31"
Endif

cAtu:= ALLTRIM(cTipo+cGrupo)

	dbSelectArea("SB1")
	dbSetOrder(1)
	Dbseek (xFilial("SB1")+ALLTRIM(cAtu))
	IF FOUND()
		while !EOF() .and.  SUBSTR(SB1->B1_COD,1,6) == CAtu
			cProxNum := SUBSTR(SB1->B1_COD,7,5)
			dbSkip()
		Enddo
	Else
		cProxNum := "00000"
	Endif
	cProxNum := SOMA1(cProxNum)
Endif

B1->B1_COD	:= cAtu+cProxNum

Return ()
