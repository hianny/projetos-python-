#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FILEIO.CH'
#INCLUDE 'IDATOOLS.CH'

#DEFINE CR Chr(13) + Chr(10)

/*/{Protheus.doc} BFES04JL
@description Solicitação ao Armazem Mod.2

@author	 Jose Leite de Barros Neto
@type	 Function
@since	 09/07/2019
@version 1.0

@return 	lReturn, Logico, Verdadeiro

@obs			#ESTOQUE #MATA105 #MATA106 #MATA185
@example 		Nil
@see 			NIl
/*/
User Function BFES04JL()

	Local __stt     	:= u___stt(procname(0),"BFES04JL")
	Local oBrowse	 	:= FWMBrowse():New()
	Local lReturn		:= .T.

	Private aRotina 	:= MenuDef()

	//Setando o Alias a ser utilizado
	oBrowse:SetAlias( 'SZP' )

	//Descrição do Cabeçalho
	oBrowse:SetDescription('Solicitação ao Armazem Mod.2')

	//Filtro por filial
	oBrowse:SetFilterDefault("ZP_FILIAL == '" + cFilAnt + "'")

	//Legendas
	oBrowse:AddLegend( 'EMPTY(ZP_STATUS) .And. EMPTY(ZP_NUMSAP)', "Enable"	,"Pendente")
	oBrowse:AddLegend( '!EMPTY(ZP_NUMSAP) .And. ZP_STATUS=="B" ', "Disable" ,"Baixada")
	oBrowse:AddLegend( '!EMPTY(ZP_NUMSAP) .And. ZP_STATUS=="D"' , "BR_AZUL" ,"Devolvido")

	//Ativando
	oBrowse:Activate()

Return( lReturn )


/*/{Protheus.doc} MenuDef
@description Funcao para Montar o Menu

@author 	Jose Leite de Barros Neto
@since 		09/07/2019
@Obs 		Uso BOM FUTURO
/*/
Static Function MenuDef()

	Local __stt   := u___stt(procname(0),"BFES04JL")
	Local aRotina := {}

	aAdd( aRotina, { 'Pesquisar' 		, 'PesqBrw'         				, 0, 1, 0, .T. } )
	aAdd( aRotina, { 'Visualizar'		, 'ViewDef.BFES04JL'				, 0, 2, 0, Nil } )
	aAdd( aRotina, { 'Incluir'   		, 'ViewDef.BFES04JL'				, 0, 3, 0, Nil } )
	aAdd( aRotina, { 'Alterar'   		, 'ViewDef.BFES04JL'				, 0, 4, 0, Nil } )
	aAdd( aRotina, { 'Excluir'   		, 'ViewDef.BFES04JL'				, 0, 5, 0, Nil } )
	aAdd( aRotina, { 'Imprimir'  		, 'ViewDef.BFES04JL'				, 0, 8, 0, Nil } )
	aAdd( aRotina, { 'Copiar'    		, 'ViewDef.BFES04JL'				, 0, 9, 0, Nil } )
	aAdd( aRotina, { 'Devolver'  	  	, 'ExecBlock("BFES001D",.f.,.f.)'	, 0, 4, 0, Nil } )
	aAdd( aRotina, { 'Estornar Baixa'  	, 'ExecBlock("BFES15JL",.f.,.f.)'	, 0, 5, 0, Nil } )

Return( aRotina )


/*/{Protheus.doc} ModelDef
@description Funcao para Montar o Modelo de Dados

@author Jose Leite de Barros Neto
@since 	09/07/2019
@Obs    Uso BOM FUTURO
/*/
Static Function ModelDef()

	Local __stt     := u___stt(procname(0),"BFES04JL")
	Local oModel
	Local oStruZP1  := FWFormStruct( 1, 'SZP', { |X|  AllTrim(X) $  'ZP_NUM, ZP_SOLICIT, ZP_EMISSAO, ZP_LOCAL, ZP_TM, ZP_CODBEM, ZP_DESCBEM, ZP_CODPROJ, ZP_OP, ZP_NUMOS, ZP_CLVL, ZP_CC, ZP_APLIC' } )
	Local oStruZP2 	:= FWFormStruct( 1, 'SZP', { |X| !(AllTrim(X) $ 'ZP_NUM, ZP_SOLICIT, ZP_EMISSAO, ZP_LOCAL, ZP_TM, ZP_CODBEM, ZP_DESCBEM, ZP_CODPROJ, ZP_OP, ZP_NUMOS, ZP_CLVL, ZP_CC, ZP_APLIC') } )
	Local lAZGesTra := U_BFMA15HS(,,2)

	oModel := MPFormModel():New( 'BFES04JM' , {| oModel | PreModelo( oModel ) }, {| oModel | PosModelo( oModel ) }, {| oModel | GrvModelo( oModel ) })

	oStruZP1:SetProperty( "ZP_OP", MODEL_FIELD_VALID, { |oFields| ValidField('ZP_OP',, oFields)} )

	oModel:AddFields( 'SZPMASTER'	,				, oStruZP1 )
	oModel:AddGrid('SZPDETAIL'		, 'SZPMASTER'	, oStruZP2 )

	oModel:SetRelation( 'SZPDETAIL', {{ 'ZP_FILIAL', 'xFilial( "SZP" )' }, {'ZP_NUM', 'ZP_NUM' }}, SZP->(IndexKey(1)) )

	//oModel:GetModel( 'SZPDETAIL' ):SetUniqueLine( {'ZP_PRODUTO','ZP_EPIFUN'})
	If lAZGesTra
		oModel:GetModel( 'SZPDETAIL' ):SetUniqueLine( {'ZP_PRODUTO', 'ZP_CPF', 'ZP_TAREOS', 'ZP_ETAPOS'})
	Else
		oModel:GetModel( 'SZPDETAIL' ):SetUniqueLine( {'ZP_PRODUTO', 'ZP_CPF'})
	EndIf
	//oModel:GetModel( 'SZPDETAIL' ):SetUniqueLine( { 'ZP_ITEM' } )

	oModel:SetDescription( 'Solicitação ao Armazem Mod.2' )
	oModel:GetModel( 'SZPMASTER' ):SetDescription( 'Cabeçalho' )
	oModel:GetModel( 'SZPDETAIL' ):SetDescription( 'Itens' )

	//Gatilhos
	oStruZP2:AddTrigger( "ZP_PRODUTO", "ZP_DESCRI"	, { || .t. }, { |oFields| AllTrim(Posicione("SB1",1,xFilial("SB1")+oFields:GetValue("ZP_PRODUTO"),"B1_DESC"))})
	oStruZP2:AddTrigger( "ZP_PRODUTO", "ZP_UM"		, { || .t. }, { |oFields| AllTrim(Posicione("SB1",1,xFilial("SB1")+oFields:GetValue("ZP_PRODUTO"),"B1_UM"))})
	oStruZP2:AddTrigger( "ZP_PRODUTO", "ZP_SALDO"	, { || .t. }, { |oFields| TrgSldB2()})
	oStruZP2:AddTrigger( "ZP_PRODUTO", "ZP_CODPFAB" , { || .t. }, { |oFields| GetZZY(oFields:GetValue("ZP_PRODUTO"))})
	oStruZP2:AddTrigger( "ZP_PRODUTO", "ZP_PRODUTO"	, { || .t. }, { |oFields| UsaProd(oModel)})

	oStruZP2:AddTrigger( "ZP_PRODUTO", "ZP_TAREOS", { || .t. }, { |oFields| U_BFMA48HS(FWFldGet("ZP_OP"), oFields:GetValue("ZP_PRODUTO"), , 'TAREFA')})
	oStruZP2:AddTrigger( "ZP_TAREOS", "ZP_ETAPOS", { || .t. }, { |oFields| U_BFMA48HS(FWFldGet("ZP_OP"), oFields:GetValue("ZP_PRODUTO"), oFields:GetValue("ZP_TAREOS"), 'ETAPA')})
	//oStruZP1:AddTrigger( "ZP_OP","ZP_DESCBEM"	, { || .t. }, { |oFields| PegaBem(oModel,2)})

	oModel:SetPrimaryKey( { "ZP_FILIAL", "ZP_NUM", "ZP_ITEM" } )

	oModel:SetVldActivate( { | oModel | IniModelo( oModel ) } )

	oModel:setActivate({ |oModel| TravaGrid(oModel,oStruZP2,oStruZP1)})

Return( oModel )


/*/{Protheus.doc} ViewDef
@description Funcao para Montar a Interface

@author 	Jose Leite de Barros Neto
@since 		09/07/2019
@Obs 		Uso BOM FUTURO
/*/
Static Function ViewDef()

	Local __stt   := u___stt(procname(0),"BFES04JL")
	Local oView
	Local oModel  := FWLoadModel( 'BFES04JL' )

	Local oStruZP1 := FWFormStruct( 2, 'SZP', { |X|  AllTrim(X)  $ 'ZP_NUM, ZP_SOLICIT, ZP_EMISSAO, ZP_LOCAL, ZP_TM, ZP_CODBEM, ZP_DESCBEM, ZP_CODPROJ, ZP_OP, ZP_NUMOS, ZP_CLVL, ZP_CC, ZP_APLIC' } )
	Local oStruZP2 := FWFormStruct( 2, 'SZP', { |X| !(AllTrim(X) $ 'ZP_NUM, ZP_SOLICIT, ZP_EMISSAO, ZP_LOCAL, ZP_TM, ZP_CODBEM, ZP_DESCBEM, ZP_CODPROJ, ZP_OP, ZP_NUMOS, ZP_CLVL, ZP_CC, ZP_APLIC') } )

	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VSZPMASTER', oStruZP1, 'SZPMASTER' )
	oView:AddGrid( 'VSZPDETAIL', oStruZP2, 'SZPDETAIL' )
	oView:AddIncrementField( "VSZPDETAIL", "ZP_ITEM" )

	oView:CreateHorizontalBox( 'CABECALHO', 40 )
	oView:CreateHorizontalBox( 'DETALHE', 60 )

	oView:SetOwnerView( 'VSZPMASTER', 'CABECALHO' )
	oView:SetOwnerView( 'VSZPDETAIL', 'DETALHE' )

	oView:EnableTitleView( 'VSZPMASTER' )
	oView:EnableTitleView( 'VSZPDETAIL' )

	oView:SetCloseOnOk( {|| .t.} )

Return( oView )


/*/{Protheus.doc} PreModelo
@description Função que realiza pre validacoes do modelo

@param         oModel, Logico, Modelo de dados
@return        lRet, Logico, verdadeiro ou falso
@author        Jose Leite de Barros Neto
@since         11/07/2019
@Obs           Uso BOM FUTURO
/*/
Static Function PreModelo( oModel )

	Local __stt		:= u___stt(procname(0),"BFES04JL")
	Local lRet  	:= .T.
	Local nOper 	:= oModel:GetOperation()
	Local lOpcInc	:= nOper == MODEL_OPERATION_INSERT
	Local lOpcAlt	:= nOper == MODEL_OPERATION_UPDATE
	Local lOpcDel	:= nOper == MODEL_OPERATION_DELETE
	Local oSZPGrid  := oModel:GetModel( 'SZPDETAIL' )

	/*If lOpcInc .Or. lOpcAlt
		SetKey(VK_F4,{|| U_BFES030D(Nil,"04JL",oModel)})
	EndIf*/
	
Return lRet


/*/{Protheus.doc} IniModelo
@description Função que realiza validacoes no inicio do modelo

@param         oModel, Objeto, Modelo de dados
@return        lRet, Logico, verdadeiro ou falso
@author        Jose Leite de Barros Neto
@since         11/07/2019
@Obs           Uso BOM FUTURO
/*/
Static Function IniModelo( oModel )

	Local __stt		:= u___stt(procname(0),"BFES04JL")
	Local lRet  	:= .T.
	Local oSZP 		:= oModel:GetModel("SZPMASTER")
	Local oSZPD 	:= oModel:GetModel("SZPDETAIL")
	Local cStatus	:= ""
	Local cNumSa	:= ""
	Local nOper 	:= oModel:GetOperation()
	Local lOpcInc	:= nOper == MODEL_OPERATION_INSERT
	Local lOpcAlt	:= nOper == MODEL_OPERATION_UPDATE
	Local lOpcDel	:= nOper == MODEL_OPERATION_DELETE

	If lOpcAlt .OR. lOpcDel
		cStatus := SZP->ZP_STATUS
		cNumSa  := SZP->ZP_NUMSAP
		If !Empty(cStatus) .And. !Empty(cNumSa)
			lRet := .F.
			// Alert("Solicitação já encerrada não podendo sofrer alterações, Favor Verificar!")
			Help(,,'VldAct',,'Solicitação já encerrada não podendo sofrer alterações',1,0,,,,,,{})
		EndIf

	EndIf

Return lRet


