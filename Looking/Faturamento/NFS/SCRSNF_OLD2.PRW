#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SCRSNF    ³ ARM Campinas        ³ Data ³ 15/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ N.Fiscal de Saida Padrao para Clientes Microsiga ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFAT                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SCRSNF()

Private aDriver 	:= {}
Private _nLin       := 0
Private _nCol       := 0
Private _cPerg      := "SCRSNF"
Private _wNrel      := "SCRSNF"
Private	_cNrel      := "SCRSNF"
Private _cTitulo    := "Emissao Nota Fiscal Padrao Microsiga"
Private _cDesc1     := "Emissao de N.F. de Entrada Lay-Out Padrao "
Private _cDesc2     := "para clientes Microsiga"
Private _cDesc3     := ""
Private aReturn    	:= {"Especial", 1, "Administracao", 2, 2, 1, "", 1}
Private _cTamanho   := "M"
Private _cEste   	:= "S"

Private _cImpNorm   := chr(18)                   //impressora - normal
Private _cImpComp   := chr(15)                   //             comprimido
Private _cImp20cpp  := chr(27) + "M"             //             20cpp CARACTER MAIS FINO
Private _cImpEsp    := chr(27) + "0"             //             1/8" altura da linha DISTANCIA ENTRE LINHAS
Private _cImpOn     := chr(17)                   //             on-line
PRivate _cImpOff    := chr(19)                   //             off-line
Private _cImpReset  := chr(27) + "@"             //             reset

Private	nLastKey    := 0
Private	_lContinua  := .T.
Private	_cKey       := ""                        	//auxiliar p/ chaves de acesso
Private	_aItens     := {}                        	//array p/ itens da NF
Private	_aServ      := {}                        	//array p/ servicos da NF
Private	_cNat       := ""                        	//string p/ naturezas da operacao
Private	_aNatOper   := {}                        	//array para armazenar diferentes naturezas
Private _aCFO       := {}                        	//array p/controle de CF ja considerados
Private _cNomCli 	:= _cCGCCli := _cEndCli := _cBaiCli := ""  						//variaveis do cliente
Private _cCEPCli 	:= _cMunCli := _cTelCli := _cEstCli := _cInsCli := ""     			//variaveis do cliente
Private _cNomTra 	:= _cCGCTra := _cEndTra := _cMunTra := _cEstTra := _cInETra := "" //Variaveis da transportadora
Private _cTpFrete 	:= ""
Private	_cEndEnt    := _cEndCob := space(80)     //endereco de entrega/cobranca
Private	_cCidEnt   	:= ""						 //cidade de entrega
Private	_cFoneEnt  	:= ""						 //fone de entrega
Private	_cCepEnt   	:= ""						 //cep de entrega
Private	_cMunCob   	:= ""                        //municipio de entrega/cobranca
Private	_cNumPed   	:= ""                        //string p/ impressao de num.ped
Private	_aMenPad1  	:= {}                        //Array p/ codigo da msg. padrao do TES.
Private	_aMenPad2  	:= {}                        //Array p/ textos da msg. padrao do TES.
Private _aDupl     	:= {}                        //array p/ desdobramento de duplicatas
Private	_nTD       	:= 22                        //num.de colunas p/ descricao do produto
Private	_cRedesp   	:= ""     					 //nome do redespacho
Private	_cOP	   	:= ""						 //OP
Private	_cPedCli   	:= ""						 //pedido do cliente
Private	_aNumOP    	:= {}						 //array com os nros das OPs
Private	_aPedCli   	:= {}						 //array com os nros do Pedido do Cliente
Private	_aNotas    	:= {}						 //array com as NF´s
Private _cCont     	:= "A"						//contador a ser utilizado na impressao da Classificacao fiscal
Private	_nKy       	:= 0
Private	_nTotServ  	:= 0
Private	_nIrrf     	:= 0
Private	_nTotImp   	:= 0
Private _cSitrib   	:= ""
Private _cNomRed   	:= ""
Private _nValUni   	:= 0 						// Valor Unitario Itens
Private _nValTot   	:= 0 						// Valor Total Itens
Private _nValor   	:= 0 						 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                             ³
//³ mv_par01             // De Nota                                  ³
//³ mv_par02             // Ate a Nota                               ³
//³ mv_par03             // Serie                                    ³
//³ mv_par04             // Tipo - 1-Normal / 2-Servico              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida/Cria Grupo de Perguntas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Pergunte(_cPerg,.T.)
	ValidPerg()
	If !Pergunte (_cPerg, .T.)
		Return
	EndIf
