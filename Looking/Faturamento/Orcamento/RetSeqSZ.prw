#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function RetSEQSZ

// Variáveis da função.
Local _xArea:= GetArea()
Public _cCod := ""

// Verifica se já existe código com o tipo de fornecedor escolhido.
cQuery := "SELECT COUNT(Z0_NUM) AS OCORR FROM " + RetSqlName("SZ0")
cQuery += " WHERE Z0_NUM='"+M->Z0_NUM+"' AND"
cQuery += " D_E_L_E_T_=' '"
TcQuery cQuery New Alias "TSZ0"
TSZ0->(dbGoTop())

If TSZ0->OCORR == 0 // Retorna 1 para o caso primeiro caso com a letra.
	_cCod := "01"
	TSZ0->(dbCloseArea())
Else // Foi encontrado, então retorna o próximo número a ser usado.
	TSZ0->(dbCloseArea())
	cQuery := "SELECT MAX(Z0_SEQUEN) AS MAIOR FROM " + RetSqlName("SZ0")
	cQuery += " WHERE Z0_NUM='"+M->Z0_NUM+"' AND"
	cQuery += " D_E_L_E_T_=' '"
	TcQuery cQuery New Alias "TSZ0"
	TSZ0->(dbGoTop())
	_cCod := Soma1(TSZ0->MAIOR,2)
	TSZ0->(dbCloseArea())
EndIf

// Restaura área
RestArea(_xArea)

// Fim do programa.
Return(_cCod)