/*/{Protheus.doc} PosModelo
@description Função que realiza as validacoes TudoOk no modelo

@param         oModel - Modelo de dados
@return        lRet - verdadeiro ou falso
@author        Jose Leite de Barros Neto
@since         11/07/2019
@Obs           Uso BOM FUTURO
/*/
Static Function PosModelo( oModel )

	Local __stt		:= u___stt(procname(0),"BFES04JL")
	Local lRet  	:= .T.
	Local _aAreaAtu  := GetArea()
	Local nOper 	:= oModel:GetOperation()
	Local lOpcInc	:= nOper == MODEL_OPERATION_INSERT
	Local lOpcAlt	:= nOper == MODEL_OPERATION_UPDATE
	Local lOpcDel	:= nOper == MODEL_OPERATION_DELETE

	If lOpcInc .OR. lOpcAlt
		lRet := U_BFES04JR(oModel)
	EndIf

	RestArea( _aAreaAtu )

Return lRet


/*/{Protheus.doc} GrvModelo
Função que grava o modelo de dados após a confirmação

@param         oModel - Modelo de dados
@return        lRet - verdadeiro ou falso
@author        Jose Leite de Barros Neto
@since         11/07/2019
@Obs           Uso BOM FUTURO
/*/
Static Function GrvModelo( oModel )

	Local __stt		:= u___stt(procname(0),"BFES04JL")
	Local lRet  	:= .T.
	Local nOper 	:= oModel:GetOperation()
	Local lOpcInc	:= nOper == MODEL_OPERATION_INSERT
	Local lOpcAlt	:= nOper == MODEL_OPERATION_UPDATE
	Local lOpcDel	:= nOper == MODEL_OPERATION_DELETE
	Local cCpNum    := SZP->ZP_NUM
	Local oSZP 		:= oModel:GetModel("SZPMASTER")
	Local cCC		:= oSZP:GetValue("ZP_CC")
	Local cOp		:= oSZP:GetValue("ZP_OP")
	Local aAreaSZP
	
	//Fluig 280169 - 15/10/20 - Valida se a solicitação esta sendo usada por outra sessão
	If lOpcAlt .Or. lOpcDel

		_cCodUsu := GetGlbValue('BFES04JL' + cEmpAnt + cFilAnt + cCpNum)

		If Empty(_cCodUsu)
			PutGlbValue('BFES04JL' + cEmpAnt + cFilAnt + cCpNum, __cUserid)
			_cCodUsu := GetGlbValue('BFES04JL' + cEmpAnt + cFilAnt + cCpNum)
		Endif

		If _cCodUsu <> __cUserid
			oModel:SetErrorMessage(oModel:GetId(),,oModel:GetId(),,'BFES04JL','Esta solicitação já esta sendo usada pelo usuário ' + Alltrim(UsrFullName(_cCodUsu)),'')
			Return(.f.)
		Endif

	Endif

	FWFormCommit(oModel)

	If lOpcAlt
		aAreaSZP := SZP->(GetArea())
		
		DbSelectArea("SZP")
		SZP->(DbSetOrder(1))
		If SZP->(DbSeek(xFilial("SZP") + cCpNum))
			While SZP->(!Eof()) .And. xFilial("SZP") + cCpNum == SZP->ZP_FILIAL + SZP->ZP_NUM
				If RecLock("SZP", .F.)
					SZP->ZP_CC	:= cCC
					SZP->ZP_OP	:= cOp
					SZP->(MsUnlock())
				EndIf
				SZP->(DbSkip())
			End
		EndIf

		RestArea(aAreaSZP)
	EndIf

	If lOpcInc .Or. lOpcAlt
		If MsgNoYes("Deseja baixar os produtos?")
			//Chamado 117065 Data: 16/08/19  Jared Ribeiro
			//Define a partir daqui que a rotina pai não esta em MVC, para não causar problema na validação CTB105CC
			CTB105MVC(.T.)
			Processa( {|| lRet := U_BFES04JB(oModel, .F.) }, "Aguarde...", "Gerando Solicitação ao Armazem",.F.)
			//Restaura a variável lRotMVC do fonte CTB105CC
			CTB105MVC(.F.)
		EndIf
	EndIf

	// Alexandre Bastos - 19/10/2021 - #470035 - modificado o retorno para não duplicar e adicionado mensagem para informar que registro foi salvo mas não baixado
	if !lRet
		Help(,,'Baixa',,"Registro salvo com sucesso, mas os produtos não foram baixados!",1,0,,,,,,{'Corrija os erros da baixa e tente executar a baixa novamente!'})	
		lRet := .T.
	endif

	if AllTrim(GetGlbValue('BFES04JL' + cEmpAnt + cFilAnt + cCpNum)) <> ''
		ClearGlbValue('BFES04JL' + cEmpAnt + cFilAnt + cCpNum)
	endif
	
Return lRet


/*/{Protheus.doc} TrgSldB2
@description Funcao para buscar saldo do produto

@author 	Jose Leite de Barros Neto
@since 		09/07/2019
@Obs 		Uso BOM FUTURO
/*/
Static Function TrgSldB2()

	Local __stt := u___stt(procname(0),"BFES04JL")
	Local nRet  := 0

	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))
	If SB2->(DbSeek(xFilial("SB2") + M->ZP_PRODUTO  + M->ZP_LOCAL))
		nRet := SALDOSB2()
	EndIf
Return(nRet)

/*/{Protheus.doc} UsaProd
@description Funcao para verificar se o produto é usado

@author 	Lucas Pedroso do Bomdespacho
@since 		25/07/2022
@Obs 		Uso BOM FUTURO
/*/
Static Function UsaProd(oModel)
	Local __stt  := u___stt(procname(0),"BFES04JL")
	Local lRet   := Nil
	Local cUsado := ''
	Local oSZPD  := oModel:GetModel("SZPDETAIL")


	cUsado := AllTrim(Posicione("SB1",1,xFilial("SB1")+M->ZP_PRODUTO,"B1_YUSADO"))

	If cUsado == '1'
		If MsgYesNo("O produto " + AllTrim(M->ZP_PRODUTO) + " - " + AllTrim(Posicione("SB1",1,xFilial("SB1")+M->ZP_PRODUTO,"B1_DESC")) + " é usado", "Confirmar solicitação ?")
			oSZPD:loadValue("ZP_YUSADO"  , '1')
			lRet := .T.
		Else
			lRet := .F.
			oSZPD:loadValue("ZP_PRODUTO"  , ' ')
			oSZPD:loadValue("ZP_DESCRI"   , ' ')
			oSZPD:loadValue("ZP_UM"       , Nil)
			oSZPD:loadValue("ZP_SALDO"    , Nil)
			oSZPD:loadValue("ZP_CODPFAB"  , ' ')
			oSZPD:loadValue("ZP_YUSADO"   , ' ')
		EndIf
	Else
		oSZPD:loadValue("ZP_YUSADO"  , '2')
	EndIf
Return(lRet)


