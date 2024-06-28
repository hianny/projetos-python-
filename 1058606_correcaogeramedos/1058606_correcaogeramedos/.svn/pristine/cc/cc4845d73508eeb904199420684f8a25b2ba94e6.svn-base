#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'IDATOOLS.CH'

#DEFINE CR Chr(13) + Chr(10)

/*/{Protheus.doc} MNTA435N
@description Ponto de entrada MNTA435, ID "VALID_CONFIRM" Neste exemplo o objetivo é não permitir incluir um insumo de MDO com data menor que a data atual
 
@author  Helitom Silva
@since   09/06/2020
@version 12.1.27

@return lRet, Logico, se obteve sucesso nas validações

@type Function
@obs Utilizado o retorno lógico utilizado para o ID "VALID_CONFIRM"
ParamIXB[2]	- aDadosOS
            1	Caracter	Número da O.S.
            2	Caracter	Plano
            3	Array	Insumos previstos já salvos
            4	Array	Insumos realizados já salvos
            5	Array	Todos os insumos realizados e modificados
/*/
User Function MNTA435N()

	Local __stt       := u___stt(procname(0), "MNTA435N")    
    Local lRet        := .T.
    Local aOldArea    := GetArea()
    Local cId         := ParamIXB[1] // Indica o momento da chamada do PE
    Local cNumOS      := cOrdemTJ
    Local aDadosOS    := {}
    Local aInsumos    := {} // Array de insumos realizados
    Local nOrdem
    Local nInsumo
    Local nPosOsBf    := 0
 	Local lNovVld     := U_BFMA15HS()
	Local dDTPRINI    := CtoD('')
	Local cHOPRINI    := ''
    Local aPrevisto   := {}
    Local aRealizado  := {}
	Local nSizeField  := TamSx3("T2_CODFUNC")[1]
    Local nQuantid    := 0
    Local cDivPreRea  := ''
    Local cTJYOBPIOS  := ''

    Local lExistPre   := .F.
	Local cMVYCVLDIP := U_YGETNPAR('MV_YCVLDIP', '')
	Local aMVYCVLDIP := Strtokarr(cMVYCVLDIP, '|')
	Local nX		 := 0
	Local nPosIns    := 0
	Local lFornec    := .F.
	Local lLoja      := .F.
	Local lTarefa    := .F.
	Local lEtapa     := .F.

    Local nPrev       := 0
    Local nReal       := 0
    Local nPPCodigo   := aScan(aHoBrw2, {|x| Trim(Upper(x[2])) == "TL_CODIGO" })
	Local nPPTarefa   := aScan(aHoBrw2, {|x| Trim(Upper(x[2])) == "TL_TAREFA" })
	Local nPPEtapa    := aScan(aHoBrw2, {|x| Trim(Upper(x[2])) == "TL_ETAPA" })
	Local nPPTiporeg  := aScan(aHoBrw2, {|x| Trim(Upper(x[2])) == "TL_TIPOREG" })
	Local nPPQuantid  := aScan(aHoBrw2, {|x| Trim(Upper(x[2])) == "TL_QUANTID" })
	Local nPPFornece  := aScan(aHoBrw2, {|x| Trim(Upper(x[2])) == "TL_FORNEC" })
	Local nPPFornLoj  := aScan(aHoBrw2, {|x| Trim(Upper(x[2])) == "TL_LOJA" })
    Local nPPDtInic   := aScan(aHoBrw2, {|x| Trim(Upper(x[2])) == "TL_DTINICI"})
    Local nPPHoInic   := aScan(aHoBrw2, {|x| Trim(Upper(x[2])) == "TL_HOINICI"})

	Local nPRCodigo   := aScan(aHoBrw6, {|x| Trim(Upper(x[2])) == "TL_CODIGO" })
	Local nPRTarefa   := aScan(aHoBrw6, {|x| Trim(Upper(x[2])) == "TL_TAREFA" })
	Local nPREtapa    := aScan(aHoBrw6, {|x| Trim(Upper(x[2])) == "TL_ETAPA" })
	Local nPRTiporeg  := aScan(aHoBrw6, {|x| Trim(Upper(x[2])) == "TL_TIPOREG" })
	Local nPRQuantid  := aScan(aHoBrw6, {|x| Trim(Upper(x[2])) == "TL_QUANTID" })
	Local nPRFornece  := aScan(aHoBrw6, {|x| Trim(Upper(x[2])) == "TL_FORNEC" })
	Local nPRFornLoj  := aScan(aHoBrw6, {|x| Trim(Upper(x[2])) == "TL_LOJA" })
    Local aPrevRea    := {}

    //Adaptado na migração para a 2310 - agora existe um browse com diversas O.S, e o paramixb traz todas as o.s, oq causou erro na customização
    //Ajustado para processar somente a O.S que esta sendo finalizada
    nPosOsBf := ascan(ParamIXB[2],{|x| x[1] == cOrdemTJ})

	For nX := 1 to Len(aMVYCVLDIP)

		If aMVYCVLDIP[nX] == 'TL_FORNEC'

			lFornec := .T.

		ElseIf aMVYCVLDIP[nX] == 'TL_LOJA'

			lLoja := .T.

		ElseIf aMVYCVLDIP[nX] == 'TL_TAREFA'

			lTarefa := .T.

		ElseIf aMVYCVLDIP[nX] == 'TL_ETAPA'

			lEtapa := .T.

		EndIf

	Next
    
    If lNovVld .And. nPosOsBf > 0

        If cId == 'VALID_CONFIRM'

            // Array com os dados das ordens de serviço
            aAdd(aDadosOS,ParamIXB[2][nPosOsBf])
        
            // Percorre o array de ordens
            For nOrdem := 1 To Len( aDadosOS )
                
                cOrdemOS := aDadosOS[1][1]
                cPlanoOS := aDadosOS[1][2]

                cTJYOBPIOS := Posicione('STJ', 1, FWxFilial('STJ') + cOrdemOS + cPlanoOS, 'TJ_YOBPIOS')

                dDTPRINI := Posicione('STJ', 1, FWxFilial('STJ') + cOrdemOS + cPlanoOS, 'TJ_DTPRINI')
                cHOPRINI := Posicione('STJ', 1, FWxFilial('STJ') + cOrdemOS + cPlanoOS, 'TJ_HOPRINI')
                
                // Verifica se há insumos realizados
                If lRet .and. ValType( aDadosOS[ nOrdem, 5 ] ) == 'A'

                    aInsumos := aClone( aDadosOS[ nOrdem, 5 ] )

                    // Percorre o array de insumos realizados
                    For nInsumo := 1 to Len( aInsumos )
                        
                        If !aTail( aInsumos[ nInsumo ] ) .and. !Empty(aInsumos[ nInsumo, nPPCodigo ]); //Verifica se não está deletado 
                           .and. (Empty(aInsumos[ nInsumo, nPPDtInic ])  .or. Empty(aInsumos[ nInsumo, nPPHoInic ])) // Verifica se a data/Hora de Aplicação do Insumo está preenchida

                            MsgAlert( 'Ordem ' + aDadosOS[ nOrdem, 1 ] +  ': A Data/Hora de Inicio da Aplicação do Insumo não estão informadas.', 'Atenção')
                            
                            lRet := .F.

                        ElseIf !aTail( aInsumos[ nInsumo ] ) .and. !Empty(aInsumos[ nInsumo, nPPCodigo ]); //Verifica se não está deletado
                               .and. (aInsumos[ nInsumo, nPPDtInic ] < dDTPRINI .or. (aInsumos[ nInsumo, nPPDtInic ] = dDTPRINI .and. Val(StrTran(aInsumos[ nInsumo, nPPHoInic ], ':')) <= Val(StrTran(cHOPRINI, ':')))) // Verifica se a data/Hora de Aplicação do Insumo é menor que a data/hora de Parada

                            MsgAlert( 'Ordem ' + aDadosOS[ nOrdem, 1 ] +  ': A Data/Hora de Inicio da Aplicação do Insumo deve ser maior ou igual a ' + AllTrim(FWX3Titulo('TJ_DTPRINI')) + ' e maior que a ' + AllTrim(FWX3Titulo('TJ_HOPRINI')) + '.', 'Atenção')
                            
                            lRet := .F.

                        EndIf

                        If !lRet
                            Exit
                        EndIf

                    Next
                    
                    // Helitom Silva - 05/11/2021 - Será comentado o código abaixo, porque o sr. Paulo Regis definiu que pode salvar novamente o Retorno mesmo já gravado os registros.
                    //Jose Leite
                    /*If ValType( aDadosOS[ nOrdem, 4 ] ) == 'A'
                        nJ := Len(aDadosOS[ nOrdem, 4 ])
                        If nJ > 0 .And. (nJ + 1 <= Len( aInsumos ))
                            For nJ := nJ + 1 to Len( aInsumos )
                                If AllTrim(aInsumos[nJ,nPPTiporeg]) == "P"
                                    MsgAlert( 'Ordem ' + aDadosOS[ nOrdem, 1 ] +  ': Não é possível realizar lançamentos de produtos, é necessário cancelar o retorno e lançar novamente, pois tem solicitação Armazem já gerada, favor verificar.', 'Atenção')
                                    lRet := .F. 
                                EndIf
                                If !lRet
                                    Exit
                                EndIf
                            Next
                        EndIf
                    EndIf*/

                EndIf
            
                If lRet .and. ValType(aDadosOS[nOrdem, 3]) == 'A'

                    If ValType(aDadosOS[nOrdem, 5]) == 'A'

                        aPrevisto  := aDadosOS[nOrdem, 3]
                        aRealizado := aDadosOS[nOrdem, 5]
                        aPrevRea   := {}

                        For nPrev := 1 to Len(aPrevisto)

                            If Len(aPrevRea) > 0

                                nPosIns := aScan(aPrevRea, {|X| X[1] == aPrevisto[nPrev, nPPTiporeg] .and. X[2] == aPrevisto[nPrev, nPPCodigo] .and.;
                                                                Iif(lTarefa, X[5] == aPrevisto[nPrev, nPPTarefa], .T.) .and.;
                                                                Iif(lEtapa,  X[6] == aPrevisto[nPrev, nPPEtapa], .T.) .and.;
                                                                Iif(lFornec, X[3] == aPrevisto[nPrev, nPPFornece], .T.) .and.;
                                                                Iif(lLoja,   X[4] == aPrevisto[nPrev, nPPFornLoj], .T.) })

                                If nPosIns == 0

                                    // Tipo Reg., Codigo Produto, Fornecedor, Loja, Tarefa, Etapa, Quantidade Prevista, Quantidade Realizado, Num. SA., Num. SC.
                                    aAdd(aPrevRea, {aPrevisto[nPrev, nPPTiporeg], aPrevisto[nPrev, nPPCodigo], Iif(lFornec, aPrevisto[nPrev, nPPFornece], ''), Iif(lLoja, aPrevisto[nPrev, nPPFornLoj], ''), Iif(lTarefa, aPrevisto[nPrev, nPPTarefa], ''), Iif(lEtapa,  aPrevisto[nPrev, nPPEtapa], ''), aPrevisto[nPrev, nPPQuantid], 0})

                                Else
                                    aPrevRea[nPosIns][7]  += aPrevisto[nPrev, nPPQuantid]
                                EndIf

                            Else
                                
                                // Tipo Reg., Codigo Produto, Fornecedor, Loja, Tarefa, Etapa, Quantidade Prevista, Quantidade Realizado, Num. SA., Num. SC.
                                aAdd(aPrevRea, {aPrevisto[nPrev, nPPTiporeg], aPrevisto[nPrev, nPPCodigo], Iif(lFornec, aPrevisto[nPrev, nPPFornece], ''), Iif(lLoja, aPrevisto[nPrev, nPPFornLoj], ''), Iif(lTarefa, aPrevisto[nPrev, nPPTarefa], ''), Iif(lEtapa, aPrevisto[nPrev, nPPEtapa], ''), aPrevisto[nPrev, nPPQuantid], 0})

                            EndIf
                                                    
                        Next

                        For nPrev := 1 to Len(aPrevRea)

                            nQuantid := 0

                            For nReal := 1 to Len(aRealizado)

                                If aTail(aRealizado[nReal]) // Verifica se está deletado - Atail retorna o ultimo elemento do Array
                                    Loop
                                EndIf

                                // Comparação de insumos previstos x insumos realizados
                                If Iif(lTarefa, AllTrim(aPrevRea[nPrev, 5]) == AllTrim(aRealizado[nReal, nPRTarefa]), .T.) ;
                                    .and. Iif(lEtapa, AllTrim(aPrevRea[nPrev, 6]) == AllTrim(aRealizado[nReal, nPREtapa]), .T.) ;
                                    .and. ((Alltrim(aPrevRea[nPrev, 1]) == "E" .And. AllTrim( aRealizado[nReal, nPRTiporeg] ) == "M" ;
                                    .and. NGIFDBSEEK( "ST2", Padr( aRealizado[nReal, nPRCodigo], nSizeField )  + Alltrim( aRealizado[nReal, nPRCodigo] ), 1 )) ;
                                    .or. (AllTrim(aPrevRea[nPrev, 1]) == AllTrim(aRealizado[nReal, nPRTiporeg]) ;
                                    .and. AllTrim(aPrevRea[nPrev, 2]) == AllTrim(aRealizado[nReal, nPRCodigo]))) ;
                                    .and. Iif(lFornec, AllTrim(aPrevRea[nPrev, 3]) == AllTrim(aRealizado[nReal, nPRFornece]), .T.) ;
                                    .and. Iif(lLoja, AllTrim(aPrevRea[nPrev, 4]) == AllTrim(aRealizado[nReal, nPRFornLoj]), .T.)

                                    // Soma a quantidade de insumos que já foram aplicados
                                    nQuantid += aRealizado[nReal, nPRQuantid]

                                EndIf

                            Next

                            aPrevRea[nPrev][8] := nQuantid

                            // Aplicado além do previsto
                            If aPrevRea[nPrev, 8] > aPrevRea[nPrev][7]
                                cDivPreRea += 'A quantidade realizada (' + cValToChar(aPrevRea[nPrev, 8]) + ') do Insumo ' + AllTrim(aPrevRea[nPrev, 2]) + ' - ' + AllTrim(Posicione('SB1', 1, FWxFilial('SB1') + aPrevRea[nPrev, 2], 'B1_DESC')) + ' está divergente do Previsto(' + cValToChar(aPrevRea[nPrev, 7]) + ').' + CR
                            EndIf
                            
                        Next

                        
                        For nReal := 1 to Len(aRealizado)

                            lExistPre := .F.

                            If aTail(aRealizado[nReal]) // Verifica se está deletado - Atail retorna o ultimo elemento do Array
                                Loop
                            EndIf

                            For nPrev := 1 to Len(aPrevRea)

                                // Comparação de insumos previstos x insumos realizados
                                If Iif(lTarefa, AllTrim(aPrevRea[nPrev, 5]) == AllTrim(aRealizado[nReal, nPRTarefa]), .T.) ;
                                    .and. Iif(lEtapa, AllTrim(aPrevRea[nPrev, 6]) == AllTrim(aRealizado[nReal, nPREtapa]), .T.) ;
                                    .and. ((Alltrim(aPrevRea[nPrev, 1]) == "E" .And. AllTrim( aRealizado[nReal, nPRTiporeg] ) == "M" ;
                                    .and. NGIFDBSEEK( "ST2", Padr( aRealizado[nReal, nPRCodigo], nSizeField )  + Alltrim( aRealizado[nReal, nPRCodigo] ), 1 )) ;
                                    .or. (AllTrim(aPrevRea[nPrev, 1]) == AllTrim(aRealizado[nReal, nPRTiporeg]) ;
                                    .and. AllTrim(aPrevRea[nPrev, 2]) == AllTrim(aRealizado[nReal, nPRCodigo]))) ;
                                    .and. Iif(lFornec, AllTrim(aPrevRea[nPrev, 3]) == AllTrim(aRealizado[nReal, nPRFornece]), .T.) ;
                                    .and. Iif(lLoja, AllTrim(aPrevRea[nPrev, 4]) == AllTrim(aRealizado[nReal, nPRFornLoj]), .T.)

                                    // Informa que encontrou a previsão
                                    lExistPre := .T.

                                EndIf

                            Next

                            If .not. lExistPre
                            
                                // Tarefa, Tipo Reg., Codigo Produto, Fornecedor, Loja, Quantidade Prevista, Quantidade Realizado, Etapa
                                aAdd(aPrevRea, {aRealizado[nReal, nPRTarefa], aRealizado[nReal, nPRTiporeg], aRealizado[nReal, nPRCodigo], aRealizado[nReal, nPRFornece], aRealizado[nReal, nPRFornLoj], 0, aRealizado[nReal, nPRQuantid], aRealizado[nReal, nPREtapa]})

                                If cTJYOBPIOS == '1'

                                    // Aplicado além do Previsto
                                    If aRealizado[nReal, nPRQuantid] > 0
                                        cDivPreRea += 'A quantidade realizada (' + cValToChar(aRealizado[nReal, nPRQuantid]) + ') do Insumo ' + AllTrim(aRealizado[nReal, nPRCodigo]) + ' - ' + AllTrim(Posicione('SB1', 1, FWxFilial('SB1') + aRealizado[nReal, nPRCodigo], 'B1_DESC')) + ' está divergente do Previsto(' + cValToChar(0) + ').' + CR
                                    EndIf
                                    
                                EndIf

                            EndIf

                        Next

                    EndIf

                    If !Empty(cDivPreRea)
                        IdaMsg(cDivPreRea, "Divergência Previsto x Realizado")
                        lRet := .F.
                    EndIf

                EndIf

                If lRet .and. (.not. ValType(aDadosOS[nOrdem, 3]) == 'A' .or. Len(aDadosOS[nOrdem, 3]) == 0)

                    If cTJYOBPIOS == '1'
                        MsgAlert('Para essa Ordem de Serviço é obrigatório haverem Insumos Previstos!', 'Atenção')
                        lRet := .F.
                    EndIf

                EndIf

            Next

            If lRet .and. .not. FWIsInCallStack('{||EVAL(BSALVAR)}')
                lRet := VldSolProd(cNumOS)
            EndIf

            U_STA435G()

        EndIf

    EndIf

    RestArea( aOldArea )

