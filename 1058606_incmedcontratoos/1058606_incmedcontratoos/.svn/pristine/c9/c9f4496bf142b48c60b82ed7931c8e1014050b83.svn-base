#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'


/*/{Protheus.doc} MT120APV
 
@author         Julio Storino
@type           User Function
@description    Ponto de entrada que Manipula grupo de aprovação e saldo de pedido
@obs            #MATA120 #MATA121 #PC #COMPRAS #C7_APROV
 
@since          24/07/2019
@version        1.0
@return         _cReturn, Caracter, codigo do grupo aprovador
@example        Nil
@see            http://tdn.totvs.com/pages/releaseview.action?pageId=6085466
/*/
User Function MT120APV()
 
    Local __stt      := u___stt(procname(0),"MT120APV")
    Local _aArea     := GetArea()
    Local _aAreaY1   := SY1->(GetArea())
    Local _cReturn   := GetMv("MV_PCAPROV") // Grupo de aprovacao padrao para retorno
    Local _lHCDireta := U_YGETNPAR("MV_YHBCDIR",.F.)
    Local _cGrpApv   := ""
    Local lAltGrp    := U_YGETNPAR("MV_YLNVCDG",.F.) /// Ticket #811288 - Simon R. Ferreiro 26/02/2023
     
    //Jose Leite - 19/07/19 - 102233 - Compra Direta
    If _lHCDireta .and. AllTrim(FunName()) $ "MATA120/MATA121" .and. !IsBlind() .and. !lAltGrp
        DbSelectArea("SY1")
        SY1->(DbSetOrder(3)) //Y1_FILIAL+Y1_USER
        SY1->(DbGoTop())
        If SY1->(DbSeek(xFilial("SY1") + __cUserId)) .and. !Empty(SY1->Y1_GRAPROV)
            _cGrpApv := SY1->Y1_GRAPROV
        EndIf
        If !Empty(_cGrpApv)
            _cReturn := _cGrpApv 
        EndIf
    Elseif _lHCDireta .and. AllTrim(FunName()) $ "MATA120/MATA121" .and. !IsBlind() .and. lAltGrp
        _cReturn := SC7->C7_APROV 
    Elseif _lHCDireta .and. IsInCallStack('U_BFMA46HS') .and. !IsInCallStack('GerMedContrato')
        _cReturn := SC7->C7_XGRAPRO 
    EndIf

    // Alexandre Bastos - 27/01/2021 - #327692 - removido pois estava afetando legenda e rotina de liberacao de compra direta. esse trecho foi transferido para MT120FIM
    // If IsBlind() .and. FunName() == 'CNTA120'
    //     _cReturn := CND->CND_APROV
    // Endif
     
Return( _cReturn )
