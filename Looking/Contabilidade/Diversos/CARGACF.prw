#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CARGACF   ³ Autor ³ J.Donizete R.Silva    ³ Data ³13/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Este programa se destina a clientes que mentém uma conta   ³±±
±±³          ³ contábil para cada Cliente/Fornecedor. Este programa lê o  ³±±
±±³          ³ cadastro de Clientes e Fornecedores e cria as respectivas  ³±±
±±³          ³ contas com base em critérios definidos pelo contador da    ³±±
±±³          ³ empresa.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ -                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ -                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ -                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Chamada através do menu em Miscelânea.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CARGACF()

// Variaveis da função
Local oRadioGrp1
Public  _nOP	:= 0
Private _oDlg	// Dialog Principal

DEFINE MSDIALOG _oDlg TITLE "Carga de Clientes e Fornecedores no Plano de Contas" FROM C(247),C(330) TO C(401),C(662) PIXEL

// Cria Componentes Padroes do Sistema
@ C(004),C(004) TO C(058),C(165) LABEL "Opções" PIXEL OF _oDlg
@ C(008),C(007) Radio oRadioGrp1 Var _nOp Items "Clientes","Fornecedores","Ambos" 3D Size C(090),C(010) PIXEL OF _oDlg
@ C(062),C(082) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Processa({|| OkProc() },"Processando..."),_oDlg:End())
@ C(062),C(124) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())

ACTIVATE MSDIALOG _oDlg CENTERED   

Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³OkProc   ³ Autores ³                        ³ Data ³13/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel pelo processamento principal da rotina.   ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OkProc()

// Verifica se o módulo em uso é o SIGACTB.
If Alltrim(GETMV("MV_MCONTAB")) <> "CTB"
	MsgStop("Esta rotina se aplica somente ao módulo contábil SIGACTB!")
	Return
EndIf

// Faz a chamada de processamento.
If _nOp=0
	MsgAlert("Nenhuma opção escolhida!")
	Return
ElseIf _nOp=1 // Clientes
	ProcSA1()
ElseIf _nOp=2 // Fornecedores
	ProcSA2()
ElseIf _nOp=3 // Ambos
	ProcSA1() // Clientes
	ProcSA2() // Fornecedores
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³PROCSA1  ³ Autores ³ J.Donizete R.Silva     ³ Data ³13/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por criar as contas de clientes.          ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcSA1()

// Variaveis da função
Local _cNome		:= ""
Local _cCod			:= ""
Local _cLoja		:= ""
Local _cCta			:= ""
Local _aCad			:= {}
Local lMsErroAuto 	:= .F.
Local lMsHelpAuto 	:= .T.

// Abre o alias a processar.
dbSelectArea("SA1")
dbSetOrder(1)
DbGotop()
ProcRegua(SA1->(RecCount()))