Return lRet


/*/{Protheus.doc} VldSolProd
@description Valida se existem produtos solicitados em aberto.
@type Function
@author Helitom Silva
@since 19/01/2024
@version 12.1.2210
@param Nil
@return lRet, Logico, Se não houver solicitações de Produtos retorna .T.
@see (links_or_references)
/*/
Static Function VldSolProd(p_cOrdem)
    
    Local __stt      := u___stt(procname(0), "MNTA435N")
    Local lRet       := .T.
    Local cAliasTMP  := GetNextAlias()
    Local nMVYVPSEOS := U_YGETNPAR('MV_YVPSEOS', 0) // 0 - Não Valida, 1 - Valida, 2 - Notifica
    Local aMsgInfo   := {}
    Local nX         := 0

    Default p_cOrdem := ''

    If .not. nMVYVPSEOS == 0

        BeginSQL Alias cAliasTMP

            Column QUANT as Numeric(10, 3)

            SELECT SL.ORIGEM, SUM(SL.QUANT) QUANT
            FROM ( SELECT 'SP' ORIGEM, 
                            NVL(SUM(ZFA.ZFA_QUANT), 0) AS QUANT
                    FROM %TABLE:ZFA% ZFA
                    WHERE SUBSTR(ZFA.ZFA_OP, 1, 6) = %EXP:p_cOrdem%
                        AND ZFA.ZFA_STATUS NOT IN ('F', 'C')
                        AND ZFA.ZFA_FILIAL = %XFILIAL:ZFA%
                        AND ZFA.%NOTDEL%

                    UNION ALL
                    
                    SELECT 'SC' ORIGEM,
                            NVL(COALESCE(SUM(COALESCE(SC1.C1_QUANT, 0)) - SUM(COALESCE(SD1.D1_QUANT, 0)), 0), 0) QUANT
                    FROM %TABLE:SC1% SC1
                    LEFT JOIN %TABLE:SC7% SC7 ON SC7.C7_NUMSC  = SC1.C1_NUM
                                            AND SC7.C7_PRODUTO = SC1.C1_PRODUTO
                                            AND SUBSTR(TRIM(SC7.C7_OP), 1, 6) = SUBSTR(TRIM(SC1.C1_OP), 1, 6)
                                            AND SC7.C7_YTAREOS = SC1.C1_YTAREOS
                                            AND SC7.C7_YETAPOS = SC1.C1_YETAPOS
                                            AND TRIM(SC7.C7_NUMSC) IS NOT NULL
                                            AND SC7.C7_FILIAL  = SC1.C1_FILIAL
                                            AND SC7.%NOTDEL%
                    LEFT JOIN %TABLE:SD1% SD1 ON SD1.D1_PEDIDO = SC7.C7_NUM
                                            AND SD1.D1_ITEMPC  = SC7.C7_ITEM
                                            AND SD1.D1_COD     = SC7.C7_PRODUTO
                                            AND SD1.D1_FORNECE = SC7.C7_FORNECE
                                            AND SD1.D1_FILIAL  = SC7.C7_FILIAL
                                            AND SD1.%NOTDEL%
                    WHERE SUBSTR(SC1.C1_OP, 1, 6) = %EXP:p_cOrdem%
                    AND SC1.C1_RESIDUO <> 'S'
                    AND SC1.C1_FILIAL  = %XFILIAL:SC1%
                    AND SC1.%NOTDEL%
                    
                    UNION ALL
                    
                    SELECT 'PC' ORIGEM, NVL(COALESCE((SUM(COALESCE(SC7.C7_QUANT, 0)) - SUM(COALESCE(SD1.D1_QUANT, 0))), 0), 0) AS QUANT
                    FROM %TABLE:SC7% SC7
                    LEFT JOIN %TABLE:SD1% SD1 ON SD1.D1_PEDIDO = SC7.C7_NUM
                                            AND SD1.D1_ITEMPC  = SC7.C7_ITEM
                                            AND SD1.D1_FORNECE = SC7.C7_FORNECE
                                            AND SD1.D1_COD     = SC7.C7_PRODUTO
                                            AND SD1.D1_FILIAL  = SC7.C7_FILIAL
                                            AND SD1.%NOTDEL%
                    WHERE SUBSTR(SC7.C7_OP, 1, 6) = %EXP:p_cOrdem%
                    AND SC7.C7_ENCER NOT IN ('E')
                    AND SC7.C7_RESIDUO NOT IN ('S')
                    AND TRIM(SC7.C7_NUMSC) IS NULL
                    AND SC7.C7_FILIAL  = %XFILIAL:SC7%
                    AND SC7.%NOTDEL% 

                    UNION ALL

                    SELECT 'MC' ORIGEM,
                           COALESCE(SUM(CNE.CNE_QUANT),0) AS QUANT
                      FROM %TABLE:CND% CND
                    INNER JOIN %TABLE:CNE% CNE ON CNE.CNE_NUMMED = CND.CND_NUMMED 
                                              AND SUBSTR(CNE.CNE_OP, 1, 6) = %EXP:p_cOrdem% 
                                              AND CNE.CNE_FILIAL = CND.CND_FILIAL 
                                              AND CNE.%NOTDEL%
                    WHERE TRIM(CND.CND_SITUAC) = 'A'
                      AND CND.CND_FILIAL = %XFILIAL:CND%
                      AND CND.%NOTDEL%) SL
            GROUP BY SL.ORIGEM

        EndSQL

        IdaGrvSQL('CONSULTA_VALIDACAO_PENDENCIAS_OS', GetLastQuery()[2])

        dbSelectArea(cAliasTMP)
        (cAliasTMP)->(DbGoTop())
        While .not. (cAliasTMP)->(EoF())

            If (cAliasTMP)->QUANT > 0

                If (cAliasTMP)->ORIGEM == 'SP'
                    Aadd(aMsgInfo, {'Solicitação de Produtos', 'Existe Solicitação de Produtos não finalizado!', 'Acesse a rotina de Solicitação de Produtos e pesquise a OS no Numero da OP.'})
                ElseIf (cAliasTMP)->ORIGEM == 'SC'
                    Aadd(aMsgInfo, {'Solicitação de Compra', 'Existe Solicitação de Compra não finalizada!', 'Acesse a rotina de Solicitação de Compras e pesquise a OS no Numero da OP.'})
                ElseIf (cAliasTMP)->ORIGEM == 'PC'
                    Aadd(aMsgInfo, {'Pedido de Compra', 'Existe Pedido de Compra não finalizado!', 'Acesse a rotina de Pedido de Compras e pesquise a OS no Numero da OP.'})
                ElseIf (cAliasTMP)->ORIGEM == 'MC'
                    Aadd(aMsgInfo, {'Medição de Contrato', 'Existe Medição de Contrato não finalizado!', 'Acesse a rotina de Medição de Contrato e pesquise a OS no Numero da OP.'})
                EndIf

            EndIf

            (cAliasTMP)->(DbSkip())
        End

        (cAliasTMP)->(DbCloseArea())

        If cValToChar(nMVYVPSEOS) $ '1/2' // 0 - Não Valida, 1 - Valida, 2 - Notifica

            If Len(aMsgInfo) > 0

                For nX := 1 to Len(aMsgInfo)

                    If nX > 1
                        aMsgInfo[1][1] += ', ' + aMsgInfo[nX][1]
                        aMsgInfo[1][2] += ' ' + aMsgInfo[nX][2]
                        aMsgInfo[1][3] += ' ' + aMsgInfo[nX][3]
                    EndIf

                Next

                If nMVYVPSEOS == 1
                    Help(,, 'ENCONTRADO PENDÊCIAS',, 'Existem pendências em (' + Upper(aMsgInfo[1][1]) + ').', 1, 0,,,,,, {'Acesse as rotinas listadas em "PROBLEMA" logo acima, e pesquise a "OS" no "Número da OP".'})
                    lRet := .F.
                Else
                    If U_BFCO14JR('ENCONTRADO PENDÊCIAS', 'Existem pendências em (' + Upper(aMsgInfo[1][1]) + ').', {'Prosseguir', 'Cancelar'}, 2) == 2
                        lRet := .F.
                    EndIf
                EndIf

            EndIf

        EndIf

    EndIf

Return lRet
