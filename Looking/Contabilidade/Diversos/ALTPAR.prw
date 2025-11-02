#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALTPAR    บAutor  ณDonizete            บ Data ณ  02/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Este programa serve para alterar alguns parโmetros,        บฑฑ
ฑฑบ          ณ barrando desta forma a operacinalidade por parte do        บฑฑ
ฑฑบ          ณ usuแrio. M๓dulos tratados: entrada de NF/Faturamento,      บฑฑ
ฑฑบ          ณ Financeiro (movimentos e reconcilia็ใo), Livros Fiscais    บฑฑ
ฑฑบ          ณ (escritura็ใo).                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fun็ใo carregada atrav้s do menu. Programa desenhado para  บฑฑ
ฑฑบ          ณ Protheus 8.                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบData      ณ Altera็๕es                                                 บฑฑ
ฑฑบ          ณ - acrescentado tratamento para o parโmetro MV_DBLQMOV.     บฑฑ
ฑฑบ          ณ - melhorado tratamento dos parโmetros mostrando ao usuแrio บฑฑ
ฑฑบ          ณaviso quando algum parโmetro estiver branco.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ALTPAR()

// Defini็ใo das variแveis do programa.
Public _mvDatafis := GetMv("MV_DATAFIS")
Public _mvDatafin := GetMv("MV_DATAFIN")
Public _mvDatarec := GetMv("MV_DATAREC")
Public _mvDataest := GetMv("MV_DBLQMOV")

// Verifica se o usuแrio ้ o Administrador do sistema ou usuแrios autorizados.
/*
If !Alltrim(Upper(SubStr(cUsuario,7,15))) $ "ADMINISTRADOR"
	Alert("Somente o Administrador ou usuแrios autorizados podem executar esta rotina.")
	Return
EndIf
*/

// Solicita ao usuแrio nome do arquivo.
@ 150,  1 TO 400, 435 DIALOG oMyDlg TITLE OemToAnsi("Bloqueio de Parโmetros")
@   2, 10 TO 110, 210
@  10, 18 Say " Data limite p/opera็๕es fiscais ?"
@  10,125 Get _mvDatafis Size 50,50
@  20, 18 Say " Data limite p/opera็๕es financeiras ?"
@  20,125 Get _mvDatafin Size 50,50
@  30, 18 Say " Data limite p/reconcilia็ใo banc. ?"
@  30,125 Get _mvDatarec Size 50,50
@  40, 18 Say " Data limite p/movimenta็๕es do estoque ?"
@  40,125 Get _mvDataest Size 50,50
@  50, 18 Say " ฺltimo fech.estoque: " + Transform(GETMV("MV_ULMES"),"@D")
@  60, 18 Say " ฺltimo cแlc.deprec.: " + Transform(GETMV("MV_ULTDEPR"),"@D")
@  70, 18 Say ""
@  80, 18 Say ""
@  90, 18 Say ""
@ 110,150 BMPBUTTON TYPE 01 ACTION (RunProc(), Close(oMyDlg))
@ 110,180 BMPBUTTON TYPE 02 ACTION Close(oMyDlg)
Activate Dialog oMyDlg Centered

Return


Static Function RunProc()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRUNPROC   บAutor  ณDonizete            บ Data ณ  02/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para alterar os parโmetros.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ fun็ใo ALTPAR.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


// Faz valida็๕es e Altera os parโmetros. 
If !Empty(_mvDatafis)
	PutMv("MV_DATAFIS",_mvDatafis)
Else
	Alert("Data limite p/opera็๕es fiscais em branco.")
EndIf

If !Empty(_mvDatafin)
	PutMv("MV_DATAFIN",_mvDatafin)   
Else
	Alert("Data limite p/opera็๕es financeiras em branco.")
EndIf

If !Empty(_mvDatarec)
	If _mvDatarec < GETMV("MV_DATAFIN")
		Alert("Data limite para reconcilia็ใo bancแria menor ou igual a data limite de mov.financeiras.")
	Else
		PutMv("MV_DATAREC",_mvDatarec)
	EndIf
Else
	Alert("Data limite p/reconcilia็ใo banc. em branco.")
EndIf

If !Empty(_mvDataest)
	If _mvDataest < GETMV("MV_ULMES")
		Alert("Data limite para movimenta็๕es do estoque nใo pode ser menor que a data de fechamento.")
	Else
		PutMv("MV_DBLQMOV",_mvDataest)
	EndIf
Else
	Alert("Data limite p/movimenta็๕es do estoque em branco.")
EndIf

Return