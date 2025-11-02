#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA050INC  บAutor  ณDonizete            บ Data ณ  23/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Este programa tem a fun็ใo de validar conta, centro de     บฑฑ
ฑฑบ          ณ custo, item contแbil e classe de valor. Checa se as contas บฑฑ
ฑฑบ          ณ foram informadas e se a amarra็ใo esta ok. Estando ok, a   บฑฑ
ฑฑบ          ณ conta contแbil serแ retornada para o tํtulo e o mesmo pode-บฑฑ
ฑฑบ          ณ rแ ser incluํdo, caso contrแrio, serแ apresentada msg. ao  บฑฑ
ฑฑบ          ณ usuแrio e o tํtulo nใo serแ incluํdo at้ que seja feita a  บฑฑ
ฑฑบ          ณ corre็ใo.                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Desenvolvido na versใo 8.11                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ponto de Entrada disparado na inclusใo do tํtulo.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบ09/06/06  ณ Programa reescrito em fun็ใo de falhas na valida็ใo.       บฑฑ
ฑฑบ17/10/07  ณ Retorna mensagem se conta nใo encontrada no CT1.           บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FA050INC

// Declara็ใo das Variแveis.
Public 	_cNat 	 		:= M->E2_NATUREZ
Public   _cConta		:= M->E2_DEBITO
Public	_cCC			:= M->E2_CCD
Public	_cItem			:= M->E2_ITEMD
Public	_cClasse		:= M->E2_CLVLDB
Public 	_xAreaSED		:= {}
Public 	_xAreaCT1		:= {}
Public	_lRet			:= .f.
Public  _cRegraCC		:= alltrim(u_cc(_cCC))
// Obt้m a regra de nํvel do centro de custo.
If !Empty(_cCC)
	_cRegraCC := alltrim(u_cc(_cCC))
EndIf


// s๓ executa para a rotina FINA050.
If !Alltrim(FUNNAME())$"FINA050,FINA750"
	Return(.t.)
EndIf

// Chama function de valida็ใo do PA.
If M->E2_TIPO=="PA "
	Return(U_VLDPA())
EndIf

// Nใo valida estes tipos de documento.
If Alltrim(M->E2_TIPO)$"PR,NDF,PA,AB-"
	Return(.T.)
EndIf

dbSelectArea("SED")
_xAreaSED := GetArea()
dbSetOrder(1)
dbSeek(xFilial("SED") + _cNat)

// S๒ valida se a natureza estiver parametrizada para ser contabilizada.
If SED->ED_ZZCTB == "N"
	RestArea(_xAreaSED)
	Return(.T.)
EndIf

// Valida็ใo inicial da obrigatoriedade do centro de custo.
If SED->ED_ZZCCOBR=="S" .And. Empty(M->E2_CCD)
	MsgAlert("ษ obrigat๓rio a digita็ใo do centro de custo!")
	RestArea(_xAreaSED)
	Return(.f.)
EndIf

// Mensagem de alerta quando a natureza tiver sua origem em outro m๓dulo.
If SED->ED_ZZCTB=="C"
	If MsgYesNo("O uso desta natureza geralmente acompanha uma NF, a digita็ใo da mesma deve ser pelo m๓dulo " + ;
	      "de Compras para o correto processamento do sistema. Continuar?","ATENCAO")
		_lRet := .T.
	//Else
		//RestArea(_xAreaSED)
		//Return(.f.)
	EndIf
EndIf

