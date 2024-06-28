#INCLUDE 'PROTHEUS.ch'


/*/{Protheus.doc} BFMA50HS
@description Valida se a quantidade solicitada é superior a quantidade prevista.
@type  Function
@author Helitom Silva
@since 09/01/2024
@version 12.1.2210
@param p_cRotina, Caracter, Rotina (SC-Sol. Compra; SP-Sol. Produto; PC-Pedido de Compra; SA -  Sol. Armazem)
@return lRet, Logico, Se válido retorna .T.
@obs #MATA110 #MATA120 #MATA105 #BFCO01FP
@example
(examples)
@see (links_or_references)
/*/
User Function BFMA50HS(p_cRotina)

	Local __stt	     := u___stt(procname(0), "BFMA50HS")
    Local lRet       := .T.
    Local cMsgErr    := ''
    Local nLinY      := 0
    Local nLinX      := 0
    Local nItemCP    := 0
    Local aItemCP    := {}
    Local nPosProdut := 1
    Local nPosQuant  := 2
    Local nPosOP     := 3
    Local nPosTarefa := 4
    Local nPosEtapa  := 5
    Local nPosFornec := 6
    Local nPosLoja   := 7
    Local oModel     := Nil
    Local oZFAD      := Nil
 
    Default p_cRotina := ''

    If p_cRotina == 'SC'

        For nLinX := 1 to Len(aCols)

            If .not. aCols[nLinX, (Len(aHeader)+1)] .and. .not. Empty(GdFieldGet("C1_OP", nLinX))

                nItemCP := ASCan(aItemCP, {|X| X[1] == GdFieldGet("C1_PRODUTO", nLinX) .and. X[3] == GdFieldGet("C1_OP", nLinX) .and. x[4] == GdFieldGet("C1_YTAREOS", nLinX) .and. X[5] == GdFieldGet("C1_YETAPOS", nLinX) .and. X[6] == GdFieldGet("C1_FORNECE", nLinX) .and. X[7] == GdFieldGet("C1_LOJA", nLinX)})

                If nItemCP == 0
                    Aadd(aItemCP, {GdFieldGet("C1_PRODUTO", nLinX), GdFieldGet("C1_QUANT", nLinX), GdFieldGet("C1_OP", nLinX), GdFieldGet("C1_YTAREOS", nLinX), GdFieldGet("C1_YETAPOS", nLinX), GdFieldGet("C1_FORNECE", nLinX), GdFieldGet("C1_LOJA", nLinX)})
                Else
                    aItemCP[nItemCP][2] += GdFieldGet("C1_QUANT", nLinX)
                EndIf

            EndIf

        Next

        For nLinX := 1 to Len(aItemCP)

            If lRet

                lRet := U_ES04JLPR(.F., aItemCP[nLinX, nPosOP], aItemCP[nLinX,nPosProdut], aItemCP[nLinX,nPosQuant], 0, @cMsgErr, aItemCP[nLinX][nPosFornec], aItemCP[nLinX][nPosLoja], aItemCP[nLinX][nPosTarefa], aItemCP[nLinX][nPosEtapa])

                If lRet .and. !Empty(cMsgErr)
                    lRet := .F.
                    Help(,,'Quantidade',, cMsgErr, 1, 0,,,,,, {'Verifique a quantidade solicitada!'})
                    Exit
                ElseIf !lRet
                    Help(,,'Quantidade',, cMsgErr, 1, 0,,,,,, {'Verifique a quantidade solicitada!'})
                    Exit
                EndIf

            EndIf

        Next        

    ElseIf p_cRotina == 'PC'

        For nLinX := 1 to Len(aCols)

            If .not. aCols[nLinX, (Len(aHeader)+1)] .and. .not. Empty(GdFieldGet("C7_OP", nLinX))

                nItemCP := ASCan(aItemCP, {|X| X[1] == GdFieldGet("C7_PRODUTO", nLinX) .and. X[3] == GdFieldGet("C7_OP", nLinX) .and. x[4] == GdFieldGet("C7_YTAREOS", nLinX) .and. X[5] == GdFieldGet("C7_YETAPOS", nLinX) .and. X[6] == cA120Forn .and. X[7] == cA120Loj})

                If nItemCP == 0
                    Aadd(aItemCP, {GdFieldGet("C7_PRODUTO", nLinX), GdFieldGet("C7_QUANT", nLinX), GdFieldGet("C7_OP", nLinX), GdFieldGet("C7_YTAREOS", nLinX), GdFieldGet("C7_YETAPOS", nLinX), cA120Forn, cA120Loj})
                Else
                    aItemCP[nItemCP][2] += GdFieldGet("C7_QUANT", nLinX)
                EndIf

            EndIf

        Next

        For nLinX := 1 to Len(aItemCP)

            If lRet

                lRet := U_ES04JLPR(.F., aItemCP[nLinX, nPosOP], aItemCP[nLinX,nPosProdut], aItemCP[nLinX,nPosQuant], 0, @cMsgErr, cA120Forn, cA120Loj, aItemCP[nLinX][nPosTarefa], aItemCP[nLinX][nPosEtapa])

                If lRet .and. !Empty(cMsgErr)
                    lRet := .F.
                    Help(,,'Quantidade',, cMsgErr, 1,0,,,,,, {'Verifique a quantidade solicitada!'})
                    Exit
                ElseIf !lRet
                    Help(,,'Quantidade',, cMsgErr, 1,0,,,,,, {'Verifique a quantidade solicitada!'})
                    Exit
                EndIf

            EndIf

        Next

    ElseIf p_cRotina == 'SA'

        For nLinX := 1 to Len(aCols)

            If .not. aCols[nLinX, (Len(aHeader)+1)] .and. .not. Empty(GdFieldGet("CP_OP", nLinX))

                nItemCP := ASCan(aItemCP, {|X| X[1] == GdFieldGet("CP_PRODUTO", nLinX) .and. X[3] == GdFieldGet("CP_OP", nLinX) .and. x[4] == GdFieldGet("CP_YTAREOS", nLinX) .and. X[5] == GdFieldGet("CP_YETAPOS", nLinX) .and. X[6] == '' .and. X[7] == ''})

                If nItemCP == 0
                    Aadd(aItemCP, {GdFieldGet("CP_PRODUTO", nLinX), GdFieldGet("CP_QUANT", nLinX), GdFieldGet("CP_OP", nLinX), GdFieldGet("CP_YTAREOS", nLinX), GdFieldGet("CP_YETAPOS", nLinX), '', ''})
                Else
                    aItemCP[nItemCP][2] += GdFieldGet("CP_QUANT", nLinX)
                EndIf

            EndIf

        Next

        For nLinX := 1 to Len(aItemCP)

            If lRet

                lRet := U_ES04JLPR(.F., aItemCP[nLinX, nPosOP], aItemCP[nLinX,nPosProdut], aItemCP[nLinX,nPosQuant], 0, @cMsgErr, , , aItemCP[nLinX][nPosTarefa], aItemCP[nLinX][nPosEtapa])

                If lRet .and. !Empty(cMsgErr)
                    lRet := .F.
                    Help(,,'Quantidade',, cMsgErr, 1,0,,,,,, {'Verifique a quantidade solicitada!'})
                    Exit
                ElseIf !lRet
                    Help(,,'Quantidade',, cMsgErr, 1,0,,,,,, {'Verifique a quantidade solicitada!'})
                    Exit
                EndIf

            EndIf

        Next

    ElseIf p_cRotina == 'SP'

        oModel := FWModelActive()
        oZFAD  := oModel:GetModel("ZFADET")

        For nLinX := 1 to oZFAD:GetQtdLine()

            oZFAD:GoLine(nLinX)

            If .not. oZFAD:IsDeleted() .and. .not. Empty(oZFAD:GetValue("ZFA_OP"))

                nItemCP := ASCan(aItemCP, {|X| X[1] == oZFAD:GetValue("ZFA_PRODUT") .and. X[3] == oZFAD:GetValue("ZFA_OP") .and. x[4] == oZFAD:GetValue("ZFA_TAREOS") .and. X[5] == oZFAD:GetValue("ZFA_ETAPOS") .and. X[6] == '' .and. X[7] == ''})

                If nItemCP == 0
                    Aadd(aItemCP, {oZFAD:GetValue("ZFA_PRODUT"), oZFAD:GetValue("ZFA_QUANT"), oZFAD:GetValue("ZFA_OP"), oZFAD:GetValue("ZFA_TAREOS"), oZFAD:GetValue("ZFA_ETAPOS"), '', ''})
                Else
                    aItemCP[nItemCP][2] += oZFAD:GetValue("ZFA_QUANT")
                EndIf

            EndIf

        Next

        For nLinX := 1 to Len(aItemCP)

            If lRet

                lRet := U_ES04JLPR(.F., aItemCP[nLinX, nPosOP], aItemCP[nLinX,nPosProdut], aItemCP[nLinX,nPosQuant], 0, @cMsgErr, , , aItemCP[nLinX][nPosTarefa], aItemCP[nLinX][nPosEtapa])

                If lRet .and. !Empty(cMsgErr)
                    lRet := .F.
                    oZFAD:oFormModel:SetErrorMessage("ZFADET", "ZFA_OP", "ZFADET", "ZFA_OP", "Ordem de Produção", cMsgErr, "Verifique a quantidade solicitada!")
                    Exit
                ElseIf !lRet
                    oZFAD:oFormModel:SetErrorMessage("ZFADET", "ZFA_OP", "ZFADET", "ZFA_OP", "Ordem de Produção", cMsgErr, "Verifique a quantidade solicitada!")
                    Exit
                EndIf

            EndIf

        Next

    ElseIf p_cRotina == 'MC'

        oModel := FWModelActive()
        oCXND  := oModel:GetModel("CXNDETAIL")
        oCNED  := oModel:GetModel("CNEDETAIL")

        aSaveLines := FwSaveRows()

        For nLinY := 1 to oCXND:Length()

            oCXND:GoLine(nLinY)

            If oCXND:GetValue('CXN_CHECK') .and. !oCXND:IsDeleted()

                For nLinX := 1 to oCNED:GetQtdLine()

                    oCNED:GoLine(nLinX)

                    If .not. oCNED:IsDeleted() .and. .not. Empty(oCNED:GetValue("CNE_OP"))

                        nItemCP := ASCan(aItemCP, {|X| X[1] == oCNED:GetValue("CNE_PRODUT") .and. X[3] == oCNED:GetValue("CNE_OP") .and. x[4] == oCNED:GetValue("CNE_TAREOS") .and. X[5] == oCNED:GetValue("CNE_ETAPOS") .and. X[6] == '' .and. X[7] == ''})

                        If nItemCP == 0
                            Aadd(aItemCP, {oCNED:GetValue("CNE_PRODUT"), oCNED:GetValue("CNE_QUANT"), oCNED:GetValue("CNE_OP"), oCNED:GetValue("CNE_TAREOS"), oCNED:GetValue("CNE_ETAPOS"), '', ''})
                        Else
                            aItemCP[nItemCP][2] += oCNED:GetValue("CNE_QUANT")
                        EndIf

                    EndIf

                Next
                    
            EndIf

        Next

        FwRestRows(aSaveLines)

        For nLinX := 1 to Len(aItemCP)

            If lRet

                lRet := U_ES04JLPR(.F., aItemCP[nLinX, nPosOP], aItemCP[nLinX,nPosProdut], aItemCP[nLinX,nPosQuant], 0, @cMsgErr, , , aItemCP[nLinX][nPosTarefa], aItemCP[nLinX][nPosEtapa])

                If lRet .and. !Empty(cMsgErr)
                    lRet := .F.
                    oCNED:oFormModel:SetErrorMessage("CNEDET", "CNE_OP", "CNEDET", "CNE_OP", "Ordem de Produção", cMsgErr, "Verifique a quantidade solicitada!")
                    Exit
                ElseIf !lRet
                    oCNED:oFormModel:SetErrorMessage("CNEDET", "CNE_OP", "CNEDET", "CNE_OP", "Ordem de Produção", cMsgErr, "Verifique a quantidade solicitada!")
                    Exit
                EndIf

            EndIf

        Next

    EndIf

Return lRet
