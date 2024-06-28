#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#INCLUDE "IDATOOLS.CH"
#INCLUDE "GCTXDEF.CH"

#DEFINE CRLF  Chr(13) + Chr(10)


/*/{Protheus.doc} BFMA46HS
@description Gera��o de (Solicita��o de Produto/ Solicita��o de Compra/ Pedido de Compra)
@type Function
@author Helitom Silva
@since 13/10/2023
@version 12.1.2210
@param Nil
@return Nil
@see (links_or_references)
/*/
User Function BFMA46HS()

	Local __stt      := u___stt(procname(0), "BFMA46HS")
	Local aCoors     := FWGetDialogSize( oMainWnd )
    Local aOldArea   := GetArea()
	Local aButtons   := {}
    Local cMVYOISCPP := U_YGETNPAR('MV_YOISCPP', '')

	Private oFWLayer
	Private INCLUI    := .T.
    Private cTit46HS  := '(' + Iif('SC' $ cMVYOISCPP, 'Solicita��o de Compra, ', '') + Iif('SP' $ cMVYOISCPP, 'Solicita��o de Produto, ', '') + Iif('PC' $ cMVYOISCPP, 'Pedido de Compra', '') + Iif('MC' $ cMVYOISCPP, 'Medi��o de Contrato', '') + ')'
    Private cNum46HS  := STJ->TJ_ORDEM
	Private aTpRequis := GetOperacoes()
	Private cTpRequis := ''
	Private cDscTpReq := ''
	Private cContrato := CriaVar('CND_CONTRA', .F.)
	Private cRevisa   := CriaVar('CN9_REVISA', .F.)
	Private cCodForn  := CriaVar('A2_COD', .F.)
	Private cLojForn  := CriaVar('A2_LOJA', .F.)
	Private cNomForn  := CriaVar('A2_NOME', .F.)
	Private cCodCLVL  := U_BFMA18HS(1)
	Private cDescCLVL := U_BFMA18HS(2)
	Private lChkIns   := .T.
	Private cCondPag  := ''
	Private cDCondPag := ''
	Private nMoeda    := 1
	Private cDMoeda   := SuperGetMv("MV_MOEDA" + AllTrim(Str(nMoeda, 2)))
	Private nTxMoeda  := 0
	Private nPerDsc   := 0
	Private nPerIPI   := 0
	Private nVlrIPI	  := 0
	Private cTpFrete  := CriaVar('C7_TPFRETE', .T.)
	Private aTpFrete  := CarregaTipoFrete()
	Private nDespesa  := 0
	Private cTpGer    := CriaVar('C7_YTPGER', .F.)
	Private cSafra    := CriaVar('AKF_CODIGO', .F.)
	Private cChvNFE   := CriaVar('C7_YCHVNFE', .F.)
	Private nTotMerc  := 0
	Private nVlrDsc   := 0
	Private nTotPed   := 0
	Private cFilCtr   := cFilAnt // Vari�vel usada na Consulta de Medi��es de Contrato e na Gera��o de Medi��o de Contrato

	Default cNum46HS := ''

	If !Empty(cNum46HS)

		// Declara��o de Variaveis Private dos Objetos
		SetPrvt("oPanelUp", "oPanelDt", "oPanelDown", "oDlgGSP", "oTpRequis", "oCodForn", "oLojForn", "oNomForn", "oPanelUp2")
		SetPrvt("oCodCLVL", "oDesCLVL", "oGridReq", "oCondPag", "oDCondPag", "oMoeda", "oDMoeda", "oTxMoeda", "oDesconto", "oPerIPI", "oFrete", "oDespesa")
		SetPrvt("oTpGer", "oSafra", "oChvNFE", "oTotMerc", "oVlrDsc", "oTotPed")

		// Definicao do Dialog e todos os seus componentes.
		oDlgGSP := MSDialog():New( aCoors[1], aCoors[2], aCoors[3], aCoors[4], "Gera��o de " + cTit46HS,,,.F.,,,,,,.T.,,,.T. )

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgGSP, .F., .T. )

		oFWLayer:AddLine( 'UP', 20, .F. )
		oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )
		oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )

		oTpRequis := TComboBox():New(Dim(008), Dim(015), {|u| if(PCount() > 0, cTpRequis := u, cTpRequis)}, aTpRequis, Dim(100),Dim(14), oPanelUp,,/*bValid*/,,,,.T.,,,,,,,,,'cTpRequis','Tipo de Requisi��o',1)
    	oTpRequis:bWhen := {|| .T.}
		If Len(aTpRequis) == 1
			oTpRequis:Select(1)
		EndIf
		oTpRequis:bChange := {|| cDscTpReq := aTpRequis[aScan(aTpRequis, {|X| SubStr(X, 1, (At('=', X) -1)) == cTpRequis})], cDscTpReq := SubStr(cDscTpReq, At('=', cDscTpReq) + 1)}
    	oTpRequis:bValid  := {|| ValidField('TIPOREQ', cTpRequis)}

		oContrato := TGet():New(Dim(008), Dim(125), {|u| If(PCount() > 0, cContrato := u, cContrato)}, oPanelUp, Dim(100), Dim(010), PesqPict("CND","CND_CONTRA"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "CN9003", "cContrato",,,,.T.,.F.,, "Contrato", 1)
		oContrato:bWhen   := {|| cTpRequis == 'MC'}
		oContrato:bChange := {|| Iif(!Empty(cContrato),, Nil)}
    	oContrato:bValid  := {|| ValidField('CONTRATO', cContrato)}

		oRevisao := TGet():New(Dim(008), Dim(235), {|u| If(PCount() > 0, cRevisa := u, cRevisa)}, oPanelUp, Dim(030), Dim(010),PesqPict("CN9","CN9_REVISA"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "cRevisa",,,,.T.,.F.,, "Revis�o", 1)
		oRevisao:bWhen   := {|| .F. }
		oRevisao:bChange := {|| Iif(!Empty(cRevisa), Nil, Nil)}
    	oRevisao:bValid  := {|| ValidField('REVISAO', cRevisa)}

		oCodForn := TGet():New(Dim(008), Dim(335-60), {|u| If(PCount() > 0, cCodForn := u, cCodForn)}, oPanelUp, Dim(030), Dim(010),PesqPict("SA2","A2_COD"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "SA2", "cCodForn",,,,.T.,.F.,, "Cod. Forn.", 1)
		oCodForn:bWhen   := {|| .T.}
		oCodForn:bChange := {|| Iif(!Empty(cCodForn) .and. !Empty(cLojForn), cNomForn := Posicione('SA2', 1, FWxFilial('SA2') + cCodForn + cLojForn, 'A2_NOME'), Nil)}
    	oCodForn:bValid  := {|| ValidField('CODFORN', cCodForn)}

		oLojForn := TGet():New(Dim(008), Dim(375-60), {|u| If(PCount() > 0, cLojForn := u, cLojForn)}, oPanelUp, Dim(010), Dim(010),PesqPict("SA2","A2_LOJA"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "cLojForn",,,,.T.,.F.,, "Loja", 1)
		oLojForn:bWhen   := {|| .T.}
		oLojForn:bChange := {|| cNomForn := Posicione('SA2', 1, FWxFilial('SA2') + cCodForn + cLojForn, 'A2_NOME')}
    	oLojForn:bValid  := {|| ValidField('LOJFORN', cLojForn)}

		oNomForn := TGet():New(Dim(008), Dim(400-60), {|u| If(PCount() > 0, cNomForn := u, cNomForn)}, oPanelUp, Dim(200),010,PesqPict("SA2","A2_NOME"),,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "cNomForn",,,,.T.,.F.,, "Nome",1)
		oNomForn:bWhen := {|| .F.}

		oCodCLVL := TGet():New(Dim(030), Dim(015), {|u| If(PCount() > 0, cCodCLVL := u, cCodCLVL)}, oPanelUp, Dim(010), Dim(010),PesqPict("CTH","CTH_CLVL"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "cCodCLVL",,,,.T.,.F.,, "Cod. Aglom.", 1)
		oCodCLVL:bWhen   := {|| .T.}
		oCodCLVL:cF3	 := 'CTH'
    	oCodCLVL:bValid  := {|| ValidField('CODAGLOM', cCodCLVL)}

		oDesCLVL := TGet():New(Dim(030), Dim(077), {|u| If(PCount() > 0, cDescCLVL := u, cDescCLVL)}, oPanelUp, Dim(130), Dim(010),PesqPict("CTH","CTH_DESC01"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "cDescCLVL",,,,.T.,.F.,, "Aglomerado", 1)
		oDesCLVL:bWhen   := {|| .F.}

		oSafra := TGet():New(Dim(030), Dim(217), {|u| If(PCount() > 0, cSafra := u, cSafra)}, oPanelUp, Dim(050), Dim(010), PesqPict("SC7","C7_YPLPCO"), /*bValid*/, CLR_BLACK, CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "AKF", "cSafra",,,,.T.,.F.,, "Ano Safra", 1)
		oSafra:bWhen   := {|| .T.}
    	oSafra:bValid  := {|| ValidField('SAFRA', cSafra)}

		oFWLayer:AddLine( 'LUP2', 25, .F. )
		oFWLayer:AddCollumn( 'CALL', 100, .T., 'LUP2' )
		oFWLayer:addWindow( 'CALL', 'WPEDCP', 'Dados para Pedido de Compras', 100, .F., .T.,, 'LUP2' )
		oPanelUp2 := oFWLayer:GetWinPanel( 'CALL', 'WPEDCP', 'LUP2' )

		oCondPag := TGet():New(Dim(008), Dim(015), {|u| If(PCount() > 0, cCondPag := u, cCondPag)}, oPanelUp2, Dim(030), Dim(010), PesqPict("SE4","E4_CODIGO"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "SE4", "cCondPag",,,,.T.,.F.,, "Cond. Pagto.", 1)
		oCondPag:bWhen   := {|| cTpRequis == 'PC'}
    	oCondPag:bValid  := {|| ValidField('CONDPAG', cCondPag)}

		oDCondPag := TGet():New(Dim(008), Dim(050), {|u| If(PCount() > 0, cDCondPag := u, cDCondPag)}, oPanelUp2, Dim(100), Dim(010), PesqPict("SE4","E4_DESCRI"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "cDCondPag",,,,.T.,.F.,, ".", 1)
		oDCondPag:bWhen  := {|| .F.}

		oMoeda := TGet():New(Dim(008), Dim(160), {|u| If(PCount() > 0, nMoeda := u, nMoeda)}, oPanelUp2, Dim(030), Dim(010), PesqPict("SC7","C7_MOEDA"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "nMoeda",,,,.T.,.F.,, "Moeda", 1)
		oMoeda:bWhen   := {|| cTpRequis == 'PC'}
    	oMoeda:bValid  := {|| ValidField('MOEDA', nMoeda)}

		oDMoeda := TGet():New(Dim(008), Dim(200), {|u| If(PCount() > 0, cDMoeda := u, cDMoeda)}, oPanelUp2, Dim(90), Dim(010), PesqPict("CTO","CTO_SIMB"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "cDMoeda",,,,.T.,.F.,, ".", 1)
		oDMoeda:bWhen  := {|| .F.}

		oTxMoeda := TGet():New(Dim(008), Dim(300), {|u| If(PCount() > 0, nTxMoeda := u, nTxMoeda)}, oPanelUp2, Dim(050), Dim(010), PesqPict("SC7","C7_TXMOEDA"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "nTxMoeda",,,,.T.,.F.,, "Taxa", 1)
		oTxMoeda:bWhen   := {|| cTpRequis == 'PC'}
    	oTxMoeda:bValid  := {|| ValidField('TAXAMOEDA', nTxMoeda)}

		oTpGer := TGet():New(Dim(008), Dim(350), {|u| If(PCount() > 0, cTpGer := u, cTpGer)}, oPanelUp2, Dim(030), Dim(010), PesqPict("SC7","C7_YTPGER"), /*bValid*/, CLR_BLACK, CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "ZA1", "cTpGer",,,,.T.,.F.,, "Tipo Gerencial", 1)
		oTpGer:bWhen   := {|| cTpRequis == 'PC'}
    	oTpGer:bValid  := {|| ValidField('TPGER', cTpGer)}

		oChvNFE := TGet():New(Dim(008), Dim(400), {|u| If(PCount() > 0, cChvNFE := u, cChvNFE)}, oPanelUp2, Dim(230), Dim(010), PesqPict("SC7","C7_YCHVNFE"), /*bValid*/, CLR_BLACK, CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "cChvNFE",,,,.T.,.F.,, "Chave NFE", 1)
		oChvNFE:bWhen   := {|| cTpRequis == 'PC'}
    	oChvNFE:bValid  := {|| ValidField('CHVNFE', cTpGer)}

		oPerIPI := TGet():New(Dim(030), Dim(015), {|u| If(PCount() > 0, nPerIPI := u, nPerIPI)}, oPanelUp2, 050, 010, PesqPict("SC7","C7_IPI"), /*bValid*/, CLR_BLACK, CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "nPerIPI",,,,.T.,.F.,, "% IPI", 1)
		//oPerIPI:bWhen   := {|| cTpRequis == 'PC'}
    	oPerIPI:bValid  := {|| ValidField('PERIPI', nPerIPI)}
		oPerIPI:Disable()

		oVlrIPI := TGet():New(Dim(030), Dim(070), {|u| If(PCount() > 0, nVlrIPI := u, nVlrIPI)}, oPanelUp2, Dim(050), Dim(010), PesqPict("SC7","C7_VALIPI"), /*bValid*/, CLR_BLACK, CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "nVlrIPI",,,,.T.,.F.,, "Vlr. IPI", 1)
		//oVlrIPI:bWhen   := {|| cTpRequis == 'PC'}
    	oVlrIPI:bValid  := {|| ValidField('VLRIPI', nVlrIPI)}
		oVlrIPI:Disable()

		oFrete  := TComboBox():New(Dim(030), Dim(120), {|u| if(PCount() > 0, cTpFrete := u, cTpFrete)}, aTpFrete, Dim(50), Dim(13), oPanelUp2,,/*bValid*/,,,,.T.,,,,,,,,,'cTpFrete','Tipo de Frete', 1)
    	oFrete:bWhen   := {|| cTpRequis == 'PC'}
    	oFrete:bValid  := {|| ValidField('TPFRETE', cTpFrete)}

		oDespesa := TGet():New(Dim(030), Dim(180), {|u| If(PCount() > 0, nDespesa := u, nDespesa)}, oPanelUp2, Dim(050), Dim(010), PesqPict("SC7","C7_DESPESA"), /*bValid*/, CLR_BLACK, CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "nDespesa",,,,.T.,.F.,, "Despesa", 1)
		oDespesa:bWhen   := {|| cTpRequis == 'PC'}
    	oDespesa:bValid  := {|| ValidField('DESPESA', nDespesa)}

		oTotMerc := TGet():New(Dim(030), Dim(235), {|u| If(PCount() > 0, nTotMerc := u, nTotMerc)}, oPanelUp2, Dim(070), Dim(010), PesqPict("SC7","C7_TOTAL"), /*bValid*/, CLR_BLACK, CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "nTotMerc",,,,.T.,.F.,, "Tot. Mercadoria", 1)
		oTotMerc:bWhen   := {|| .F.}
    	oTotMerc:bValid  := {|| ValidField('TOTMERC', nTotPed)}

		oPerDsc := TGet():New(Dim(030), Dim(305), {|u| If(PCount() > 0, nPerDsc := u, nPerDsc)}, oPanelUp2, Dim(070), Dim(010), PesqPict("SC7","C7_DESC1"), /*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "nPerDsc",,,,.T.,.F.,, "% Desconto", 1)
		//oPerDsc:bWhen   := {|| cTpRequis == 'PC'}
    	oPerDsc:bValid  := {|| ValidField('PERDSC', nPerDsc)}
		oPerDsc:Disable()

		oVlrDsc := TGet():New(Dim(030), Dim(375), {|u| If(PCount() > 0, nVlrDsc := u, nVlrDsc)}, oPanelUp2, Dim(070), Dim(010), PesqPict("SC7","C7_VLDESC"), /*bValid*/, CLR_BLACK, CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "nVlrDsc",,,,.T.,.F.,, "Vl. Desconto", 1)
		//oVlrDsc:bWhen   := {|| cTpRequis == 'PC'}
    	oVlrDsc:bValid  := {|| ValidField('VLRDSC', oVlrDsc)}
		oVlrDsc:Disable()

		oTotPed := TGet():New(Dim(030), Dim(445), {|u| If(PCount() > 0, nTotPed := u, nTotPed)}, oPanelUp2, Dim(070), Dim(010), PesqPict("SC7","C7_TOTAL"), /*bValid*/, CLR_BLACK, CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F., "", "nTotPed",,,,.T.,.F.,, "Vl. Total", 1)
		oTotPed:bWhen   := {|| .F.}
    	oTotPed:bValid  := {|| ValidField('TOTPED', nTotPed)}

		oFWLayer:AddLine( 'DETAIL', 40, .F. )
		oFWLayer:AddCollumn( 'ALL', 100, .T., 'DETAIL' )
		oPanelDt := oFWLayer:GetColPanel( 'ALL', 'DETAIL' )

		oGridReq := IdaGrid():Create( 012, 010, 273, 443, GD_UPDATE, 'AllwaysTrue()', 'AllwaysTrue()', '',, 0, 99, 'AllwaysTrue()', '', 'AllwaysTrue()', oPanelDt, HeaderCons(), {}, 1, 1)
		oGridReq:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		oGridReq:SetRel('BFMA46HS', 'Relat�rio de ' + cTit46HS, 'Relat�rio de ' + cTit46HS, .T.)
		oGridReq:hlHabReord := .F.
		oGridReq:hVldMarc := {|| Iif(oGridReq:GetColuna('QTDREQ') > 0, .T., (MsgInfo('Informe a quantidade � Requisitar', 'Aten��o'), .F.))}
		oGridReq:hDepMarc := {|| Iif(.not. oGridReq:Marcado() .and. oGridReq:GetColuna('QTDREQ') > 0, oGridReq:SetColuna('QTDREQ', 0), Nil)}
		oGridReq:Limpar()

		oFWLayer:AddLine( 'DOWN', 15, .F. )
		oFWLayer:AddCollumn( 'ALL' ,  100, .T., 'DOWN' )
		oPanelDown := oFWLayer:GetColPanel( 'ALL', 'DOWN' )

		oChkIns          := TCheckBox():New(Dim(005), Dim(015), 'Listar somente Insumos com (Falta Atual) maior que Zero ( 0 )', {|u| If(PCount() > 0, lChkIns := u, lChkIns)}, oPanelDown, Dim(180), Dim(10),,,,,,,, .T., "",,)
		oChkIns:bWhen    := {|| .not. Empty(cTpRequis)}
		//oChkIns:bValid   := {|| SysRefresh(), .T.}
		oChkIns:bChange  := {|x| FwMsgRun(, {|lEnd| Consulta(cNum46HS, .T.)}, 'Obtendo Insumos...', 'Consulta Insumos da OS')}
		
		aAdd(aButtons, {"BMPINCLUIR", {|| FwMsgRun(, {|lEnd| Consulta(cNum46HS)}, 'Obtendo Insumos...', 'Consulta Insumos da OS' )}, "Atualizar dados da Grid de Insumos", "Atualizar Dados da Grid" })

		oDlgGSP:lCentered := .T.
		oDlgGSP:lEscClose := .T.
		oDlgGSP:Activate(,,,.T.,,, {|| (EnchoiceBar(oDlgGSP, {|| nOpcA := 1, Iif( VldGravacao(), FwMsgRun(, {|| Iif(GravaDados(nOpcA), nOpcA := 1, nOpcA := 0)}, cDscTpReq, "Gerando " + cDscTpReq + "..."), nOpcA := 0) , Iif( nOpcA == 0, .F., oDlgGSP:End())}, {|| Iif(VldCancela(), (nOpcA := 0, oDlgGSP:End()), Nil) },,aButtons)), FwMsgRun(, {|lEnd| Consulta(cNum46HS, .T.)}, 'Obtendo Insumos...', 'Consulta Insumos da OS') })	

	Else
		MsgInfo('Posicione em uma Ordem de Servi�o!', 'Aten��o')
	EndIf

    RestArea(aOldArea)

Return


/*/{Protheus.doc} ValidField
@description Valida Campos do Cabe�alho
@type function
@version 12.1.2210
@author Helitom Silva
@since 12/19/2023
@param p_cField, Caracter, Campo a ser validado
@param p_cValue, Caracter, Valor do campo a ser validado
@return lRet, Logico, Se o valor do campo for v�lido, retorna .T.
/*/
Static Function ValidField(p_cField, p_cValue)

	Local __stt      := u___stt(procname(0), "BFMA46HS")
	Local lRet 	     := .T.
	Local lVldVig 	 := .F.

	Private aRotina  := {}

	If .not. IsInCallStack('CONSULTA')

		If p_cField = 'TIPOREQ'

			If Empty(cTpRequis)
			
				Help(,, 'Tipo de Requisi��o',, "� obrigat�rio informar o Tipo de Requisi��o!",1,0,,,,,,{'Selecione um Tipo de Requisi��o!'})
				lRet := .F.	
			
			ElseIf cTpRequis == 'PC'

				// Analisa se o usu�rio tem permiss�o para Incluir Pedido de Compras
				lRet := U_BFGN01HS('MATA121', 3, __cUserId, .T.)

			ElseIf cTpRequis == 'SP'

				// Analisa se o usu�rio tem permiss�o para Incluir Solicita��o de Produtos
				lRet := U_BFGN01HS('BFCO01FP', 3, __cUserId, .T.)

			ElseIf cTpRequis == 'SC'

				// Analisa se o usu�rio tem permiss�o para Incluir Solicita��o de Compras
				lRet := U_BFGN01HS('MATA110', 3, __cUserId, .T.)

			ElseIf cTpRequis == 'MC'

				// Analisa se o usu�rio tem permiss�o para Incluir Medi��o de Contratos
				lRet := U_BFGN01HS('CNTA121', 3, __cUserId, .T.)

			EndIf

			If cTpRequis == 'PC'
				
				oPerDsc:Enable()
				oVlrDsc:Enable()
				oPerIPI:Enable()
				oVlrIPI:Enable()

			Else

				oPerDsc:Disable()
				oVlrDsc:Disable()
				oPerIPI:Disable()
				oVlrIPI:Disable()

			EndIf

			If lRet 

				cContrato := CriaVar('CND_CONTRA', .F.)
				oContrato:Refresh()

				cRevisa := CriaVar('CND_REVISA', .F.)
				oRevisao:Refresh()

				cCodForn := CriaVar('A2_COD', .F.)
				oCodForn:Refresh()

				cLojForn := CriaVar('A2_LOJA', .F.)
				oLojForn:Refresh()

				cNomForn := CriaVar('A2_NOME', .F.)
				oNomForn:Refresh()

				cSafra := CriaVar('AKF_CODIGO', .F.)
				oSafra:Refresh()

				cCondPag := CriaVar('E4_CODIGO', .F.)
				oCondPag:Refresh()

				cDCondPag := CriaVar('E4_DESCRI', .F.)
				oDCondPag:Refresh()

				nTxMoeda := 0
				oTxMoeda:Refresh()

			EndIf

		ElseIf p_cField = 'CONTRATO'

			lVldVig	:= SuperGetMV("MV_CNFVIGE", .F., "N") == "N" //S=permite incluir fora da vig�ncia,N=n�o permite.

			If !Empty(cContrato)
				
				If Select('CN9') > 0
					cFilCtr := CN9->CN9_FILCTR
				Endif

				//CN9->(dbSetOrder(1))
				//If CN9->(dbSeek(xFilial("CN9", cFilCTR) + cContrato))
				
				If !(CNTVldCTR(cContrato, @cFilCtr) .And. CN240VldUsr(cContrato,DEF_TRAINC, .T.,, cFilCtr))
					lRet := .F.
				EndIf

				If lRet .and. ( lRet := CN9->(dbSeek(xFilial("CN9",cFilCTR)+cContrato)) )		
					CN9->(DbSetOrder(7)) // CN9_FILIAL + CN9_NUMERO + CN9_SITUAC
					If CN9->(DbSeek(xFilial("CN9",cFilCtr) + cContrato + DEF_SVIGE))//-- busca revis�o vigente
						If !Empty(CN9->CN9_REVATU)
							lRet := .F.				
							Help("",1,"CNTA120_REV","","Contrato n�o est� vigente, verifique!",1,0) //- Valida se o contrato esta em vigencia
						Else
							cRevisa := CN9->CN9_REVISA
						EndIf
					Else
						lRet := .F.
						Help( " ", 1, "CNTA120_02" ) //"Apenas contratos em vig�ncia podem ser medidos"
					Endif

					If lVldVig .and. (CN9->CN9_DTINIC > dDataBase .Or. CN9->CN9_DTFIM < dDataBase)
						lRet := .F.
						Help( " ", 1, "CNTA120_07" ) //Contrato fora do periodo de vigencia
					EndIf
					CN9->(dbSetOrder(1))
				EndIf
			
				lRet := Iif(lRet, CN240VldUsr(cContrato, DEF_TRAINC_MED, .T.,, cFilCtr), lRet)

				If lRet
					oRevisao:Refresh()
				EndIf

				/*Else

					Help(,, 'Codigo do Contrato',, "� obrigat�rio informar o Codigo do Contrato, quando o tipo de Requisi��o � Medi��o de Contrato!",1,0,,,,,,{'Informe o codigo do Contrato!'})
					lRet := .F.

				EndIf*/


			Else
				Help(,, 'Codigo do Contrato',, "� obrigat�rio informar o Codigo do Contrato, quando o tipo de Requisi��o � Medi��o de Contrato!",1,0,,,,,,{'Informe o codigo do Contrato!'})
				lRet := .F.
			EndIf

			/*If lRet
				FwMsgRun(, {|lEnd| Consulta(cNum46HS)}, 'Obtendo Insumos...', 'Consulta Insumos da OS' )
			EndIf*/

		ElseIf p_cField = 'CODFORN'

			If Empty(cCodForn) 
			
				If cTpRequis == 'PC'
			
					Help(,, 'Codigo do Fornecedor',, "� obrigat�rio informar o Codigo do Fornecedor, quando o tipo de Requisi��o � Pedido de Compra!",1,0,,,,,,{'Informe o codigo do Fornecedor!'})
					lRet := .F.
			
				ElseIf cTpRequis == 'MC'

					Help(,, 'Codigo do Fornecedor',, "� obrigat�rio informar o Codigo do Fornecedor, quando o tipo de Requisi��o � Medi��o de Contrato!",1,0,,,,,,{'Informe o codigo do Fornecedor!'})
					lRet := .F.
			
				EndIf

			ElseIf !Empty(cCodForn) .and. !ExistCPO('SA2', cCodForn, 1)
			
				lRet := .F.
			
			ElseIf !Empty(cCodForn) .and. !Empty(cLojForn) .and. !Empty(cTpRequis)

				If cTpRequis == 'PC'
					cCondPag := Posicione('SA2', 1, FWxFilial('SA2') + cCodForn + cLojForn, 'A2_COND')
					oCondPag:Refresh()
					cDCondPag := AllTrim(Posicione('SE4', 1, FWxFilial('SE4') + cCondPag, 'E4_DESCRI'))
					oDCondPag:Refresh()					
				EndIf

			EndIf

		ElseIf p_cField = 'LOJFORN'

			If Empty(cLojForn) 
				
				If cTpRequis == 'PC'
			
					Help(,, 'Loja do Fornecedor',, "� obrigat�rio informar a Loja do Fornecedor, quando o tipo de Requisi��o � Pedido de Compra!",1,0,,,,,,{'Informe a Loja do Fornecedor!'})
					lRet := .F.
					
				ElseIf cTpRequis == 'MC'

					Help(,, 'Loja do Fornecedor',, "� obrigat�rio informar a Loja do Fornecedor, quando o tipo de Requisi��o � Medi��o de Contrato!",1,0,,,,,,{'Informe a Loja do Fornecedor!'})
					lRet := .F.
			
				EndIf

			ElseIf !Empty(cCodForn) .and. !Empty(cLojForn) .and. !ExistCPO('SA2', cCodForn + cLojForn, 1)
				
				lRet := .F.

			ElseIf !Empty(cCodForn) .and. !Empty(cLojForn) .and. !Empty(cTpRequis)
				
				If cTpRequis == 'PC'

					cCondPag := Posicione('SA2', 1, FWxFilial('SA2') + cCodForn + cLojForn, 'A2_COND')
					oCondPag:Refresh()

					cDCondPag := AllTrim(Posicione('SE4', 1, FWxFilial('SE4') + cCondPag, 'E4_DESCRI'))
					oDCondPag:Refresh()		

				EndIf

			EndIf

		ElseIf p_cField == 'CODAGLOM'

			lRet := (Ctb105Clvl() .and. MTPVLSOLEC())

		ElseIf p_cField == 'SAFRA'

			If Empty(cSafra)
				Help(,, 'Safra',, "� obrigat�rio informar a Safra!",1,0,,,,,,{'Verifique!'})
				lRet := .F.	
			Else
				lRet := ExistCPO('AKF', cSafra, 1)
			EndIf

		ElseIf p_cField == 'CONDPAG'

			If !Empty(cCondPag)
				
				If !ExistCPO('SE4', cCondPag)
					lRet := .F.
				Else
					cDCondPag := AllTrim(Posicione('SE4', 1, FWxFilial('SE4') + cCondPag, 'E4_DESCRI'))
					oDCondPag:Refresh()
				EndIf
			
			EndIf

		ElseIf p_cField == 'MOEDA'

			If !Empty(nMoeda)
				
				If nMoeda > MoedFin()
					lRet := .F.
				Else

					cDMoeda := SuperGetMv("MV_MOEDA" + AllTrim(Str(nMoeda, 2)))
					oDMoeda:Refresh()

					nTxMoeda := RecMoeda(dDataBase, nMoeda)
					oTxMoeda:Refresh()

				EndIf
			
			EndIf

		ElseIf p_cField == 'TXMOEDA'

			If !Positivo()
				lRet := .F.
			EndIf

		ElseIf p_cField == 'PERIPI'

			If !Positivo()
				lRet := .F.
			Else
				AtuaTotais('PERIPI')
			EndIf

		ElseIf p_cField == 'VLRIPI'

			If !Positivo()
				lRet := .F.
			Else
				AtuaTotais('VLRIPI')
			EndIf

		ElseIf p_cField == 'PERDSC'

			If !Positivo()
				lRet := .F.
			Else
				AtuaTotais('PERDSC')
			EndIf

		ElseIf p_cField == 'VLRDSC'

			If !Positivo()
				lRet := .F.
			Else
				AtuaTotais('VLRDSC')
			EndIf

		EndIf

	EndIf

Return lRet


/*/{Protheus.doc} HeaderCons
@description Monta aHeader da Grid de Consulta

@author	 Helitom Silva
@since	 03/08/2019
@version 12.1.2210

@param p_lDefault, Logico, Define se ira criar somente os campos Default

/*/
Static Function HeaderCons(p_lDefault)

	Local __stt   := u___stt(procname(0), "BFMA46HS")
	Local aRet    := {}

	Default p_lDefault := .T.

	aAdd(aRet, {"Cod.Insumo", "CODINSU", GetSX3Cache("TL_CODIGO", 'X3_PICTURE'), TamSX3('TL_CODIGO')[1], TamSX3('TL_CODIGO')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_CODIGO", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"Insumo", "DESINSU", GetSX3Cache("B1_DESC", 'X3_PICTURE'), TamSX3('B1_DESC')[1], TamSX3('B1_DESC')[2], "AllWaysTrue()", "�", GetSX3Cache("B1_DESC", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"(+) Qtd. Prev.", "QTDPRE", GetSX3Cache("TL_QUANTID", 'X3_PICTURE'), TamSX3('TL_QUANTID')[1], TamSX3('TL_QUANTID')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_QUANTID", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"(-) Qtd. Real.", "QTDREA", GetSX3Cache("TL_QUANTID", 'X3_PICTURE'), TamSX3('TL_QUANTID')[1], TamSX3('TL_QUANTID')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_QUANTID", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"(-) Qtd. SC", "QTDSC", GetSX3Cache("TL_QUANTID", 'X3_PICTURE'), TamSX3('TL_QUANTID')[1], TamSX3('TL_QUANTID')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_QUANTID", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"(-) Qtd. SP", "QTDSP", GetSX3Cache("TL_QUANTID", 'X3_PICTURE'), TamSX3('TL_QUANTID')[1], TamSX3('TL_QUANTID')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_QUANTID", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"(-) Qtd. PC", "QTDPC", GetSX3Cache("TL_QUANTID", 'X3_PICTURE'), TamSX3('TL_QUANTID')[1], TamSX3('TL_QUANTID')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_QUANTID", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"(-) Qtd. MC", "QTDMC", GetSX3Cache("TL_QUANTID", 'X3_PICTURE'), TamSX3('TL_QUANTID')[1], TamSX3('TL_QUANTID')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_QUANTID", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"(=) Falta Atual", "FALTAATUAL", GetSX3Cache("TL_QUANTID", 'X3_PICTURE'), TamSX3('TL_QUANTID')[1], TamSX3('TL_QUANTID')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_QUANTID", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"(-) Qtd. � Req.", "QTDREQ", GetSX3Cache("TL_QUANTID", 'X3_PICTURE'), TamSX3('TL_QUANTID')[1], TamSX3('TL_QUANTID')[2], "U_MA46HSVF('QTDREQ', M->QTDREQ)", "�", GetSX3Cache("TL_QUANTID", 'X3_TIPO'), "", "R",,,,"A"})
	aAdd(aRet, {"(=) Falta Prev.", "FALTAPREV", GetSX3Cache("TL_QUANTID", 'X3_PICTURE'), TamSX3('TL_QUANTID')[1], TamSX3('TL_QUANTID')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_QUANTID", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"Vl. Unit.", "VLUNIT", GetSX3Cache("C7_PRECO", 'X3_PICTURE'), TamSX3('C7_PRECO')[1], TamSX3('C7_PRECO')[2], "U_MA46HSVF('VLUNIT', M->VLUNIT)", "�", GetSX3Cache("C7_PRECO", 'X3_TIPO'), "", "R",,,"cTpRequis $ 'PC/MC' .and. oGridReq:GetQtdLinha() > 0 .and. oGridReq:Marcado()","R"})
	aAdd(aRet, {"Total", "TOTAL", GetSX3Cache("C7_TOTAL", 'X3_PICTURE'), TamSX3('C7_TOTAL')[1], TamSX3('C7_TOTAL')[2], "AllWaysTrue()", "�", GetSX3Cache("C7_TOTAL", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"Tp. Oper.", "TPOPER", GetSX3Cache("ZFA_OPER", 'X3_PICTURE'), TamSX3('ZFA_OPER')[1], TamSX3('ZFA_OPER')[2], "U_MA46HSVF('TPOPER', M->TPOPER)", "�", GetSX3Cache("ZFA_OPER", 'X3_TIPO'), "SFMCUS", "R",,,"oGridReq:GetQtdLinha() > 0 .and. oGridReq:Marcado()","A"})
	aAdd(aRet, {"Armazem", "LOCAL", GetSX3Cache("ZFA_LOCAL", 'X3_PICTURE'), TamSX3('ZFA_LOCAL')[1], TamSX3('ZFA_LOCAL')[2], "U_MA46HSVF('LOCAL', M->LOCAL)", "�", GetSX3Cache("ZFA_LOCAL", 'X3_TIPO'), "NNR2", "R",,,"oGridReq:GetQtdLinha() > 0 .and. oGridReq:Marcado()","A"})
	aAdd(aRet, {"Grp. Aprovador", "GRPAPRO", GetSX3Cache("ZFA_XGRAPR", 'X3_PICTURE'), TamSX3('ZFA_XGRAPR')[1], TamSX3('ZFA_XGRAPR')[2], "U_MA46HSVF('GRPAPRO', M->GRPAPRO)", "�", GetSX3Cache("ZFA_XGRAPR", 'X3_TIPO'), "ZBJSP", "R",,,"oGridReq:GetQtdLinha() > 0 .and. oGridReq:Marcado() .and. cTpRequis <> 'MC'","A"})
	aAdd(aRet, {"Observa��o", "OBSREQ", GetSX3Cache("ZFA_OBS", 'X3_PICTURE'), TamSX3('ZFA_OBS')[1], TamSX3('ZFA_OBS')[2], "AllWaysTrue()", "�", GetSX3Cache("ZFA_OBS", 'X3_TIPO'), "", "R",,,"oGridReq:GetQtdLinha() > 0 .and. oGridReq:Marcado()","A"})
	aAdd(aRet, {"Etapa", "ETAPA", GetSX3Cache("TL_ETAPA", 'X3_PICTURE'), TamSX3('TL_ETAPA')[1], TamSX3('TL_ETAPA')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_ETAPA", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"Desc.Etapa", "DESETAP", GetSX3Cache("TPA_DESCRI", 'X3_PICTURE'), TamSX3('TT9_DESCRI')[1], TamSX3('TPA_DESCRI')[2], "AllWaysTrue()", "�", GetSX3Cache("TPA_DESCRI", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"Tarefa", "TAREFA", GetSX3Cache("TL_TAREFA", 'X3_PICTURE'), TamSX3('TL_TAREFA')[1], TamSX3('TL_TAREFA')[2], "AllWaysTrue()", "�", GetSX3Cache("TL_TAREFA", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"Desc.Tarefa", "DESTARE", GetSX3Cache("TT9_DESCRI", 'X3_PICTURE'), TamSX3('TT9_DESCRI')[1], TamSX3('TT9_DESCRI')[2], "AllWaysTrue()", "�", GetSX3Cache("TT9_DESCRI", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"Cod.Bem", "CODBEM", GetSX3Cache("TJ_CODBEM", 'X3_PICTURE'), TamSX3('TJ_CODBEM')[1], TamSX3('TJ_CODBEM')[2], "AllWaysTrue()", "�", GetSX3Cache("TJ_CODBEM", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"C.Custo", "CCUSTO", GetSX3Cache("TJ_CCUSTO", 'X3_PICTURE'), TamSX3('TJ_CCUSTO')[1], TamSX3('TJ_CCUSTO')[2], "AllWaysTrue()", "�", GetSX3Cache("TJ_CCUSTO", 'X3_TIPO'), "", "R",,,,"V"})
	aAdd(aRet, {"Equivalente", "CODEQUI", GetSX3Cache("ZFA_CODPFA", 'X3_PICTURE'), TamSX3('ZFA_CODPFA')[1], TamSX3('ZFA_CODPFA')[2], "U_MA46HSVF('CODEQUI', M->CODEQUI)", "�", GetSX3Cache("ZFA_CODPFA", 'X3_TIPO'), "ZZYSP", "R",,,"oGridReq:GetQtdLinha() > 0 .and. oGridReq:Marcado()","A"})

Return aRet


/*/{Protheus.doc} MA46HSVF
@description Valida Campo da Grid
@type  Static Function
@author Helitom Silva
@since 18/10/2023
@version 12.1.2210

@param p_cField, Caracter, Campo a ser validado
@param p_uValue, Indefinido, Valor a ser validado
@return lRet, Logico, Se o valor for v�lido retorna .T.

/*/
User Function MA46HSVF(p_cField, p_uValue)
	
	Local __stt      := u___stt(procname(0), "BFMA46HS")
	Local lRet       := .T.
	Local cClvl      := ''
	Local cCodEqui   := ''
	Local cOpSai     := ''
    Local cMVYAPLDIR := U_YGETNPAR("MV_YAPLDIR", "")
    Local cMVYOPVSAI := U_YGETNPAR("MV_YOPVSAI", "")
	Local nX		 := 0

	If p_cField == 'QTDREQ'

		If p_uValue > GDFieldGet('FALTAATUAL')
		
			Help( ,, 'Qtd. � Requisitar',, 'A quantidade requisitada deve ser menor ou igual a Falta Atual(' + cValToChar(GDFieldGet('FALTAATUAL')) + ')!', 1, 0,,,,,,{'Informe um valor maior que 0 e menor que a Falta Atual.'})
			lRet := .F.
		
		ElseIf p_uValue < 0 

			Help( ,, 'Qtd. � Requisitar',, 'A quantidade requisitada n�o pode ser negativo!', 1, 0,,,,,,{'Informe um valor maior que 0 e menor que a Falta Atual.'})
			lRet := .F.

		EndIf
		
		If lRet

			GDFieldPut('FALTAPREV', GDFieldGet('FALTAATUAL') - p_uValue)

			If p_uValue > 0

				oGridReq:MarcLin(,.T.)

				cCodEqui := ExecBlock("BFES023D", .F., .F., {GDFieldGet('CODINSU'), "ZFA_CODPFA"})
				GDFieldPut('CODEQUI', cCodEqui)
				
				If cTpRequis <> 'MC'
					GDFieldPut('GRPAPRO', Posicione("SAI", 2, FWxFilial("SAI") + __cUserId, "AI_XGRAPRO"))
				EndIf

				DbSelectArea('STJ')
				STJ->(DbSetOrder(1))
				If STJ->(DbSeek(FWxFilial('STJ') + cNum46HS))
					GDFieldPut('OBSREQ', PadR('PLACA: ' + AllTrim(STJ->TJ_YPLACA) + ' - COD. BEM: ' + AllTrim(STJ->TJ_CODBEM ) + '.', TamSX3('ZFA_OBS')[1]) )
				EndIf

				GDFieldPut('TOTAL', (p_uValue * GDFieldGet('VLUNIT')))

				If cTpRequis == 'PC'
					AtuaTotais()
				EndIf
				
			Else

				oGridReq:MarcLin(,.F.)

				GDFieldPut('VLUNIT', CriaVar('C7_PRECO', .F.))
				GDFieldPut('TOTAL', CriaVar('C7_TOTAL', .F.))
				GDFieldPut('TPOPER', CriaVar('ZFA_OPER', .F.))
				GDFieldPut('LOCAL', CriaVar('ZFA_LOCAL', .F.))
				GDFieldPut('GRPAPRO', CriaVar('ZFA_XGRAPR', .F.))
				GDFieldPut('CODEQUI', CriaVar('ZFA_CODPFA', .F.))
				GDFieldPut('OBSREQ', CriaVar('ZFA_OBS', .F.))

			EndIf

		EndIf

	ElseIf p_cField == 'VLUNIT'

		GDFieldPut('TOTAL', (GDFieldGet('QTDREQ') * p_uValue))

		If cTpRequis == 'PC'
			AtuaTotais()
		EndIf

	ElseIf p_cField == 'TPOPER'

		lRet := ExistCpo("SX5", "DJ" + p_uValue)

		If lRet

			If .not. AllTrim(p_uValue) $ cMVYAPLDIR

				Help( ,, 'Tipo de opera��o',, 'Para requisitar insumos obrigat�rio o Tipo de Opera��o de Aplica��o Direta.', 1, 0,,,,,,{'Corrija o Tipo de opera��o!'})

				lRet := .F.

			ElseIf AllTrim(p_uValue) $ cMVYOPVSAI

				cOpSai := Posicione("SAI", 2, FWxFilial("SAI") + __cUserId, "AI_YOPMVEI")

				If .not. (cOpSai == 'S')

					Help( ,, 'Tipo de opera��o',, 'Para essa opera��o � necess�rio que o solicitante tenha permiss�o para realizar Operacao Manut. Veicular no Cadastro de Solicitantes!', 1, 0,,,,,, {'Procure o respons�vel pelo departamento de Patrim�nio/Almoxarifado.'})

					lRet := .F.

				EndIf
			
			EndIf

			lRet := Iif(lRet, U_BFFUNFIS("_OPER", {GDFieldGet("CODINSU"), p_uValue}), lRet)

		EndIf

	ElseIf p_cField == 'LOCAL'

		lRet := U_BFCO018D(,, p_uValue, GDFieldGet("CODINSU"))

		IF lRet

			cClvl := Posicione("NNR", 1, xFilial("NNR") + p_uValue, "NNR_YAGLOM")

			IF cClvl <> cCodCLVL
				
				Help( ,, 'Aglomerado',, 'O Aglomerado deste Armaz�m � diferente do informado no Cabe�alho!', 1, 0)
				
				lRet := .F.

			EndIf

		EndIf

	ElseIf p_cField == 'GRPAPRO'

		lRet := ExistCPO("ZBJ", p_uValue + cCodCLVL, 1)

	ElseIf p_cField == 'CODEQUI'

		lRet := ExistCpo("ZZY", GDFieldGet('CODINSU') + p_uValue, 1)

	EndIf

Return lRet


/*/{Protheus.doc} Consulta
@description Consulta dados

@author	 Helitom Silva
@since	 03/08/2019
@version 12.1.2210

/*/
Static Function Consulta(p_cNumOS, p_lDefault)

	Local __stt   	 := u___stt(procname(0), "BFMA46HS")
	Local lRet		 := .T.
	Local cAliasREL  := GetNextAlias()
	Local cChave 	 := ''
	Local cSQLForn 	 := ''
	Local nQtdRea 	 := 0
	Local nQtdSC  	 := 0
	Local nQtdSP  	 := 0
	Local nQtdPC  	 := 0
	Local nQtdMC  	 := 0
	Local nFaltaAtu	 := 0
	Local nCol		 := 0
	Local cJoinPre   := ''

	Default p_cNumOs   := ''
	Default p_lDefault := .F.

	Iif(Select(cAliasREL) > 0, (cAliasREL)->(DbCloseArea()), Nil )
	
	//If Empty(cTpRequis) .or. .not. cTpRequis == "PC"
		cSQLForn := " 0 = 0 "
		cJoinPre := " LEFT "
	//ElseIf cTpRequis == "PC"
	//	cSQLForn := " STL.TL_FORNEC = '" + cCodForn + "' AND STL.TL_LOJA = '" + cLojForn + "' "
	//	cJoinPre := " INNER "
	//EndIf

	cSQLForn := "%" + cSQLForn + "%"
	cJoinPre := "%" + cJoinPre + "%"

	// STL->TL_TIPOREG // F=Ferramenta; M=M�o de Obra; P=Produto; T=Terceiro; E=Especialidade

	BeginSql Alias cAliasREL

        SELECT STL.TL_ORDEM   AS ORDEM,
               STL.TL_CODIGO  AS CODINSU,
               SB1.B1_DESC    AS DESINSU,
               STL.TL_TAREFA  AS TAREFA,
               TT9.TT9_DESCRI AS DESTARE,
               STL.TL_ETAPA   AS ETAPA,
               TPA.TPA_DESCRI AS DESETAP,
               STJ.TJ_CODBEM  AS CODBEM,
               STJ.TJ_CCUSTO  AS CCUSTO,
			   STJ.TJ_YPLACA  AS PLACA,
			   SUM(STL.TL_QUANTID) AS QTDINS
          FROM %TABLE:STJ% STJ
        %EXP:cJoinPre% JOIN %TABLE:STL% STL ON STL.TL_ORDEM   = STJ.TJ_ORDEM AND
											   STL.TL_PLANO   = STJ.TJ_PLANO AND
											   STL.TL_TIPOREG = 'P' AND
											   STL.TL_SEQRELA = '0' AND
											   STL.TL_FILIAL  = STJ.TJ_FILIAL AND
											   %EXP:cSQLForn% AND
											   STL.%NOTDEL%
        LEFT JOIN %TABLE:SB1% SB1 ON SB1.B1_COD    = STL.TL_CODIGO AND
                                     SB1.B1_FILIAL = %XFILIAL:SB1% AND
                                     SB1.%NOTDEL%
		LEFT JOIN %TABLE:TT9% TT9 ON TT9.TT9_TAREFA = STL.TL_TAREFA AND
								     TT9.TT9_FILIAL = %XFILIAL:TT9% AND
								     TT9.%NOTDEL%
		LEFT JOIN %TABLE:TPA% TPA ON TPA.TPA_ETAPA  = STL.TL_ETAPA AND
								     TPA.TPA_FILIAL = %XFILIAL:TPA% AND
								     TPA.%NOTDEL%
        WHERE STJ.TJ_ORDEM   = %EXP:p_cNumOs% AND
			  STJ.TJ_TERMINO = 'N' AND
      	  	  STJ.TJ_SITUACA = 'L' AND		
          	  STJ.TJ_FILIAL  = %XFILIAL:STJ% AND
          	  STJ.%NOTDEL%
        GROUP BY STL.TL_ORDEM,
                 STL.TL_CODIGO, 
                 SB1.B1_DESC,
                 STL.TL_TAREFA,
                 TT9.TT9_DESCRI,
                 STL.TL_ETAPA,
                 TPA.TPA_DESCRI,
                 STJ.TJ_CODBEM,
                 STJ.TJ_CCUSTO,
				 STJ.TJ_YPLACA

	EndSql
	
	IdaGrvSQL('CONSULTA_GERAR_SOLICITACAO_INSUMOS', GetLastQuery()[2])

	oGridReq:Limpar()

	If .not. (cAliasREL)->(EoF())

		(cAliasREL)->(DbGoTop())
		While .not. (cAliasREL)->(EoF())

			nQtdRea   := GetRealizado((cAliasREL)->ORDEM, (cAliasREL)->CODINSU, (cAliasREL)->TAREFA, (cAliasREL)->ETAPA)
			nQtdSC    := GetSolCompra((cAliasREL)->ORDEM, (cAliasREL)->CODINSU, (cAliasREL)->TAREFA, (cAliasREL)->ETAPA)
			nQtdSP    := GetSolProdut((cAliasREL)->ORDEM, (cAliasREL)->CODINSU, (cAliasREL)->TAREFA, (cAliasREL)->ETAPA)
			nQtdPC    := GetPedCompra((cAliasREL)->ORDEM, (cAliasREL)->CODINSU, (cAliasREL)->TAREFA, (cAliasREL)->ETAPA)
			nQtdMC    := GetMedContrato(cContrato, cFilCtr, (cAliasREL)->ORDEM, (cAliasREL)->CODINSU, (cAliasREL)->TAREFA, (cAliasREL)->ETAPA)
			nFaltaAtu := (cAliasREL)->QTDINS - (nQtdRea + nQtdSC + nQtdSP + nQtdPC + nQtdMC)

			If lChkIns .and. nFaltaAtu <= 0
				(cAliasREL)->(DbSkip())
				Loop
			EndIf

			oGridReq:AddLinha()

			oGridReq:SetColuna('CODINSU', (cAliasREL)->CODINSU )
			oGridReq:SetColuna('DESINSU', (cAliasREL)->DESINSU )
			oGridReq:SetColuna('TAREFA', (cAliasREL)->TAREFA )
			oGridReq:SetColuna('DESTARE', (cAliasREL)->DESTARE )
			oGridReq:SetColuna('ETAPA', (cAliasREL)->ETAPA )
			oGridReq:SetColuna('DESETAP', (cAliasREL)->DESETAP )
			oGridReq:SetColuna('QTDPRE', (cAliasREL)->QTDINS )
			oGridReq:SetColuna('QTDREA', nQtdRea )
			oGridReq:SetColuna('QTDSC', nQtdSC )
			oGridReq:SetColuna('QTDSP', nQtdSP )
			oGridReq:SetColuna('QTDPC', nQtdPC )
			oGridReq:SetColuna('QTDMC', nQtdMC )
			oGridReq:SetColuna('FALTAATUAL', nFaltaAtu )
			oGridReq:SetColuna('QTDREQ', 0 )
			oGridReq:SetColuna('FALTAPREV', oGridReq:GetColuna('FALTAATUAL') - oGridReq:GetColuna('QTDREQ') )
			oGridReq:SetColuna('CODBEM', (cAliasREL)->CODBEM )
			oGridReq:SetColuna('CCUSTO', (cAliasREL)->CCUSTO )

			(cAliasREL)->(DbSkip())
		End

	Else
		MsgInfo('N�o encontrado dados para Solicita��o. A Ordem de Servi�o n�o possui Itens Previstros ou foi Finalizada', 'Verifique!')
	EndIf

	Iif(Select(cAliasREL) > 0, (cAliasREL)->(DbCloseArea()), Nil)

	oGridReq:GoTop()
	oGridReq:Refresh(.F.)

	If p_lDefault
		oTpRequis:SetFocus()
	EndIf

Return lRet


/*/{Protheus.doc} VldGravacao
@description Valida Grava��o dos Dados
@type function
@version 12.1.2210
@author Helitom Silva
@since 17/10/2023
@return lRet, Logica, Se os dados forem v�lidos retorna .T.
/*/
static Function VldGravacao()

	Local __stt  	:= u___stt(procname(0),"BFMA46HS")
	Local lRet   	:= .T.
	Local cMsgValid := ''
	Local nLinha    := .F.

	If Empty(cTpRequis)
		cMsgValid := 'Por favor, selecione o Tipo de Requisi��o!'
	ElseIf Empty(cSafra)
		cMsgValid := '� obrigat�rio informar a Safra!'
	ElseIf oGridReq:GetQtdLinha(.F., .T.) == 0 // Verifica se tem 1 ou mais itens marcados pra Gerar Requisi��o
		cMsgValid := 'Por favor, selecione os Insumos a serem Requisitados!'
	EndIf

	If cTpRequis == 'PC'

		If Empty(cCodForn)
			cMsgValid := '� obrigat�rio informar o Codigo do Fornecedor, quando o tipo de Requisi��o � Pedido de Compra!'
		EndIf

		If Empty(cLojForn)
			cMsgValid := '� obrigat�rio informar a Loja do Fornecedor, quando o tipo de Requisi��o � Pedido de Compra!'
		EndIf

	ElseIf cTpRequis == 'MC'

		If Empty(cContrato)
			cMsgValid := '� obrigat�rio informar o Contrato, quando o tipo de Requisi��o � Medi��o de Contrato!'
		EndIf

		If Empty(cCodForn)
			cMsgValid := '� obrigat�rio informar o Codigo do Fornecedor, quando o tipo de Requisi��o � Medi��o de Contrato!'
		EndIf

		If Empty(cLojForn)
			cMsgValid := '� obrigat�rio informar a Loja do Fornecedor, quando o tipo de Requisi��o � Medi��o de Contrato!'
		EndIf

	EndIf

	For nLinha := 1 to oGridReq:GetQtdLinha()

		oGridReq:PosLinha(nLinha, .T.)

		If oGridReq:GetColuna('QTDREQ') > 0
			
			If Empty(oGridReq:GetColuna('TPOPER'))
				cMsgValid := 'Informe o campo "' + oGridReq:GetHeadCol('TPOPER')[1] + '" do Insumo (' + AllTrim(oGridReq:GetColuna('CODINS')) + '-' + AllTrim(oGridReq:GetColuna('DESINSU')) + ')!'
				Exit
			ElseIf Empty(oGridReq:GetColuna('LOCAL'))
				cMsgValid := 'Informe o campo "' + oGridReq:GetHeadCol('LOCAL')[1] + '" do Insumo (' + AllTrim(oGridReq:GetColuna('CODINS')) + '-' + AllTrim(oGridReq:GetColuna('DESINSU')) + ')!'
				Exit
			ElseIf Empty(oGridReq:GetColuna('GRPAPRO')) .and. cTpRequis <> 'MC'
				cMsgValid := 'Informe o campo "' + oGridReq:GetHeadCol('GRPAPRO')[1] + '" do Insumo (' + AllTrim(oGridReq:GetColuna('CODINS')) + '-' + AllTrim(oGridReq:GetColuna('DESINSU')) + ')!'
				Exit
			ElseIf Empty(oGridReq:GetColuna('OBSREQ'))
				cMsgValid := 'Informe o campo "' + oGridReq:GetHeadCol('OBSREQ')[1] + '" do Insumo (' + AllTrim(oGridReq:GetColuna('CODINS')) + '-' + AllTrim(oGridReq:GetColuna('DESINSU')) + ')!'
				Exit
			ElseIf Empty(oGridReq:GetColuna('CODBEM'))
				cMsgValid := 'Informe o campo "' + oGridReq:GetHeadCol('CODBEM')[1] + '" do Insumo (' + AllTrim(oGridReq:GetColuna('CODINS')) + '-' + AllTrim(oGridReq:GetColuna('DESINSU')) + ')!'
				Exit
			ElseIf Empty(oGridReq:GetColuna('CCUSTO'))
				cMsgValid := 'Informe o campo "' + oGridReq:GetHeadCol('CCUSTO')[1] + '" do Insumo (' + AllTrim(oGridReq:GetColuna('CODINS')) + '-' + AllTrim(oGridReq:GetColuna('DESINSU')) + ')!'
				Exit
			EndIf

		EndIf

	Next

	If .not. Empty(cMsgValid)
		MsgAlert(cMsgValid, 'Aten��o')
		lRet := .F.
	EndIf

Return lRet


/*/{Protheus.doc} GravaDados
@description Grava��o dos Dados
@type function
@version 12.1.2210
@author Helitom Silva
@since 17/10/2023
@return lRet, Logica, Se os dados forem v�lidos retorna .T.
/*/
static Function GravaDados(p_nOpcao)

	Local __stt  	:= u___stt(procname(0),"BFMA46HS")
	Local lRet   	:= .T.

	If cTpRequis == 'SC'
		lRet := GerSolCompra()
	ElseIf cTpRequis == 'SP'
		lRet := GerSolProdut()
	ElseIf cTpRequis == 'PC'
		lRet := GerPedCompra()
	ElseIf cTpRequis == 'MC'
		lRet := GerMedContrato()
	EndIf

Return lRet


/*/{Protheus.doc} VldCancela
@description Cancelamento da EnchoiceBar

@type function
@version 12.1.27
@author Helitom Silva
@since 17/10/2023
@return lRet, Logico, Se puder Cancelar retorna .T.
/*/
Static Function VldCancela()

	Local __stt    := u___stt(procname(0),"BFMA46HS")
	Local lRet     := .T.

	If .not. lRet
		MsgInfo('N�o � poss�vel cancelar!', 'Aten��o')
		lRet := .F.
	EndIf

Return lRet


/*/{Protheus.doc} GetZZY
@description Fun��o para retornar cod equivalente n�o bloqueado
@type  Function
@author Helitom Silva
@since 20/12/2023
@version 12.1.2210
@param cCodigo, Caracter, codigo Produto
@return cRet, Caracter, Codigo Equivalente do produto
@obs Nil
/*/
Static Function GetZZY(cCodigo)

	Local __stt     := u___stt(procname(0), "BFMA46HS")
	Local cRet  	:= CriaVar("ZFA_CODPFA", .F.)
	Local cQuery    := ''
	Local nCount    := 0

	If Select("TZZY") > 0
		TZZY->(DbCloseArea())
	EndIf

	cQuery := " SELECT * " + CRLF
	cQuery += "   FROM " + RetSQLName("ZZY") + " ZZY " + CRLF
	cQuery += "  WHERE ZZY.D_E_L_E_T_ <> '*' "
	cQuery += "    AND ZZY.ZZY_COD = '" + cCodigo + "' " + CRLF
	cQuery += "    AND ZZY.ZZY_MSBLQL <> '1' "

	TcQuery cQuery New Alias "TZZY"

	While TZZY->(!EoF())

		nCount++
		
		cRet := TZZY->(ZZY_CODEQU)

		TZZY->(dbSkip())
	End

	TZZY->(DbCloseArea())

	If nCount > 1
		
		cRet := " "

		Help(,,'CodFab',,"Para este produto, existe mais de um codigo equivalente, favor verificar!",1,0,,,,,,{'Informe um codigo equivalente no campo: Equivalente'})

	EndIf

Return cRet


/*/{Protheus.doc} GetRealizado
@description Obtem quantidade Realizada na OS
@type  Static Function
@author Helitom Silva
@since 19/12/2023
@version 12.1.2210
@param p_cOrdem, Caracter, Codigo da Ordem de Servi�o
@param p_cCodProd, Caracter, Codigo do Produto da Ordem de Servi�o
@param p_cTarefa, Caracter, Codigo da Tarefa da Ordem de Servi�o
@param p_cEtapa, Caracter, Codigo da Etapa da Ordem de Servi�o
@return nRet, Numerico, Quantidade requisitada
@example
(examples)
@see (links_or_references)
/*/
Static Function GetRealizado(p_cOrdem, p_cCodProd, p_cTarefa, p_cEtapa)
	
	Local __stt     := u___stt(procname(0), "BFMA46HS")
	Local nRet 		:= 0
	Local cAliasTMP := GetNextAlias()
	Local cSQLForn  := ''
	
	//If Empty(cTpRequis) .or. .not. cTpRequis == "PC"
		cSQLForn := " 0 = 0 "
	//ElseIf cTpRequis == "PC"
	//	cSQLForn := " STL.TL_FORNEC = '" + cCodForn + "' AND STL.TL_LOJA = '" + cLojForn + "' "
	//EndIf

	cSQLForn := "%" + cSQLForn + "%"
	
	BeginSQL Alias cAliasTMP

		Column TL_QUANTID as Numeric(9, 2)

         SELECT SUM(STL.TL_QUANTID) AS TL_QUANTID
		  FROM %TABLE:STL% STL 
		 WHERE STL.TL_ORDEM   = %EXP:AllTrim(p_cOrdem)% AND
			   STL.TL_PLANO   = STL.TL_PLANO AND
			   STL.TL_CODIGO  = %EXP:p_cCodProd% AND
			   STL.TL_TAREFA  = %EXP:p_cTarefa% AND
			   STL.TL_ETAPA   = %EXP:p_cEtapa% AND
			   STL.TL_TIPOREG = 'P' AND
			   STL.TL_SEQRELA != '0' AND
			   STL.TL_FILIAL  = %XFILIAL:STL% AND
			   %EXP:cSQLForn% AND
			   STL.%NOTDEL%

	EndSQL

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())
	If .not. (cAliasTMP)->(EoF())
		nRet := (cAliasTMP)->TL_QUANTID
	EndIf

	(cAliasTMP)->(DbCloseArea())
	
Return nRet


/*/{Protheus.doc} GetSolCompra
@description Obtem quantidade requisitada via Solicita��o de Compra
@type  Static Function
@author Helitom Silva
@since 19/10/2023
@version 12.1.2210
@param p_cOrdem, Caracter, Codigo da Ordem de Servi�o
@param p_cCodProd, Caracter, Codigo do Produto da Ordem de Servi�o
@param p_cTarefa, Caracter, Codigo da Tarefa da Ordem de Servi�o
@param p_cEtapa, Caracter, Codigo da Etapa da Ordem de Servi�o
@return nRet, Numerico, Quantidade requisitada
@example
(examples)
@see (links_or_references)
/*/
Static Function GetSolCompra(p_cOrdem, p_cCodProd, p_cTarefa, p_cEtapa)
	
	Local __stt     := u___stt(procname(0), "BFMA46HS")
	Local nRet 		:= 0
	Local cAliasTMP := GetNextAlias()
	
	BeginSQL Alias cAliasTMP

		Column C1_QUANT as Numeric(18, 3)

		SELECT NVL(SUM(NVL(SC1.C1_QUANT, 0)) - SUM(NVL(SD1.D1_QUANT, 0)), 0) C1_QUANT
		  FROM %TABLE:SC1% SC1
		LEFT JOIN %TABLE:SC7% SC7 ON SC7.C7_NUMSC   = SC1.C1_NUM
								 AND SC7.C7_PRODUTO = SC1.C1_PRODUTO
								 AND SUBSTR(TRIM(SC7.C7_OP), 1, 6) = SUBSTR(TRIM(SC1.C1_OP), 1, 6)
								 AND SC7.C7_YTAREOS = SC1.C1_YTAREOS
								 AND SC7.C7_YETAPOS = SC1.C1_YETAPOS
								 AND TRIM(SC7.C7_NUMSC) IS NOT NULL
								 AND SC7.C7_FILIAL  = SC1.C1_FILIAL
								 AND SC7.%NOTDEL%
		LEFT JOIN %TABLE:SD1% SD1 ON SD1.D1_PEDIDO  = SC7.C7_NUM
								 AND SD1.D1_ITEMPC  = SC7.C7_ITEM
								 AND SD1.D1_COD     = SC7.C7_PRODUTO  
								 AND SD1.D1_FORNECE = SC7.C7_FORNECE
								 AND SD1.D1_FILIAL  = SC7.C7_FILIAL
								 AND SD1.%NOTDEL%
		 WHERE SUBSTR(SC1.C1_OP, 1, 6) = %EXP:AllTrim(p_cOrdem)%
		   AND SC1.C1_PRODUTO = %EXP:p_cCodProd%
		   AND SC1.C1_YTAREOS = %EXP:p_cTarefa%
		   AND SC1.C1_YETAPOS = %EXP:p_cEtapa%
		   AND SC1.C1_RESIDUO != 'S'
		   AND SC1.C1_FILIAL  = %XFILIAL:SC1%
		   AND SC1.%NOTDEL%

	EndSQL

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())
	If .not. (cAliasTMP)->(EoF())
		nRet := (cAliasTMP)->C1_QUANT
	EndIf

	(cAliasTMP)->(DbCloseArea())
	
Return nRet


/*/{Protheus.doc} GetSolProdut
@description Obtem quantidade requisitada via Solicita��o de Produto
@type  Static Function
@author Helitom Silva
@since 19/10/2023
@version 12.1.2210
@param p_cOrdem, Caracter, Codigo da Ordem de Servi�o
@param p_cCodProd, Caracter, Codigo do Produto da Ordem de Servi�o
@param p_cTarefa, Caracter, Codigo da Tarefa da Ordem de Servi�o
@param p_cEtapa, Caracter, Codigo da Etapa da Ordem de Servi�o
@return nRet, Numerico, Quantidade requisitada
@example
(examples)
@see (links_or_references)
/*/
Static Function GetSolProdut(p_cOrdem, p_cCodProd, p_cTarefa, p_cEtapa)
	
	Local __stt     := u___stt(procname(0), "BFMA46HS")
	Local nRet 		:= 0
	Local cAliasTMP := GetNextAlias()
	
	BeginSQL Alias cAliasTMP

		Column ZFA_QUANT as Numeric(15, 3)

		SELECT SUM(ZFA.ZFA_QUANT) AS ZFA_QUANT
		  FROM %TABLE:ZFA% ZFA
		 WHERE SUBSTR(ZFA.ZFA_OP, 1, 6) = %EXP:AllTrim(p_cOrdem)%
		   AND ZFA.ZFA_PRODUT = %EXP:p_cCodProd%
		   AND ZFA.ZFA_TAREOS = %EXP:p_cTarefa%
		   AND ZFA.ZFA_ETAPOS = %EXP:p_cEtapa%
		   AND ZFA.ZFA_STATUS NOT IN ('F', 'C')
		   AND ZFA.ZFA_FILIAL = %XFILIAL:ZFA%
		   AND ZFA.%NOTDEL%

	EndSQL

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())
	If .not. (cAliasTMP)->(EoF())
		nRet := (cAliasTMP)->ZFA_QUANT
	EndIf

	(cAliasTMP)->(DbCloseArea())
	
Return nRet


/*/{Protheus.doc} GetPedCompra
@description Obtem quantidade requisitada via Pedido de Compra
@type  Static Function
@author Helitom Silva
@since 19/10/2023
@version 12.1.2210
@param p_cOrdem, Caracter, Codigo da Ordem de Servi�o
@param p_cCodProd, Caracter, Codigo do Produto da Ordem de Servi�o
@param p_cTarefa, Caracter, Codigo da Tarefa da Ordem de Servi�o
@param p_cEtapa, Caracter, Codigo da Etapa da Ordem de Servi�o
@return nRet, Numerico, Quantidade requisitada
@example
(examples)
@see (links_or_references)
/*/
Static Function GetPedCompra(p_cOrdem, p_cCodProd, p_cTarefa, p_cEtapa)
	
	Local __stt     := u___stt(procname(0), "BFMA46HS")	
	Local nRet 		:= 0
	Local cAliasTMP := GetNextAlias()
	
	BeginSQL Alias cAliasTMP

		Column C7_QUANT as Numeric(15, 3)

		SELECT NVL((SUM(NVL(SC7.C7_QUANT, 0)) - SUM(NVL(SD1.D1_QUANT, 0))), 0) AS C7_QUANT  
		  FROM %TABLE:SC7% SC7
		LEFT JOIN %TABLE:SD1% SD1 ON SD1.D1_PEDIDO  = SC7.C7_NUM
							     AND SD1.D1_ITEMPC  = SC7.C7_ITEM
								 AND SD1.D1_FORNECE = SC7.C7_FORNECE
								 AND SD1.D1_COD     = SC7.C7_PRODUTO		  
								 AND SD1.D1_FILIAL  = SC7.C7_FILIAL
								 AND SD1.%NOTDEL%
		 WHERE SUBSTR(SC7.C7_OP, 1, 6) = %EXP:AllTrim(p_cOrdem)%
		   AND SC7.C7_PRODUTO = %EXP:p_cCodProd%
		   AND SC7.C7_YTAREOS = %EXP:p_cTarefa%
		   AND SC7.C7_YETAPOS = %EXP:p_cEtapa%
		   AND SC7.C7_ENCER NOT IN ('E')
		   AND SC7.C7_RESIDUO NOT IN ('S')
		   AND TRIM(SC7.C7_NUMSC) IS NULL
		   AND SC7.C7_FILIAL  = %XFILIAL:SC7%
		   AND SC7.%NOTDEL%

	EndSQL

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())
	If .not. (cAliasTMP)->(EoF())
		nRet := (cAliasTMP)->C7_QUANT  
	EndIf

	(cAliasTMP)->(DbCloseArea())
	
Return nRet


/*/{Protheus.doc} GetMedContrato
@description Obtem quantidade requisitada via Medicao de Contrato
@type  Static Function
@author Helitom Silva
@since 21/02/2024
@version 12.1.2210
@param p_cContrato, Caracter, Contrato
@param p_cFilCtr, Caracter, Filial do Contrato
@example
(examples)
@see (links_or_references)
/*/
Static Function GetMedContrato(p_cContrato, p_cFilCtr, p_cOrdem, p_cCodProd, p_cTarefa, p_cEtapa)
	
	Local __stt     := u___stt(procname(0), "BFMA46HS")	
	Local nRet 		:= 0
	Local cAliasTMP := GetNextAlias()
	
	BeginSQL Alias cAliasTMP

		SELECT COALESCE(SUM(CNE.CNE_QUANT), 0) AS CNE_QUANT
		  FROM %TABLE:CND% CND
		INNER JOIN %TABLE:CNE% CNE ON CNE.CNE_NUMMED = CND.CND_NUMMED
								  AND CNE.CNE_PRODUT = %EXP:p_cCodProd%
								  AND CNE.CNE_OP     = %EXP:AllTrim(p_cOrdem) + 'OS001'%
								  AND CNE.CNE_TAREOS = %EXP:p_cTarefa%
								  AND CNE.CNE_ETAPOS = %EXP:p_cEtapa%
								  AND CNE.CNE_FILIAL = CND.CND_FILIAL
								  AND CNE.%NOTDEL%
		 WHERE TRIM(CND.CND_SITUAC) = %EXP:'A'%
		   //AND CND.CND_CONTRA = %EXP:p_cContrato%
		   //AND CND.CND_FILCTR = %EXP:p_cFilCtr%
		   AND CND.CND_FILIAL = %XFILIAL:CND%
		   AND CND.%NOTDEL%

	EndSQL

	IdaGrvSQL('Get_Med_Contrato_Prod_' + AllTrim(p_cCodProd), GetLastQuery()[2])

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())
	If .not. (cAliasTMP)->(EoF())
		nRet := (cAliasTMP)->CNE_QUANT  
	EndIf

	(cAliasTMP)->(DbCloseArea())
	
Return nRet


/*/{Protheus.doc} TipoSolicit
@description Seleciona Tipo de Solicita��o
@type  Function
@author Helitom Silva
@since 18/10/2023
@version 12.1.2210
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function TipoSolicit()
	
	Local __stt	:= u___stt(procname(0), "BFMA46HS")
	Local cRet  := ''

Return cRet


/*/{Protheus.doc} GerSolCompra
@description Gera Solicita��o de compra
@type Function
@version 12.1.2210
@author Helitom Silva
@since 24/10/2023
@return lRet, Se for gerado o pedido retorna .T.
/*/
Static Function GerSolCompra()

	Local __stt		:= u___stt(procname(0), "BFMA46HS")
	Local lRet		:= .T.
	Local aCabSC 	:= {}
	Local aItensSC  := {}
	Local aLinhaC1  := {}
	Local nX 	 	:= 0
	Local nLinha 	:= 0
	Local cDoc 		:= ""
	Local lOk 		:= .T.
	Local nAux 		:= 0
	Local cItem     := StrZero(1, TamSX3('C1_ITEM')[1])
	Local cLogErro  := ''
	Local aErroAuto := {}

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.

	DbSelectArea("SC1")

	If lOk

		cDoc := GetSXENum("SC1", "C1_NUM")

		SET DELE OFF
		SC1->(dbSetOrder(1))
		While SC1->(dbSeek(xFilial("SC1") + cDoc))
			ConfirmSX8()
			cDoc := GetSXENum("SC1", "C1_NUM")
		EndDo
		SET DELE ON
		ConfirmSX8()

		aadd(aCabSC, {"C1_NUM", cDoc})
		aadd(aCabSC, {"C1_SOLICIT", UsrRetName(RetCodUsr())})
		aadd(aCabSC, {"C1_EMISSAO", dDataBase})
		Aadd(aCabSC, {"C1_APROV", "L", Nil})

		For nLinha := 1 To oGridReq:GetQtdLinha()
		
			If oGridReq:Marcado(nLinha)

				aLinhaC1 := {}
				aadd(aLinhaC1, {"C1_ITEM", cItem, Nil})
				aadd(aLinhaC1, {"C1_PRODUTO", oGridReq:GetColuna('CODINS', nLinha), Nil})
				Aadd(aLinhaC1, {"C1_DESCRI", SubStr(Posicione('SB1', 1, FWxFilial('SB1') + oGridReq:GetColuna('CODINS', nLinha), 'B1_DESC'), 1, TamSX3('C1_DESCRI')[1]), Nil})
				aadd(aLinhaC1, {"C1_QUANT", oGridReq:GetColuna('QTDREQ', nLinha), Nil})
				Aadd(aLinhaC1, {"C1_UM", Posicione("SB1", 1, FWxFilial("SB1") + oGridReq:GetColuna('CODINS', nLinha), "B1_UM"), Nil})
				Aadd(aLinhaC1, {"C1_SEGUM", Posicione("SB1", 1, FWxFilial("SB1") + oGridReq:GetColuna('CODINS', nLinha), "B1_SEGUM"), Nil})
				Aadd(aLinhaC1, {"C1_YOPER", oGridReq:GetColuna('TPOPER', nLinha), Nil}) // Alexandre Bastos - 25/06/2020 - #236381 - ordenado por prioridade
				Aadd(aLinhaC1, {"C1_LOCAL", oGridReq:GetColuna('LOCAL', nLinha), Nil}) // Alexandre Bastos - 25/06/2020 - #236381 - ordenado por prioridade
				Aadd(aLinhaC1, {"C1_CLVL", cCodCLVL, Nil}) // Alexandre Bastos - 25/06/2020 - #236381 - ordenado por prioridade
				Aadd(aLinhaC1, {"C1_OBS", oGridReq:GetColuna('OBSREQ', nLinha), Nil})
				Aadd(aLinhaC1, {"C1_YOBS", oGridReq:GetColuna('OBSREQ', nLinha), Nil})
				Aadd(aLinhaC1, {"C1_XGRAPRO", oGridReq:GetColuna('GRPAPRO', nLinha), Nil})
				Aadd(aLinhaC1, {"C1_YPLPCO", cSafra, Nil})
				Aadd(aLinhaC1, {"C1_USER", __cUserid, Nil})

				If !Empty(cCodForn) .and. !Empty(cLojForn)
					aadd(aLinhaC1, {"C1_FORNECE", cCodForn, Nil})
					aadd(aLinhaC1, {"C1_LOJA   ", cLojForn, Nil})
				EndIf

				Aadd(aLinhaC1, {"C1_OP", AllTrim(cNum46HS) + 'OS001', Nil})
				Aadd(aLinhaC1, {"C1_YTAREOS", oGridReq:GetColuna('TAREFA', nLinha), Nil})
				Aadd(aLinhaC1, {"C1_YETAPOS", oGridReq:GetColuna('ETAPA', nLinha), Nil})
				Aadd(aLinhaC1, {"C1_YCODBEM", oGridReq:GetColuna('CODBEM', nLinha), Nil})
				Aadd(aLinhaC1, {"C1_YORIBEM", "STJ", Nil})
				Aadd(aLinhaC1, {"C1_CC", oGridReq:GetColuna('CCUSTO', nLinha), Nil})

				IF !Empty(oGridReq:GetColuna('CODEQUI', nLinha))
					Aadd(aLinhaC1,{"C1_CODPFAB", oGridReq:GetColuna('CODEQUI', nLinha), Nil})
				EndIf

				Aadd(aLinhaC1, {"C1_ORIGEM", "BFMA46HS", Nil})

				aadd(aItensSC, aLinhaC1)
				
				cItem := Soma1(cItem)

			EndIf

		Next

		MSExecAuto({|x, y| MATA110(x, y, 3)}, aCabSC, aItensSC)
		
		If !lMsErroAuto
			MsgInfo("Solicita��o de Compra " + cDoc + " inclu�da com Sucesso!")
		Else

			MsgInfo("Erro na Inclus�o de Solicita��o de Compra:" + cDoc)
			lRet := .F.

			aErroAuto := GETAUTOGRLOG()

			For nX := 1 to Len(aErroAuto)
				cLogErro += aErroAuto[nX] + CRLF
			Next
			
			MsgInfo(cLogErro)

		EndIf
		
	EndIf

Return lRet


/*/{Protheus.doc} GerPedCompra
@description Gera pedido de compra
@type function
@version 12.1.2210
@author Helitom Silva
@since 23/10/2023
@return lRet, Se for gerado o pedido retorna .T.
/*/
Static Function GerPedCompra()

	Local __stt	   := u___stt(procname(0), "BFMA46HS")
	Local lRet     := .T.
	Local aCabec   := {}
	Local aItens   := {}
	Local aLinha   := {}
	Local aRatCC   := {}
	Local aRatPrj  := {}
	Local aAdtPC   := {}
	Local aItemPrj := {{"01", "02"}, {"02", "01"}} // Projeto, Tarefa
	Local aCCusto  := {{40, "01", "101010", "333330", "CL0001"}, {60, "02", "101011", "333330", "CL0001"}} // Porcentagem, Centro de Custo, Conta Contabil, Item Conta, CLVL
	Local nLinha   := 0
	Local cDoc     := ""
	Local nOpc     := 3
	Local cCond    := ''
	Local cItem    := StrZero(1, 4)
	Local nVlDesc  := 0
	Local nVlTotal := 0
	Local cTes     := ''
	Local cGrpApv  := ''

	Private lMsErroAuto := .F.

	cDoc := GetSXENum("SC7", "C7_NUM")

	SET DELE OFF
	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	While SC7->(dbSeek(xFilial("SC7") + cDoc))
		ConfirmSX8()
		cDoc := GetSXENum("SC7", "C7_NUM")
	End
	SET DELE ON
	ConfirmSX8()

	cCond := Posicione('SA2', 1 , FWxFilial('SA2') + cCodForn + cLojForn, 'A2_COND')

	If Empty(cCond)
		cCond := U_YGETNPAR('MV_CONDPAD', '')
	EndIf

	aadd(aCabec, {"C7_NUM", cDoc, Nil})
	aadd(aCabec, {"C7_EMISSAO", dDataBase, Nil})
	aadd(aCabec, {"C7_FORNECE", cCodForn, Nil})
	aadd(aCabec, {"C7_LOJA", cLojForn, Nil})
	aadd(aCabec, {"C7_COND", cCondPag, Nil})
	aadd(aCabec, {"C7_CONTATO", "AUTO", Nil})
	aadd(aCabec, {"C7_FILENT", cFilAnt, Nil})
    aAdd(aCabec, {"C7_TPFRETE", SubStr(cTpFrete,1,1), Nil})
    aAdd(aCabec, {"C7_FRETE", 0, Nil})
    aAdd(aCabec, {"C7_VALFRE", 0, Nil})
    aAdd(aCabec, {"C7_DESPESA", nDespesa, Nil})
    aAdd(aCabec, {"C7_SEGURO", 0, Nil})
	aAdd(aCabec, {"C7_MOEDA", nMoeda, Nil}) // Moeda do sistema
	aAdd(aCabec, {"C7_TXMOEDA", nTxMoeda, Nil}) // Taxa da moeda
	aAdd(aCabec, {"C7_VLDESC", nVlrDsc, Nil})
	aAdd(aCabec, {"C7_TOTAL", nTotPed, Nil})

	For nLinha := 1 To oGridReq:GetQtdLinha()
	
		If oGridReq:Marcado(nLinha)

			aLinha := {}

			nVlTotal += oGridReq:GetColuna('TOTAL', nLinha)
			cGrpApv  := oGridReq:GetColuna('GRPAPRO', nLinha)

			aAdd(aLinha, {"C7_ITEM", cItem, Nil})
			aadd(aLinha, {"C7_PRODUTO", oGridReq:GetColuna('CODINS', nLinha), Nil})
			aAdd(aLinha, {"C7_DESCRI", SubStr(Posicione('SB1', 1, FWxFilial('SB1') + oGridReq:GetColuna('CODINS', nLinha), 'B1_DESC'), 1, TamSX3('C7_DESCRI')[1]), Nil})
			aadd(aLinha, {"C7_QUANT", oGridReq:GetColuna('QTDREQ', nLinha), Nil})
			aadd(aLinha, {"C7_UM", Posicione('SB1', 1, FWxFilial('SB1') + oGridReq:GetColuna('CODINS', nLinha), 'B1_UM'), Nil})
			aadd(aLinha, {"C7_PRECO", oGridReq:GetColuna('VLUNIT', nLinha), Nil})
			aadd(aLinha, {"C7_TOTAL", oGridReq:GetColuna('TOTAL', nLinha), Nil})
			aAdd(aLinha, {"C7_OP", AllTrim(cNum46HS) + 'OS001', Nil})
			aAdd(aLinha, {"C7_YTAREOS", oGridReq:GetColuna('TAREFA', nLinha), Nil})
			aAdd(aLinha, {"C7_YETAPOS", oGridReq:GetColuna('ETAPA', nLinha), Nil})
			aAdd(aLinha, {"C7_CODPFAB", oGridReq:GetColuna('CODEQUI', nLinha), Nil})
			aAdd(aLinha, {"C7_YCODMON", Posicione('SB1', 1, FWxFilial('SB1') + oGridReq:GetColuna('CODINS', nLinha), 'B1_YCODMON'), Nil})
			aAdd(aLinha, {"C7_OPER", oGridReq:GetColuna('TPOPER', nLinha), Nil})
			aAdd(aLinha, {"C7_CLVL", cCodCLVL, Nil})
			aAdd(aLinha, {"C7_LOCAL", oGridReq:GetColuna('LOCAL', nLinha), Nil})
			aAdd(aLinha, {"C7_DATPRF", dDataBase, Nil}) // Data da Previsao de Entrega
			aAdd(aLinha, {"C7_YPLPCO", cSafra, Nil}) // Safra
			aAdd(aLinha, {"C7_YPLVER", CriaVar("C7_YPLVER", .F.), Nil}) // Versao Safra
			aAdd(aLinha, {"C7_OBS", oGridReq:GetColuna('OBSREQ', nLinha), Nil})
			aAdd(aLinha, {"C7_YOBS", oGridReq:GetColuna('OBSREQ', nLinha), Nil})
			aAdd(aLinha, {"C7_YCODBEM", oGridReq:GetColuna('CODBEM', nLinha), Nil})
			aAdd(aLinha, {"C7_YORIBEM", 'STJ', Nil})
			aAdd(aLinha, {"C7_CC", oGridReq:GetColuna('CCUSTO', nLinha), Nil})
			aAdd(aLinha, {"C7_XGRAPRO", cGrpApv, Nil}) // Grupo de Aprovadores
			aAdd(aLinha, {"C7_YTPGER", cTpGer, Nil}) // Tipo Gerencial
			aAdd(aLinha, {"C7_YCHVNFE", cChvNFE, Nil})

			// Adicionado TES caso frete CIF, para somar o frete na base do IPI
			// Adicionado validacao somente se tiver IPI e frete CIF
			// adicionado validacao por filial logada
			If cTpFrete == 'C' .and. nPerIPI > 0

				dbselectArea('SF4')
				SF4->(DbSetOrder(1))
				SF4->(MsSeek(xFilial("SF4")))

				// Adicionado F4_MSBLQL e F4_IPI
				While SF4->(!Eof()) .and. SF4->F4_FILIAL == xFilial("SF4") .and. SF4->F4_CODIGO >= '000' .and. SF4->F4_CODIGO <= '499'

					If SF4->F4_IPIFRET == 'S';
					   .and. SF4->F4_IPI == 'S';
					   .and. SF4->F4_MSBLQL == '2'

						cTes := SF4->F4_CODIGO

						Exit
					EndIf

					SF4->(DbSkip())
				End

				If !Empty(cTes)
					aAdd(cTes, {"C7_TES", cTes, Nil})
				Else
					MsgInfo("N�o foi encontrado uma TES que calcule IPI somando FRETE CIF -> 'F4_IPIFRET = S' e 'F4_IPI = S' ","TES / IPI")
					lRet := .F.
					Exit
				EndIf

			Endif

            Aadd(aLinha, {"C7_BASEIPI", nTotMerc, Nil}) // Base de Calculo IPI
            Aadd(aLinha, {"C7_VALIPI", nVlrIPI, Nil}) // Valor do IPI
			aAdd(aLinha, {"C7_IPI", nPerIPI, Nil}) // % IPI

			/*
			aAdd(aLinha, {"C7_NUMCOT", _cC8_Num, Nil})
			aAdd(aLinha, {"C7_PICM", _nAliqIcm, Nil}) // Al�quota ICMS
	
			If SC7->(FieldPos("C7_ICMSRET")) > 0
				aAdd(aLinha, {"C7_ICMSRET", _aItensPed[_nCtaA,zXVLICMS], Nil}) // Vlr. ICMS
			EndIf
			*/

			aadd(aItens, aClone(aLinha))

			cItem := Soma1(cItem)

			/*
			//Rateio Centro de Custo
			aAdd(aRatCC, Array(2))

			aRatCC[1][1] := "0001"
			aRatCC[1][2] := {}

			For nLinha := 1 To Len(aCCusto)

				aLinha := {}

				aAdd(aLinha, {"CH_FILIAL", xFilial("SCH"), Nil})
				aAdd(aLinha, {"CH_ITEM", PadL(nLinha, TamSx3("CH_ITEM")[1], "0"), Nil})
				aAdd(aLinha, {"CH_PERC", aCCusto[nLinha][1], Nil})
				aAdd(aLinha, {"CH_CC", aCCusto[nLinha][2], Nil})
				aAdd(aLinha, {"CH_CONTA", aCCusto[nLinha][3], Nil})
				aAdd(aLinha, {"CH_ITEMCTA", aCCusto[nLinha][4], Nil})
				aAdd(aLinha, {"CH_CLVL", aCCusto[nLinha][5], Nil})

				aAdd(aRatCC[1][2], aClone(aLinha))

			Next
			
			//Rateio Projeto
			aAdd(aRatPrj, Array(2))

			aRatPrj[1][1] := "0001"
			aRatPrj[1][2] := {}

			For nLinha := 1 To Len(aItemPrj)
				
				aLinha := {}

				aAdd(aLinha, {"AJ7_FILIAL" , xFilial("AJ7") , Nil})
				aAdd(aLinha, {"AJ7_PROJET" , aItemPrj[nLinha][1], Nil})
				aAdd(aLinha, {"AJ7_TAREFA" , PadR(aItemPrj[nLinha][2],TamSX3("AF9_TAREFA")[1]), Nil})
				aAdd(aLinha, {"AJ7_NUMPC" , cDoc , Nil})
				aAdd(aLinha, {"AJ7_ITEMPC" , "0001" , Nil})
				aAdd(aLinha, {"AJ7_COD" , "0001" , Nil})
				aAdd(aLinha, {"AJ7_QUANT" , 1 , Nil})
				aAdd(aLinha, {"AJ7_REVISA" , "0001" , Nil})

				aAdd(aRatPrj[1][2], aClone(aLinha))

			Next
			
			//Adiantamento
			aLinha := {}

			aAdd(aLinha, {"FIE_FILIAL", xFilial("FIE"), Nil})
			aAdd(aLinha, {"FIE_CART",   "P", Nil}) // Carteira pagar
			aAdd(aLinha, {"FIE_PEDIDO", "" , Nil}) // N�o precisa, pois quem trata � a MATA120
			aAdd(aLinha, {"FIE_PREFIX", PadR("A", TamSX3("FIE_PREFIX")[1]), Nil}) //Prefixo
			aAdd(aLinha, {"FIE_NUM",    PadR("PAPC01", TamSX3("FIE_NUM")[1]), Nil}) //Numero Titulo
			aAdd(aLinha, {"FIE_PARCEL", PadR("1", TamSX3("FIE_PARCEL")[1]), Nil}) //Parcela
			aAdd(aLinha, {"FIE_TIPO",   PadR("PA", TamSX3("FIE_TIPO")[1]), Nil}) //Tipo = PA
			aAdd(aLinha, {"FIE_FORNEC", PadR("001 ", TamSX3("FIE_FORNEC")[1]), Nil}) // Fornecedor
			aAdd(aLinha, {"FIE_LOJA",   PadR("01", TamSX3("FIE_LOJA")[1]), Nil}) //Loja
			aAdd(aLinha, {"FIE_VALOR",  100, Nil}) // Valor do pa que est� vinculado ao pedido

			aAdd(aAdtPC, aClone(aLinha))
			*/

		EndIf

	Next

	If lRet

		MSExecAuto({|a,b,c,d,e,f,g,h| MATA120(a,b,c,d,e,f,g,h)}, 1, aCabec, aItens, nOpc, .F./*, aRatCC, aAdtPC, aRatPrj*/)

		If !lMsErroAuto

			DbSelectArea('SC7')
			SC7->(dbSetOrder(1))
			If SC7->(DbSeek(xFilial('SC7') + cDoc))

				While .not. SC7->(Eof()) .and. SC7->C7_FILIAL = xFilial('SC7') .and. SC7->C7_NUM = cDoc

					RecLock('SC7', .F.)
						SC7->C7_YCDIR   := 'S'
						SC7->C7_CONAPRO := 'B'
						SC7->C7_ACCPROC := '2'
						SC7->C7_APROV   := cGrpApv
						SC7->C7_ORIGEM  := 'BFMA46HS'
					SC7->(MsUnLock())

					SC7->(dbSkip())
				End
				
			EndIf

			MsgInfo("Pedido de Compra: " + cDoc + " inclu�do com sucesso!")
		Else
			MsgInfo("Erro na gera��o do Pedido de Compra.")
			MostraErro()
			lRet := .F.
		EndIf

	EndIf
    
Return lRet


/*/{Protheus.doc} GerSolProdut
@description Gera pedido de compra
@type function
@version 12.1.2210
@author Helitom Silva
@since 23/10/2023
@return lRet, Se for gerado o pedido retorna .T.
/*/
Static Function GerSolProdut()

	Local __stt	   := u___stt(procname(0), "BFMA46HS")
	Local lRet 	   := .T.
	Local nLinha   := 0
	Local nItem    := 0
	Local cDoc     := ''
	Local nOpc     := 3
	Local nVlUnit  := 0

	Private cCabMod := "ZFA_NUM|ZFA_EMISSA|ZFA_USER|ZFA_NMUSER|ZFA_CLVL|ZFA_USERAN|ZFA_NMUSAN|"
	Private n

	cDoc := GetSXENum("ZFA", "ZFA_NUM")

	SET DELE OFF
	dbSelectArea("ZFA")
	ZFA->(dbSetOrder(1))
	While ZFA->(dbSeek(xFilial("ZFA") + cDoc))
		ConfirmSX8()
		cDoc := GetSXENum("ZFA", "ZFA_NUM")
	EndDo
	SET DELE ON
	ConfirmSX8()

	oModelZFA := FWLoadModel( "BFCO01FP" )
	oModelZFA:SetOperation(MODEL_OPERATION_INSERT)
	oModelZFA:Activate()

	oZFACab := oModelZFA:GetModel("ZFACAB")
	oZFADet := oModelZFA:GetModel("ZFADET")

	oZFACab:LoadValue("ZFA_NUM", cDoc )
	oZFACab:LoadValue("ZFA_EMISSA", dDataBase )
	oZFACab:LoadValue("ZFA_USER", __cUserId )
	oZFACab:LoadValue("ZFA_NMUSER", UsrRetName(__cUserId))
	oZFACab:LoadValue("ZFA_CLVL", cCodCLVL)

	oGridReq:PosLinha(1, .T.)
	For nLinha := 1 To oGridReq:GetQtdLinha()

		If oGridReq:Marcado(nLinha)

			nItem++

			If nItem > oZFADet:Length(.F.)
				oZFADet:AddLine()
			EndIf

			oZFADet:GoLine(nItem)
			oZFADet:LoadValue("ZFA_ITEM", StrZero(nItem, TamSX3('ZFA_ITEM')[1], 0))
			oZFADet:LoadValue("ZFA_PRODUT", oGridReq:GetColuna('CODINS', nLinha))
			oZFADet:LoadValue("ZFA_DESCRI", SubStr(Posicione('SB1', 1, FWxFilial('SB1') + oGridReq:GetColuna('CODINS', nLinha), 'B1_DESC'), 1, TamSX3('ZFA_DESCRI')[1]))
			oZFADet:LoadValue("ZFA_QUANT", oGridReq:GetColuna('QTDREQ', nLinha))
			oZFADet:LoadValue("ZFA_UM", Posicione('SB1', 1, FWxFilial('SB1') + oGridReq:GetColuna('CODINS', nLinha), 'B1_UM'))
			oZFADet:LoadValue("ZFA_CODPFA", oGridReq:GetColuna('CODEQUI', nLinha))
			oZFADet:LoadValue("ZFA_OPER", oGridReq:GetColuna('TPOPER', nLinha))
			oZFADet:LoadValue("ZFA_LOCAL", oGridReq:GetColuna('LOCAL', nLinha))
			oZFADet:LoadValue("ZFA_XGRAPR", oGridReq:GetColuna('GRPAPRO', nLinha))
			oZFADet:LoadValue("ZFA_OBS", oGridReq:GetColuna('OBSREQ', nLinha))
			oZFADet:LoadValue("ZFA_CC", oGridReq:GetColuna('CCUSTO', nLinha))
			oZFADet:LoadValue("ZFA_OP", AllTrim(cNum46HS) + 'OS001')
			oZFADet:LoadValue("ZFA_TAREOS", oGridReq:GetColuna('TAREFA', nLinha))
			oZFADet:LoadValue("ZFA_ETAPOS", oGridReq:GetColuna('ETAPA', nLinha))
			oZFADet:LoadValue("ZFA_CODBEM", oGridReq:GetColuna('CODBEM', nLinha))
			oZFADet:LoadValue("ZFA_DTNECE", dDataBase)

		EndIf

	Next

	If oModelZFA:VldData()
		lRet := oModelZFA:CommitData()
	Else
		lRet := .F.
	EndIf

	If !lRet
		aErro := oModelZFA:GetErrorMessage()
		AutoGrLog( "Id do formul�rio de origem:" + " [" + AllToChar( aErro[1] ) + "]" )
		AutoGrLog( "Id do campo de origem: "     + " [" + AllToChar( aErro[2] ) + "]" )
		AutoGrLog( "Id do formul�rio de erro: "  + " [" + AllToChar( aErro[3] ) + "]" )
		AutoGrLog( "Id do campo de erro: "		 + " [" + AllToChar( aErro[4] ) + "]" )
		AutoGrLog( "Id do erro: "				 + " [" + AllToChar( aErro[5] ) + "]" )
		AutoGrLog( "Mensagem do erro: "			 + " [" + AllToChar( aErro[6] ) + "]" )
		AutoGrLog( "Mensagem da solu��o: "       + " [" + AllToChar( aErro[7] ) + "]" )
		AutoGrLog( "Valor atribu�do: "           + " [" + AllToChar( aErro[8] ) + "]" )
		AutoGrLog( "Valor anterior: "            + " [" + AllToChar( aErro[9] ) + "]" )
		MostraErro()
		lRet := .F.
	EndIf

	oModelZFA:Destroy()

Return lRet



/*/{Protheus.doc} GerMedContrato
@description Gera Medi��o de Contrato
@type function
@version 12.1.2210
@author Helitom Silva
@since 21/02/2024
@return lRet, Se for gerado o pedido retorna .T.
/*/
Static Function GerMedContrato()

	Local __stt	    := u___stt(procname(0), "BFMA46HS")
	Local lRet 	    := .T.
	Local oModel    := Nil
	Local cNumMed   := ""
	Local nX        := 0
	Local nY        := 0
	Local aErro	    := {}
	Local nLinha    := 0
	Local nItem     := 0
	Local cOldFName := FunName()
	Private n

	cNumMed := GetSXENum("CND", "CND_NUMMED")

	SET DELE OFF
	dbSelectArea("CND")
	CND->(dbSetOrder(4))
	While CND->(dbSeek(xFilial("CND") + cNumMed))
		ConfirmSX8()
		cNumMed := GetSXENum("CND", "CND_NUMMED")
	EndDo
	SET DELE ON
	ConfirmSX8()

	SetFunName('CNTA121')

	Begin Sequence

		CN9->(DbSetOrder(1))
		If CN9->(DbSeek(xFilial("CN9", cFilCtr) + cContrato)) //Posicionar na CN9 para realizar a inclus�o

			oModel := FWLoadModel("CNTA121")
			
			oModel:SetOperation(MODEL_OPERATION_INSERT)

			If (oModel:CanActivate())

				oModel:Activate()
				oModel:LoadValue("CNDMASTER", "CND_NUMMED", cNumMed)
				oModel:SetValue("CNDMASTER", "CND_CONTRA", CN9->CN9_NUMERO)
				oModel:SetValue("CNDMASTER", "CND_REVISA", CN9->CN9_REVISA)
				oModel:LoadValue("CNDMASTER", "CND_YTPMED", "1") // 1=Materiais;2=Mao de Obra
				oModel:LoadValue("CNDMASTER", "CND_YTPFRT", "S") // Tipo de Frete
				/*
				oModel:LoadValue("CNDMASTER", "CND_RCCOMP", "1") // Selecionar compet�ncia
				oModel:LoadValue("CNDMASTER", "CND_YTPGER", "DVFR") // Tipo Gerencial
				*/
				
				oModel:GetModel("CXNDETAIL"):GoLine(1)

				oModel:SetValue("CXNDETAIL", "CXN_CHECK", .T.)
				oModel:LoadValue("CXNDETAIL", "CXN_FORCLI", cCodForn)
				oModel:LoadValue("CXNDETAIL", "CXN_FORNEC", cCodForn)
				oModel:LoadValue("CXNDETAIL", "CXN_LOJA", cLojForn)
				nY++

				/*
				oModel:GetModel('CNRDETAIL1'):GoLine(1) //<CNRDETAIL1> � o submodelo das multas da planilha(CXN)
				oModel:SetValue("CNRDETAIL1", "CNR_TIPO", aDados[nX,15]) //1=Multa/2=Bonifica��o
				oModel:SetValue("CNRDETAIL1", "CNR_DESCRI", aDados[nX,17])
				oModel:SetValue("CNRDETAIL1", "CNR_VALOR", aDados[nX,19])
				*/

				oGridReq:PosLinha(1, .T.)
				For nLinha := 1 To oGridReq:GetQtdLinha()

					If oGridReq:Marcado(nLinha)

						nItem++

						If nItem > oModel:GetModel('CNEDETAIL'):Length(.F.)
							If !oModel:GetModel('CNEDETAIL'):AddLine()
								lRet := .F.
								Exit
							EndIf
						EndIf

						/*If !oModel:GetModel('CNEDETAIL'):IsEmpty()
							oModel:GetModel('CNEDETAIL'):AddLine()
						EndIf*/

						oModel:GetModel('CNEDETAIL'):LoadValue('CNE_ITEM', PadL(nItem, TamSX3('CNE_ITEM')[1], "0")) // Adiciona um item a planilha           
						oModel:LoadValue('CNEDETAIL', 'CNE_PRODUT', oGridReq:GetColuna('CODINS', nLinha))
						oModel:LoadValue('CNEDETAIL', 'CNE_OPER', oGridReq:GetColuna('TPOPER', nLinha))
						oModel:LoadValue('CNEDETAIL', 'CNE_CC', oGridReq:GetColuna('CCUSTO', nLinha))
						oModel:LoadValue('CNEDETAIL', 'CNE_LOCAL', oGridReq:GetColuna('LOCAL', nLinha))
						oModel:SetValue('CNEDETAIL', 'CNE_QUANT', oGridReq:GetColuna('QTDREQ', nLinha))
						oModel:SetValue('CNEDETAIL', 'CNE_VLUNIT', oGridReq:GetColuna('VLUNIT', nLinha))
						oModel:SetValue('CNEDETAIL', 'CNE_VLTOT', oGridReq:GetColuna('TOTAL', nLinha))
						oModel:LoadValue('CNEDETAIL', 'CNE_YPLPCO', cSafra)
						oModel:LoadValue('CNEDETAIL', 'CNE_CLVL', cCodCLVL)
						oModel:LoadValue('CNEDETAIL', 'CNE_YCBEM', oGridReq:GetColuna('CODBEM', nLinha))
						oModel:LoadValue('CNEDETAIL', 'CNE_OP', cNum46HS + 'OS001')
						oModel:LoadValue('CNEDETAIL', 'CNE_TAREOS', oGridReq:GetColuna('TAREFA', nLinha))
						oModel:LoadValue('CNEDETAIL', 'CNE_ETAPOS', oGridReq:GetColuna('ETAPA', nLinha))
						oModel:LoadValue('CNEDETAIL', 'CNE_YOBSPC', oGridReq:GetColuna('OBSREQ', nLinha))

						/*If !(Empty(aDados[nX,6])) // Quando tiver valor extra adicionar mais uma linha com o mesmo produto

							nY++

							oModel:GetModel('CNEDETAIL'):AddLine()
							oModel:GetModel('CNEDETAIL'):LoadValue('CNE_ITEM', PadL(ny, CNE->(Len(CNE_ITEM)), "0")) // Adiciona um item a planilha           
							oModel:SetValue('CNEDETAIL', 'CNE_PRODUT', aDados[nX,1])
							oModel:SetValue('CNEDETAIL', 'CNE_QUANT', aDados[nX,7])
							oModel:SetValue('CNEDETAIL', 'CNE_VLUNIT', aDados[nX,6])

						EndIf*/

						If (oModel:HasErrorMessage())
							lRet := .F.
							Exit
						EndIf
					
					EndIf

				Next
						
				If lRet 
					If (lRet := oModel:VldData()) /*Valida o modelo como um todo*/
						oModel:CommitData()
					EndIf
				EndIf

			EndIf

			If (oModel:HasErrorMessage())

				aErro := oModel:GetErrorMessage()

				AutoGrLog( "Id do formul�rio de origem:" + " [" + AllToChar( aErro[1] ) + "]" )
				AutoGrLog( "Id do campo de origem: "     + " [" + AllToChar( aErro[2] ) + "]" )
				AutoGrLog( "Id do formul�rio de erro: "  + " [" + AllToChar( aErro[3] ) + "]" )
				AutoGrLog( "Id do campo de erro: "		 + " [" + AllToChar( aErro[4] ) + "]" )
				AutoGrLog( "Id do erro: "				 + " [" + AllToChar( aErro[5] ) + "]" )
				AutoGrLog( "Mensagem do erro: "			 + " [" + AllToChar( aErro[6] ) + "]" )
				AutoGrLog( "Mensagem da solu��o: "       + " [" + AllToChar( aErro[7] ) + "]" )
				AutoGrLog( "Valor atribu�do: "           + " [" + AllToChar( aErro[8] ) + "]" )
				AutoGrLog( "Valor anterior: "            + " [" + AllToChar( aErro[9] ) + "]" )

				MostraErro()
				lRet := .F.

			EndIf
			
			If lRet

				cNumMed := CND->CND_NUMMED

				//Adicionar o c�digo da medi��o no contrato          
				oModel:DeActivate()        
				
				If MsgYesNo('Medi��o gerada com sucesso sob N� ' + cNumMed + CRLF + CRLF + 'Deseja encerrar esta medi��o gerando seu pedido de compras?', 'Medi��o de Contrato')

					lRet := CN121Encerr(.T.) //Realiza o encerramento da medi��o

					If lRet .and. Select('SC7') > 0
						MsgInfo("Medi��o de Contrato: " + cNumMed + " - Pedido de Compra: " + SC7->C7_NUM + " inclu�do com sucesso!")
					ElseIf lRet
						MsgInfo("Pedigo de compras n�o encontrado, verifique!", 'Medi��o de Contrato')
					EndIf

				EndIf
						
			EndIf

		EndIf

		oModel:Destroy()

	Recover
		lRet := .F.
		oModel:Destroy()
	End Sequence

	SetFunName(cOldFName)

Return lRet


/*/{Protheus.doc} GetOperacoes
@description Obtem Lista de Opera��es a Serem usadas na Solicita��o de Insumos

@type  Function
@author Helitom Silva
@since 26/12/2023
@version 12.1.2210

@return aRet, Array, Lista de Opera��es

/*/
Static Function GetOperacoes()

	Local __stt      := u___stt(procname(0), "BFMA46HS")
	Local aRet 		 := {}
    Local cMVYOISCPP := U_YGETNPAR('MV_YOISCPP', '')
    Local aMVYOISCPP := StrtokArr(cMVYOISCPP, '|;')
	Local nX		 := 0

	For nX := 1 to Len(aMVYOISCPP)

		If aMVYOISCPP[nX] $ 'SC'
			
			Aadd(aRet, 'SC=Solicita��o de Compra')

		ElseIf aMVYOISCPP[nX] $ 'SP'
			
			Aadd(aRet, 'SP=Solicita��o de Produtos')

		ElseIf aMVYOISCPP[nX] $ 'PC'

			Aadd(aRet, 'PC=Pedido de Compra')

		ElseIf aMVYOISCPP[nX] $ 'MC'

			Aadd(aRet, 'MC=Medi��o de Contrato')

		EndIf

	Next
	
	If .not. Len(aRet) == 1
		Aadd(aRet, ' ')
	EndIf

Return aRet


/*/{Protheus.doc} AtuaTotais
@description Atualiza Totalizadores de Valor do Pedido, Desconto e Total

@type  Static Function
@author Helitom Silva
@since 27/12/2023
@version 12.1.2210

@return lRet, Logico, Se n�o ocorrer erros retorna .T.
/*/
Static Function AtuaTotais(p_cField)
	
	Local __stt	:= u___stt(procname(0), "BFMA46HS")
	Local lRet 	:= .T.
	Local nX   	:= 0

	Default p_cField := '*'

	nTotMerc := 0
	//nVlrDsc := 0
	nTotPed  := 0

	For nX := 1 to oGridReq:GetQtdLinha()

		If oGridReq:Marcado()
			nTotMerc += oGridReq:GetColuna('TOTAL', nX)
		EndIf

	Next

	If p_cField == 'PERDSC' 
	
		If nPerDsc > 0

			nVlrDsc := Round((nTotMerc * nPerDsc / 100), TamSX3('C7_VLDESC')[2])
			oVlrDsc:Disable()
	
		Else

			nVlrDsc := 0
			oVlrDsc:Enable()

		EndIf

	EndIf

	If p_cField == 'VLRDSC' 
	
		If nVlrDsc > 0

			nPerDsc := Round((nVlrDsc / nTotMerc * 100), TamSX3('C7_DESC')[2])
			oPerDsc:Disable()

		Else

			nPerDsc := 0
			oPerDsc:Enable()

		EndIf

	EndIf

	If p_cField == 'PERIPI' 
	
		If nPerIPI > 0

			nVlrIPI := Round((nTotMerc * nPerIPI / 100), TamSX3('C7_IPI')[2])
			oVlrIPI:Disable()

		Else
			
			nVlrIPI := 0
			oVlrIPI:Enable()

		EndIf

	ElseIf p_cField == 'VLRIPI'

		If nVlrIPI > 0

			nPerIPI := Round((nVlrIPI / nTotMerc * 100), TamSX3('C7_VALIPI')[2])
			oPerIPI:Disable()

		Else

			nPerIPI := 0
			oPerIPI:Enable()

		EndIf

	EndIf

	nTotPed := Round((nTotMerc - nVlrDsc), TamSX3('C7_TOTAL')[2])

	If p_cField == '*'

		If oPerDsc:lActive

			nVlrDsc := Round((nTotMerc * nPerDsc / 100), TamSX3('C7_VLDESC')[2])

		ElseIf oVlrDsc:lActive

			nPerDsc := Round((nVlrDsc / nTotMerc * 100), TamSX3('C7_DESC')[2])

		EndIf
	
		nTotPed := Round((nTotMerc - nVlrDsc), TamSX3('C7_TOTAL')[2])
		
		If oPerIPI:lActive

			nVlrIPI := Round((nTotMerc * nPerIPI / 100), TamSX3('C7_IPI')[2])

		ElseIf oVlrIPI:lActive

			nPerIPI := Round((nVlrIPI / nTotMerc * 100), TamSX3('C7_VALIPI')[2])

		EndIf

	EndIf

	nTotPed += nDespesa + nVlrIPI

	oPerIPI:Refresh()
	oVlrIPI:Refresh()
	oPerDsc:Refresh()
	oVlrDsc:Refresh()
	oTotMerc:Refresh()
	oTotPed:Refresh()

Return lRet