If Empty(_cConta) // Conta nใo foi informa pelo usuแrio.
	
	// Posiciona no cadastro de naturezas para obter a conta.
	dbSeek(xFilial("SED") + _cNat)
	
	If Found() // Encontrou a natureza, obt้m as contas e valida.
		
		// Checa o centro de custo, pois este define qual conta serแ utilzada, faz a valida็ใo.
		If _cRegraCC $ "ACR"  .And. !Empty(SED->ED_ZZCTAD) // Administra็ใo / Comercial.
			_cConta := SED->ED_ZZCTAD
			TLP001A()
		Else
			If _cRegraCC $ "DI" .And. !Empty(SED->ED_ZZCTAC) // Produ็ใo -> Deptos.Diretos/Indiretos.
				_cConta := SED->ED_ZZCTAC
				TLP001A()
				// Centro de custo nใo informado ou sem regra.
			Else // Regra nใo conhecida.
				If !Empty(_cRegraCC) .And. (!Empty(SED->ED_ZZCTAC) .Or. ;
					!Empty(SED->ED_ZZCTAD) .Or. ;
					!Empty(SED->ED_ZZCTAC))
					TLP001B("Nใo ้ possํvel tomar decisใo porque a regra do C.Custo nใo ้ conhecida -> "+_cRegraCC)
				ELse
					_cConta := SED->ED_ZZCTAD
					If !Empty(_cConta)
						TLP001A()
					Else
						_cConta := SED->ED_ZZCTAC
						If !Empty(_cConta)
							TLP001A()
						Else
							_cConta := SED->ED_ZZCTAA
							If !Empty(_cConta)
								TLP001A()
							else
								_lRet := .t.
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Else
	// Conta foi informa pelo usuแrio, validar.
	TLP001A()
EndIf

// Restaura แrea.
RestArea(_xAreaSED)

// Retorna no tํtulo a conta contแbil encontrada e validada.
If _lRet == .T.
	M->E2_DEBITO := _cConta
EndIf

// Retorna falso ou verdadeiro, permitindo a inclusใo do tํtulo.
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTLP001A   บAutor  ณDonizete            บ Data ณ  23/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Este programa valida as informa็๕es (entidades e amarra-   บฑฑ
ฑฑบ          ณ ็๕es).                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FA050INC                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TLP001A

Local _cCTTac := ""
Local _cCTTob := ""
Local _cCTDac := ""
Local _cCTDob := ""
Local _cCTHac := ""
Local _cCTHob := ""

dbSelectArea("CT1")
_xAreaCT1 := GetArea()
dbSetOrder(1)
dbSeek(xFilial("CT1") + _cConta)
If Found()
	// Centro de custo.
	_cCTTac := CT1->CT1_ACCUST
	_cCTTOb := CT1->CT1_CCOBRG
	// Item.
	_cCTDac := CT1->CT1_ACITEM
	_cCTDOb := CT1->CT1_ITOBRG
	// Classe.
	_cCTHac := CT1->CT1_ACCLVL
	_cCTHob := CT1->CT1_CLOBRG
	
	If _cCTTac == "2" .And. !Empty(_cCC)
		TLP001B("A conta amarrada a natureza nใo aceita centro de custo.")
	ElseIf _cCTDac == "2" .And. !Empty(_cItem)
		TLP001B("A conta amarrada a natureza nใo aceita item contแbil.")
	ElseIf _cCTHac == "2" .And. !Empty(_cClasse)
		TLP001B("A conta amarrada a natureza nใo aceita classe de valor.")
	ElseIf _cCTTob == "1" .And. Empty(_cCC) .And. M->E2_RATEIO <> "S"
		TLP001B("O centro de custo ้ obrigat๓rio. Favor informar.")
	ElseIf _cCTDob == "1" .And. Empty(_cItem) .And. M->E2_RATEIO <> "S"
		TLP001B("O item contแbil ้ obrigat๓rio. Favor informar.")
	ElseIf _cCTHob == "1" .And. Empty(_cClasse) .And. M->E2_RATEIO <> "S"
		TLP001B("A classe de valor ้ obrigat๓ria. Favor informar.")
	Else
		If !Empty(_cConta)
			_lRet := CtbAmarra(_cConta,_cCC,_cItem,_cClasse,.T.)
		Else
			_lRet := .t.
		EndIf
	EndIf
Else
	MsgAlert("Aten็ใo, conta contแbil nใo encontrada.","FA050INC")
	_lRet := .f.	
EndIf
RestArea(_xAreaCT1)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTLP001B   บAutor  ณDonizete            บ Data ณ  23/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Este programa apresenta mensagens de alerta e atribui falsoบฑฑ
ฑฑบ          ณ เs variแveis nใo permitindo a inclusใo do tํtulo.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TLP001A                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TLP001B(_cMsg)
Alert(_cMsg)
_lRet := .F.
_lOk := .F.
Return