EndIf

If LastKey () == 27 .or. nLastKey == 27 .or. nLastKey == 286
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Prepara a array para impressao das Notas Fiscais de Saida.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")           //cabecalho de N.F.
dbSetOrder(1)                 //filial,documento,serie,cliente,loja

//Posiciona na nota informada no parametro "De", ou a proxima caso exista.
dbSeek(xFilial("SF2") + mv_par01 + mv_par03, .T.)

Do While SF2->(!Eof()) .and. SF2->F2_FILIAL == xFilial("SF2") .and. SF2->F2_DOC <= mv_par02
	If SF2->F2_SERIE <> mv_par03
		SF2->(dbSkip())
		Loop
	EndIf
	lOpca := .t.
	
	If !Empty(SF2->F2_FIMP)
		lOpca := MsgBox("Nota " + SF2->F2_DOC + "/" + SF2->F2_SERIE + " ja emitida. Deseja emiti-la novamente ?", "Atencao!!!", "YESNO")
	EndIf
	
	If lOpca == .t.
		aAdd(_aNotas, SF2->F2_DOC)
	EndIf
	SF2->(dbSkip())
EndDo

If Len(_aNotas) == 0
	MsgBox("Nao ha Notas Fiscais a imprimir para os parametros informados.")
	Return
EndIf

// Monta a interface padrao com o usuario...
_cNRel := SetPrint("SF2",_cNRel,_cPerg,_cTitulo,_cDesc1,_cDesc2,_cDesc3,.T.,,.T.,_cTamanho,,.T.)

If LastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
	Return
EndIf

SetDefault(aReturn, "SF2")

If LastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
	Return
EndIf

//Funcao para Processamento e Impressao da NF Saida
SCIMPRNF()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCIMPRNF  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para Processamento e Impressao da NF de Saida.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCIMPRNF

Local _aArea	:= {}
// Posiciona Todos os Indices Necessarios
dbSelectArea("SA1")             //Clientes
dbSetOrder(1)                 //filial,codigo,loja
dbSelectArea("SA3")             //Vendedores
dbSetOrder(1)                 //filial,codigo
dbSelectArea("SA4")             //transportadoras
dbSetOrder(1)                 //filial,codigo transport.
dbSelectArea("SA7")           //Amarracao ProdutoxCliente
dbSetOrder(1)
dbSelectArea("SB1")             //produtos
dbSetOrder(1)                 //filial,codigo produto
dbSelectArea("SC5")             //Pedidos de Venda
dbSetOrder(1)                 //filial, pedido
dbSelectArea("SC6")             //Itens dos Pedidos de Venda
dbSetOrder(1)                 //filial, pedido, item
dbSelectArea("SD1")             //itens da NF de entrada
dbSetOrder(1)                 //filial,doc,serie,fornece
dbSelectArea("SD2")             //itens de venda da NF
dbSetOrder(3)                 //filial,doc,serie,cliente,loja,cod
dbSelectArea("SE1")             //contas a receber
dbSetOrder(1)                 //filial,prefixo,num,parcela,tipo
dbSelectArea("SE4")             //cond.pagamento
dbSetOrder(1)                 //filial,codigo
dbSelectArea("SF1")             //NF de Entrada
dbSetOrder(1)                 //filial,doc,serie,cliente e loja
dbSelectArea("SF2")             //NF de Saida
dbSetOrder(1)                 //filial,doc,serie,cliente e loja
dbSelectArea("SF4")             //tipos de entrada e saida
dbSetOrder(1)                 //filial,codigo
dbSelectArea("SZZ")             //mensagens
dbSetOrder(1)                 //filial,codigo

