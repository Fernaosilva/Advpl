#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SCRSNF    ³ ARM Campinas        ³ Data ³ 29/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ N.Fiscal de Entrada Padrao p/ Clientes Microsiga ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACOM                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                 
User Function SCRENF()

Local bTReg			:= .F.

Private aDriver 	:= {}
Private _nLin       := 0
Private cPerg       := "SCRENF"
Private _wNrel      := "SCRENF"
Private	_cNrel      := "SCRENF"
Private _cTitulo    := "Emissao Nota Fiscal Padrao Microsiga"
Private _cDesc1     := "Emissao de N.F. de Entrada Lay-Out Padrao "
Private _cDesc2     := "para clientes Microsiga"
Private _cDesc3     := ""
Private aReturn     := {"Especial", 1, "Administracao", 2, 2, 1, "", 1}
Private _cTamanho   := "M"
Private _cEste   	:= "N"

Private _cImpNorm   := chr(18)                   //impressora - normal
Private _cImpComp   := chr(15)                   //             comprimido
Private _cImp20cpp  := chr(27) + "M"             //             20cpp CARACTER MAIS FINO
Private _cImpEsp    := chr(27) + "0"             //             1/8" altura da linha DISTANCIA ENTRE LINHAS
Private _cImpOn     := chr(17)                   //             on-line
PRivate _cImpOff    := chr(19)                   //             off-line
Private _cImpReset  := chr(27) + "@"             //             reset

Private	nLastKey    := 0
Private	_lContinua  := .T.
//Private	_nPosReg    := 0                      //guarda recno() do 1§ item da NF
Private	_cKey       := ""                        //auxiliar p/ chaves de acesso
Private	_aItens     := {}                        //array p/ itens da NF
Private	_aServ      := {}                        //array p/ servicos da NF
Private	_cNat       := ""                        //string p/ naturezas da operacao
Private	_aNatOper   := {}                        //array para armazenar diferentes naturezas
Private _aCFO       := {}                        //array p/controle de CF ja considerados
Private _cNomCli    := _cCGCCli := _cEndCli := _cBaiCli := ""  						//variaveis do cliente
Private _cCEPCli    := _cMunCli := _cTelCli := _cEstCli := _cInsCli := ""				//variaveis do cliente
Private _cNomTra    := _cCGCTra := _cEndTra := _cMunTra := _cEstTra := _cInETra := "" //Variaveis da transportadora
Private _cTpFrete   := ""
Private	_cEndEnt    := _cEndCob := space(80)     //endereco de entrega/cobranca
Private	_cCidEnt    := ""						 //cidade de entrega
Private	_cFoneEnt   := ""						 //fone de entrega
Private	_cCepEnt    := ""						 //cep de entrega
Private	_cMunCob    := ""                        //municipio de entrega/cobranca
//Private	_aNumPed    := {}                        //array  p/ numeros de nossos pedidos
Private	_cNumPed    := ""                        //string p/ impressao de num.ped
Private	_aMenPad1   := {}                        //Array p/ codigo da msg. padrao do TES.
Private	_aMenPad2   := {}                        //Array p/ textos da msg. padrao do TES.
Private _aDupl      := {}                        //array p/ desdobramento de duplicatas
Private	_nTD        := 22                        //num.de colunas p/ descricao do produto
Private	_cRedesp    := ""     					 //nome do redespacho
Private	_cPedCli    := ""						 //pedido do cliente
Private	_aPedCli    := {}						 //array com os nros do Pedido do Cliente
Private	_aNotas     := {}						 //array com as NF´s
Private _cCont      := "A"						//contador a ser utilizado na impressao da Classificacao fiscal
Private	_nKy        := 0
Private	_nTotServ   := 0
Private	_nIrrf      := 0
Private	_nTotImp    := 0
Private _cSitrib    := ""
Private _cNomRed    := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                             ³
//³ mv_par01             // De Nota                                  ³
//³ mv_par02             // Ate a Nota                               ³
//³ mv_par03             // Da Serie                                 ³
//³ mv_par04             // Ate Serie                                ³
//³ mv_par05             // Fornecedor                               ³
//³ mv_par06             // Loja                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida/Cria Grupo de Perguntas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Pergunte(cPerg,.T.)
	ValidPerg()
	If !Pergunte (cPerg, .T.)
		Return
	EndIf
EndIf

If LastKey () == 27 .or. nLastKey == 27 .or. nLastKey == 286
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Prepara a array para impressao das Notas Fiscais de Entrada.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF1")           //cabecalho de N.F.
dbSetOrder(1)                 //filial,documento,serie,cliente,loja

//Posiciona na nota informada no parametro "De", ou a proxima caso exista.
dbSeek(xFilial("SF1") + mv_par01 + mv_par03, .T.)

Do While SF1->(!Eof()) .and. SF1->F1_FILIAL == xFilial("SF1") .and. SF1->F1_DOC <= mv_par02
	If SF1->F1_SERIE < mv_par03 .Or. SF1->F1_SERIE > mv_par04
		SF1->(dbSkip())
		Loop
	EndIf

	If !Empty(mv_par05)
		If SF1->F1_FORNECE <> mv_par05
			bTReg := .T.
		EndIf
	End If
		
	If !Empty(mv_par06)
		If SF1->F1_LOJA <> mv_par06
			bTReg := .T.
		EndIf
	End If

    If bTReg = .T.
		SF1->(dbSkip ())
		bTReg = .F.
		loop
	EndIf
	
	lOpca := .t.
	
	If !Empty(SF1->F1_FIMP)
		lOpca := MsgBox("Nota " + SF1->F1_DOC + "/" + SF1->F1_SERIE + " ja emitida. Deseja emiti-la novamente ?", "Atencao!!!", "YESNO")
	EndIf
	
	If lOpca == .t.
		aAdd(_aNotas, { SF1->F1_DOC,;
						SF1->F1_SERIE,;
						SF1->F1_FORNECE,;
						SF1->F1_LOJA})
	EndIf
	SF1->(dbSkip())