// Processa o cadastro de clientes.
While !Eof()
	
	_cNome	:= SA1->A1_NOME
	_cCod	:= SA1->A1_COD+SA1->A1_LOJA
	_cCta	:= ""

	// Reseta matriz.
	_aCad	:= {}
	
	IncProc("Processando Cliente: " + _cCod)
	
	// Este escopo deve ser atualizado com as regras definidas pelo Contador.
	If SA1->A1_EST == "EX"
		_cCta := "11020102"
	ElseIf SA1->A1_EST <> "EX" .And. !Empty(SA1->A1_EST)
		_cCta := "11020101"
	Else
		_cCta := ""
	EndIf
	
	// Verifica se tem conta a ser processada.
	If !Empty(_cCta)
		
		dbSelectArea("CT1")
		dbSetOrder(1)
		
		// Caso não encontre a conta no plano de contas, criar a mesma.
		If !DbSeek(xFilial("CT1") + _cCta + _cCod)
			
			aAdd( _aCad , { "CT1_FILIAL"  , xFilial("CT1") , Nil } )
			aAdd( _aCad , { "CT1_CONTA"   , _cCta+_cCod    , Nil } )
			aAdd( _aCad , { "CT1_DESC01"  , _cNome         , Nil } )
			aAdd( _aCad , { "CT1_CLASSE"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_NORMAL"  , "1"            , Nil } )
			aAdd( _aCad , { "CT1_RES"     , _cCod          , Nil } )
			//aAdd( _aCad , { "CT1_CTASUP"  , _cCta          , Nil } )
			aAdd( _aCad , { "CT1_ACCUST"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_ACITEM"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_ACCLVL"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_CCOBRG"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_ITOBRG"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_CLOBRG"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_BOOK"    , "001/002/003/004/005"  , Nil } )
			aAdd( _aCad , { "CT1_RGNV1"   , "N"            , Nil } )
			
			
			// Inclui a conta contábil através de rotina automática.
			MSExecAuto({|x,y| CTBA020(x,y)},_aCad,3) //Inclusao
			If lMsErroAuto
				MostraErro()
				Alert("Não foi possível incluir registro.")
			Endif
			
		EndIf
		
		// Atualiza o cadastro de clientes, independente de ter criado a conta.
		DbSelectArea("SA1")
		If Empty(SA1->A1_CONTA)
			If Reclock("SA1", .F.)
				SA1->A1_CONTA	:= _cCta+_cCod
				MsUnlock()
			EndIf
		EndIf
	EndIf
	
	// Processa o próximo cliente.
	DbSelectArea("SA1")
	dbSkip()
Enddo
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³PROCSA2  ³ Autores ³ J.Donizete R.Silva     ³ Data ³13/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por criar as contas de fornecedores.      ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcSA2()

// Variaveis da função
Local _cNome		:= ""
Local _cCod			:= ""
Local _cLoja		:= ""
Local _cCta			:= ""
Local _aCad			:= {}
Local lMsErroAuto 	:= .F.
Local lMsHelpAuto 	:= .T.

// Abre o alias a processar.
dbSelectArea("SA2")
dbSetOrder(1)
DbGotop()
ProcRegua(SA2->(RecCount()))

// Processa o cadastro de fornecedores.
While !Eof()
	
	_cNome	:= SA2->A2_NOME
	_cCod	:= SA2->A2_COD+SA2->A2_LOJA
	_cCta	:= ""

	// Reseta matriz.
	_aCad	:= {}
	
	IncProc("Processando Fornecedor: " + _cCod)
	
	// Este escopo deve ser atualizado com as regras definidas pelo Contador.
	If SubStr(SA2->A2_COD,1,1) == "0"
		_cCta := "21010101"+_cCod
	ElseIf SubStr(SA2->A2_COD,1,1) == "F"
		_cCta := "21010509"
	ElseIf SubStr(SA2->A2_COD,1,1) == "O"
		_cCta := "21010509"
	ElseIf SubStr(SA2->A2_COD,1,1) == "V"
		_cCta := "21010504"
	Else
		_cCta := ""
	EndIf
	
	// Verifica se tem conta a ser processada.
	If !Empty(_cCta)
		
		dbSelectArea("CT1")
		dbSetOrder(1)
		
		// Caso não encontre a conta no plano de contas, criar a mesma.
		If !DbSeek(xFilial("CT1") + _cCta)
			
			aAdd( _aCad , { "CT1_FILIAL"  , xFilial("CT1") , Nil } )
			aAdd( _aCad , { "CT1_CONTA"   , _cCta          , Nil } )
			aAdd( _aCad , { "CT1_DESC01"  , _cNome         , Nil } )
			aAdd( _aCad , { "CT1_CLASSE"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_NORMAL"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_RES"     , _cCod          , Nil } )
			//aAdd( _aCad , { "CT1_CTASUP"  , _cCta          , Nil } )
			aAdd( _aCad , { "CT1_ACCUST"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_ACITEM"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_ACCLVL"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_CCOBRG"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_ITOBRG"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_CLOBRG"  , "2"            , Nil } )
			aAdd( _aCad , { "CT1_BOOK"    , "001/002/003/004/005"  , Nil } )
			aAdd( _aCad , { "CT1_RGNV1"   , "N"            , Nil } )
			
			
			// Inclui a conta contábil através de rotina automática.
			CTBA020( _aCad , , 3)
			If lMsErroAuto
				MostraErro()
				Alert("Não foi possível incluir registro.")
			Endif
			
		EndIf
		
		// Atualiza o cadastro de clientes, independente de ter criado a conta.
		DbSelectArea("SA2")
		If Empty(SA2->A2_CONTA)
			If Reclock("SA2", .F.)
				SA2->A2_CONTA	:= _cCta
				MsUnlock()
			EndIf
		EndIf
	EndIf
	
	// Processa o próximo fornecedor.
	DbSelectArea("SA2")
	dbSkip()
Enddo
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³                        ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)