For _nIf := 1 to Len(_aNotas)
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
	_cOP		:= ""
	_cPedCli    := ""
	_aNumOP     := {}
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
	_cNomCli	:= _cCGCCli := _cEndCli := _cBaiCli := ""  				// variaveis do cliente
	_cCEPCli	:= _cMunCli := _cTelCli := _cEstCli := _cInsCli := ""		// variaveis do cliente
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
	_cNomTra 	:= _cCGCTra := _cEndTra := _cMunTra := _cEstTra := _cInETra := ""		// Variaveis da transportadora
	_cTpFrete 	:= ""

	// Posiciona o SF2 - Cabecalho da Nota Fiscal de Saida
	_cNota := Alltrim(_aNotas[_nIf])
	dbSelectArea("SF2")
	dbSeek(xFilial("SF2")+_cNota+mv_par03)	// Filial + Nota + Serie
	
	//Carrega as Variaveis de Cabecalho da NF
	_cTipoNF  		:= SF2->F2_TIPO
	_cNumNF   		:= SF2->F2_DOC
	_cSerNF   		:= SF2->F2_SERIE
	_dEmissao 		:= SF2->F2_EMISSAO
	_dDtSaida 		:= SF2->F2_ZZDTSAI
	_cHrSaida 		:= SF2->F2_ZZHRSAI
	
	//Carrega as Variaveis com os Impostos
	_nBaseIcm 		:= SF2->F2_BASEICM
	_nValIcm  		:= SF2->F2_VALICM
	_nValMerc 		:= SF2->F2_VALMERC
	_nValFret 		:= SF2->F2_FRETE
	_nValSeg  		:= SF2->F2_SEGURO
	_nVlrDesp 		:= SF2->F2_DESPESA
	_nValIPI  		:= SF2->F2_VALIPI
	_nValBrut 		:= SF2->F2_VALFAT          // Valor Total da Fatura
	If _nValBrut == 0
		_nValBrut 	:= SF2->F2_VALMERC + SF2->F2_VALIPI + SF2->F2_SEGURO + SF2->F2_FRETE
	EndIf
	
	//Carrega as variaveis de Volumes Transportados
	_cVolu1   		:= SF2->F2_VOLUME1
	_cEspec1  		:= SF2->F2_ESPECI1
	_cMarca   		:= SF2->F2_ZZMARCA
	_cPlaca   		:= SF2->F2_ZZPLACA
	_nPBruto  		:= SF2->F2_PBRUTO
	_nPLiqui  		:= SF2->F2_PLIQUI
	
	// Posiciona o SD2 - Itens da NF
	_cKey := xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE
	dbSelectArea("SD2")
	dbSeek(_cKey)
	_nPosReg := SD2->(Recno())                  //guarda posicao do 1§ item da NF
	
	Do While SD2->(!Eof()) .And. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE == _cKey
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada da Funcao SCPOSPRD - posicionar no Produto (SB1)   ³
		//³ para carregar as variaveis Descricao, Cod Clas Fiscal, etc ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SCPOSPRD())
			dbSelectArea("SD2")
			SD2->(dbSkip())
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada da Funcao SCITEMPV - posicionar no Item do PV (SC6)   ³
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
		dbSelectArea("SD2")
		_cCodProd := Alltrim(SD2->D2_COD)
		_cUM      := SD2->D2_UM
		_nQuant   := SD2->D2_QUANT
		_nPesoL   := SD2->D2_QUANT * SD2->D2_PESO
		If SF2->F2_TIPO != "I"
			If SD2->D2_DESCZFR > 0
				_nValUni := (SD2->D2_DESCZFR + SD2->D2_TOTAL) / SD2->D2_QUANT
				_nValTot := (SD2->D2_DESCZFR + SD2->D2_TOTAL)
			Else
				_nValUni :=  SD2->D2_PRCVEN
				_nValTot :=  SD2->D2_TOTAL
			Endif
		Else
			_nVa010302
			
			lUni :=  0
			_nValTot :=  0
		Endif
		
		If !Empty(SD2->D2_CLASFIS)
			_cSitrib := SD2->D2_CLASFIS
		EndIf
		If MV_PAR04 == 1	// Normal
			_nP    := aSCAN(_aItens, {|X|Substr(X[1], 1, 15) == _cCodProd})
			If _nP == 0
				AAdd(_aItens, {	_cCodProd										,; 	// 01 - Cod Produto
								_cDescPr										,; 	// 02 - Descricao Prd
								_cClasFis										,; 	// 03 - Classificacao Fiscal
								_cSiTrib 										,; 	// 04 - Situacao Tributaria
								_cUM											,; 	// 05 - Unidade Medida
								_nQuant											,; 	// 06 - Quantidade
								_nValUni										,; 	// 07 - Preco Unitario
								_nValTot										,; 	// 08 - Total
								SD2->D2_PICM									,; 	// 09 - Perc ICM
								IIf(SF4->F4_DESTACA == "N", "", SD2->D2_IPI) 	,; 	// 10 - Perc IPI
								IIf(SF4->F4_DESTACA == "N", "", SD2->D2_VALIPI)}) 	// 11 - Valor IPI
			Else
				_aItens[_nP, 06] += _nQuant
				_aItens[_nP, 08] += SD2->D2_TOTAL
				_aItens[_nP, 11] += SD2->D2_VALIPI
			EndIf
		Else				// Servico
			AAdd (_aServ, {		_cCodProd										,; 	// 01 - Cod Produto
								_cDescPr								  		,;	// 02 - Descricao Prd
								_cUM											,;	// 03 - Unidade Medida
								_nQuant											,;	// 04 - Quantidade
								SD2->D2_PRCVEN									})	// 05 - Preco Unitario

			_nTotServ += SD2->D2_TOTAL												// Acumula Total do ISS
		EndIf
		
		_aArea := GetArea()
		// Verifica nota fiscal de devolução ou poder de terceiro
		If !Empty(SD2->D2_NFORI)
			If !Empty(SD2->D2_IDENTB6)
				// Poder de Terceiro - captura data de emissão e valor
				If !Empty(posicione("SB6", 1, xfilial("SB6") + SD2->D2_COD + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_IDENTB6, "B6_PRODUTO"))
					Aadd(_aNFDev, {SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA, SB6->B6_EMISSAO, SD2->D2_TOTAL,"B"})
				EndIf
			Else
				// Verifica nota de devolução - sem poder de terceiro
				If !Empty(posicione("SD1", 1, xfilial("SD1") + SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA, "D1_DOC"))
					Aadd(_aNFDev, {SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA, SD1->D1_EMISSAO, SD2->D2_TOTAL,"D"})
				EndIf
			EndIf
		EndIf
		RestArea(_aArea)
		dbSelectArea("SD2")
		SD2->(dbSkip())
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
	_cCondPag := Posicione("SE4", 1, xFilial("SE4") + SF2->F2_COND, "SE4->E4_DESCRI")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona e Carrega variaveis referente a Duplicata           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCDUPLIC()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega todas as mensagens no aMenPad2	                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCCARMSG()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega variaveis para impressao de ISS                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//_nVlrIss  := _nVlrIss + SF2->F2_VALISS   // Acumula o vlr iss

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
	dbSelectArea("SF2")
	RecLock("SF2",.F.)
	SF2->F2_FIMP := "T"
	SF2->(MsUnlock())
