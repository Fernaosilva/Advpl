#INCLUDE "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP530     ºAutor  ³Donizete            º Data ³  08/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa criado para dar suporte a contabilizacao de im-   º±±
±±º          ³ postos. Devido a extensa sintaxe, foi necessario o uso de  º±±
±±º          ³ exeblock.                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Nos LPs 530 que contabilizam impostos.                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function LP530(_cExp,_cNat)

// Parâmetros
// _cExp  = contido (em branco) ou não contido "!"
// _cNat = naturezas a testar

// Definição das variáveis.
Local _nValor := 0

// Faz os testes de expressão conforme parâmetros informados no LP.

If !SE5->E5_MOTBX$"DAC,DEV,VEN,CHA" ;
 .AND.SE5->E5_TIPO<>"PA " ;
 .AND.EMPTY(SE5->E5_MOEDA) ;
 .AND.ALLTRIM(SA2->A2_COD)$"UNIAO,ESTADO,INPS,MUNIC"
 
 If _cExp == ""
  If ALLTRIM(SE5->E5_NATUREZ) $ _cNat
   _nValor := SE5->(E5_VALOR-E5_VLJUROS-E5_VLMULTA+E5_VLDESCO-E5_VLCORRE)
   Alert("Contido")
  EndIf
 ElseIf _cExp == "!"
  If !ALLTRIM(SE5->E5_NATUREZ) $ _cNat
   _nValor := SE5->(E5_VALOR-E5_VLJUROS-E5_VLMULTA+E5_VLDESCO-E5_VLCORRE)
   Alert("Não Contido")
  EndIf
 Endif 
EndIf

Return(_nValor) // Retorna o valor para o LP.
