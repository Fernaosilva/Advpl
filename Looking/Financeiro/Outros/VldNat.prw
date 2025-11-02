#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDNAT    บAutor  ณMicrosiga           บ Data ณ  26/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Este programa valida se a natureza financeira esta sendo   บฑฑ
ฑฑบ          ณ utilizada corretamente.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Este programa eh utilizado nas valida็๕es de usuแrio      บฑฑ
ฑฑบ          ณ dos campos A1_NATUREZ, A2_NATUREZ, E1_NATUREZ, E2_NATUREZ, บฑฑ
ฑฑบ          ณ E5_NATUREZ, C5_ZZNAT                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VldNat(_cNat,_cRecPag)

// Parโmetros:
//	_cNat = Natureza que esta sendo utilizada no momento.
//	_cRecPag = qual o tipo de movimento utilizado no momento.

// Defini็ใo de variแveis.
Public _lRet	:= .T.
Public _cDig	:= ""

// Elimina espa็os em branco.
_cNat := Alltrim(_cNat)
_cDig := SubStr(_cNat,1,1)

// Checa se a natureza ้ sint้tica.
If Len(_cNat) < 5
	_lRet := .F.
	Alert("Nใo ้ permitido utilizar naturezas sint้ticas.")
	Return(_lRet)
EndIf

// Outras valida็๕es.
If _cRecPag == "P" .And. _cDig $ "1,2,3,4"
	_lRet := .F.
	Alert("Natureza Invแlida, favor digitar natureza de saํda.")
ElseIf _cRecPag == "R" .And. _cDig $ "5,6,7,8"
	_lRet := .F.
	Alert("Natureza Invแlida, favor digitar natureza de entrada.")
EndIf
		
Return(_lRet)
// Fim.