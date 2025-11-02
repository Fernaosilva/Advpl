#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410LIOK  ºAutor  ³Donizete            º Data ³  13/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação de informações no pedido de vendas.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de entrada disparado na digitação do item do PV.    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User function M410LIOK()

Local aArea    := GetArea()
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSF4 := SF4->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local lRet     := .T.
Local nPosTES  := GDFieldPos("C6_TES")
Local nPosProd := GDFieldPos("C6_PRODUTO")
Local lDel     := aCols[ n , Len(aCols[n]) ]

If !lDel
	
	cQuery := "SELECT F4_IPI FROM "+ RetSQLName("SF4") +" WHERE"
	cQuery += " F4_FILIAL ='"+ xFILIAL("SF4") +"' AND F4_CODIGO ='"+ aCols[ n , nPosTES ] +"'"
	cQuery += " AND D_E_L_E_T_ = ' '"
	TcQuery cQuery Alias TSF4 New
	TSF4->(dbGoTop())
	
	cQuery := "SELECT B1_IPI FROM "+ RetSQLName("SB1") +" WHERE"
	cQuery += " B1_FILIAL ='"+ xFILIAL("SB1") +"' AND B1_COD ='"+ aCols[ n , nPosProd ] +"'"
	cQuery += " AND D_E_L_E_T_ = ' '"
	TcQuery cQuery Alias TSB1 New
	TSB1->(dbGoTop())
	
	// Verifica se o centro de custo é obrigatório.
	If TSF4->F4_IPI == "S" .And. TSB1->B1_IPI==0
		If MsgYesNo("TES calcula IPI, porém produto esta com a alíquota zerada. Confirma?", ;
			OemToAnsi('ATENCAO!!!'))
			lRet := .t.
		Else
			lRet := .f.
		EndIf
	Endif
	
	TSF4->(dbCloseArea())
	TSB1->(dbCloseArea())
			
EndIf

RestArea(aAreaSB1)
RestArea(aAreaSF4)
RestArea(aAreaSC6)
RestArea(aArea)              

Return(lRet)