Next _nIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra a Impressao da(s) NF(s) e deixa posicionado para      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin := 0

If aReturn[5] == 3 .AND. Len(aDriver) > 0 	//Direto na Porta
	SetPrc(0, 0) 							//Deixa posicionado para a proxima Nota
	@ 0,0 PSAY " "
	@ 0,Pcol() + 1 PSAY &(aDriver[7]) 		//-Reset
	@ 0,Pcol() + 1 PSAY chr(27) + "@" 		//10cpi
EndIf

dbSelectArea("SF2")

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
Local _aArea	:= GetArea()
Local _lRet		:= .t.

dbSelectArea("SB1")
dbSeek(xFilial("SB1") + SD2->D2_COD)
If !Found()
	msginfo("O produto " + SD2->D2_COD + ", informado na NF " + SD2->D2_SERIE + "/" + SD2->D2_DOC + ", nao existe no cadastro de Produtos!")
	Return(.f.)
Endif

_cClasFis	:= SB1->B1_CLASFIS
//_cClasFis	:= SB1->B1_ZZLGIPI
RestArea(_aArea)

Return(_lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCITEMPV  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Posiciona no arquivo de Itens do PV e carrega as variaveis º±±
±±º          ³ contendo Descricao, Nro PV, Nro Ped Cli  				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCITEMPV

Local _aArea    := GetArea()
Local nPos		:= 0

dbSelectArea("SC5")
dbSeek(xFilial("SC5") + SD2->D2_PEDIDO)
dbSelectArea("SC6")
dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV)

