#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F050IRF   ºAutor  ³Mario F. Silveira   º Data ³  28/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravação de informações adicionais no título de IRRF.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN ( FINA050 ).                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º16/06/06  ³ Implantado no JP Donizete.                                 º±±
±±º          ³ Adaptações eftuadas para tratar os códigos dos impostos.   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION F050IRF()

// Variáveis utilizadas pelo programa.
Local aArea    	:= GetArea()
Local aAreaSE2 	:= SE2->(GetArea())
Local cHist	 	:= ""
Local cForn		:= ""
Local cLoja		:= ""
Local cCodImp	:= ""

// Posiciona no título original.
dbSelectArea("SE2")
dbGoTo(ParamIXB)

// Obtém dados do fornecedor origem dos impostos.
cForn    := SE2->E2_FORNECE
cLoja    := SE2->E2_LOJA
cHist    := cForn+"/"+cLoja+"/"+SE2->E2_NOMFOR

// Processa o código do imposto.
If SE2->E2_IRRF<>0 .And. SE2->E2_FORNECE$"A00139,A00188,A00144" //UNIMED,UNIMED,UNIODONTO
	cCodImp	:= "3280"
ElseIf SE2->E2_IRRF<>0 .And. Alltrim(SE2->E2_NATUREZ) == "5.02.01" //ALUGUEL
	cCodImp	:= "3208"
ElseIf SE2->E2_IRRF<>0
	cCodImp	:= "1708"
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
