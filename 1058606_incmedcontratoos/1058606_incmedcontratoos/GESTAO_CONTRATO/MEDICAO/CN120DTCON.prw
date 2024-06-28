#INCLUDE "PROTHEUS.CH"


/*/{Protheus.doc} CN120DTCON
@author Kaique Mathias
@type function
@description Ponto de entrada para validar o contrato.
@obs #GESTAODECONTRATOS #MEDI��O 
@since 21/01/13
@version Protheus 12
/*/

User Function CN120DTCON()

	Local __stt          := u___stt(procname(0),"CN120DTCON")
	Local lRet           := .T.
	Local oModel         := NIL
	Local oHeadCND       := Nil

	Public _nVlrIpiBf    := If(Type("_nVlrIpiBf") <> 'U', _nVlrIpiBf, 0)

	lRet := ExecBlock("BFGC030K",.F.,.F.) //valida se o contrato possui area arrendada.

    //Chamado 666662 - 22/08/22 - Jared Ribeiro
    //Adapta��o das customiza��es para a nova medi��o, inicializadores de campos da CND agora ser�o preenchidas aqui
	If (IsInCallStack('CNTA121') .or. IsInCallStack('GerMedContrato')) .and. lRet
		oModel   := FwModelActive()
		oHeadCND := oModel:GetModel('CNDMASTER')

		oHeadCND:SetValue('CND_APROV' , CN9->CN9_APROV)
		oHeadCND:SetValue('CND_YTXMOE', RecMoeda(dDatabase,CN9->CN9_MOEDA))
		oHeadCND:SetValue('CND_YPI'   , CN9->CN9_YPI)
		oHeadCND:SetValue('CND_YVLCON', CN9->CN9_YVLCTR)
		oHeadCND:SetValue('CND_YSALDO', CN9->CN9_SALDO)
		oHeadCND:SetValue('CND_YFORES', CN9->CN9_YCTRES)
		oHeadCND:SetValue('CND_YLORES', CN9->CN9_YLOJA)
		oHeadCND:SetValue('CND_YDERES', CN9->CN9_YNTRES)
		oHeadCND:SetValue('CND_YAPROV', CN9->CN9_YAPROV)
		oHeadCND:SetValue('CND_YSALME', U_BFGC011K(CN9->CN9_FILCTR, CN9->CN9_NUMERO, CN9->CN9_YVLCTR, (ALLTRIM(CN9->CN9_YELRES) == "S")))
		oHeadCND:SetValue('CND_YNPARC', CN9->CN9_YNPARC)
		oHeadCND:SetValue('CND_YTOTKG', CN9->CN9_YTOTKG)
		oHeadCND:SetValue('CND_YTPGER', CN9->CN9_YTPGER)

	EndIf

Return lRet