//Carrega variavel com a Descricao do Produto
//If Empty(_cDescPr)
//	_cDescPr := Alltrim(SB1->B1_DESC)
	_cDescPr := Alltrim(SC6->C6_DESCRI)
	// Caso possua Descricao Complementar, a mesma sera acrescentada na descricao do produto.
	// Solicitado por Antonio Maia em 09/11/2006.
/*
	If !Empty(SB1->B1_ZZDESC) // Descricao complementar removida por A.Marson 28.12
		_cDescPr += " " + Alltrim(SB1->B1_ZZDESC)
	EndIf
*/
//EndIf

// Verifica se o Pedido ja Foi Considerado. Se Nao, inclui.
nPos := aScan(_aPedCli, SC6->C6_PEDCLI)
If nPos == 0
	aAdd(_aPedCli, SC6->C6_PEDCLI)
EndIf

// Verifica se a OP ja Foi Considerado. Se Nao, inclui.
If !Empty(SC6->C6_NUMOP)
	nPos := aScan(_aNumOP, SC6->C6_NUMOP)
	If nPos == 0
		aAdd(_aNumOP, SC6->C6_NUMOP)
	EndIf
EndIf

_cTpFrete := SC5->C5_TPFRETE

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
dbSeek(xFilial("SF4") + SD2->D2_TES)

_cSitrib := SB1->B1_ORIGEM + SF4->F4_SITTRIB

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o CFO ja foi considerado.                      ³
//³ Se for novo CFO, le TES e complementa string com CFOs.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nI := Ascan(_aCFO, Alltrim(SD2->D2_CF))

