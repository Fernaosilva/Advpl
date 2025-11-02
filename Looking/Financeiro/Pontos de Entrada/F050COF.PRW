#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F050COF   ºAutor  ³Mario F. Silveira   º Data ³  28/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravação de informações adicionais no título de COFINS.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN ( FINA050 ).                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º16/06/06  ³ Implantado no JP Donizete.                                 º±±
±±º          ³ Adaptações eftuadas para tratar os códigos dos impostos.   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION F050COF()

// Variáveis utilizadas pelo programa.
Local aArea    	:= GetArea()
Local aAreaSE2 	:= SE2->(GetArea())
Local cHist	 	:= ""
Local cForn		:= ""
Local cLoja		:= ""
Local cCodImp		:= ""

// Posiciona no título original.
dbSelectArea("SE2")
dbGoTo(ParamIXB)

// Obtém dados do fornecedor origem dos impostos.
cForn    := SE2->E2_FORNECE
cLoja    := SE2->E2_LOJA
cHist    := cForn+"/"+cLoja+"/"+SE2->E2_NOMFOR

// Processa o código do imposto.
If SE2->E2_PIS<>0 .And. SE2->E2_COFINS <>0 .And. SE2->E2_CSLL<> 0
	cCodImp	:= "5952"
ElseIf SE2->E2_COFINS<>0
	cCodImp	:= "5960"
Else
	cCodImp	:= ""
EndIf

// Restaura área de trabalho SE2.
RestArea(aAreaSE2)

// Grava o histórico complementar.
SE2->E2_HIST    := cHist

// Grava dados do imposto ref.dirf.
If !Empty(cCodImp)
	SE2->E2_DIRF  := "1"
	SE2->E2_CODRET:= cCodImp
EndIf

// Restaura área de trabalho original.
RestArea(aArea)

Return
