#INCLUDE "rwmake.ch"
#include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCT1CF    บ Autor ณ                  บ Data ณ                บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Este programa tem a finalidade de dar carga inicial no Planoบฑฑ
ฑฑบ          ณ de Contas quando da Implantacao do Modulo SIGACTB           บฑฑ
ฑฑบ          ณ este programa devera ser utilizado apenas na migracao       บฑฑ
ฑฑบ          ณ podendo ser retirado do projeto                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CT1CF()

SETPRVT("_cOrder,_cRecno,_cConta,_cNome,_cCod,_nParamRet,_cEst,_Contab")
_Contab:=alltrim(GetMv("MV_MCONTAB"))

If _Contab<>"CTB"
	Return
Endif

If MsgYesNo("Importar Clientes (se nใo, entใo importarแ Fornecedores)?")
	U_CT1CLIENTES("")      // Cria Contas Contabeis dos Clientes
Else
	U_CT1FORNECEDORES()  // Cria Contas Contabeis dos Fornecedores
EndIf

Alert("Dados Importados!")

Return

/*/
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบFuncao    ณCT1CLIENTES บ Autor ณ                  บ Data ณ            บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Esta funcao criara as contas contabeis dos clientes         บฑฑ
ฑฑบ          ณ quando da Implantacao do Modulo SIGACTB                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
/*/

User Function CT1CLIENTES(_cConta)
dbSelectArea("SA1")
DbGotop()
While .not. eof()


	_cNome	:= SA1->A1_NOME
	_cCod	:= SA1->A1_COD+SA1->A1_LOJA
	_cEst	:= SA1->A1_EST

	If SA1->A1_EST == "EX"
		_cConta := "11020102"
	ElseIf SA1->A1_EST <> "EX" .And. !Empty(SA1->A1_EST)
		_cConta := "11020101"
	Else
		_cConta := ""
	EndIf
	
	_Contacli:=_cConta+_cCod




	dbSelectArea("CT1")
	dbSetOrder(1)
	DbSeek(xFilial("CT1") + _ContaCli)
	
	//Begin Transaction
	If .not. Found()
		Reclock("CT1", .T.)
		
		CT1->CT1_FILIAL		:= xFilial("CT1")
		CT1->CT1_CONTA		:= _ContaCli
		CT1->CT1_DESC01		:= _cNome
		CT1->CT1_DESC02		:= ""
		CT1->CT1_DESC03		:= ""
		CT1->CT1_DESC04		:= ""
		CT1->CT1_DESC05		:= ""
		CT1->CT1_CLASSE		:= "2"
		CT1->CT1_NORMAL		:= "1"
		CT1->CT1_RES		:= ""
		CT1->CT1_BLOQ		:= "2"
		CT1->CT1_DTBLIN		:= Ctod(Space(8))
		CT1->CT1_DTBLFI		:= Ctod(Space(8))
		CT1->CT1_DC			:= "1"
		CT1->CT1_NCUSTO		:= 0
		CT1->CT1_CC			:= ""
		CT1->CT1_CVD02		:= "5"
		CT1->CT1_CVC02		:= "5"
		CT1->CT1_CVD03		:= "5"
		CT1->CT1_CVC03		:= "5"
		CT1->CT1_CVD04		:= "5"
		CT1->CT1_CVC04		:= "5"
		CT1->CT1_CVD05		:= "5"
		CT1->CT1_CVC05		:= "5"
		CT1->CT1_CTASUP		:= _cConta
		CT1->CT1_HP			:= ""
		CT1->CT1_ACITEM		:= "1"
		CT1->CT1_ACCUST		:= "2"
		CT1->CT1_ACCLVL		:= "1"
		CT1->CT1_DTEXIS		:= CTOD("01/01/1980")
		CT1->CT1_CTAVM		:= ""
		CT1->CT1_CTARED		:= ""
		CT1->CT1_CTALP		:= ""
		CT1->CT1_CTAPON		:= ""
		CT1->CT1_BOOK		:= "001/002/003/004/005"
		CT1->CT1_GRUPO		:= ""
		CT1->CT1_AGLSLD		:= "2"
		CT1->CT1_RGNV1		:= "N"
		CT1->CT1_RGNV2		:= ""
		CT1->CT1_RGNV3		:= ""
		CT1->CT1_CCOBRG		:= "2"
		CT1->CT1_ITOBRG		:= "2"
		CT1->CT1_CLOBRG		:= "2"
		CT1->CT1_LALUR		:= "0"
		CT1->CT1_AGLUT		:= ""
		CT1->CT1_TRNSEF		:= "" //8.11
		CT1->CT1_CTLALU		:= _ContaCli //8.11
		CT1->CT1_ESTOUR		:= "" //8.11
		CT1->CT1_CODIMP		:= "" //8.11
		CT1->CT1_RATEIO		:= "" //8.11
		CT1->CT1_AJ_INF		:= "" //8.11

		MsUnlock()
		DbSelectArea("SA1")
		Reclock("SA1", .F.)
		Replace SA1->A1_CONTA	with _ContaCli
		MsUnlock()
	Endif
	//End Transaction
	DbSelectArea("SA1")
	Skip
