#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFORIGEM  ºAutor  ³Donizete            º Data ³  19/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este execblock retorna dados da nota fiscal de origem      º±±
±±º          ³ quando a operação for uma devolução de compras ou vendas.  º±±
±±º          ³ O usuário deve passar dois parâmetros para o Execblock, o  º±±
±±º          ³ 1o.é com relação a tabela que deve ser utilizada para a    º±±
±±º          ³ busca dos dados originais e, o 2o. parâmetro indica o tipo º±±
±±º          ³ de informação de retorno.                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Este Execblock é utilizado nos LPs de devolução de vendas eº±±
±±º          ³ compras (640, 650).                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NFORIGEM(_cTab,_cTpDado)

// Informações:
// _cTab trata SD1 e SD2.
// _cTpDados retorna:		Disponível na tabela:
//		1 - CONTA 			(SD1/SD2)
//		2 - C.CUSTO 		(SD1/SD2)
//		3 - ITEM CONTÁBIL	(SD1/SD2)
//		4 - NATUREZA		(SD1)
//		5 - D2_cCUSTO		(SD2)

// Variáveis.
Local 	_AreaSDX 	:= {}
Local 	_cChave  	:= ""
Public  _cRet		:= ""

//Inicialização dos parâmetros.
_cTab 		:= Alltrim(Upper(_cTab))
_cTpDado	:= Alltrim(Upper(_cTpDado))

If !_cTab $ "SD1/SD2"
	Alert("Parâmetro válido: SD1/SD2!")
	Return(_cRet)
EndIf


// Busca dados no SD1 a partir do SD2.
If _cTab == "SD1"
	
	If SD2->D2_TIPO=="D" // Devolução de compras.
		
		// Monta chave para pesquisa da NF original.
		_cChave := SD2->(D2_FILIAL+D2_NFORI+D2_SERIORI+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEMORI)
		
		// Posiciona no SD1 para obter dados da NF original.
		dbSelectArea("SD1")
		_AreaSDX := GetArea()
		dbSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		dbSeek(_cChave)
		If Found()  
			If     _cTpDado == "1"
				_cRet := SD1->D1_CONTA
			ElseIf _cTpDado == "2"
				_cRet := SD1->D1_CC
			ElseIf _cTpDado == "3"
				_cRet := SD1->D1_ITEMCTA
			ElseIf _cTpDado == "4"
				_cRet := SD1->D1_NATUREZ
			Else
				_cRet := "?"
			EndIf
		EndIf
		
		// Restaura área.
		RestArea(_AreaSDX)
		
	EndIf
EndIf


// Busca dados no SD2 a partir do SD1.
If _cTab == "SD2"
	
	If SD1->D1_TIPO=="D" // Devolução de Vendas.
		
		// Monta chave para pesquisa da NF original.
		_cChave := SD1->(D1_FILIAL+D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEMORI)
		// Posiciona no SD2 para obter dados da NF original.
		dbSelectArea("SD2")
		_AreaSDX := GetArea()
		dbSetOrder(3) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		dbSeek(_cChave)
		If Found()  
			If     _cTpDado == "1"
				_cRet := SD2->D2_CONTA
			ElseIf _cTpDado == "2"
				_cRet := SD2->D2_CCUSTO
			ElseIf _cTpDado == "3"
				_cRet := SD2->D2_ITEMCC
			ElseIf _cTpDado == "5"
				_cRet := SD2->D2_CCUSTO
			Else
				_cRet := "?"
			EndIf
		EndIf
		
		// Restaura área.
		RestArea(_AreaSDX)
		
	EndIf
EndIf

Return(_cRet)
