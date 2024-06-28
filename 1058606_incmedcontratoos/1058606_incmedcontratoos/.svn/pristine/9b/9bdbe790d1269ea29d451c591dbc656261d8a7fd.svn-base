#Include 'Protheus.ch'

/*/{Protheus.doc} BFGC013K
@author Kaique Mathias
@type User Function 
@description Fonte que valida se o valor total dos produtos e maior que o saldo da medicao do contrato.
@obs #MEDICAO #GESTAODECONTRATOS #SALDOCONTRATO
@since 10/02/2013
@version Protheus 12
@Return Boolean, Retorna se o processo foi ou não validado.
/*/
User Function BFGC013K()

	Local __stt   := u___stt(procname(0),"BFGC013K")

	Local aAreas  := {CN9->(GetArea()),CN1->(GetArea())}
	Local _lRet   := .T.
	Local nSaldo  := U_BFGC003K() //busca saldo disponivel do contrato

	DbSelectArea("CN9")
	DbSetOrder(1)
	DbGoTop()

	If CN9->(DbSeek(M->CND_FILCTR+M->CND_CONTRA+M->CND_REVISA))

		DbSelectArea("CN1")
		CN1->(DbSetOrder(1))
		CN1->(DbGoTop())
		If CN1->(DbSeek(xFilial("CN1",CN9->CN9_FILCTR)+CN9->CN9_TPCTO))

			If CN1->CN1_YCSALD == "1" .And. CN1->CN1_CTRFIX == '2' //chamado 1004029 - só valida contrato flexível
				
				If nSaldo < 0

					Aviso("Aviso","Valor total do produto é maior do que o saldo do contrato ou saldo disponivel para medições, verifique.",{"OK"})
					_lRet := .F.

					If IsInCallStack('U_BFMA46HS')
						Break
					EndIf
				
				EndIf

			EndIf

		EndIf

	EndIf 

	aEval(aAreas,{|x| RestArea(x) })

Return (_lRet)