EndDo

If Len(_aNotas) == 0
	MsgBox("Nao ha Notas Fiscais a imprimir para os parametros informados.")
	Return
EndIf

// Monta a interface padrao com o usuario...
_cNRel := SetPrint("SF1",_cNRel,cPerg,_cTitulo,_cDesc1,_cDesc2,_cDesc3,.T.,,.T.,_cTamanho,,.T.)

If LastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
	Return
EndIf

SetDefault(aReturn, "SF1")

If LastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
	Return
EndIf

//Funcao para Processamento e Impressao da NF Entrada
SCIMPRNF()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCIMPRNF  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para Processamento e Impressao da NF de Entrada.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCIMPRNF

Local _aArea	:= {}
// Posiciona Todos os Indices Necessarios
dbSelectArea("SA1")             // Clientes
dbSetOrder(1)                 // filial,codigo,loja
dbSelectArea("SA2")             // Fornecedores
dbSetOrder(1)                 // filial,codigo,loja
dbSelectArea("SA3")             // Vendedores
dbSetOrder(1)                 // filial,codigo
dbSelectArea("SA4")             // transportadoras
dbSetOrder(1)                 // filial,codigo transport.
dbSelectArea("SB1")             // produtos
dbSetOrder(1)                 // filial,codigo produto
dbSelectArea("SC5")             // Pedidos de Venda
dbSetOrder(1)                 // filial, pedido
dbSelectArea("SC6")             // Itens dos Pedidos de Venda
dbSetOrder(1)                 // filial, pedido, item
dbSelectArea("SD1")             // itens da NF de entrada
dbSetOrder(1)                 // filial,doc,serie,fornece
dbSelectArea("SD2")             // itens de venda da NF
dbSetOrder(3)                 // filial,doc,serie,cliente,loja,cod
dbSelectArea("SE1")             // contas a receber
dbSetOrder(1)                 // filial,prefixo,num,parcela,tipo
dbSelectArea("SE2")             // contas a Pagar
dbSetOrder(1)                 // filial,prefixo,num,parcela,tipo
dbSelectArea("SE4")             // cond.pagamento
dbSetOrder(1)                 // filial,codigo
dbSelectArea("SF1")             // NF de Entrada
dbSetOrder(1)                 // filial,doc,serie,cliente e loja
dbSelectArea("SF2")             // NF de Saida
dbSetOrder(1)                 // filial,doc,serie,cliente e loja
dbSelectArea("SF4")             // tipos de entrada e saida
dbSetOrder(1)                 // filial,codigo
dbSelectArea("SWN")             // SIGAEIC
dbSetOrder(1)                 //
dbSelectArea("SZZ")             // mensagens
dbSetOrder(1)                 // filial,codigo

For _nIF := 1 to Len(_aNotas)
	If LastKey () == 27 .or. nLastKey == 27 .or. nLastKey == 286
		@ 25, 01 PSAY "** CANCELADO PELO OPERADOR **"
		_lContinua := .F.
		Exit
	EndIf
	
	_aNFDev     := {}
	_aItens		:= {}
	_aServ		:= {}
	_aCFO       := {}
	_aNatOper   := {}
	_cNat       := ""
	_cNumPed    := ""
	_aMenPad1   := {}
	_aMenPad2   := {}
	_cEndEnt    := _cEndCob := space(80)
	_cMunCob    := ""
	_cDesc1     := _cDesc2 := ""
	_cRedesp    := ""
	_cPedCli    := ""
	_aPedCli    := {}
	_cDescPr    := ""
	_cDesServ   := ""
	_nVlrIss    := 0
	_nKy        := 0
	_aDupl      := {}
	_nPesoL     := 0
	_nTotServ   := 0
	_dEmissao   := CToD("  /  /  ")
	_cChave     := ""
	_cNomCli 	:= _cCGCCli := _cEndCli := _cBaiCli := ""  				//variaveis do cliente
	_cCEPCli 	:= _cMunCli := _cTelCli := _cEstCli := _cInsCli := ""     //variaveis do cliente
	_cEndEnt    := ""
	_cCidEnt    := ""
	_cFoneEnt   := ""
	_cCepEnt    := ""
	_nPerIrrf   := 0
	_cCont      := "A"
	_cClasFis   := ""
	_nIrrf      := 0
	_nTotImp    := 0
	_nVlrSufr   := 0
	_nPSufr     := 0
	_cSitrib    := ""	
	_cCodProd   := ""
	_cNomRed    := ""                                                                                            
	_cNomTra 	:= _cCGCTra := _cEndTra := _cMunTra := _cEstTra := _cInETra := "" //Variaveis da transportadora
	_cTpFrete 	:= ""
	_cSerNFE	:= ""
	_cForNFE	:= ""
	_cLjNFE		:= ""

	// Posiciona o SF1 - Cabecalho da Nota Fiscal de Entrada
	_cNota := _aNotas[_nIF,01]
	_cSerNFE := _aNotas[_nIF,02]
	_cForNFE := _aNotas[_nIF,03]	
	_cLjNFE := _aNotas[_nIF,04]
	
	dbSelectArea("SF1")