/*/{Protheus.doc} fVldDados
@description Funcao para validar Estoque x Bem x Tipo de Movimentacao x Centro de Custo

@param      lJob, Logico, lJob   : .T. executado via Job | .F. executado via Sol. Arm. mod2
@author 	Jose Leite de Barros Neto
@since 		09/07/2019
@Obs 		Uso BOM FUTURO
/*/
User Function BFES04JR(oModel, lJob)

	Local __stt 	:= u___stt(procname(0),"BFES04JL")
	Local aArea		:= GetArea()
	Local aAreaF5 	:= SF5->(GetArea())
	Local aAreaB2 	:= SB2->(GetArea())
	Local aAreaB1 	:= SB1->(GetArea())
	Local aAreaBM 	:= SBM->(GetArea())
	Local aAreaZZY  := ZZY->(GetArea())
	Local aAreaZZH  := ZZH->(GetArea())
	Local lRet  	:= .T.
	Local cMsgErr   := ""
	Local oSZP 		:= Nil
	Local oSZPD 	:= Nil
	Local cBem		:= ""
	Local cTm		:= ""
	Local cCC		:= ""
	Local cLocal	:= ""
	Local cOp		:= ""
	Local cNumOs	:= ""
	Local cProj		:= ""
	Local cAglo		:= ""
	Local cCpfSolic := ""
	Local cTarOs	:= ""
	Local cEtaOs	:= ""
	Local cProdt	:= ""
	Local cLoteCtl	:= ""
	Local cEpiFun	:= ""
	Local nJ		:= 0
	Local nSaldo	:= 0
	Local nQuant	:= 0
	Local cGrpPrd	:= ""
	Local aTmp1		:= {}
	Local lVistAtv  := U_YGETNPAR("MV_YVISTOK", .F.)
	Local nLen      := 0
	Local lcRet     := Nil
	Local cFilZP 	:= cFilAnt
	Local nQtItm	:= 0
	Local _cEmpZZH  := ""
	Local _cFilZZH  := ""
	Local _cTodos   := ""
	Local cGrpMv	:= Alltrim(U_YGETNPAR('MV_YGRPBOV',''))
	Local cUsrEstMv	:= Alltrim(U_YGETNPAR('MV_YUBXBOV',''))
	Local lAZGesTra := U_BFMA15HS(,,2)
	
	Default lJob    := .F.

	If lJob
		cChv := xFilial("SZP") + PadR(oModel[2],TAMSX3("ZP_NUM")[1])
		
		DbSelectArea("SZP")
		SZP->(DbSetOrder(1)) //ZP_FILIAL+ZP_NUM+ZP_ITEM+DTOS(ZP_EMISSAO)
		If SZP->(DbSeek(cChv))
			cBem      := SZP->ZP_CODBEM
			cTm       := SZP->ZP_TM
			cCC       := SZP->ZP_CC
			cLocal    := SZP->ZP_LOCAL
			cOp       := SZP->ZP_OP
			cNumOs    := SZP->ZP_NUMOS
			cProj     := SZP->ZP_CODPROJ
			cAglo     := SZP->ZP_CLVL
			cCpfSolic := SZP->ZP_SOLICIT
			cFilZP    := SZP->ZP_FILIAL
			_cJobBem  := cBem
			
			While .Not. SZP->(Eof()) .And. cChv == SZP->(ZP_FILIAL+ZP_NUM)
				nQtItm++
				SZP->(dbSkip())
			End
			
		EndIf
	Else
		oSZP 	  := oModel:GetModel("SZPMASTER")
		oSZPD 	  := oModel:GetModel("SZPDETAIL")
		cBem	  := oSZP:GetValue("ZP_CODBEM")
		cTm		  := oSZP:GetValue("ZP_TM")
		cCC		  := oSZP:GetValue("ZP_CC")
		cLocal	  := oSZP:GetValue("ZP_LOCAL")
		cOp	      := oSZP:GetValue("ZP_OP")
		cNumOs	  := oSZP:GetValue("ZP_NUMOS")
		cProj	  := oSZP:GetValue("ZP_CODPROJ")
		cAglo	  := oSZP:GetValue("ZP_CLVL")
		cCpfSolic := AllTrim(oSZP:GetValue("ZP_SOLICIT"))
		cFilZP    := xFilial("SZP")
	EndIf

	//Validar Cabeçalho
	DbSelectArea("SF5")
	SF5->(DbSetOrder(1))
	SF5->(DbGoTop())
	If SF5->(DbSeek(xFilial("SF5",cFilZP) + cTm))
		//TM - BEM
		If SF5->F5_YOBBEM == '1'
			If Empty(cBem)
				// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
					// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "Para esta TM, favor informar o codigo do Bem (ZP_CODBEM)"),;
					// 	OemToAnsi('Verifique o codigo informado!'))
				lRet := .F.
				If lJob
					cMsgErr := "(TM): Para a TM(" + cTm + "), favor informar o codigo do Bem (ZP_CODBEM). Verifique o codigo informado!"
				Else
					Help(,,'TM',,"Para esta TM, favor informar o codigo do Bem (ZP_CODBEM)",1,0,,,,,,{'Verifique o codigo informado!'})
				EndIf
			EndIf
			If Empty(cCC)
				// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
					// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "Para esta TM, favor informar o Centro de Custo (ZP_CC)"),;
					// 	OemToAnsi('Verifique o codigo informado!'))
				lRet := .F.
				If lJob
					cMsgErr := "(TM): Para a TM(" + cTm + "), favor informar o Centro de Custo (ZP_CC). Verifique o codigo informado!"
				Else
					Help(,,'TM',,"Para esta TM, favor informar o Centro de Custo (ZP_CC)",1,0,,,,,,{'Verifique o codigo informado!'})
				EndIf
			EndIf
			//TM - Centro de Custo
		ElseIf SF5->F5_YOBBEM == '2' .Or. Empty(SF5->F5_YOBBEM)
			If Empty(cCC)
				// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
					// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "Para esta TM, favor informar o Centro de Custo (ZP_CC)"),;
					// 	OemToAnsi('Verifique o codigo informado!'))
				lRet := .F.
				If lJob
					cMsgErr := "(TM): Para a TM("+ cTm + "), favor informar o Centro de Custo (ZP_CC). Verifique o codigo informado!"
				Else
					Help(,,'TM',,"Para esta TM, favor informar o Centro de Custo (ZP_CC)",1,0,,,,,,{'Verifique o codigo informado!'})
				EndIf
			EndIf
			//TM - Projeto
		ElseIf SF5->F5_YOBBEM == '4' .And. Empty(cProj)
			// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
				// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + 'TM de Projeto e o Código do Projeto não foi informado, favor verificar!'),;
				// 	OemToAnsi("Informe o codigo do projeto ou altere a TM!"))
			lRet :=	.F.
			If lJob
				cMsgErr := "(Saldo): TM de Projeto e o Código do Projeto não foi informado. Informe o codigo do projeto ou altere a TM!"
			Else
				Help(,,'Saldo',,"TM de Projeto e o Código do Projeto não foi informado",1,0,,,,,,{'Informe o codigo do projeto ou altere a TM!'})
			EndIf
		EndIf
	Else
		// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
			// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "TM não encontrada (ZP_TM)"),;
			// 	OemToAnsi('Verifique o codigo informado!'))
		lRet := .F.
		If lJob
			cMsgErr := "(Saldo): TM (" + cTm + ") não encontrada (ZP_TM). Verifique o codigo informado!"
		Else
			Help(,,'Saldo',,"TM não encontrada (ZP_TM)",1,0,,,,,,{'Verifique o codigo informado!'})
		EndIf
	EndIf

	//Verifico se o parâmetro MV_YVISTOK está ativo. Caso esteja, o usuário é obrigado a preencher o campo do CPF do solicitante.
	If lRet .And. lVistAtv
		If Empty(cCpfSolic)
			// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
				// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + 'O parâmetro MV_YVISTOK está ativo.'),;
				// 	OemToAnsi("É necessário preencher o CPF do solicitante."))
			lRet :=	.F.
			If lJob
				cMsgErr := "(Parametro): O parâmetro MV_YVISTOK está ativo. É necessário preencher o CPF do solicitante."
			Else
				Help(,,'Param',,"O parâmetro MV_YVISTOK está ativo",1,0,,,,,,{'É necessário preencher o CPF do solicitante.'})
			EndIf
		Else
			// Busco o grupo aprovador relacionado ao cpf do usuário e com base no aglomerado
			DbSelectArea('SZQ')
			SZQ->(DBSETORDER( 3 )) //ZQ_CPFUSER+ZQ_CLVL
			//Verifica se o CPF está cadastrado para o mesmo aglomerado
			If !dbSeek(cCpfSolic+cAglo)
				// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
					// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + 'Não foi encontrado CPF cadastrado para o aglomerado informado.'),;
					// 	OemToAnsi("Favor trocar o CPF."))
				If lJob
					cMsgErr := "(CPF): Não foi encontrado CPF cadastrado para o aglomerado informado. Favor trocar o CPF."
				Else
					Help(,,'CPF',,"Não foi encontrado CPF cadastrado para o aglomerado informado.",1,0,,,,,,{'Favor trocar o CPF.'})
					lRet     := .F.
				EndIf
			EndIf
			SZQ->(DBCLOSEAREA())
		EndIf
		DbSelectArea('SZQ')
		SZQ->(DBSETORDER( 4 )) //ZQ_CPFUSER+ZQ_CLVL+ZQ_LOCAL
		//Verifica se o CPF está cadastrado para o mesmo aglomerado e local de estoque
		If !dbSeek(cCpfSolic+cAglo+cLocal)
			// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
				// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + 'Não foi encontrado CPF cadastrado para o local de estoque informado.'),;
				// 	OemToAnsi("Favor trocar o CPF."))
			If lJob
				cMsgErr := "(CPF): Não foi encontrado CPF cadastrado para o local de estoque (" + cLocal + ") informado. Favor trocar o CPF."
			Else
				Help(,,'CPF',,"Não foi encontrado CPF cadastrado para o local de estoque informado.",1,0,,,,,,{'Favor trocar o CPF.'})
				lRet     := .F.
			EndIf
		EndIf
		SZQ->(DBCLOSEAREA())
	EndIf

	//Validar Grid dos itens
	If lRet
		If lJob
			nLen := nQtItm
		Else
			nLen := oSZPD:Length()
		EndIf

		For nJ := 1 to nLen
			If lJob
				cChv := xFilial("SZP") + PadR(oModel[2],TAMSX3("ZP_NUM")[1]) + StrZero(nJ,2)
				If SZP->(DbSeek(cChv))
					cProdt   := SZP->ZP_PRODUTO
					cLoteCtl := SZP->ZP_LOTECTL
					nQuant   := SZP->ZP_QUANT
					cEpiFun  := SZP->ZP_EPIFUN
					cTarOs   := SZP->ZP_TAREOS
					cEtaOs   := SZP->ZP_ETAPOS
				EndIf
			Else
				oSZPD:GoLine(nJ)
				If !oSZPD:IsDeleted()
					cProdt   := oSZPD:GetValue("ZP_PRODUTO")
					cLoteCtl := oSZPD:GetValue("ZP_LOTECTL")
					nQuant   := oSZPD:GetValue("ZP_QUANT")
					cEpiFun  := oSZPD:GetValue("ZP_EPIFUN")
					cTarOs   := oSZPD:GetValue("ZP_TAREOS")
					cEtaOs   := oSZPD:GetValue("ZP_ETAPOS")
				EndIf
			EndIf

			If !Empty(cNumOS) .and. At('OS', cNumOS) > 0

				If Empty(cTarOs) .or. Empty(cEtaOs)
				
					lRet := .F.

					If lJob
						cMsgErr := "Quando é informado Ordem de Produção referente à Ordem de Serviço deve ser informado o código da Tarefa e Etapa, verifique os dados da (linha: " + cValToChar(__s) + ")!. Informe a Tarefa e a Etapa da Ordem de Serviços!"
					Else
						Help(Nil, Nil, "Ordem de Serviço", Nil, "Quando é informado Ordem de Produção referente à Ordem de Serviço deve ser informado o código da Tarefa e Etapa, verifique os dados do (item: " + cValToChar(__s) + ")!", 1, 0, Nil, Nil, Nil, Nil, Nil, {"Informe a Tarefa e a Etapa da Ordem de Serviços!"})
					EndIf
					
					Exit
				EndIf

			EndIf

			If lRet
				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				SB1->(DbGoTop())
				If SB1->(DbSeek(xFilial("SB1") + cProdt))
					cGrpPrd := SB1->B1_GRUPO
					If SB1->B1_RASTRO == "L" .And. Empty(cLoteCtl) .And. U_YGETNPAR("MV_RASTRO", "N") == "S" // Alexandre Bastos - 10/09/2021 - #452755 - adicionado validação MV_RASTRO também, para validar junto com B1_RASTRO
						// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
							// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "O Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +" controla lote, favor informar o Lote (ZP_LOTECTL)"),;
							// 	OemToAnsi('Verifique o lote do produto informado!'))
						lRet := .F.
						If lJob
							cMsgErr := "(Lote): O Produto: "+ AllTrim(cProdt) + " controla lote, favor informar o Lote (ZP_LOTECTL). Verifique o lote do produto informado!"
						Else
							Help(,,'Lote',,"O Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +" controla lote, favor informar o Lote (ZP_LOTECTL)",1,0,,,,,,{'Verifique o lote do produto informado!'})
						EndIf
						Exit
					EndIf
					
					//Higor.Boas 11/01/2023 - Adicionado Validação de Grupo de Produto x Usuario - Bloqueio de Mov. de Gado.  #Chamado: 779225
					If !IsBlind() .And. !Empty(cGrpPrd)
						If cGrpPrd $ cGrpMv
							If .Not. __cUserId $ cUsrEstMv
								lRet := .F.
								Help(,,'Grupo Prod. Bovinos',,"O Produto: "+ AllTrim(cProdt) +" com o Grupo : " + Alltrim(cGrpPrd) + " Possui Restrição de Acesso por Usuario.",1,0,,,,,,{'Usuário não tem acesso a movimentar esse Grupo de Produto, Configurar parametro (MV_YUBXBOV).'})
								Exit
							Endif
						Endif
					Endif                

					If !Empty(SB1->B1_YGPEPIR) .And. Empty(cEpiFun)
						// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
							// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "O Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +" controla EPI, favor informar o Funcionário (ZP_EPIFUN)"),;
							// 	OemToAnsi('Verifique funcionario informado!'))
						lRet := .F.
						If lJob
							cMsgErr := "(Funcionario): O Produto: "+ AllTrim(cProdt) + " controla EPI, favor informar o Funcionario (ZP_EPIFUN). Verifique funcionario informado!"
						Else
							Help(,,'Func',,"O Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +" controla EPI, favor informar o Funcionário (ZP_EPIFUN)",1,0,,,,,,{'Verifique funcionario informado!'})
						EndIf
						Exit
					EndIf
				EndIf

				DbSelectArea("SBM")
				SBM->(DbSetOrder(1))
				SBM->(DbGoTop())
				If SBM->(DbSeek( xFilial("SBM",cFilZP) + cGrpPrd ))
					aTmp1 := U_LINCOL( SBM->BM_YTMGRUP , ";" )
					If Len(aTmp1) > 0  //se tiver a TM
						lRet := VldTm(aTmp1,cTm)
						If !lRet
							cMsgTM := GetTm(aTmp1)
							// u_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+;
								// 	Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+;
								// 	Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10)+;
								// 	"PROBLEMA!"+Chr(13)+Chr(10)+ "O Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +", nao esta autorizado para esta TM."),OemToAnsi("SOLUCAO!"+Chr(13)+Chr(10)+;
								// 	"Favor utilizar uma das seguintes TMs "+Alltrim(cMsgTM)+"."))
							If lJob
								cMsgErr := "(TM): O Produto: "+ AllTrim(cProdt) + ", nao esta autorizado para esta TM. Favor utilizar uma das seguintes TMs " + Alltrim(GetTm(aTmp1)) + "."
							Else
								Help(,,'TM',,"O Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +", nao esta autorizado para esta TM.",1,0,,,,,,{"Favor utilizar uma das seguintes TMs "+Alltrim(cMsgTM)+"."})
							Endif
							Exit
						EndIf
					Else
						// u_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+;
							// 	Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+;
							// 	Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10)+;
							// 	"PROBLEMA!"+Chr(13)+Chr(10)+ "O Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +", nao existe TM associada ao grupo de produto "+cGrpPrd),OemToAnsi("SOLUCAO!"+Chr(13)+Chr(10)+;
							// 	"Favor procurar responsavel pelo cadastro."))
						lRet := .F.
						If lJob
							cMsgErr := "(TM): O Produto: "+ AllTrim(cProdt) + ", nao existe TM associada ao grupo de produto " + cGrpPrd + ". Favor procurar responsavel pelo cadastro."
						Else
							Help(,,'TM',,"O Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +", nao existe TM associada ao grupo de produto " + cGrpPrd,1,0,,,,,,{"Favor procurar responsavel pelo cadastro."})
						Endif
						Exit
					EndIf
				EndIf

				DbSelectArea("SB2")
				SB2->(DbSetOrder(1))
				If SB2->(DbSeek(xFilial("SB2",cFilZP) + cProdt  + cLocal))
					nSaldo := SALDOSB2()
					If nSaldo <= 0
						// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
							// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +", sem saldo em estoque !"),;
							// 	OemToAnsi('Verifique o saldo do produto!'))
						lRet := .F.
						If lJob
							cMsgErr := "(Saldo): Produto: "+ AllTrim(cProdt) + ", sem saldo em estoque. Verifique o saldo do produto!"
						Else
							Help(,,'Saldo',,"Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +", sem saldo em estoque !",1,0,,,,,,{'Verifique o saldo do produto!'})
						EndIf
						Exit
					ElseIf nSaldo < nQuant
						// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
							// 	(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +", o saldo em estoque ("+ cValToChar(nSaldo) +") é menor que a quantidade solicitada ("+ cValToChar(nQuant) +")"),;
							// 	OemToAnsi('Verifique a quantidade solicitada!'))
						lRet := .F.
						If lJob
							cMsgErr := "(Saldo): Produto: " + AllTrim(cProdt) + ", o saldo em estoque (" + cValToChar(nSaldo) + ") é menor que a quantidade solicitada (" + cValToChar(nQuant) + "). Verifique a quantidade solicitada!"
						Else
							Help(,,'Saldo',,"Produto: " + AllTrim(cProdt) + " da linha " + cValToChar(nJ) + ", o saldo em estoque (" + cValToChar(nSaldo) + ") é menor que a quantidade solicitada (" + cValToChar(nQuant) + ")",1,0,,,,,,{'Verifique a quantidade solicitada!'})
						EndIf
						Exit
					
					ElseIf nSaldo > nQuant
						
						If lAZGesTra

							lRet := U_ES04JLPR(lJob, cNumOs, cProdt, nQuant, nJ, @cMsgErr,,, cTarOs, cEtaOs)

							If !lJob
							
								If lRet .and. !Empty(cMsgErr)
									lRet := .F.
									Help(,,'Quantidade',, cMsgErr,1,0,,,,,,{'Verifique a quantidade solicitada!'})
									Exit
								ElseIf !lRet
									Help(,,'Quantidade',, cMsgErr,1,0,,,,,,{'Verifique a quantidade solicitada!'})
									Exit
								EndIf
								
							EndIf

						EndIf

					EndIf
				Else
					//Chamado 117065 Data: 16/08/2019 Jared Ribeiro - Se não existir, cria a SB2 e retorna saldo zerado
					CriaSB2(cProdt, cLocal)
					// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
						// 		(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +", sem saldo em estoque !"),;
						// 		OemToAnsi('Verifique o saldo do produto!'))
					lRet := .F.
					If lJob
						cMsgErr := "(Saldo): Produto: "+ AllTrim(cProdt) + ", sem saldo em estoque. Verifique o saldo do produto!"
					Else
						Help(,,'Saldo',,"Produto: "+ AllTrim(cProdt) +" da linha "+ cValToChar(nJ) +", sem saldo em estoque !",1,0,,,,,,{'Verifique o saldo do produto!'})
					EndIf
					Exit
				EndIf

				DbSelectArea("SF5")
				SF5->(DbSetOrder(1))
				SF5->(DbGoTop())
				If SF5->(DbSeek(xFilial("SF5",cFilZP) + cTm))
					//TM - OS
					If SF5->F5_YOBBEM $ '3|5'

						If !Empty(cOp) .And. At('OS', cOp) > 0 
						
							If Empty(cTarOs) .And. !Empty(cNumOs)

								lRet :=	.F.

								If lJob
									cMsgErr := "(Tarefa): Não está informado a Tarefa da OS (Ordem de Serviço). Informe o código da Tarefa!"
								Else
									Help(,,'Tarefa',,"Não está informado a Tarefa da OS (Ordem de Serviço)",1,0,,,,,,{'Informe o código da Tarefa!'})
								EndIf

								Exit

							ElseIf !Empty(cTarOs) .and. !U_BFMA08HS(cOp, cTarOs, cProdt, .F.)

								lRet :=	.F.

								If lJob
									cMsgErr := "(Tarefa): A Tarefa informada nao esta relacionada com a OS informada no campo (Ordem de Produção) e com o Produto da Linha (" + cValToChar(nJ) + "). Informe uma tarefa relacionada a OS!"
								Else
									Help(,,'Tarefa',,'A Tarefa informada não está relacionada com a OS informada no campo "Ordem de Produção" e com o Produto da Linha (' + cValToChar(nJ) + ').',1,0,,,,,,{'Informe uma tarefa relacionada a OS!'})
								EndIf

								Exit

							ElseIf Empty(cEtaOs) .And. !Empty(cNumOs)

								lRet :=	.F.

								If lJob
									cMsgErr := "(Etapa): Não está informado a Etapa da OS (Ordem de Serviço). Informe o código da Etapa!"
								Else
									Help(,,'Etapa',,"Não está informado a Etapa da OS (Ordem de Serviço)",1,0,,,,,,{'Informe o código da Etapa!'})
								EndIf

								Exit

							ElseIf !Empty(cEtaOs) .and. !U_BFMA45HS(cOp, cTarOs, cEtaOs, cProdt, .F.)

								lRet :=	.F.

								If lJob
									cMsgErr := "(Etapa): A Etapa informada nao esta relacionada com a OS informada no campo (Ordem de Produção) e com a Tarefa e Produto da Linha (" + cValToChar(nJ) + "). Informe uma Etapa relacionada a OS!"
								Else
									Help(,,'Etapa',,'A Etapa informada não está relacionada com a OS informada no campo "Ordem de Produção" e com a Tarefa e Produto da Linha (' + cValToChar(nJ) + ').',1,0,,,,,,{'Informe uma Etapa relacionada a OS!'})
								EndIf

								Exit

							EndIf

						ElseIf Empty(cOp) .And. !Empty(cTarOs) .And. !Empty(cNumOs)

							lRet :=	.F.

							If lJob
								cMsgErr := "(OS): Esta informado a Tarefa, mas nao esta informado o numero da OS no campo (Ordem de Produção). Informe o número da OS no campo (Ordem de Produção)"
							Else
								Help(,,'OS',,'Está informado a Tarefa, mas não está informado o numero da OS no campo "Ordem de Produção".',1,0,,,,,,{'Informe o número da OS no campo "Ordem de Produção"'})
							EndIf

							Exit

						ElseIf Empty(cOp) .And. !Empty(cEtaOs) .And. !Empty(cNumOs)

							lRet :=	.F.

							If lJob
								cMsgErr := "(OS): Esta informado a Etapa, mas nao esta informado o numero da OS no campo (Ordem de Produção). Informe o número da OS no campo (Ordem de Produção)"
							Else
								Help(,,'OS',,'Está informado a Etapa, mas não está informado o numero da OS no campo "Ordem de Produção".',1,0,,,,,,{'Informe o número da OS no campo "Ordem de Produção"'})
							EndIf

							Exit

						ElseIf Empty(cOp) .And. Empty(cCC) .And. !U_BFMN04WK('3') //Nao for projeto

							lRet :=	.F.

							If lJob
								cMsgErr := "(CC): O centro de custo não foi informado, favor verificar. Informe o centro de custo!"
							Else
								Help(,,'CC',,'O centro de custo não foi informado, favor verificar!',1,0,,,,,,{'Informe o centro de custo!'})
							EndIf

							Exit

						EndIf

					EndIf

				EndIf
				
				//549691 - Job almoxarifado - CC x Algomerado
				If ChkFile("ZZH") .And. !Empty(cCc)
					_cEmpZZH  := PadR(cEmpAnt,TamSx3("ZZH_GRPEMP")[1])
					_cFilZZH  := PadR(cFilAnt,TamSx3("ZZH_FIL")[1])
					_cTodos   := PadR("*",TamSX3("ZZH_AGLOM")[1])
					DbSelectArea("ZZH")
					ZZH->(DbSetOrder(1))
					ZZH->(DbGoTop())
					If .Not. ZZH->(DbSeek(_cEmpZZH + _cFilZZH + cAglo + cCc)) .And. .Not. ZZH->(DbSeek(_cEmpZZH + _cFilZZH + _cTodos + cCc))
						If lJob
							cMsgErr := "Centro de Custo não válido, favor verificar amarração entre Aglomerado x CC (ZZH)"
						Else
							Aviso("Agl. x CC","Centro de Custo não válido, favor verificar amarração entre Aglomerado x CC (ZZH), Verifique o Codigo informado!",{"OK"},1)
						EndIf
						lRet := .F.
						Exit
					Else
						If ZZH->ZZH_MSBLQL <> "2"
							If lJob
								cMsgErr := "O Centro de Custo bloqueado ("+ AllTrim(cCc) +"), favor verificar amarração entre Aglomerado x CC (ZZH)"
							Else
								Aviso("Agl. x CC","O Centro de Custo bloqueado ("+ AllTrim(cCc) +"), favor verificar amarração entre Aglomerado x CC (ZZH), Verifique o Codigo informado!",{"OK"},1)
							EndIf
							lRet := .F.
							Exit
						EndIf
					EndIf
				EndIf
				
			EndIf
		Next
	EndIf

	RestArea(aAreaF5)
	RestArea(aAreaB2)
	RestArea(aAreaB1)
	RestArea(aAreaBM)
	RestArea(aAreaZZY)
	RestArea(aAreaZZH)
	RestArea(aArea)

	If lJob
		lcRet := cMsgErr
	Else
		lcRet := lRet
	EndIf

Return(lcRet)


/*/{Protheus.doc} BFES04JB
@description Funcao para Gerar e baixar pre-requisicoes

@author 	Jose Leite de Barros Neto
@since 		09/07/2019
@Obs 		Uso BOM FUTURO
/*/
User Function BFES04JB(oModel, lJob)
	Local __stt     := u___stt(procname(0),"BFES04JL")

	Local lRet		:= .T.
	Local aArea 	:= GetArea()
	Local aAreaB1	:= SB1->(GetArea())
	Local aAreaCP	:= SCP->(GetArea())
	Local nOpcx    	:= 0
	Local cNumero  	:= ""
	Local aCab	   	:= {}
	Local dDtEmis  	:= dDataBase
	Local aItens	:= {}
	Local cItem	   	:= ""
	Local cProduto 	:= ""
	Local nQuant   	:= 0
	Local cLocal	:= ""
	Local cCentroC	:= ""
	Local cObs		:= ""
	Local cAglom	:= ""
	Local cTm		:= ""
	Local cBem		:= ""
	Local cCodEqu	:= ""
	Local cProjeto 	:= ""
	Local cOp		:= ""
	Local cTarOs	:= ""
	Local cEtaOs	:= ""
	Local cNumOs	:= ""
	Local cMarca	:= ""
	Local lMarkB 	:= .T.
	Local lDtNec 	:= .F.
	Local bFiltro
	Local cFiltraSCP:= ""
	Local lConsSPed	:= .T.
	Local lGeraSC1	:= .T.
	Local lAmzSA	:= .T.
	Local lLtEco	:= .F.
	Local lConsEmp	:= .F.
	Local nAglutSC	:= 3
	Local cLoteCtl  := ""
	Local cNumLote  := ""
	Local dDtLote	:= CtoD("  /  /  ")
	Local cFunEpi	:= ""
	Local cFunCpf	:= ""
	Local cFunCha	:= ""
	Local cFunInt	:= ""
	// Chamado 104405- Autor: Alexandre Lima
	Local lVistAtv  := U_YGETNPAR("MV_YVISTOK", .F.)
	Local cCpfRetira:= ""
	Local cQuery    := ""

	Local oSZP 		:= Nil
	Local cSolic   	:= ""
	Local cChv		:= ""
	Local cSts      := ""
	Local cNumSap   := ""

	Local clRet     := Nil
	Local cRet      := Nil
	Local cNumBEM  := ""
	Local cMemoXml          := ""

	Private lMSHelpAuto	:= .F.
	Private lMsErroAuto := .F.
	Private __lUsStj 	:= .T. //Fluig 736461 - Variavel utilizada no pe MTA105OK - não remover
	
	Default lJob    := .F.

	If lJob
		cChv := xFilial("SZP") + PadR(oModel[2],TAMSX3("ZP_NUM")[1])
	Else
		oSZP := oModel:GetModel("SZPMASTER")
		cChv := xFilial("SZP") + SZP->ZP_NUM
	EndIf

	DbSelectArea( "SB1" )
	SB1->( dbSetOrder( 1 ) )

	DbSelectArea( "SCP" )
	SCP->( dbSetOrder( 1 ) )

	Begin Transaction
		DbSelectArea("SZP")
		SZP->(DbSetOrder(1)) //ZP_FILIAL+ZP_NUM+ZP_ITEM+DTOS(ZP_EMISSAO)
		If SZP->(DbSeek(cChv))
			
			cSolic  := SZP->ZP_SOLICIT
			cSts    := SZP->ZP_STATUS
			cNumSap := SZP->ZP_NUMSAP

			//---------- Inclusao de Solicitacao de Armazem --------------
			If Empty(cSts) .And. Empty(cNumSap)
				nOpcx := 3
				nSaveSx8 := GetSx8Len()
				cNumero  := GetSxENum("SCP","CP_NUM")
				While SCP->( dbSeek( xFilial( "SCP" ) + cNumero ) )
					ConfirmSx8()
					cNumero := GetSxENum("SCP", "CP_NUM")
				EndDo
				//---------- Alteracao/delecao de Solicitacao de Armazem -------------
			Else
				nOpcx := 4
				cNumero := SZP->ZP_NUMSAP

				If SCP->(DBSeek(xFilial("SCP") + cNumero)) // Alexandre Bastos - 27/05/2021 - #386708 - adicionado validacao para confirmar a existencia do SCP, caso não encontre muda para inclusao
					dDtEmis := SCP->CP_EMISSAO
				else
					nOpcx := 3
					nSaveSx8 := GetSx8Len()
					cNumero  := GetSxENum("SCP","CP_NUM")
					While SCP->( dbSeek( xFilial( "SCP" ) + cNumero ) )
						ConfirmSx8()
						cNumero := GetSxENum("SCP", "CP_NUM")
					EndDo
				endif
			EndIf

			aCab := {}
			Aadd( aCab, { "CP_NUM" 		,cNumero 	, Nil })
			Aadd( aCab, { "CP_EMISSAO" 	,dDtEmis 	, Nil })
			Aadd( aCab, { "CP_SOLICIT" 	,cUserName 	, Nil }) // Verificar se está atrapalhando

			aItens   := {}

			While .Not. SZP->(Eof()) .And. cChv == SZP->ZP_FILIAL + SZP->ZP_NUM

				If Select("TZZY")
					TZZY->(DbCloseArea())
				EndIf
				cItem	 := SZP->ZP_ITEM
				cProduto := SZP->ZP_PRODUTO
				nQuant	 := SZP->ZP_QUANT
				cObs	 := SZP->ZP_OBS
				cCodEqu	 := SZP->ZP_CODPFAB
				cTarOs	 := SZP->ZP_TAREOS
				cEtaOs	 := SZP->ZP_ETAPOS
				cLoteCtl := SZP->ZP_LOTECTL
				cNumLote := SZP->ZP_NUMLOTE
				dDtLote	 := SZP->ZP_DTVALID
				cFunEpi  := SZP->ZP_EPIFUN
				cFunCpf  := SZP->ZP_CPF
				cFunCha  := SZP->ZP_CHAPA
				cFunInt  := SZP->ZP_INTTER
				
				If Empty(cCodEqu)
					cCodEqu := AllTrim(Posicione("ZZY", 1, XFILIAL("ZZY") + cProduto, "ZZY_CODEQU"))
				EndIf 
				
				If lJob
					cLocal	 := SZP->ZP_LOCAL
					cCentroC := SZP->ZP_CC
					cAglom	 := SZP->ZP_CLVL
					cTm		 := SZP->ZP_TM
					cBem	 := SZP->ZP_CODBEM
					cProjeto := SZP->ZP_CODPROJ
					cOp		 := SZP->ZP_OP
					cNumOs	 := SZP->ZP_NUMOS
					cCpfRetira := cSolic     			     // chamado 656490

				Else
					cLocal	 := oSZP:GetValue("ZP_LOCAL")
					cCentroC := oSZP:GetValue("ZP_CC")
					cAglom	 := oSZP:GetValue("ZP_CLVL")
					cTm		 := oSZP:GetValue("ZP_TM")
					cBem	 := oSZP:GetValue("ZP_CODBEM")
					cProjeto := oSZP:GetValue("ZP_CODPROJ")
					cOp		 := oSZP:GetValue("ZP_OP")
					cNumOs	 := oSZP:GetValue("ZP_NUMOS")
					cCpfRetira := oSZP:GetValue("ZP_SOLICIT") // chamado 656490
				EndIf

				Aadd( aItens, {} )
				Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" 	,cItem 		, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,cProduto	, Nil } )
				If !Empty(cCodEqu)
					Aadd( aItens[ Len( aItens ) ],{"CP_CODPFAB" ,cCodEqu	, Nil } )
				EndIf
				Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" 	,nQuant 	, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_LOCAL" 	,cLocal 	, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_CC" 		,cCentroC 	, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_OBS"		,cObs 		, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_CLVL"	,cAglom 	, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_YTM"		,cTm 		, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_YCODBEM" ,cBem 		, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_YCODPRJ" ,cProjeto	, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_OP" 		,cOp 		, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_YTAREOS" ,cTarOs 	, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_YETAPOS" ,cEtaOs 	, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_NUMOS" 	,cNumOs 	, Nil } )
				Aadd( aItens[ Len( aItens ) ],{"CP_YCODBEM"	,cNumBEM 	, Nil } )

				If !Empty(cProjeto)
					cTipoProj := Posicione("AF8", 1, xFilial("AF8")+cProjeto,"AF8_TPPRJ")
					Aadd( aItens[ Len( aItens ) ],{"CP_CONTA",alltrim(Posicione("ZAW",1,xFilial("ZAW")+cTipoProj,"ZAW_CONTA")),Nil })
				EndIf

				//Jose Leite - 126857 - Baixar produtos que controlam lote
				If !Empty(cLoteCtl)
					Aadd( aItens[ Len( aItens ) ],{"CP_LOTECTL" ,cLoteCtl	, Nil } )
					Aadd( aItens[ Len( aItens ) ],{"CP_NUMLOTE" ,cNumLote 	, Nil } )
					Aadd( aItens[ Len( aItens ) ],{"CP_DTVALID" ,dDtLote 	, Nil } )
				EndIf

				//Jose Leite - 126857 - Baixar produtos que controlam lote
				If !Empty(cFunEpi)
					Aadd( aItens[ Len( aItens ) ],{"CP_YEPIFUN" , cFunEpi	, Nil } )
					Aadd( aItens[ Len( aItens ) ],{"CP_YCPF"    , cFunCpf	, Nil } ) 
					Aadd( aItens[ Len( aItens ) ],{"CP_YCHAPA"  , cFunCha	, Nil } )
					Aadd( aItens[ Len( aItens ) ],{"CP_YINTERN" , cFunInt	, Nil } )
				EndIf

				If lVistAtv 		// chamado 656490
					Aadd( aItens[ Len( aItens ) ],{"CP_YCPFRET" ,cCpfRetira , Nil } )
				EndIf

				//Atualiza dados da SZP - pelo mvc estava gravando somente na primeira linha
				If RecLock("SZP",.F.)
					SZP->ZP_STATUS  := "B"
					SZP->ZP_NUMSAP  := cNumero
					SZP->ZP_CODPFAB := cCodEqu
					SZP->ZP_LOCAL	:= cLocal
					SZP->ZP_CC		:= cCentroC
					SZP->ZP_TM		:= cTm
					SZP->ZP_CODBEM  := cBem
					SZP->ZP_CODPROJ	:= cProjeto
					SZP->ZP_OP		:= cOp
					SZP->ZP_NUMOS	:= cNumOs
					SZP->ZP_SOLICIT := cCpfRetira
					If !Empty(cLoteCtl)
						SZP->ZP_LOTECTL	:= cLoteCtl
						SZP->ZP_NUMLOTE	:= cNumLote
						SZP->ZP_DTVALID	:= dDtLote
					EndIf
					If !Empty(cFunEpi)
						SZP->ZP_EPIFUN := cFunEpi
						SZP->ZP_CPF    := cFunCpf
						SZP->ZP_CHAPA  := cFunCha
						SZP->ZP_INTTER := cFunInt
					EndIf
					SZP->(MsUnlock())
				EndIf

				SZP->(DbSkip())
			End

			If Len(aCab) > 0 .And. Len(aItens) > 0

				lMSHelpAuto := .F.
				lMsErroAuto := .F.

				MsExecAuto( { |x,y,z| MATA105(x,y,z) }, aCab, aItens , nOpcx )

				If lMsErroAuto
					If !__lSX8
						RollBackSx8()
					EndIf
					lRet := .F.
					DisarmTransaction()
					If lJob
						cMemoXml := MemoRead(NomeAutoLog())
						DbSelectArea("SZP")
						SZP->(DbSetOrder(1))
						If SZP->(DbSeek(xFilial("SZP") + oModel[2]))  // filial + num + item + emissao
							If RecLock("SZP",.F.)
								SZP->ZP_MSGINT := cMemoXml
								SZP->(MsUnlock())
							EndIf
						EndIf
						SZP->(DbCloseArea())

					Else
						MostraErro()
					EndIf
					Return lRet
				Else
					ConfirmSx8()
					cChv := xFilial("SCP") + cNumero
					DbSelectArea("SCP")
					SCP->(dbSetOrder(1))
					If SCP->(DbSeek(xFilial("SCP") + cNumero))
						While .Not. SCP->(Eof()) .And. cChv == SCP->CP_FILIAL + SCP->CP_NUM
							cMarca	 := GetMark()
							If RecLock("SCP",.F.)
								SCP->CP_OK := cMarca
								SCP->CP_YCODBEM := cBem
								SCP->(MsUnlock())
							EndIf
							cFiltraSCP := "(CP_FILIAL == '"+ xFilial("SCP") +"' .And. CP_NUM == '"+ cNumero +"' .And. CP_ITEM == '"+  SCP->CP_ITEM +"' )"
							bFiltro := {|| &cFiltraSCP}

							//Gera Pre Requisicao
							If lJob
								U_xMaSaPre(lMarkB,lDtNec,bFiltro,lConsSPed,lGeraSC1,lAmzSA,cLocal,cLocal,lLtEco,lConsEmp,nAglutSC,cMarca)
							Else
								Processa({|lEnd| U_xMaSaPre(lMarkB,lDtNec,bFiltro,lConsSPed,lGeraSC1,lAmzSA,cLocal,cLocal,lLtEco,lConsEmp,nAglutSC,cMarca)}, "Aguarde...", "Gerando Pre-Requisição - Item "+ SCP->CP_ITEM,.F.)
							EndIf

							//Baixa Requisicoes - gerando sd3
							If SCP->CP_PREREQU == "S"
								// Alexandre Lima - Chamado 104405
								If lVistAtv
									If (Select("TSZQ") > 0)
										TSZQ->(dbCloseArea())
									EndIf

									// Busco o grupo aprovador relacionado ao cpf do usuário e com base no aglomerado
									cQuery := " SELECT zq_graprov as GRUPO FROM "+RetSqlName("SZQ")+" szq"+CRLF
									cQuery += " WHERE szq.zq_cpfuser = '"+cCpfRetira+"' AND szq.d_e_l_e_t_ = ' ' "+CRLF
									cQuery += " AND szq.zq_clvl = '"+cAglom+"' "
									TcQuery cQuery New Alias "TSZQ"

									// Gravo na SCQ o CPF do solicitante e grupo aprovador
									dbSelectArea("SCQ")
									SCQ->(DbSetOrder(1))
									SCQ->(dbSeek(xFilial("SCP")+ cNumero+SCP->CP_ITEM))
									If RecLock("SCQ",.F.)
										SCQ->CQ_NUMSZP 	  :=   cNumero
										SCQ->CQ_YCPFRET   :=   cCpfRetira
										SCQ->CQ_YGRVIST	  :=   TSZQ->GRUPO
										SCQ->(MSUNLOCK())
									EndIf

								EndIf
								If lJob
									lRet := fBxPrReq(.T.)
								Else
									Processa({|lEnd| lRet := fBxPrReq(.F.)}, "Aguarde...", "Baixando Pre-Requisição",.F.)
								EndIf
								If !lRet
									DisarmTransaction()
									Exit
								EndIf
							Else
								DisarmTransaction()
								lRet := .F.
								Exit
							EndIf
							SCP->(DbSkip())
						End
					EndIf
				EndIf
			EndIf
		EndIf
	End Transaction

	RestArea(aAreaCP)
	RestArea(aAreaB1)
	RestArea(aArea)
lJob

	If lJob
		clRet := cRet
	Else
		clRet := lRet
	EndIf

Return(clRet)


/*/{Protheus.doc} fBxPrReq
@description Funcao para baixar pre-requisicoes

@param      lJob .T. executado via Job | .F. executado via sol. arm. mod2
@author 	Jose Leite de Barros Neto
@since 		09/07/2019
@Obs 		Uso BOM FUTURO
/*/
Static Function fBxPrReq(lJob)

	Local __stt     := u___stt(procname(0),"BFES04JL")
	Local lRet		:= .T.
	Local cYOBBEM 	:= ""
	Local cRet		:= .T.
	Local dDtEmis  	:= dDataBase
	Local cNumD3 	:= ""
	Local aCpoSCP	:= {}
	Local aCpoSD3	:= {}
	Local nOpcAuto	:= 1
	Local lMAGesTra := U_BFMA15HS()
	Local aFornec   := U_GtSAXtoSM0('SA2', Alltrim(StrTran(StrTran(StrTran(SM0->M0_CGC,'.',''),'/',''),'-','')), Alltrim(StrTran(StrTran(StrTran(SM0->M0_INSC,'.',''),'/',''),'-','')))

	Default lJob    := .F.

	cNumD3 := GetSxeNum('SD3','D3_DOC')

	aCpoSCP := {{"CP_NUM"		,SCP->CP_NUM   	 	,Nil },;
				{"CP_ITEM"		,SCP->CP_ITEM   	,Nil },;
				{"CP_QUANT"		,SCP->CP_QUANT  	,Nil }}


	Aadd( aCpoSD3,{"D3_DOC"		,cNumD3  			,Nil }) // No.do Docto.
	Aadd( aCpoSD3,{"D3_TM"		,SCP->CP_YTM		,Nil }) // Tipo do Mov.
	Aadd( aCpoSD3,{"D3_COD"		,SCP->CP_PRODUTO	,Nil }) // Cod Produto
	Aadd( aCpoSD3,{"D3_LOCAL" 	,SCP->CP_LOCAL   	,Nil }) // Local
	Aadd( aCpoSD3,{"D3_EMISSAO"	,dDtEmis        	,Nil }) // Data Emissao
	Aadd( aCpoSD3,{"D3_NUMSA"	,SCP->CP_NUM		,Nil }) // Num SA
	Aadd( aCpoSD3,{"D3_ITEMSA"	,SCP->CP_ITEM		,Nil }) // Item SA
	Aadd( aCpoSD3,{"D3_YCODBEM" ,SCP->CP_YCODBEM 	,Nil }) // Cod Bem
	Aadd( aCpoSD3,{"D3_CODPROJ" ,SCP->CP_YCODPRJ	,Nil }) // Codigo do Projeto
	Aadd( aCpoSD3,{"D3_CC" 		,SCP->CP_CC			,Nil }) // Centro Custo
	Aadd( aCpoSD3,{"D3_YCODBEM"	,SCP->CP_YCODBEM	,Nil }) // Codigo do Bem
	Aadd( aCpoSD3,{"D3_CONTA"	,SCP->CP_CONTA		,Nil }) // Conta Contabil
	Aadd( aCpoSD3,{"D3_OP" 		,SCP->CP_OP			,Nil }) // OP
	
	//Fluig 736461
	If __lUsStj
		Aadd( aCpoSD3,{"D3_ORDEM"	,SCP->CP_NUMOS		,Nil }) // OS
	EndIf
	
	//Jose Leite - 126857 - Baixar produtos que controlam lote
	If !Empty(SCP->CP_LOTECTL)
		Aadd( aCpoSD3,{"D3_LOTECTL"	,SCP->CP_LOTECTL	,Nil }) // Lote
		Aadd( aCpoSD3,{"D3_NUMLOTE"	,SCP->CP_NUMLOTE	,Nil }) // Num Lote
		Aadd( aCpoSD3,{"D3_DTVALID"	,SCP->CP_DTVALID	,Nil }) // Data Lote
	EndIf

	//Jose Leite - 126857 - Baixar produtos epi que controlam lote
	If !Empty(SCP->CP_YEPIFUN)
		Aadd( aCpoSD3,{"D3_YEPIFUN" ,SCP->CP_YEPIFUN, Nil } ) // Nome

		Aadd( aCpoSD3,{"D3_YCPF"    ,SCP->CP_YCPF   , Nil } ) // Chapa;Nome;CPF
		Aadd( aCpoSD3,{"D3_YCHAPA"  ,SCP->CP_YCHAPA , Nil } ) // Chapa;Nome;CPF
		Aadd( aCpoSD3,{"D3_YINTERN" ,SCP->CP_YINTERN, Nil } ) // Chapa;Nome;CPF

		Aadd( aCpoSD3,{"D3_YEPIINT" ,"N"			, Nil } ) // Integrado RM - N=Nao
	EndIf

	lMSHelpAuto := .F.
	lMsErroAuto := .F.
	__aErrAuto  := .T.

	MSExecAuto({|v,x,y,z| MATA185(v,x,y)},aCpoSCP,aCpoSD3,nOpcAuto)  // 1 = BAIXA (ROT.AUT)

	If lMsErroAuto
		lRet := .F.
		If !__lSX8
			RollBackSx8()
		EndIf
		If lJob
			lcRet := "Retornar error Log da rotina automatica"
			cMemoXml := MemoRead(NomeAutoLog())
			/// continuar aqui = preencher campo de log
			DbSelectArea("SZP")
			SZP->(DbSetOrder(1))
			If SZP->(DbSeek(xFilial(SCP) + SCP->CP_NUM + SCP->CP_ITEM + dDtEmis))  // filial + num + item + emissao
				If RecLock("SZP",.F.)
					SZP->ZP_MSGINT := cMemoXml
					SZP->(MsUnlock())
				EndIf
			EndIf
			SZP->(DbCloseArea())

		Else
			MostraErro()
		EndIf
	Else
		ConfirmSX8()
		//Jose Leite - 137253 - Gravar Tarefa da OS
		If !Empty(SCP->CP_OP)
			aAreaTL := STL->(GetArea())
			DbSelectArea("STL")
			STL->(DbSetOrder(7)) //TL_FILIAL+TL_NUMSEQ
			STL->(DbGoTop())
			If STL->(DbSeek(xFilial("STL")+SD3->D3_NUMSEQ))
				If RecLock("STL",.F.)

					STL->TL_TAREFA := SCP->CP_YTAREOS
					STL->TL_ETAPA  := SCP->CP_YETAPOS

					If lMAGesTra
						If Len(aFornec) > 1 .and. !Empty(aFornec[1]) .and. !Empty(aFornec[2])
							STL->TL_FORNEC := aFornec[1]
							STL->TL_LOJA   := aFornec[2]
						EndIf
					EndIf

					STL->(MsUnlock())
				EndIf
			EndIf
			RestArea(aAreaTL)
		Endif
	EndIf

	//If !lJob
	//	lcRet := lRet
	//EndIf

Return(lRet)
//Return(lcRet)

/*/{Protheus.doc} VldTm
@description Funcao para validar tipo de movimentacao

@author 	Jose Leite de Barros Neto
@since 		09/07/2019
@Obs 		Uso BOM FUTURO
/*/
Static Function VldTm(_aTmp1,_cTm/*,_cCp*/)

	Local __stt	:= u___stt(procname(0),"BFES04JL")
	Local _nI   := 0
	Local _lRet := .F.

	For _nI := 1 To Len(_aTmp1)
		If Alltrim(_cTm) == Alltrim(_aTmp1[_nI]) //compara se existe
			_lRet := .T.
		EndIf
	Next _nI

Return( _lRet )


/*/{Protheus.doc} GetTm
@description Funcao que monta as tm que poderao ser utilizadas

@author 	Jose Leite de Barros Neto
@since 		09/07/2019
@Obs 		Uso BOM FUTURO
/*/
Static Function GetTm(_aTmp1/*,_cCp*/)

	Local __stt := u___stt(procname(0),"BFES04JL")
	Local _cMsg := ""
	Local i     := 0

	For i = 1 to len(_aTmp1)
		_cMsg += _aTmp1[i]+ "/"
		If i == 9 // alterado para mostrar todas as TMS no help - Joao Tavares
			_cMsg += Chr(13)+Chr(10)
		EndIf
	Next i

Return ( _cMsg )


/*/{Protheus.doc} GetZZY
@description Função para retornar cod equivalente não bloqueado
@type  Function
@author Alexandre Lima
@since 08/11/2020
@version Protheus 12
@param cCodigo, Character, codigo Produto
@return cCodEqui, Character, Codigo Equivalente do produto
@example
(examples)
@see (links_or_references)
@obs Nil
/*/
Static Function GetZZY(cCodigo)

	Local __stt   := u___stt(procname(0),"BFES04JL")
	Local cCodEqui  := " "
	Local cQuery    := " "
	Local nCount    := 0

	If Upper(Alltrim(FunName()))=="MNTA420" .OR.  Upper(Alltrim(FunName()))=="BFES04JL"

		If Select("TZZY") > 0
			TZZY->(DbCloseArea())
		Endif
		cQuery := " SELECT * FROM  "+RetSqlName("ZZY")+" ZZY "+CRLF
		cQuery += " WHERE ZZY.D_E_L_E_T_ <> '*' AND ZZY.ZZY_COD = '"+cCodigo+"' "+CRLF
		cQuery += " AND ZZY.ZZY_MSBLQL <> '1' "
		TcQuery cQuery New Alias "TZZY"

		While TZZY->(!EoF())
			nCount++
			cCodEqui := TZZY->(ZZY_CODEQU)
			TZZY->(dbSkip())
		End

		If nCount > 1
			cCodEqui := " "
			// U_MsgBF(OemToAnsi(If((_nPos := At(".",cUserName))>0,Upper(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),1,1))+Lower(SubStr(Alltrim(SubStr(cUserName,1,(_nPos-1))),2,(Len(Alltrim(SubStr(cUserName,1,;
				// 		(_nPos-1))))-1))),Upper(SubStr(Alltrim(cUserName),1,1))+Lower(SubStr(Alltrim(cUserName),2,(Len(Alltrim(cUserName))-1))))+Chr(13)+Chr(10) + "Para este produto, existe mais de um codigo equivalente, favor verificar!"),;
				// 		OemToAnsi('Favor informar um codigo equivalente no campo: Cod.Equivale (ZP_CODPFAB)'))
			Help(,,'CodFab',,"Para este produto, existe mais de um codigo equivalente, favor verificar!",1,0,,,,,,{'Favor informar um codigo equivalente no campo: Cod.Equivale (ZP_CODPFAB)'})
		EndIf
	Else
		cCodEqui := " "
	EndIf

Return cCodEqui


/*/{Protheus.doc} ES04JLPR
@description Valida se a quantidade solicitada e Relizada das O

@type    Function
@author  Helitom Silva
@since   30/11/2021
@version 12.1.27

@param p_lJob, Logico, Se a execução é originada por Job
@param p_cNumOS, Caracter, Codigo da OS
@param p_cCodProd, Caracter, Codigo do Produto
@param p_nQuant, Numerico, Quantidade
@param p_nLinha, Caracter, Numero da linha
@param p_cMsgErr, Caracter, Mensagem para retorno do Job - deve ser passado variável por referencia neste parâmetro.
@param p_cFornece, Caracter, Codigo do Fornecedor.
@param p_cLoja, Caracter, Loja do Fornecedor.
@param p_cTarefa, Caracter, Codigo da Tarefa.
@param p_cEtapa, Caracter, Codigo da Etapa.

@return lRet, Logico, Se for válido retorna .T.

@example
(examples)
@see (links_or_references)
@obs Nil
/*/
User Function ES04JLPR(p_lJob, p_cNumOS, p_cCodProd, p_nQuant, p_nLinha, p_cMsgErr, p_cFornece, p_cLoja, p_cTarefa, p_cEtapa)

	Local __stt      := u___stt(procname(0),"BFES04JL")
	Local lRet 		 := .T.
	Local nSTLPre 	 := 0
	Local nSTLRea 	 := 0
	Local cAliasTMP  := GetNextAlias()
	Local aFornec    := U_GtSAXtoSM0('SA2', Alltrim(StrTran(StrTran(StrTran(SM0->M0_CGC,'.',''),'/',''),'-','')), Alltrim(StrTran(StrTran(StrTran(SM0->M0_INSC,'.',''),'/',''),'-','')))
	Local aOpLibOS   := {"Prosseguir", "Cancelar"}
	Local cTJYOBPIOS := ""
	Local lMVYORPOSR := U_YGETNPAR('MV_YORPOSR', .F.)
	Local cMVYCVLDIP := U_YGETNPAR('MV_YCVLDIP', '')
	Local aMVYCVLDIP := Strtokarr(cMVYCVLDIP, '|')
	Local cRelation  := ""
	Local nX		 := 0
	Local cCondMsg   := ''

	Default p_lJob     := .F.
	Default p_cNumOS   := ''
	Default p_cCodProd := ''
	Default p_nQuant   := 0
	Default p_nLinha   := 0
	Default p_cFornece := ''
	Default p_cLoja    := ''
	Default p_cTarefa  := ''
	Default p_cEtapa   := ''

	p_cMsgErr := ''

	p_cNumOS := Iif(At('OS', p_cNumOS) > 0, SubStr(p_cNumOS, 1, TamSX3('TJ_ORDEM')[1]), p_cNumOS)

	If Empty(p_cFornece)
		p_cFornece := aFornec[1]
	EndIf

	If Empty(p_cLoja)
		p_cLoja := aFornec[2]
	EndIf

	For nX := 1 to Len(aMVYCVLDIP)

		If aMVYCVLDIP[nX] == 'TL_FORNEC' .and. (.not. FunName() $ 'U_BFCO01FP' .and. .not. IsInCallStack('MATA110'))

			cRelation += " STL.TL_FORNEC = '" + p_cFornece + "' AND " + CR
			If isBlind()
				cCondMsg  += "Fonecedor: " + aFornec[1] + ". "
			Else
				cCondMsg  += "Fonecedor: " + aFornec[1] + CR
			EndIf

		ElseIf aMVYCVLDIP[nX] == 'TL_LOJA' .and. (.not. FunName() $ 'U_BFCO01FP' .and. .not. IsInCallStack('MATA110'))

			cRelation += " STL.TL_LOJA = '" + p_cLoja + "' AND " + CR
			If isBlind()
				cCondMsg  += "Loja: " + aFornec[2] + ". "
			Else
				cCondMsg  += "Loja: " + aFornec[2] + CR
			EndIf

		ElseIf aMVYCVLDIP[nX] == 'TL_TAREFA'

			cRelation += " STL.TL_TAREFA = '" + p_cTarefa + "' AND " + CR
			If isBlind()
				cCondMsg  += "Tarefa: " + AllTrim(p_cTarefa) + ". "
			Else
				cCondMsg  += "Tarefa: " + AllTrim(p_cTarefa) + CR
			EndIf

		ElseIf aMVYCVLDIP[nX] == 'TL_ETAPA'

			cRelation += " STL.TL_ETAPA = '" + p_cEtapa + "' AND " + CR
			If isBlind()
				cCondMsg  += "Etapa: " + AllTrim(p_cEtapa) + ". "
			Else
				cCondMsg  += "Etapa: " + AllTrim(p_cEtapa) + CR
			EndIf

		EndIf

	Next

	If !Empty(cRelation)
		cRelation := '%' + cRelation + '%'
	Else
		cRelation := '% 0 = 0 AND %'
	EndIf

	cAliasTMP := GetNextAlias()
	
	BeginSQL Alias cAliasTMP

		Column PREVISTO as Numeric(9,2)
		Column REALIZADO as Numeric(9,2)

		SELECT MAX(STJ.TJ_YOBPIOS) AS TJ_YOBPIOS,
				SUM(CASE WHEN STL.TL_SEQRELA = '0' THEN STL.TL_QUANTID ELSE 0 END) PREVISTO,
				SUM(CASE WHEN STL.TL_SEQRELA != '0' THEN STL.TL_QUANTID ELSE 0 END) REALIZADO
			FROM %TABLE:STJ% STJ
		LEFT JOIN %TABLE:STL% STL ON STL.TL_ORDEM   = STJ.TJ_ORDEM AND
										STL.TL_PLANO   = STJ.TJ_PLANO AND
										TRIM(STL.TL_CODIGO) = TRIM(%EXP:p_cCodProd%) AND
										%EXP:cRelation%
										STL.TL_FILIAL  = STJ.TJ_FILIAL AND
										STL.%NOTDEL% 
			WHERE STJ.TJ_ORDEM  = %EXP:p_cNumOS%
			AND STJ.TJ_FILIAL = %XFILIAL:STJ%
			AND STJ.%NOTDEL%

	EndSQL

	IdaGrvSQL('CONSULTA_INSUMOS_PREVISTOS', GetLastQuery()[2])

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())
	If .not. (cAliasTMP)->(EoF())
		cTJYOBPIOS := (cAliasTMP)->TJ_YOBPIOS
		nSTLPre    := (cAliasTMP)->PREVISTO
		nSTLRea    := (cAliasTMP)->REALIZADO
	EndIf

	(cAliasTMP)->(DbCloseArea())

	If cTJYOBPIOS = '1' .and. .not. nSTLPre > 0
		If isBlind()
			p_cMsgErr := "Produto: " + AllTrim(p_cCodProd) + Iif(p_nLinha > 0, " da linha " + cValToChar(p_nLinha), "") + ". " + cCondMsg + " A quantidade prevista (" + cValToChar(nSTLPre) + ") na OS não é suficiente para atender essa solicitação. Verifique a quantidade solicitada!"
		Else
			p_cMsgErr := "Produto: " + AllTrim(p_cCodProd) + Iif(p_nLinha > 0, " da linha " + cValToChar(p_nLinha), "") + CR + cCondMsg + "A quantidade prevista (" + cValToChar(nSTLPre) + ") na OS não é suficiente para atender essa solicitação. Verifique a quantidade solicitada!"
		EndIf
	ElseIf nSTLPre > 0 .and. ((p_nQuant + nSTLRea) > nSTLPre)
		If isBlind()
			p_cMsgErr := "Produto: " + AllTrim(p_cCodProd) + Iif(p_nLinha > 0, " da linha " + cValToChar(p_nLinha), "") + ". " + cCondMsg + " A quantidade solicitada (" + cValToChar(p_nQuant) + ") " + Iif(nSTLRea > 0, "mais a quantidade realizada (" + cValToChar(nSTLRea) + ") ", "") + "é superior a quantidade prevista (" + cValToChar(nSTLPre) + "). Verifique a quantidade solicitada!"
		Else
			p_cMsgErr := "Produto: " + AllTrim(p_cCodProd) + Iif(p_nLinha > 0, " da linha " + cValToChar(p_nLinha), "") + CR + cCondMsg + "A quantidade solicitada (" + cValToChar(p_nQuant) + ") " + Iif(nSTLRea > 0, "mais a quantidade realizada (" + cValToChar(nSTLRea) + ") ", "") + "é superior a quantidade prevista (" + cValToChar(nSTLPre) + "). Verifique a quantidade solicitada!"
		EndIf
	EndIf

	If .not. Empty(p_cMsgErr)

		If .not. lMVYORPOSR

			nOpLibOS := U_BFCO14JR("Previsto x Realizado", p_cMsgErr, aOpLibOS, 2)

			If isBlind() .And. (FunName() == "U_BFWS20JL" .Or. FunName() == "U_BFWS54LB")
				
				If ___confApp == '1'
					// ___confApp: variavel Private declarada nos Fontes: BFWS20JL e BFWS54LB
					// origem: App BF Almoxarifado: usuário confirmou a solicitação divergencia na O.S
					p_cMsgErr := ''
				Else
					lRet := .F.
				EndIf
				
			Else 
			
				If (nOpLibOS == 2)
					lRet := .F.
				Else
					p_cMsgErr := ''
				EndIf
				
			EndIf

		Else

			lRet := .F.
			
		EndIf

	EndIf

Return lRet


/*/{Protheus.doc} BFCO01WB
@description Funcao para gravar cod bem chamado 829927
// chamado 773601 melhoria na rotina [willian barreto] 
@author 	willian barreto araujo
@since 		26/03/2023
@Obs 		Uso BOM FUTURO
/*/
User Function BFCO01WB()
	Local __stt   := u___stt(procname(0),"BFES04JL")
	Local oModel2        := FwModelActive()
	Local cQury := " "
	lOCAL cBem := ""
	Local aAreaOld  := GetArea()
	lOCAL cTm := oModel2:GetModel("SZPMASTER"):getvalue("ZP_TM")
	lOCAL cTipoTm := POSICIONE("SF5",1,xFilial("SF5")+cTm,"F5_YOBBEM")
	
	IF cTipoTm == "3"

		If (Select("TSZW") > 0)
			TSZW->(dbCloseArea())
		EndIf

		cQury := " SELECT TJ_CODBEM FROM PROTHEUS11." + RETSQLNAME("STJ") + " WHERE TJ_ORDEM = '"+SUBSTR(M->ZP_OP,0,6)+"' AND TJ_FILIAL = '"+CFILANT+"'"
		
		TcQuery cQury New Alias "TSZW"

		While TSZW->(!EoF())

				cBem := TSZW->(TJ_CODBEM)
					oModel2:GetModel("SZPMASTER"):loadValue("ZP_DESCBEM"  , Posicione("SN1",11,xFilial("SN1")+TSZW->(TJ_CODBEM),"N1_DESCRIC"))
					TSZW->(dbSkip())

		End

		TSZW->(dbclosearea())

		RestArea( aAreaOld )
		
	ENDIF

Return(cBem)

/*/{Protheus.doc} BFCO02WB
@description Funcao para gravar cod bem chamado 829927
// chamado 773601 melhoria na rotina [willian barreto] 
@author 	willian barreto araujo
@since 		26/03/2023
@Obs 		Uso BOM FUTURO
/*/
User Function BFCO02WB()

	Local __stt      := u___stt(procname(0),"BFES04JL")
	Local oModel2    := FwModelActive()
	Local cQury      := " "
	lOCAL cCC 		 := ""
	Local aAreaOld   := GetArea()
	lOCAL cTm 		 := oModel2:GetModel("SZPMASTER"):getvalue("ZP_TM")
	lOCAL cTipoTm    := POSICIONE("SF5",1,xFilial("SF5")+cTm,"F5_YOBBEM") // 1=Bem;2=CCusto;3=OS;4=Projeto;5=OP
	lOCAL cTipoObrig := POSICIONE("SF5",1,xFilial("SF5")+cTm,"F5_YOBRICC")

	IF cTipoTm == "3"

		If (Select("TSZW") > 0)
			TSZW->(dbCloseArea())
		EndIf

		cQury := " SELECT TJ_CCUSTO FROM PROTHEUS11." + RETSQLNAME("STJ") + " WHERE TJ_ORDEM = '" + SUBSTR(M->ZP_OP,0,6) + "' AND TJ_FILIAL = '" + CFILANT + "'"
		
		TcQuery cQury New Alias "TSZW"

		While TSZW->(!EoF())

			cCC := TSZW->(TJ_CCUSTO)
			oModel2:GetModel("SZPMASTER"):loadValue("ZP_CC"  , cCC)
			TSZW->(dbSkip())

		End

		TSZW->(dbclosearea())

		RestArea( aAreaOld )

		If cTipoObrig == "N"
			oModel2:GetModel("SZPMASTER"):GetStruct():SetProperty('ZP_CC'       ,MODEL_FIELD_WHEN,{|| .F. })
			oModel2:GetModel("SZPMASTER"):GetStruct():SetProperty('ZP_SOLICIT'       ,MODEL_FIELD_WHEN,{|| .F. })
			oModel2:GetModel("SZPMASTER"):GetStruct():SetProperty('ZP_CLVL'       ,MODEL_FIELD_WHEN,{|| .F. })
		EndIf

	Else
		cCC := SC2->C2_CC
	EndIf

Return(cCC)

/*/{Protheus.doc} BFES02KM
@description Validação X3_WHEN dos campos ZP_SOLICIT,ZP_CLVL,ZP_CC
@obs não há
@type function
@version  
@author KESIA.MARTINS
@since 14/08/2023
@param cCampo, character, param_description
@return variant, return_description
/*/
User function BFES02KM(cCampo,lValid)

	Local __stt   	:= u___stt(procname(0),"BFES04JL")
	Local oModel 	:= FwModelActivate()
	Local oSZPCab 	:= oModel:GetModel("SZPMASTER")
	Local oSZPGRID  := oModel:GetModel("SZPDETAIL")
	Local lRet      := .T.
	
	DbSelectArea("SF5")
	SF5->(DbSetOrder(1))
	SF5->(DbGoTop())

	If SF5->(DbSeek(xFilial("SF5") + oSZPCab:GetValue('ZP_TM')))
		
		If (ALTERA .or. INCLUI) .and. (Alltrim(cCampo) == "ZP_SOLICIT" .or. Alltrim(cCampo) == "ZP_CLVL" )

			lRet := IIF(SF5->F5_YOBBEM $"1|2|3|4",.F.,.T.)

		Elseif (ALTERA .or. INCLUI) .and. Alltrim(cCampo) == "ZP_CC"

			lRet := IIF(SF5->F5_YOBBEM == "3",.F.,.T.) 

		Endif

	Endif

	If lRet .and. Alltrim(cCampo) == "ZP_QUANT"

		nLinhaAtual := oSZPGRID:GetLine()
		oSZPGRID:GoLine(nLinhaAtual)

		DbSelectArea("SZP")
		SZP->(DbSetOrder(2))
		If SZP->(DbSeek(xFilial("SZP") + oSZPGRID:GetValue("ZP_PRODUTO") + oSZPCab:GetValue("ZP_NUM") + oSZPGRID:GetValue("ZP_ITEM")))
			If oSZPGRID:GetValue("ZP_QUANT") > SZP->ZP_QUANT .and. lValid
				lRet := .F.
			Else
				lRet := .T.
			Endif                                                                                                                         
		Endif
		
	Endif

Return lRet


/*/{Protheus.doc} TravaGrid
@description Validação travar grid quando for registro vindo do app
@obs não há
@type function
@version  
@author KESIA.MARTINS
@since 16/08/2023
@param oModel, object, param_description
@return variant, return_description
/*/
Static Function TravaGrid(oModel,oStruZP2,oStruZP1)
	
	Local __stt   := u___stt(procname(0),"BFES04JL")
	Local lOpcAlt := oModel:GetOperation() == MODEL_OPERATION_UPDATE
	Local lValid  := IIF(lOpcAlt .and. !Empty(oModel:GetModel( 'SZPDETAIL' ):GetValue('ZP_HASH')),.T.,.F.)
	Local cUser   := U_YGETNPAR("MV_YALTECC", "")

	oModel:GetModel( 'SZPDETAIL' ):SetNoInsertLine(lValid)
	oStruZP2:SetProperty('ZP_NUMSAP',	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_PRODUTO', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_CODPFAB', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_NUMLOTE', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_LOTECTL', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_DTVALID', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_LOCALIZ', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_LOTE', 	MODEL_FIELD_WHEN,   {||!lValid})
	oStruZP2:SetProperty('ZP_OBS', 		MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_CONTA', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_QTSEGUM',	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_DATPRF', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_ITEMCTA', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_OBSSC', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_OPER', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_EC05DB', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_EC05CR', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_MEDIDA', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_CODSOLI', 	MODEL_FIELD_WHEN,	{||!lValid})
	oStruZP2:SetProperty('ZP_SULCMI', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_SULCMA', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_TIPMOD', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_VUNIT', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_CONSEST', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_EPICHP', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_EPIUAT', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_CHAPA', 	MODEL_FIELD_WHEN,	{||!lValid})
	oStruZP2:SetProperty('ZP_CPF', 		MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_YUSADO', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_MSGINT', 	MODEL_FIELD_WHEN, 	{||!lValid})

	oStruZP1:SetProperty('ZP_TM', 	MODEL_FIELD_WHEN, 	{||!lValid})
	oStruZP2:SetProperty('ZP_QUANT', 	MODEL_FIELD_VALID , 	{|| U_BFES02KM('ZP_QUANT',lValid)})


	If (RetCodUsr() $ cUser)
		oStruZP1:SetProperty('ZP_CC',  MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.T.' ))
	Else
		oStruZP1:SetProperty('ZP_CC',  MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.F.' ))
	EndIf
	

Return .T.


/*/{Protheus.doc} ValidField
@description Avalia campos

@author  Helitom Silva
@since   27/10/2023

@param p_cField, Caracter, Campo a ser avaliado

@return lRet, Se Valido Retorna .T.

/*/
Static Function ValidField(p_cField, p_lForced, p_oModel)

    Local __stt  	 := u___stt(procname(0),"BFES04JL")
	Local lRet   	 := .T.
	Local oView	     := FwViewActive()
	Local oModel 	 := oView:GetModel()
	Local oSZPM	 	 := oModel:GetModel('SZPMASTER')
	Local oSZPD	 	 := oModel:GetModel('SZPDETAIL')
	Local cAliasTMP  := ''
	Local aOldArea   := GetArea()
	Local cOldRVar   := ''
	Local nLinX      := 0

	Default p_cField    := ''
	Default p_lForced   := .F.

	If p_cField = 'ZP_OP'
		
		If .not. (Vazio() .or. ExistCpo('SC2', p_oModel:GetValue('ZP_OP'),,,.F.))

			oModel:SetErrorMessage("SZPMASTER", "ZP_OP", "SZPMASTER", "ZP_OP", X3Titulo("ZP_OP"), "Ordem de Produção não encontrada no cadastro!", "Verifique.")
			lRet := .F.
		
		ElseIf At('OS', Upper(p_oModel:GetValue('ZP_OP'))) > 0

			cAliasTMP := GetNextAlias()

			BeginSQL Alias cAliasTMP

				SELECT STJ.TJ_ORDEM, STJ.TJ_SITUACA
				  FROM %TABLE:STJ% STJ
				 WHERE STJ.TJ_ORDEM = %EXP:SubStr(p_oModel:GetValue('ZP_OP'), 1, At('OS', Upper(p_oModel:GetValue('ZP_OP'))) - 1)%
				   AND NOT (STJ.TJ_TERMINO = 'N' AND STJ.TJ_SITUACA = 'L')
				   AND STJ.TJ_FILIAL = %XFILIAL:STJ%
				   AND STJ.%NOTDEL%

			EndSQL

			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(DbGoTop())
			If .not. (cAliasTMP)->(EoF())

				If (cAliasTMP)->TJ_SITUACA = 'C'
					oModel:SetErrorMessage("SZPMASTER", "ZP_OP", "SZPMASTER", "ZP_OP", X3Titulo("ZP_OP"), "Ordem de Serviço Cancelada!", "Verifique.")
				Else
					oModel:SetErrorMessage("SZPMASTER", "ZP_OP", "SZPMASTER", "ZP_OP", X3Titulo("ZP_OP"), "Ordem de Serviço Finalizada!", "Reabra para poder Solicitar Insumos.")
				EndIf

				lRet := .F.

			EndIf

			(cAliasTMP)->(DbCloseArea())

			If lRet

				For nLinX := 1 to oSZPD:GetQtdLine()

					oSZPD:GoLine(nLinX)

					If .not. oSZPD:IsDeleted() 

						oSZPD:LoadValue("ZP_TAREOS", CriaVar('ZP_TAREOS', .F.))
						oSZPD:LoadValue("ZP_ETAPOS", CriaVar('ZP_ETAPOS', .F.))

					EndIf

				Next

				oSZPD:GoLine(1)
				oView:Refresh('VSZPDETAIL')

			EndIf

		EndIf

	EndIf

	//oView:Refresh()
	//SysRefresh()

	RestArea(aOldArea)

Return lRet


/*/{Protheus.doc} BFES05LB
@description Funcao para validar o Usuário/CPF por solicitação de EPI
@author 	Lucas Pedroso do Bomdespacho
@since 		08/01/2024
@Obs 		Uso BOM FUTURO
/*/
User Function BFES05LB()
	Local __stt     := u___stt(procname(0),"BFES04JL")
	Local oView	    := FwViewActive()
	Local oModel 	:= oView:GetModel()
	Local oSZPM	 	:= oModel:GetModel('SZPMASTER')
	Local oSZPD	 	:= oModel:GetModel('SZPDETAIL')
	Local cRet      := ""
	Local nJ        := 0
	Local cCPF      := ""
	Local lPrime    := .T.
	Local aArrPj    := {}
	Local _cEpiPj   := ""
	Local _cEpiTm   := ""
	Local __cCC     := ""

	For nJ := 1 to oSZPD:Length()
		oSZPD:GoLine(nJ)
		If !oSZPD:IsDeleted()
			If lPrime
				// guarda o primeiro cpf
				lPrime := .F.
				cCPF := trim(oSZPD:GetValue("ZP_EPICHP"))
			EndIf

			If cCPF <> trim(oSZPD:GetValue("ZP_EPICHP"))
				cRet := "Validação de CPF"
				MsgInfo("Só é possivel adicionar um CPF por solicitação","Validação de CPF")
				oSZPD:SetValue("ZP_EPICHP", "")
				oSZPD:SetValue("ZP_CHAPA" , "")
				oSZPD:SetValue("ZP_CPF"   , "")
				oSZPD:SetValue("ZP_INTTER", "")
				oSZPD:SetValue("ZP_EPIFUN", "")
			EndIf
			
		EndIf
	Next
	If Empty(cRet) .and. !lPrime

		If !Empty(U_YGETNPAR("MV_YTMPJEP", ""))
			aArrPj    := StrTokArr(Alltrim(U_YGETNPAR("MV_YTMPJEP", "")),";" )
			If Len(aArrPj) > 1
				_cEpiPj   := aArrPj[1] // codigo do projeto / finalizado / vazio
				If Len(aArrPj) >= 2
					_cEpiTm   := aArrPj[2] // TM
				EndIf

				If Empty(_cEpiPj)
					cRet := "Favor entrar em contato com o setor de Patrimonio, parametro MV_YTMPJEP vazio"
					MsgInfo(cRet)
				ElseIf _cEpiPj == "FINALIZADO"
					// ok - segue a validação - gatilhando o centro de custo do colaborador cadastrado no RM
					cRet := ""
					oModel:GetModel("SZPMASTER"):GetStruct():SetProperty("ZP_CC", MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.T.' ))
					__cCC := U_BFES06LB(cCPF)
					oSZPM:LoadValue("ZP_CC", __cCC)
					oModel:GetModel("SZPMASTER"):GetStruct():SetProperty("ZP_CC", MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.F.' ))
				ElseIf SubStr(_cEpiPj,1,2) == "PI"
					// validar PI e apontar para o projeto do parametro
					AF8->( dbSetOrder( 1 ) ) // filial+projeto
					If AF8->(Dbseek(xFilial("AF8") + PadR(_cEpiPj,TamSX3("AF8_PROJET")[1]) ))
						If AF8->AF8_FASE == "01"
							// projeto ok - gatilha o projeto e limpa o centro de custo
							oSZPM:SetValue("ZP_TM", _cEpiTm)
							oSZPM:LoadValue("ZP_CC", "")
							oSZPM:SetValue("ZP_CODPROJ", PadR(_cEpiPj,TamSX3("AF8_PROJET")[1])) 
							cRet := ""
						Else
							// projeto não esta em andamento
							cRet  := "Projeto (" + _cEpiPj + ") nao esta em fase de andamento. Favor entrar em contato com o setor de Patrimonio"
							MsgInfo(cRet)
						EndIf
					Else
						// divergencia no projeto: verificar
						cRet  := "Divergencia no projeto (" + _cEpiPj + ") informado no parametro MV_YTMPJEP. Favor entrar em contato com o setor de Patrimonio"
						MsgInfo(cRet)
					EndIf
				EndIf
			Else
				If !Empty(cCPF)
					oModel:GetModel("SZPMASTER"):GetStruct():SetProperty("ZP_CC", MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.T.' ))
					__cCC := U_BFES06LB(cCPF)
					oSZPM:LoadValue("ZP_CC", __cCC)
					oModel:GetModel("SZPMASTER"):GetStruct():SetProperty("ZP_CC", MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.F.' ))
				Else
					oModel:GetModel("SZPMASTER"):GetStruct():SetProperty("ZP_CC", MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.T.' ))
					oSZPM:LoadValue("ZP_CC", U_BFES06LB(cCPF))
					oModel:GetModel("SZPMASTER"):GetStruct():SetProperty("ZP_CC", MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.F.' ))
				EndIf
			EndIf
		Else
			cRet := "Favor entrar em contato com o setor de Patrimonio, parametro MV_YTMPJEP vazio"
			MsgInfo(cRet)
		EndIf

	EndIF
Return(cRet)


/** {Protheus.doc} BFES06LB
	Funcao para buscar centro de custo do colaborador do RM
 
@author:    Lucas Pedroso do Bomdespacho
@param      cCpf 
@since:     01/10/2021
@Uso:       BOM FUTURO
*/
User Function BFES06LB(cCpf)
	Local __stt      := u___stt(procname(0),"BFES04JL")
	Local cQuery     := ""
	Local oView	     := FwViewActive()
	Local oModel 	 := oView:GetModel()
	Local oSZPM	 	 := oModel:GetModel('SZPMASTER')
	Local oSZPD	 	 := oModel:GetModel('SZPDETAIL')
	Local nJ		 := 0
	Local __cCCusto  := ""
	Local tipoRet    := .T.
	Local retorno    := Nil
	Local _cEmpZZH   := ""
	Local _cFilZZH   := ""
	Local cAglo      := ""
	Local _aEPiCC    := ""
	Local _cEPiCC1   := ""
	Local _cEPiCC2   := ""
	Default cCpf     := ""

	If Empty(cCpf)
		tipoRet := .F.
		For nJ := 1 to oSZPD:Length()
			oSZPD:GoLine(nJ)
			If !oSZPD:IsDeleted()
				cCpf := trim(oSZPD:GetValue("ZP_EPICHP"))
				EXIT
			EndIf
		Next
	EndIf

	If !Empty(cCpf)
		If Select("TMPPRD")>0
			TMPPRD->(dbCloseArea())
		EndIf

		cQuery := " SELECT CENTROCUSTO "                            + CRLF
		cQuery += " FROM RM.VWPFUNC "                               + CRLF
		cQuery += " WHERE "                                         + CRLF
		cQuery += " CPF   = '" + cCpf + "'  AND "              		+ CRLF
		cQuery += " TIPODEMISSAO is null             "              + CRLF

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery), "TMPPRD",.F.,.F.)

		If .Not. TMPPRD->(EOF())
			// validar se o CC está liberado nessa filial
			// caso seja 20.xx -> gatilhar 30.07 - de acordo com parâmetro: MV_YCCPADR
			_cEmpZZH  := PadR(cEmpAnt,TamSx3("ZZH_GRPEMP")[1])
			_cFilZZH  := PadR(cFilAnt,TamSx3("ZZH_FIL")[1])

			_aEPiCC    := StrTokArr(Alltrim(U_YGETNPAR("MV_YCCPADR", "")),";" )
			If Len(_aEPiCC) > 0
				_cEPiCC1   := Alltrim(_aEPiCC[1])
				If Len(_aEPiCC) > 1
					_cEPiCC2   := Alltrim(_aEPiCC[2])
				EndIf
			EndIf

			DbSelectArea("ZZH")
			ZZH->(DbSetOrder(1))
			ZZH->(DbGoTop())
			cAglo := oSZPM:GetValue("ZP_CLVL")
			If .Not. ZZH->(DbSeek(_cEmpZZH + _cFilZZH + cAglo + AllTrim(TMPPRD->CENTROCUSTO)))
				//If "20." $ AllTrim(TMPPRD->CENTROCUSTO)
				If _cEPiCC1 $ AllTrim(TMPPRD->CENTROCUSTO)
					//__cCCusto := "30.07"
					__cCCusto := _cEPiCC2
				Else
					oModel:GetModel("SZPMASTER"):GetStruct():SetProperty("ZP_CC", MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.T.' ))
					__cCCusto := " "
				EndIf
			Else
				__cCCusto := AllTrim(TMPPRD->CENTROCUSTO)
			EndIf
		Else
			oModel:GetModel("SZPMASTER"):GetStruct():SetProperty("ZP_CC", MODEL_FIELD_WHEN, FWBuildFeature( STRUCT_FEATURE_WHEN, '.T.' ))
			__cCCusto := " "
		EndIf
	EndIf

	If tipoRet
		retorno := __cCCusto
	Else
		If !EMPTY(__cCCusto)
			If __cCCusto == trim(oSZPM:GetValue("ZP_CC"))
				retorno := .T.
			Else
				Help(,,'Centro de custo',,"Para este colaborador, o centro de custo cadastro no RH é o " + __cCCusto + ", favor verificar!",1,0,,,,,,{'Favor informar o centro de custo valido'})
				retorno := .F.
			EndIf
		Else
			retorno := .T.
		EndIf
	EndIf

Return ( retorno )