If nI == 0
	AADD(_aCFO, Alltrim (SD2->D2_CF))
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
dbSeek(xFilial("SZZ") + "S" + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
Do While SZZ->(!Eof()) 					.And. ;
	SZZ->ZZ_TIPODOC == "S"				.And. ;
	SZZ->ZZ_FILIAL  == xFilial("SZZ")	.And. ;
	SZZ->ZZ_DOC		== SF2->F2_DOC		.And. ;
	SZZ->ZZ_SERIE	== SF2->F2_SERIE	.And. ;
	SZZ->ZZ_CLIFOR	== SF2->F2_CLIENTE	.And. ;
	SZZ->ZZ_LOJA	== SF2->F2_LOJA
	
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
If SA3->(Found())
	_cNomeVen := "Vendedor: " + SA3->A3_NOME
	_nTMens := MLCount(_cNomeVen, 80)
	AADD(_aMenPad2, MemoLine(_cNomeVen, 80, 1))
	For _nI := 2 To _nTMens
		AADD(_aMenPad2, Memoline(_cNomeVen, 80, _nI))
	Next
EndIf

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

If _cTipoNF $ "D;B" //nf de devolucao/remessa->fornecedor
	dbSelectArea("SA2")       //Cad de Fornecedor
	dbSetOrder(1)
	dbSeek(xFilial("SA2") + SD2->D2_CLIENTE + SD2->D2_LOJA)
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
Else
	dbSelectArea("SA1")       //Cad de Clientes
	dbSetOrder(1)
	dbSeek(xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA)
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
EndIf

dbSelectArea("SA1")
dbSeek(xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA)

//Restaura a area salva
RestArea(_aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³SCDUPLIC  º Autor ³ ARM Campinas       º Data ³  dd/mm/aa   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Posiciona o SE1 - Contas a Receber 						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCDUPLIC

Local _cKey   := xFilial("SE1") + SF2->(F2_SERIE + F2_DOC)
Local _aArea  := GetArea()
//Local _nValor := 0
Local _nImpostos := 0

dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(_cKey)

Do While SE1->(!Eof()) .and. SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM) == _cKey
	If SubStr(SE1->E1_TIPO, 1, 2) == "NF"
		_nImpostos :=  SE1->E1_CSLL + SE1->E1_COFINS + SE1->E1_PIS
		_nValor    :=  SE1->E1_VALOR - _nImpostos
		
		Aadd(_aDupl , {SE1->E1_NUM + "/" + SE1->E1_PARCELA, _nValor, SE1->E1_VENCTO})
		
//		_nTotImp  += _nImpostos
	ElseIf SE1 -> E1_TIPO == "CF-" .or. SE1 -> E1_TIPO == "CS-" .or. SE1 -> E1_TIPO == "PI-"
	    _nTotImp  += SE1->E1_VALOR
	EndIf                         
	If SubStr(SE1->E1_TIPO,1,3) == "IR-"
		_nIrrf :=  _nIrrf + E1_VALOR
	EndIf
	SE1->(dbSkip())
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
dbSeek (xFilial ("SA4") + SF2->F2_TRANSP)
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

Local _cEndEmp	:= _cCidEmp	:= _cTelEmp	:= Space(75)
Local _cCepEmp	:= _cHomePg	:= _cEmail	:= Space(75)
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
@ _nLin, 003 PSAY chr(27) + chr(67) + chr(64)
@ _nLin, 010 PSAY _cImpComp
*/

If MV_PAR04 == 1	// Normal
	@ _nLin, 086 PSAY "X"
	// @ _nLin, 128 PSAY _cNumNF			// A impressao ja vem pronta da grafica.

	_nLin += 5
	
	_cCFO := ""
	For _nCont := 1 to Len (_aCFO)
		_cCFO := _cCFO + _aCFO [_nCont]
		If _nCont < len (_aCFO)
			_cCFO := _cCFO + "/"
		EndIf
	Next _nCont
	
	_cNat := ""
	for _nCont := 1 to len (_aNatOper)
		_cNat := _cNat + _aNatOper [_nCont]
		if _nCont < len (_aNatOper)
			_cNat := _cNat + "/"
		EndIf
	Next _nCont
	
	@ _nLin, 003 PSAY SubStr(_cNat, 1, 40)
	@ _nLin, 040 PSAY _cCFO
EndIf

If MV_PAR04 == 1	// Normal
	_nLin := 9
Else
	_nLin := 10
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados do cliente ou fornecedor - Parte 1                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nCol := IIf(MV_PAR04 == 1, 125, 127)
If !Empty(_dEmissao)
	@ _nLin, _nCol PSAY _dEmissao
Endif
_nLin += 2
_nCol := IIf(MV_PAR04 == 1, 003, 006)
If !Empty(_cNomCli)
	@ _nLin, _nCol PSAY Alltrim(_cNomCli)
EndIf
_nCol := IIf(MV_PAR04 == 1, 090, 093)
If Len(Alltrim(_cCGCCli)) > 11
	@_nLin, _nCol PSAY _cCGCCli Picture "@R 99.999.999/9999-99"
Else
	@_nLin, _nCol PSAY _cCGCCli Picture "@R 999.999.999-99"
EndIf

_nLin += 2
_nCol := IIf(MV_PAR04 == 1, 003, 006)
If !Empty(_cEndCli)
	@ _nLin, _nCol PSAY _cEndCli
EndIf
_nCol := IIf(MV_PAR04 == 1, 069, 072)
If !Empty(_cBaiCli)
	@ _nLin, _nCol PSAY Substr(_cBaiCli, 1, 27) Picture "@!S27"
EndIf
_nCol := IIf(MV_PAR04 == 1, 102, 105)
If !Empty(_cCEPCli)
	@ _nLin, _nCol PSAY Substr(_cCEPCli, 1, 5) + "-" + Substr(_cCEPCli, 6, 3)
EndIf

_nLin += 2
_nCol := IIf(MV_PAR04 == 1, 003, 006)
If !Empty(_cMunCli)
	@ _nLin, _nCol PSAY _cMunCli 	    	Picture "@!S30"
EndIf
_nCol := IIf(MV_PAR04 == 1, 042, 045)
If !Empty(AllTrim(_cTelCli))
	@ _nLin, _nCol PSAY AllTrim(_cTelCli)  	Picture "@!S30"
EndIf
_nCol := IIf(MV_PAR04 == 1, 080, 083)
If !Empty(_cEstCli)
	@ _nLin, _nCol PSAY _cEstCli       		Picture "!!"
EndIf
_nCol := IIf(MV_PAR04 == 1, 095, 098)
If !Empty(_cInsCli)
	@ _nLin, _nCol PSAY _cInsCli
EndIf

_nLin += 3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao das Parcelas                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aColDup := {05, 20, 35, 50, 65, 80}

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
If MV_PAR04 == 1	// Normal
	_nLin 	:= 23
Else
	_nLin 	:= 24
EndIf
_nContLi	:= 0
_lImpCont	:= .F.
_xP			:= 0

If MV_PAR04 == 1	// Normal
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
Else 
	For _nK := 1 To Len (_aServ)
		If _lImpCont
			@ _nLin, 018 PSAY MemoLine(_aServ[_nK - 1, 02], 55, _nImpCont + 1)		Picture "@!S55"				// Descr. Prod
		EndIf
		
		_nTamItem := MLCount(Alltrim(_aServ[_nK, 02]), 55)
		
		If _nTamItem >= 1    // Com quebra de item para impressao da descricao.
			For _nY := 1 To _nTamItem
				If _nY == 1
					@ _nLin, 005 PSAY _aServ[_nK, 01]								Picture "@!"				// Codigo do Produto
					@ _nLin, 018 PSAY MemoLine(_aServ[_nK, 02], 55, _nY)			Picture "@!S55"             // Descr. Prod
					@ _nLin, 087 PSAY _aServ[_nK, 03]								Picture "!!"                // Unidade
					@ _nLin, 089 PSAY _aServ[_nK, 04]								Picture "@E 99,999.99"      // Quantidade
					@ _nLin, 101 PSAY _aServ[_nK, 05]								Picture "@E 9,999,999.99"   // Vlr Unit
				Else
					@ _nLin, 018 PSAY MemoLine(_aServ[_nK, 02], 55, _nY)			Picture "@!S55"             // Descr. Prod
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
EndIf
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

If _nTotImp > 0
	@ _nLin, 014 PSAY "Valor dos Impostos "
	@ _nLin, 035 PSAY _nTotImp  Picture "@E 999,999,999.99"   // Vlr PIS+Cofins+CSLL
	_nLin += 1
EndIf

If Len(_aServ) > 0
	_nLin += 2
//	@ _nLin, 140 PSAY _nValBrut Picture "@E 999,999,999.99" 	// Vlr. Bruto
	@ _nLin, 140 PSAY _nValor Picture "@E 999,999,999.99" 	// Vlr. Bruto
	_nLin += 10
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valor dos impostos.                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao das Mensagens Fiscais, Vendedor, Local entrega,        ³
//³ Mensagens Fiscais, Vendedor, Local entrega, Cobranca             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nCol := IIf(MV_PAR04 == 1, 022, 025)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena pedido do cliente para ser impresso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(_aPedCli) > 0
	For nI := 1 To Len(_aPedCli)
		_cPedCli := IIf(Empty(_cPedCli), "", _cPedCli + "/") + _aPedCli[nI]
	Next nI
EndIf
@ _nLin, _nCol PSAY _cPedCli						Picture "@S23"
_nLin ++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena OP para ser impresso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(_aNumOP) > 0
	For nI := 1 To Len(_aNumOP)
		_cOP := IIf(Empty(_cOP), "", _cOP + "/") + _aNumOP[nI]
	Next nI
EndIf
If Len(AllTrim(_cOP)) > 23
	_nLin ++
	_nCol := IIf(MV_PAR04 == 1, 001, 004)
	@ _nLin, 01 PSAY AllTrim(_cOP)						Picture "@S60"
Else
	_nCol := IIf(MV_PAR04 == 1, 022, 025)
	@ _nLin, 22 PSAY AllTrim(_cOP)						Picture "@S23"
EndIf     
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
±±ºFun‡„o    ³IMPASTER  º Autor ³ AP7 IDE            º Data ³  05/08/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Imprime asteriscos se houver quebra de nota.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ImpAster()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valor dos impostos.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin := 039
@ _nLin, 008 PSAY "************"		// Base ICMS
@ _nLin, 030 PSAY "**************"		// Vlr. ICMS
@ _nLin, 140 PSAY "**************" 		// Vlr. Mercadorias (c/ ISS).
_nLin += 2
@ _nLin, 008 PSAY "**********"			// Val. Frete
@ _nLin, 030 PSAY "**************"		// Val. Seguro
@ _nLin, 070 PSAY "**************"		// Vlr. Despesas Acessorias
@ _nLin, 105 PSAY "**************"		// Vlr. IPI
@ _nLin, 140 PSAY "**************"		// Vlr. Bruto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados da transportadora                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin += 3
@ _nLin, 005 PSAY "***************************"
@ _nLin, 092 PSAY "*"
@ _nLin, 102 PSAY "********"
@ _nLin, 117 PSAY "**"
@ _nLin, 127 PSAY "******************"

_nLin += 2
@ _nLin, 005 PSAY "************************"
@ _nLin, 072 PSAY "*****************"
@ _nLin, 117 PSAY "**"
@ _nLin, 127 PSAY "***************"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Peso Liquido, Peso Bruto, Especie, Volume                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin += 2
@ _nLin, 005 PSAY "******"
@ _nLin, 023 PSAY "***************"
@ _nLin, 066 PSAY "***************"
@ _nLin, 120 PSAY "*********"
@ _nLin, 140 PSAY "*********"

// Seta para uma posicao menor para forcar uma nova pagina.
_nLin := 69
@ _nLin, 000 PSAY ""

SetPrc(0, 0) 							//Deixa posicionado para a proxima Nota
@ 000, 000 PSAY " "
@ 000, Pcol() + 1 PSAY &(aDriver[7]) 	//-Reset
@ 000, Pcol() + 1 PSAY _cImpReset  		//10cpi

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IMPMENS   ³ ARM Campinas        º Data ³ dd/mm/aa º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de impressao das mensagens                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaFat/SigaCom                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ImpMens()

Local nCol := 0
If _cEste == "S"
	nCol := IIf(MV_PAR04 == 1, 002, 005)
Else
	nCol := 002
EndIf

If Len(_aMenPad2) >= _nM
	@ _nLin, nCol PSAY _aMenPad2[_nM]	Picture "@!S80"
	_nLin ++
EndIf
_nM++

Return

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
_cPerg := PADR(_cPerg, 6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
aAdd(aRegs, {_cPerg, "01", "Da N.Fiscal ", "Da N.Fiscal ", "Da N.Fiscal ", "mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", ""		, ""		, ""		, "", "", ""		, ""		, ""		, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF2"})
aAdd(aRegs, {_cPerg, "02", "Ate N.Fiscal", "Ate N.Fiscal", "Ate N.Fiscal", "mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", ""		, ""		, ""		, "", "", ""		, ""		, ""		, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF2"})
aAdd(aRegs, {_cPerg, "03", "Serie       ", "Serie       ", "Serie       ", "mv_ch3", "C", 03, 0, 0, "G", "", "mv_par03", ""		, ""		, ""		, "", "", ""		, ""		, ""		, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {_cPerg, "04", "Tipo de NF  ", "Tipo de NF  ", "Tipo de NF  ", "mv_ch4", "C", 01, 0, 1, "C", "", "mv_par04", "Normal"	, "Normal"	, "Normal"	, "", "", "Servico"	, "Servico"	, "Servico"	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

For i := 1 to Len(aRegs)
	If !dbSeek(_cPerg + aRegs[i, 2])
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
