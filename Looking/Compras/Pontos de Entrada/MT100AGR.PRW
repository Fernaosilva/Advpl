#Include "RWMAKE.CH"

User Function MT100AGR()

// Delaração das Variáveis.
Local _xArea 		:= GetArea()
Local _xAreaSA2		:= {}
Local _xAreaSE2		:= {}
Local _xAreaSF1		:= {}
Local _cChaveSF1	:= ""
Local _cChaveSA2	:= ""
Local _cNat			:= ""

// Carrega Alias e salva área de trabalho.
dbSelectArea("SF1") // Cabec.NFE.
_xAreaSF1 := GetArea()

// Verifica se é uma NF Normal.
If SF1->F1_TIPO == "N"

	// Monta chaves de pesquisa.
	_cChaveSA2 := SF1->(F1_FORNECE+F1_LOJA)
	_cChaveSE2 := SF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC)

	// Restaura área de trabalho do SF1.
	RestArea(_xAreaSF1)

	// Carrega Alias e salva área de trabalho.
	dbSelectArea("SE2") // Títulos a Pagar.
	_xAreaSE2 := GetArea()
	dbSetOrder(6)
	
	// Procura pelo título a apagr.
	dbSeek(xFilial("SE2")+_cChaveSE2)
	If Found()
		_cNat := SE2->E2_NATUREZ

		// Carrega Alias e salva área de trabalho.
		dbSelectArea("SA2") // Fornecedores.
		_xAreaSA2 := GetArea()
		dbSetOrder(1)
		
		// Procura pelo Fornecedor e atualiza o cadastro.
		dbSeek(xFilial("SA2")+_cChaveSA2)
		If Found() .And. Empty(SA2->A2_NATUREZ)
			If RecLock("SA2",.F.)
				SA2->A2_NATUREZ := _cNat
				MsUnlock()
			EndIf
		EndIf		

		// Restaura área de trabalho do SA2.
		RestArea(_xAreaSA2)
	EndIf
	// Restaura área de trabalho do SE2.
	RestArea(_xAreaSE2)

Else
	// Restaura área de trabalho do SF1.
	RestArea(_xAreaSF1)
EndIf

// Restaura área de trabalho original.
RestArea(_xArea)

Return