Enddo
Return

/*/
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบFuncao    ณCT1FORNECEDORESบ Autor ณ                  บ Data ณ          บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Esta funcao criara as contas contabeis dos Fornecedores     บฑฑ
ฑฑบ          ณ quando da Implantacao do Modulo SIGACTB                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
/*/

User Function CT1FORNECEDORES(_cConta)

Local _cCtaSup := ""

dbSelectArea("SA2")
DbGotop()

While .not. eof()
	
	dbSelectArea("SA2")
	
	_cOrder := DbSetOrder()
	_cRecno := Recno()
	_cNome	  := SA2->A2_NOME
	_cCod     := SA2->A2_COD+SA2->A2_LOJA
	_cEst  	  := SA2->A2_EST
	_cConta   :=""
	
	// Este escopo deve ser atualizado com as regras definidas pelo Contador.
	If SubStr(SA2->A2_COD,1,1) == "0"
		_cConta := "21010101"+_cCod 
		_cCtaSup:= "21010101"
	ElseIf SubStr(SA2->A2_COD,1,1) == "F"
		_cConta := "21010509"
		_cCtaSup:= "21010101"
	ElseIf SubStr(SA2->A2_COD,1,1) == "V"
		_cConta := "21010504"
		_cCtaSup:= "21010101"
	Else
		_cCta := ""
	EndIf
	
	If empty(_cConta)
		Skip
		Loop
	Endif
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	DbSeek(xFilial("CT1") + _cConta)
	If .not. Found() .And. !empty(_cCod)
		//Begin Transaction
		Reclock("CT1", .T.)
		
		CT1->CT1_FILIAL		:= xFilial("CT1")
		CT1->CT1_CONTA		:= _cConta+_cCod
		CT1->CT1_DESC01		:= _cNome
		CT1->CT1_DESC02		:= ""
		CT1->CT1_DESC03		:= ""
		CT1->CT1_DESC04		:= ""
		CT1->CT1_DESC05		:= ""
		CT1->CT1_CLASSE		:= "2"
		CT1->CT1_NORMAL		:= "2"
		CT1->CT1_RES		:= ""
		CT1->CT1_BLOQ		:= "2"
		CT1->CT1_DTBLIN		:= Ctod(Space(8))
		CT1->CT1_DTBLFI		:= Ctod(Space(8))
		CT1->CT1_DC			:= "1"
		CT1->CT1_NCUSTO		:= 0
		CT1->CT1_CC			:= ""
		CT1->CT1_CVD02		:= "5"
		CT1->CT1_CVC02		:= "5"
		CT1->CT1_CVD03		:= "5"
		CT1->CT1_CVC03		:= "5"
		CT1->CT1_CVD04		:= "5"
		CT1->CT1_CVC04		:= "5"
		CT1->CT1_CVD05		:= "5"
		CT1->CT1_CVC05		:= "5"
		CT1->CT1_CTASUP		:= _cCtaSup
		CT1->CT1_HP			:= ""
		CT1->CT1_ACITEM		:= "1"
		CT1->CT1_ACCUST		:= "2"
		CT1->CT1_ACCLVL		:= "1"
		CT1->CT1_DTEXIS		:= CTOD("01/01/1980")
		CT1->CT1_CTAVM		:= ""
		CT1->CT1_CTARED		:= ""
		CT1->CT1_CTALP		:= ""
		CT1->CT1_CTAPON		:= ""
		CT1->CT1_BOOK		:= "001/002/003/004/005"
		CT1->CT1_GRUPO		:= ""
		CT1->CT1_AGLSLD		:= "2"
		CT1->CT1_RGNV1		:= "N"
		CT1->CT1_RGNV2		:= ""
		CT1->CT1_RGNV3		:= ""
		CT1->CT1_CCOBRG		:= "2"
		CT1->CT1_ITOBRG		:= "2"
		CT1->CT1_CLOBRG		:= "2"
		CT1->CT1_LALUR		:= "0"
		CT1->CT1_AGLUT		:= ""
		CT1->CT1_TRNSEF		:= "" //8.11
		CT1->CT1_CTLALU		:= _cConta+_cCod //8.11
		CT1->CT1_ESTOUR		:= "" //8.11
		CT1->CT1_CODIMP		:= "" //8.11
		CT1->CT1_RATEIO		:= "" //8.11
		CT1->CT1_AJ_INF		:= "" //8.11
		
		MsUnlock()
	Endif
	DbSelectArea("SA2")
	Reclock("SA2", .F.)
	Replace SA2->A2_CONTA	with _cConta+_cCod
	MsUnlock()
	//End Transaction
	DbSelectArea("SA2")
	Skip
Enddo
Return
