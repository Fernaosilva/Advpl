#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M030INC  º Autor ³ J.DONIZETE R.SILVA º Data ³  29/01/04    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada p/ para geracao automatica da Conta Conta-º±±
±±º          ³ bil do Cliente conforme inclusao do mesmo.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cadastro de Clientes                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlterações³ 23/12/2006 Donizete/Microsiga.                             º±±
±±º          ³ Adaptado do modelo desenvolvido pelo Vitor L.Fattori       º±±
±±º30/05/2007³ Donizete - Microsiga - Implantado na Looking por Donizete. º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M030INC()

// Declaração das Variáveis.
Local _xAreaSA1		:= {}
Local _xAreaCT1		:= {}
Local _cNome		:= ""
Local _cCod			:= ""
Local _cEst			:= ""
Local _cConta		:= ""
Local _aIncCad  	:= {}
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

// Processa somente se o módulo for SIGACTB e a opção for de Inclusão.
If INCLUI .and. Upper(Alltrim(GetMv("MV_MCONTAB"))) == "CTB" .And. Empty(SA1->A1_CONTA)
	
	dbSelectArea("SA1")
	_xAreaSA1 := GetArea()
	
	// Memoriza dados.
	_cNome		:= SA1->A1_NOME
	_cCod		:= SA1->A1_COD+SA1->A1_LOJA
	_cEst		:= SA1->A1_EST
	
	If SA1->A1_EST == "EX"
		_cConta  	:= "11020101"
	Else
		_cConta		:= "11020102"
	EndIf
	
	dbSelectArea("CT1")
	_xAreaCT1 := GetArea()
	dbSetOrder(1)
	DbSeek(xFilial("CT1") + _cConta + SA1->A1_COD + SA1->A1_LOJA)
	If .not. Found()
		
		// Alimenta matriz com os dados do registro a ser criado.
		aAdd( _aIncCad , { "CT1_FILIAL"  , XFILIAL("CT1") , Nil } )
		aAdd( _aIncCad , { "CT1_CONTA "  , _cConta + _cCod, Nil } )
		aAdd( _aIncCad , { "CT1_DESC01"  , _cNome         , Nil } )
		aAdd( _aIncCad , { "CT1_CLASSE"  , "2"            , Nil } )
		aAdd( _aIncCad , { "CT1_NORMAL"  , "1"            , Nil } )
		aAdd( _aIncCad , { "CT1_RES"     , _cCod          , Nil } )
		aAdd( _aIncCad , { "CT1_CTASUP"  , _cConta        , Nil } )
		aAdd( _aIncCad , { "CT1_ACITEM"  , "2"            , Nil } )
		aAdd( _aIncCad , { "CT1_ACCUST"  , "2"            , Nil } )
		aAdd( _aIncCad , { "CT1_ACCLVL"  , "2"            , Nil } )
		aAdd( _aIncCad , { "CT1_CCOBRG"  , "2"            , Nil } )
		aAdd( _aIncCad , { "CT1_ITOBRG"  , "2"            , Nil } )
		aAdd( _aIncCad , { "CT1_CLOBRG"  , "2"            , Nil } )
		aAdd( _aIncCad , { "CT1_CTAVM "  , ""             , Nil } )
		aAdd( _aIncCad , { "CT1_BOOK  "  , "001/002/003/004/005"           , Nil } )
		
		// Inclui o registro no cadastro.
		CTBA020( _aIncCad , , 3)
		If lMsErroAuto
			MostraErro()
			Alert("Não foi possível incluir registro.")
		Else
			// Atualiza a conta no cadastro do Cliente.
			DbSelectArea("SA1")
			If Reclock("SA1", .F.)
				REPLACE SA1->A1_CONTA	with _cConta + _cCod
				MsUnlock()
			EndIf
		Endif
		// Restaura áreas de trabalho.
		DbSelectArea("CT1")
		RestArea(_xAreaCT1)
	Endif
	
	// Restaura áreas de trabalho.
	DbSelectArea("SA1")
	RestArea(_xAreaSA1)
	
Endif

Return