//	If !Empty(mv_par05)
		dbSeek(xFilial("SF1") + _cNota + _cSerNFE + _cForNFE + _cLjNFE)	// Filial + Nota + Serie + Fornecedor + Loja 
//	Else
//		dbSeek(xFilial("SF1") + _cNota + _cSerNFE)	// Filial + Nota + Serie 
//	EndIf
	//Carrega as Variaveis de Cabecalho da NF
	_cTipoNF  		:= SF1->F1_TIPO
	_cNumNF   		:= SF1->F1_DOC
	_cSerNF   		:= SF1->F1_SERIE
	_cFornec		:= SF1->F1_FORNECE
	_cLoja			:= SF1->F1_LOJA
	_dEmissao 		:= SF1->F1_EMISSAO
	_dDtSaida 		:= SF1->F1_ZZDTSAI
	_cHrSaida 		:= SF1->F1_ZZHRSAI
	
	//Carrega as Variaveis com os Impostos
	_nBaseIcm		:= SF1->F1_BASEICM
	_nValIcm  		:= SF1->F1_VALICM
	_nValMerc		:= SF1->F1_VALMERC
	_nValFret 		:= SF1->F1_FRETE
	_nValSeg  		:= SF1->F1_SEGURO
	_nVlrDesp 		:= SF1->F1_DESPESA
	_nValIPI  		:= SF1->F1_VALIPI
	_nValBrut 		:= SF1->F1_VALBRUT
	If _nValBrut == 0
		_nValBrut 	:= SF1->F1_VALMERC + SF1->F1_VALIPI + SF1->F1_SEGURO + SF1->F1_FRETE
	EndIf
	
	//Carrega as variaveis de Volumes Transportados
	_cVolu1   		:= SF1->F1_ZZVOLUM 
	_cEspec1  		:= SF1->F1_ZZESPEC
	_cMarca   		:= SF1->F1_ZZMARCA
	_cPlaca   		:= SF1->F1_ZZPLACA
	_nPBruto  		:= SF1->F1_ZZPBRUT
	_nPLiqui  		:= SF1->F1_PESOL

	// Posiciona o SD1 - Itens da NF
	_cKey := xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
	dbSelectArea("SD1")
	dbSeek(_cKey)
	_nPosReg := SD1->(Recno())                  //guarda posicao do 1§ item da NF
	
	Do While SD1->(!Eof()) .And. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == _cKey
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada da Funcao SCPOSPRD - posicionar no Produto (SB1)   ³
		//³ para carregar as variaveis Descricao, Cod Clas Fiscal, etc ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SCPOSPRD())
			dbSelectArea("SD1")
			SD1->(dbSkip())
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada da Funcao SCITEMPV - posicionar no Item do PV (SC7)   ³
		//³ para carregar as variaveis Descricao, Num PV, Nr Ped Cli, etc ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SCITEMPV()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SF4 - TES                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SCPOSTES()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche array dos Itens da N.F.                                                         ³
		//³ Estrutura do array de Itens da NF _aItens[n][m]                                          ³
		//³ n = numero do item                                                                       ³
		//³ m = CodProd, Descr, ClasFis, SitTrib, UniMedida, Quant, PrcUnit, PrcTot, AliqIPI, ValIPI ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")
		_cCodProd := Alltrim(SD1->D1_COD)
		_cUM      := SD1->D1_UM
		_nQuant   := SD1->D1_QUANT
		_nPesoL   := SD1->D1_QUANT * SD1->D1_PESO
		
		_cSitrib := SD1->D1_CLASFIS
		
		AAdd (_aItens, {_cCodProd				,; 	// 01 - Cod Produto
						_cDescPr				,; 	// 02 - Descricao Prd
						_cClasFis				,; 	// 03 - Classificacao Fiscal
						_cSiTrib				,; 	// 04 - Situacao Tributaria
						_cUM					,; 	// 05 - Unidade Medida
						_nQuant					,; 	// 06 - Quantidade
						SD1->D1_VUNIT			,; 	// 07 - Preco Unitario
						SD1->D1_TOTAL			,; 	// 08 - Total
						SD1->D1_PICM			,; 	// 09 - Perc ICM
						SD1->D1_IPI				,; 	// 10 - Perc IPI
						SD1->D1_VALIPI			}) 	// 11 - Valor IPI

		_aArea := GetArea()
		// Verifica nota fiscal de devolução ou poder de terceiro
		If !Empty(SD1->D1_NFORI)
			If !Empty(SD1->D1_IDENTB6)
				// Poder de Terceiro - captura data de emissão e valor
				If !Empty(posicione("SB6", 1, xfilial("SB6") + SD1->D1_COD + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_IDENTB6, "B6_PRODUTO"))
					Aadd(_aNFDev, {SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA, SB6->B6_EMISSAO, SD1->D1_TOTAL, "B"})
				EndIf
			Else
				// Verifica nota de devolução - sem poder de terceiro
				If !Empty(posicione("SD1", 1, xfilial("SD1") + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA, "D1_DOC"))
					Aadd(_aNFDev, {SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA, SD1->D1_EMISSAO, SD1->D1_TOTAL,"D"})
				EndIf
			EndIf
		EndIf
		RestArea(_aArea)
		dbSelectArea("SD1")
		SD1->(dbSkip())
	EndDo

	DbGoTo(_nPosReg)						// Reposiciona no primeiro item da NF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona SA1 (Cliente) ou SA2 (Fornecedor)                   ³
	//³ Verifica se NF Devolucao ou Beneficiamento                    ³
	//³ Preencher os campos de endereco de cobranca nas variaveis     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCPOSCLI()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA3 Para Buscar o vendedor                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA3")
	dbSeek(xFilial("SA3") + SF2->F2_VEND1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA4 Para Buscar o Redespacho e Transportadora     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCTRANSP()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA6 Para Buscar o Banco                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA6")
	dbSeek(xFilial("SA6") + SC5->C5_BANCO)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SE4 Para Buscar a Condicao de Pagamento           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cCondPag := Posicione("SE4", 1, xFilial("SE4") + SF1->F1_COND, "SE4->E4_DESCRI")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona e Carrega variaveis referente a Duplicata           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCDUPLIC()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega todas as mensagens no aMenPad2	                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCCARMSG()
	
	If !_lContinua
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                               ³
	//³                          IMPRESSAO                            ³
	//³                                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Cabecalho da NF 				                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCCABEC()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos itens da NF - Materiais.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCIMPITM()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Rodape da NF 				                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IMPRODAPE()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o Flag de Impressao				                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF1")
	
 	If dbSeek(xFilial("SF1") + _cNumNF + _cSerNF + _cFornec + _cLoja)	// Filial + Nota + Serie + Fornecedor + Loja 
		RecLock("SF1",.F.)
		SF1->F1_FIMP := "T"
		SF1->(MsUnlock())
	End If
Next _nIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra a Impressao da(s) NF(s) e deixa posicionado para      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin := 0

If aReturn[5] == 3 .AND. Len(aDriver) > 0 	//Direto na Porta
	SetPrc(0, 0) 							//Deixa posicionado para a proxima Nota
	@ 0,0 PSAY " "
	@ 0,Pcol() + 1 PSAY &(aDriver[7]) 		//-Reset
	@ 0,Pcol() + 1 PSAY chr(27) + "@"  	//10cpi
EndIf

dbSelectArea("SF1")
//Set Device To Screen

If _lContinua
	SetPgEject(.F.)
	If aReturn[5] == 1           // relatorio em tela
		Set Printer To
		dbcommitAll()
		ourspool(_wNrel)
	EndIf
	MS_FLUSH()
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCPOSPRD  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Posiciona no arquivo de produtos e carrega as variaveis    º±±
±±º          ³ contendo Descricao, Clas. Fiscal 						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCPOSPRD
Local _aArea 	:= GetArea()
Local _lRet 	:= .t.

dbSelectArea("SB1")
dbSeek(xFilial("SB1") + SD1->D1_COD)
If !Found()
	msginfo("O produto " + SD1->D1_COD + ", informado na NF " + SD1->D1_SERIE + "/" + SD1->D1_DOC + ", nao existe no cadastro de Produtos!")
	Return(.f.)
Endif

//_cClasFis	:= SB1->B1_CLASFIS //comentado por Adriano Marson 17/10
_cClasFis	:= SB1->B1_ZZLGIPI
RestArea(_aArea)

Return(_lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCITEMPV  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Posiciona no arquivo de Itens do PC e carrega as variaveis º±±
±±º          ³ contendo Descricao, Nro PC, Nro Ped For  				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCITEMPV

Local _aArea    := GetArea()
Local nPos		:= 0

dbSelectArea("SC7")
dbSeek(xFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC)  

//Carrega variavel com a Descricao do Produto
//If Empty(_cDescPr)
	_cDescPr := Alltrim(SB1->B1_DESC)
	// Caso possua Descricao Complementar, a mesma sera acrescentada na descricao do produto.
	// Solicitado por Antonio Maia em 09/11/2006.
	If !Empty(SB1->B1_ZZDESC)
		_cDescPr += " " + Alltrim(SB1->B1_ZZDESC)
	EndIf
//EndIf

// Verifica se o Pedido ja Foi Considerado. Se Nao, inclui.
nPos := aScan(_aPedCli, SD1->D1_PEDIDO)
If nPos == 0
	aAdd(_aPedCli, SD1->D1_PEDIDO)
EndIf

_cTpFrete := SC7->C7_TPFRETE

//restaura as area salvas
RestArea(_aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCPOSTES  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Posiciona no arquivo de TES para carregar as variaveis     º±±
±±º          ³ Sit. Trib., CFO, Texto, Natureza, etc        			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCPOSTES

dbSelectArea("SF4")
dbSeek(xFilial("SF4") + SD1->D1_TES)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o CFO ja foi considerado.                      ³
//³ Se for novo CFO, le TES e complementa string com CFOs.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nI := Ascan(_aCFO, Alltrim(SD1->D1_CF))

If nI == 0
	AADD(_aCFO, Alltrim (SD1->D1_CF))
	_nTemNat := ASCAN(_aNatOper, Alltrim(SF4->F4_TEXTO))
	If _nTemNat == 0
		AADD(_aNatOper, Alltrim(SF4->F4_TEXTO))
	EndIf
EndIf
                
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCCARMSG  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Carrega todas as mensagens fiscais na variavel aMenPad2    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCCARMSG()

Local _aArea    := GetArea()

//Verifica todas as mensagens fiscais gravadas para a nota fiscal
dbSelectArea("SZZ")
dbSeek(xFilial("SZZ") + "E" + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
Do While SZZ->(!Eof())					.And. ;
	SZZ->ZZ_TIPODOC == "E"				.And. ;
	SZZ->ZZ_FILIAL  == xFilial("SZZ")	.And. ;
	SZZ->ZZ_DOC		== SF1->F1_DOC		.And. ;
	SZZ->ZZ_SERIE	== SF1->F1_SERIE	.And. ;
	SZZ->ZZ_CLIFOR	== SF1->F1_FORNECE	.And. ;
	SZZ->ZZ_LOJA	== SF1->F1_LOJA
	
	nI := Ascan(_aMenPad1, SZZ->ZZ_CODMENS + SZZ->ZZ_SEQMENS)
	If nI == 0
		_cMens  := AllTrim(SZZ->ZZ_TXTMENS)
		If !Empty(_cMens)
			AADD(_aMenPad1, SZZ->ZZ_CODMENS + SZZ->ZZ_SEQMENS)
			_nTMens := MLCount(_cMens, 80)
			AADD(_aMenPad2, MemoLine(_cMens, 80, 1))
			For _nI := 2 To _nTMens
				AADD(_aMenPad2, Memoline(_cMens, 80, _nI))
			Next _nI
		EndIf
	EndIf
	SZZ->(dbSkip())
EndDo

//Mensagens do Cabecalho do PV (SC5)
If !Empty(SC5->C5_MENNOTA)
	_nTMens := MLCount(SC5->C5_MENNOTA, 80)
	AADD(_aMenPad2, MemoLine(SC5->C5_MENNOTA, 80, 1))
	For _nI := 2 To _nTMens
		AADD(_aMenPad2, Memoline(SC5->C5_MENNOTA, 80, _nI))
	Next _nI
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Mensagem de devolução de nota fiscal (c/ ou s/ poder terceiro) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(_aNFDev)
	For _nSeq := 1 to len(_aNFDev)
		If _aNFDev[_nSeq, 4] == "B"
			_cStr := "Retorno da NF " + SubStr(_aNFDev[_nSeq, 1], 1, 6) + "/" + AllTrim(SubStr(_aNFDev[_nSeq, 1], 7, 3))
			_cStr += " de " + Dtoc(_aNFDev[_nSeq, 2])
		ElseIf _aNFDev[_nSeq, 4] == "D"
			_cStr := "Devolucao da NF " + SubStr(_aNFDev[_nSeq, 1], 1, 6) + "/" + AllTrim(SubStr(_aNFDev[_nSeq, 1], 7, 3))
			_cStr += " de " + Dtoc(_aNFDev[_nSeq, 2])
		EndIf
		
		_nTMens := mlcount(_cStr, 80)
		aadd(_aMenPad2, memoLine(_cStr, 80, 1))
		For _nI := 2 to _nTMens
			aadd(_aMenPad2, memoline(_cStr, 80, _nI))
		Next
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Mensagem de Redespacho										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(AllTrim(_cNomRed) )
	_nTMens := MLCount(_cNomRed, 80)
	AADD(_aMenPad2, MemoLine(_cNomRed, 80, 1))
	For _nI := 2 To _nTMens
		AADD(_aMenPad2, Memoline(_cNomRed, 80, _nI))
	Next _nI
EndIf

//Mensagens de Vendedor
/*
If SA3->(Found())
	_cNomeVen := "Vendedor: " + SA3->A3_NOME
	_nTMens := MLCount(_cNomeVen, 80)
	AADD(_aMenPad2, MemoLine(_cNomeVen, 80, 1))
	For _nI := 2 To _nTMens
		AADD(_aMenPad2, Memoline(_cNomeVen, 80, _nI))
	Next
EndIf
*/

//Restaura as areas salvas
RestArea(_aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCPOSCLI  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Posiciona no Cliente/Fornece para carregar as variavies    º±±
±±º          ³ de Dados Pessoais, endereco, end entrega, end cobranca, etcº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCPOSCLI()

Local _aArea    := GetArea()

If _cTipoNF $ "D;B" //nf de devolucao/remessa->cliente
	dbSelectArea("SA1")       //Cad de Clientes
	dbSetOrder(1)
	dbSeek(xFilial("SA1") + SD1->D1_FORNECE + SD1->D1_LOJA)
	//Dados do cliente
	_cNomCli  := AllTrim(SA1->A1_NOME) + " (" + SA1->A1_COD + "/" + SA1->A1_LOJA + ")"
	_cCGCCli  := SA1->A1_CGC
	_cEndCli  := SA1->A1_END
	_cBaiCli  := SA1->A1_BAIRRO
	_cCEPCli  := SA1->A1_CEP
	_cMunCli  := SA1->A1_MUN
	_cTelCli  := AllTrim(SA1->A1_TEL)
	_cEstCli  := SA1->A1_EST
	_cInsCli  := SA1->A1_INSCR
	
	If !Empty(SA1->A1_FAX)
		_cTelCli  := _cTelCli  + " / " + AllTrim(SA1->A1_FAX)
	EndIf
	If !Empty(SA1->A1_INSCR)
		_cInsCli  := SA1->A1_INSCR
	Else
		_cInsCli  := SA1->A1_INSCRUR
	EndIf
	
	//Endereco Cobranca
	If !Empty(SA1->A1_ENDCOB)
		_cEndCob := Alltrim(SA1->A1_ENDCOB)
		_cEndCob := _cEndCob + " - " + Alltrim(SA1->A1_BAIRROC) + ", CEP: " + Alltrim(SA1->A1_CEPC)
		_cMunCob := Alltrim (SA1->A1_MUNC)
		_cMunCob := _cMunCob + " - " + SA1->A1_ESTC
	EndIf
	
	//Endereco entrega se tiver conteudo, substitui o anterior.
	If !Empty(SA1->A1_ENDENT)
		_cEndCli := SA1->A1_ENDENT
	Endif
	If !Empty(SA1->A1_CEPE)
		_cCEPCli := SA1->A1_CEPE
	EndIf
	If !Empty(SA1->A1_MUNE)
		_cMunCli := SA1->A1_MUNE
	EndIf
	If !Empty(SA1->A1_ESTE)
		_cEstCli := SA1->A1_ESTE
	EndIf
Else
	dbSelectArea("SA2")       //Cad de Fornecedor
	dbSetOrder(1)
	dbSeek(xFilial("SA2") + SD1->D1_FORNECE + SD1->D1_LOJA)
	//Dados do fornecedor
	_cNomCli  := AllTrim(SA2->A2_NOME) + " (" + SA2->A2_COD + "/" + SA2->A2_LOJA + ")"
	_cCGCCli  := SA2->A2_CGC
	_cEndCli  := SA2->A2_END
	_cBaiCli  := SA2->A2_BAIRRO
	_cCEPCli  := SA2->A2_CEP
	_cMunCli  := SA2->A2_MUN
	_cTelCli  := AllTrim(SA2->A2_TEL)
	_cEstCli  := SA2->A2_EST
	_cInsCli  := SA2->A2_INSCR
EndIf

dbSelectArea("SA1")
dbSeek(xFilial("SA1") + SD1->D1_FORNECE + SD1->D1_LOJA)

//Restaura a area salva
RestArea(_aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCDUPLIC  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Posiciona o SE2 - Contas a Pagar 						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCDUPLIC

Local _cKey   := xFilial("SE2") + SF1->(F1_SERIE + F1_DOC)
Local _aArea  := GetArea()
Local _nValor := 0
Local _nImpostos := 0

dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(_cKey)

_cKey := xFilial("SE2") + SF1->(F1_SERIE + F1_DOC + F1_FORNECE + F1_LOJA)

Do While SE2->(!Eof()) .and. SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_FORNECE + E2_LOJA) == _cKey
	If SubStr(SE2->E2_TIPO, 1, 2) == "NF"
		_nImpostos :=  SE2->E2_CSLL + SE2->E2_COFINS + SE2->E2_PIS
		_nValor    :=  SE2->E2_VALOR - _nImpostos
		
		Aadd(_aDupl , {SE2->E2_NUM + "/" + SE2->E2_PARCELA, _nValor, SE2->E2_VENCTO})
		
		_nTotImp  += _nImpostos
	EndIf

	SE2->(dbSkip())
EndDo

//Restaura areas salvas
RestArea(_aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCTRANSP  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Posiciona o SA4 - Redespacho e Transportadora			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCTRANSP()

Local _aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o SA4 Para Buscar a Transportadora e Redespacho     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea ("SA4")
dbSeek (xFilial ("SA4") + SF1->F1_ZZTRANS)
_cNomTra := SA4->A4_NOME
_cCGCTra := SA4->A4_CGC
_cEndTra := ALLTRIM(SA4->A4_END) + " - " + ALLTRIM(SA4->A4_BAIRRO)
_cMunTra := SA4->A4_MUN
_cEstTra := SA4->A4_EST
_cInETra := SA4->A4_INSEST

//Restaura a area salva
Restarea(_aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCCABEC   º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Imprime Cabecalho da nota onde as mensagens serao impressasº±±
±±º          ³ no rodape                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCCabec()

Local _cEndEmp	:= _cCidEmp := _cTelEmp	:= Space(75)
Local _cCepEmp	:= _cHomePg := _cEmail	:= Space(75)
Local nI		:= 0

_nLin := 3

If aReturn[5] == 3 //Direto na Porta
	aDriver := ReadDriver( )
	@ 0,0 PSAY &(aDriver[7]) //-Reset
	
	If (_cTamanho == 'P')									// [080C]CHR(15)
		@ 0, PCol() + 1 PSAY &(aDriver[1])
	ElseIf (_cTamanho == 'G')								// [220C]CHR(15)
		@ 0, PCol() + 1 PSAY &(aDriver[5])
	ElseIf (_cTamanho == 'M') .And. (aReturn[4] == 1)		// [132C]CHR(15)
		@ 0, PCol() + 1 PSAY &(aDriver[3])
	ElseIf (_cTamanho == 'M') .And. (aReturn[4] == 2)		// [132E]CHR(18)
		@ 0, PCol() + 1 PSAY &(aDriver[4])
	EndIf
EndIf
/*
@ _nLin, 001 PSAY chr(27) + chr(67) + chr(64)
@ _nLin, 010 PSAY _cImpComp
*/

@ _nLin, 099 PSAY "X"

_nLin += 5

_cCFO := ""
For _nCont := 1 to Len (_aCFO)
	_cCFO := _cCFO + _aCFO [_nCont]
	If _nCont < len (_aCFO)
		_cCFO := _cCFO + "/"
	EndIf
Next _nCont

_cNat := ""
For _nCont := 1 to len (_aNatOper)
	_cNat := _cNat + _aNatOper [_nCont]
	If _nCont < len (_aNatOper)
		_cNat := _cNat + "/"
	EndIf
Next _nCont

@ _nLin, 003 PSAY SubStr(_cNat, 1, 40)
@ _nLin, 040 PSAY _cCFO

_nLin ++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados do cliente ou fornecedor - Parte 1                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(_dEmissao)
	@ _nLin, 125 PSAY _dEmissao
Endif
_nLin += 2
If !Empty(_cNomCli)
	@ _nLin, 003 PSAY Alltrim(_cNomCli)
EndIf
If Len(Alltrim(_cCGCCli)) > 11
	@_nLin, 090 PSAY _cCGCCli Picture "@R 99.999.999/9999-99"
Else
	@_nLin, 090 PSAY _cCGCCli Picture "@R 999.999.999-99"
EndIf

_nLin += 2
If !Empty(_cEndCli)
	@ _nLin, 003 PSAY _cEndCli
EndIf
If !Empty(_cBaiCli)
	@ _nLin, 069 PSAY Substr(_cBaiCli, 1, 27) Picture "@!S27"
EndIf
If !Empty(_cCEPCli)
	@ _nLin, 102 PSAY Substr(_cCEPCli, 1, 5) + "-" + Substr(_cCEPCli, 6, 3)
EndIf

_nLin += 2
If !Empty(_cMunCli)
	@ _nLin, 003 PSAY _cMunCli 	    		Picture "@!S30"
EndIf
If !Empty(AllTrim(_cTelCli))
	@ _nLin, 042 PSAY AllTrim(_cTelCli)  	Picture "@!S30"
EndIf
If !Empty(_cEstCli)
	@ _nLin, 080 PSAY _cEstCli       		Picture "!!"
EndIf
If !Empty(_cInsCli)
	@ _nLin, 095 PSAY _cInsCli
EndIf

_nLin += 3
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao das Parcelas                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aColDup := {05, 20, 35, 50, 65, 80, 95, 110, 125, 140, 155, 170}
//_aColDup := {05, 20, 35, 50, 65, 80, 95}

// Impressao de duas linhas ref. dupl. (Linha 1 = Data, Linha 2 = Valor). Uma embaixo da outra.
For _nSeq := 1 to Len(_aDupl)
	@ _nLin, _aColDup[_nSeq]	psay _aDupl[_nSeq, 3]                            				// vencimento
Next _nSeq
_nLin ++
For _nSeq := 1 to Len(_aDupl)
	@ _nLin, _aColDup[_nSeq]	psay _aDupl[_nSeq, 2] picture "@E 99,999,999.99" 				// valor do titulo
Next _nSeq
_nLin ++

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCIMPITM  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Imprime o(s) Item(ns) da NF								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCIMPITM

@ _nLin, 010 PSAY _cImp20cpp 	// Aciona a compactacao maior da impressao.
_nLin		:= 23
_nContLi	:= 0
_lImpCont	:= .F.
_xP			:= 0

For _nK := 1 To Len (_aItens)
	If _lImpCont
		@ _nLin, 016 PSAY MemoLine(_aItens[_nK - 1, 02], 55, _nImpCont + 1)	Picture "@!S55"				// Descr. Prod
	EndIf
	
	If _nContLi >= 17
		U_ImpAster()
		_xP ++
		SCCabec()
		_nContLi	:= 0
		_nLin		:= 23
	EndIf
	_nTamItem := MLCount(Alltrim(_aItens[_nK, 02]), 55)
	
	If _nTamItem >= 1    // Com quebra de item para impressao da descricao.
		For _nY := 1 To _nTamItem
			If _nY == 1
				@ _nLin, 003 PSAY _aItens[_nK, 01]								Picture "@!"				// Codigo do Produto
				@ _nLin, 016 PSAY MemoLine(_aItens[_nK, 02], 55, _nY)			Picture "@!S55"             // Descr. Prod
				@ _nLin, 074 PSAY _aItens[_nK, 03]								Picture "!"        			// Clas. Fisc.
				@ _nLin, 078 PSAY _aItens[_nK, 04]								Picture "!!!"               // Sit. Trib.
				@ _nLin, 085 PSAY _aItens[_nK, 05]								Picture "!!"                // Unidade
				@ _nLin, 088 PSAY _aItens[_nK, 06]								Picture "@E 99,999.99"      // Quantidade
				@ _nLin, 100 PSAY _aItens[_nK, 07]								Picture "@E 9,999,999.99"   // Vlr Unit
				@ _nLin, 122 PSAY _aItens[_nK, 08]								Picture "@E 9999,999.99"    // Vlr Tot
				@ _nLin, 137 PSAY _aItens[_nK, 09]								Picture "99"                // % ICM
				@ _nLin, 142 PSAY _aItens[_nK, 10]								Picture "99"                // % IPI
				If !Empty(_aItens[_nK, 11])
					@ _nLin, 147 PSAY _aItens[_nK, 11]							Picture "@E 999,999.99"     // Vlr Tot IPI
				EndIf
			Else
				@ _nLin, 016 PSAY MemoLine(_aItens[_nK, 02], 55, _nY)			Picture "@!S55"             // Descr. Prod
			Endif
			_nLin ++
			_nContLi ++
			_lImpCont := .F.
			_nImpCont := 0
			If _nY < _nTamItem .And. _nContLi >= 17
				_lImpCont := .T.
				_nImpCont := _nY
			EndIf
		Next
	Endif
Next
_nLin ++

@ _nLin, 010 PSAY _cImpComp 	// Aciona a impressao Comprimida.

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³IMPRODAPE º Autor ³ AP7 IDE            º Data ³  05/08/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Imprime rodape da nota.                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()

Private _nM := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valor dos impostos.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin := 044
@ _nLin, 008 PSAY _nBaseICM Picture "@E 999,999,999.99"     // Base ICMS
@ _nLin, 030 PSAY _nValIcm  Picture "@E 999,999,999.99"     // Vlr. ICMS
//@ _nLin, 070 PSAY _nBICMRet Picture "@E 999,999,999.99"     // Base de Calculo ICMS Retido
//@ _nLin, 105 PSAY _nVICMRet Picture "@E 999,999,999.99"     // Vlr. ICMS Retido
@ _nLin, 140 PSAY _nValMerc Picture "@E 999,999,999.99" 	// Vlr. Mercadorias (c/ ISS).
_nLin += 2
@ _nLin, 008 PSAY _nValFret Picture "@E 999,999,999.99"     // Val. Frete
@ _nLin, 030 PSAY _nValSeg  Picture "@E 999,999,999.99"     // Val. Seguro
@ _nLin, 070 PSAY _nVlrDesp Picture "@E 999,999,999.99"     // Vlr. Despesas Acessorias
@ _nLin, 105 PSAY _nValIPI  Picture "@E 999,999,999.99"     // Vlr. IPI
@ _nLin, 140 PSAY _nValBrut Picture "@E 999,999,999.99" 	// Vlr. Bruto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados da transportadora                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin += 3
If !Empty(_cNomTra)
	@ _nLin, 005 PSAY Alltrim (_cNomTra) Picture "@!S40"
EndIf
If _cTpFrete == "C"
	@ _nLin, 092 PSAY "1"
Else
	@ _nLin, 092 PSAY "2"
EndIf
If !Empty(_cPlaca)
	@ _nLin, 102 PSAY _cPlaca Picture "@!S10"
EndIf
If !Empty(_cEstTra)
	@ _nLin, 117 PSAY _cEstTra Picture "!!"
EndIf
If Len(Alltrim(_cCGCTra)) > 11
	@ _nLin, 127 PSAY _cCGCTra Picture "@R 99.999.999/9999-99"
Else
	@ _nLin, 127 PSAY _cCGCTra Picture "@R 999.999.999-99"
EndIf

_nLin += 2
If !Empty(_cEndTra)
	@ _nLin, 005 PSAY Alltrim (_cEndTra) Picture "@!S70"
EndIf
If !Empty(_cMunTra)
	@ _nLin, 072 PSAY Alltrim (_cMunTra) Picture "@!S15"
EndIf
If !Empty(_cEstTra)
	@ _nLin, 117 PSAY _cEstTra    Picture "!!"
EndIf
If empty(_cInETra)
	@ _nLin, 127 PSAY _cInETra    Picture "!!!!!!!!!!"
Else
	@ _nLin, 127 PSAY _cInETra    Picture "@R 999.999.999.999"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Peso Liquido, Peso Bruto, Especie, Volume                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin += 2
@ _nLin, 005 PSAY _cVolu1  Picture "9999999999"
If !Empty(_cEspec1)
	@ _nLin, 023 PSAY AllTrim(_cEspec1) Picture "@S10"
EndIf
If !Empty(_cMarca)
	@ _nLin, 066 PSAY AllTrim(_cMarca) Picture "@S20"
EndIf
@ _nLin, 120 PSAY _nPBruto Picture "@E 999,999,999.99"
@ _nLin, 140 PSAY _nPLiqui Picture "@E 999,999,999.99"
_nLin += 3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao das Mensagens Fiscais, Vendedor, Local entrega,        ³
//³ Mensagens Fiscais, Vendedor, Local entrega, Cobranca             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nCol := 22

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena pedido do cliente para ser impresso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(_aPedCli) > 0
	For nI := 1 To Len(_aPedCli)
		_cPedCli := IIf(Empty(_cPedCli), "", _cPedCli + "/") + _aPedCli[nI]
	Next nI
EndIf
@ _nLin, nCol PSAY _cPedCli						Picture "@S23"
_nLin += 2

For nI := 1 to 4
	u_ImpMens()
Next nI

_nLin := 69
@ _nLin, 000 PSAY ""

SetPrc(0, 0) 								// Deixa posicionado para a proxima Nota
@ 000, 000 PSAY " "
If aReturn[5] <> 1
	@ 000, Pcol() + 1 PSAY &(aDriver[7]) 	// Reset
EndIf
@ 000, Pcol() + 1 PSAY _cImpReset  			// 10cpi

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³  ARM Campinas      º Data ³  05/08/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local _sAlias	:= Alias()
Local aRegs		:= {}
Local i, j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg, 10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs, {cPerg, "01", "Da N.Fiscal ", "Da N.Fiscal ", "Da N.Fiscal ", "mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "02", "Ate N.Fiscal", "Ate N.Fiscal", "Ate N.Fiscal", "mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "03", "Da Serie    ", "da Serie    ", "Da Serie    ", "mv_ch3", "C", 03, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "04", "Ate Serie   ", "Ate Serie   ", "Ate Serie   ", "mv_ch4", "C", 03, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "05", "Fornecedor  ", "Fornecedor  ", "Fornecedor  ", "mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"})
aAdd(aRegs, {cPerg, "06", "Loja        ", "Loja        ", "Loja        ", "mv_ch6", "C", 02, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg + aRegs[i, 2])
		RecLock("SX1", .T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j, aRegs[i, j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
