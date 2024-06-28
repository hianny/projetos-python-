#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ 1058606  บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de update dos dicionแrios para compatibiliza็ใo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function 1058606()

Local aSay         := {}
Local aButton      := {}
Local aMarcadas    := {}
Local lExclu       := .T.
Local cTitulo      := '1058606 - Atualiza็ใo de Dicionแrios e Tabelas'
Local cDesc1       := 'Esta rotina tem como objetivo realizar a atualiza็ใo  dos dicionแrios do Sistema ( SX?/SIX )'
Local cDesc2       := Replicate('-',110)
Local cDesc3       := 'Esta atualiza็ใo ' + if(lExclu,'deve','pode') + ' ser executada em modo [ ** ' + if(lExclu,'E X C L U S I V O','C O M P A R T I L H A D O') + ' ** ]'
Local cDesc4       := Replicate('-',110)
Local cDesc5       := '[DIVERSOS] :SX3,SXB,SX6,SX7'
Local cDesc6       := Replicate('-',110)
Local cDesc7       := '*******  [  Fa็a sempre BACKUP antes de aplicar qualquer compatibilizador  ]  *******'
Local cLibCli      := ''
Local lOk          := .F.
Local cVersion     := '1.1' 
Local cVerUpd      := MemoRead('\system\mv_verupd.par')

Private cDevName   := 'HELITOM SILVA     '
Private cTicket    := '105860'
Private lAuditDic  := .T.
Private lAuditZZA  := .T.
Private aAudiVal   := {,}
Private cAudiReg   := '' 
Private cTimeIni   := '' 
Private cTimeFim   := '' 
Private lOpen
Private lMacOS     := (GetRemoteType(@cLibCli),('MAC' $ cLibCli))
Private cComando   := If(lMacOS,'Open ','Cmd /c Start ')

Private oMainWnd   := Nil
Private oProcess   := Nil
Private cFixEmp    := '??'
Private lChkOrd    := .F.
Private lChkPar    := .F.
Private lChkTod    := .F.
Private cEmpSel    := ''
Private _nTamFil   := 0 

If cVersion <> cVerUpd 
	 Alert('Favor verificar a versใo do gera update - o mesmo encontra-se diferente do parametro')
	 Return 
EndIf 

#IFDEF TOP
    TCInternal( 5, '*OFF' ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := Nil
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
aAdd( aSay, cDesc6 )
aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

FormBatch(  cTitulo,  aSay,  aButton )

If lOk

   aMarcadas := EscEmpresa(lExclu)

   If !Empty( aMarcadas )
      If  ApMsgNoYes( 'Confirma a atualiza็ใo dos dicionแrios ?', cTitulo )

         oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lExclu ) }, cTicket + ' - Atualizando', 'Aguarde, atualizando ...', .F. )
         oProcess:Activate()

         If !lOk
            MsgStop( 'Atualiza็ใo nใo Realizada.' )
         EndIf

      Else
         MsgStop( 'Atualiza็ใo nใo Realizada.' )
      EndIf
   Else
      MsgStop( 'Voc๊ nใo selecionou nenhuma empresa !' )
   EndIf

EndIf

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSTProc  บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da grava็ใo dos arquivos           ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSTProc( lEnd, aMarcadas, lExclu )

Local   aTexto    := {}
Local   aLog      := {}
Local   cFile     := ''
Local   cSave     := ''
Local   cFileLog  := ''
Local   cAux      := ''
Local   cMask     := 'Arquivos Texto (*.LOG)|*.log|'
Local   nRecno    := 0
Local   nI        := 0
Local   nX        := 0
Local   nZ        := 0
Local   nY        := 0
Local   nPos      := 0
Local   aRecnoSM0 := {}
Local   aInfo     := {}
Local   lOpen     := .F.
Local   lRet      := .T.
Local   oDlg      := Nil
Local   oMemo     := Nil
Local   oFont     := Nil
Local   lAlertLog := .F.

Private aArqUpd   := {}
Private aX3Add    := {}
Private aAuditDic := {}

//Marca a hora de inicio do compatibilizador
cTimeIni := Time()

If ( lOpen := MyOpenSm0Ex(lExclu) )

   dbSelectArea( 'SM0' )
   dbGoTop()

   While !SM0->( EOF() )
      // So adiciona no aRecnoSM0 se tiver sido escolhida e ainda nao estiver no array
      If Empty( nZ := aScan( aRecnoSM0, { |x| x[1] == SM0->M0_CODIGO } )) .And. (aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0)
            aAdd( aRecnoSM0, { SM0->M0_CODIGO , SM0->M0_CODFIL , SM0->M0_NOME , {} } )
            cEmpSel += If(Empty(cEmpSel),'','-') + SM0->M0_CODIGO
            nZ := Len(aRecnoSM0)
      EndIf

      If !Empty(nZ)
         aAdd( aRecnoSM0[nZ][4] , AllTrim(SM0->M0_CODFIL) )
      EndIf

      SM0->( dbSkip() )
   End

   If lOpen

      oProcess:SetRegua1( ( Len(aRecnoSM0) * DefRegua(1) ) )
      oProcess:SetRegua2( DefRegua(2) )

      For nI := 1 To Len( aRecnoSM0 )

         aArqUpd := {} 

         RpcSetType( 2 )
         RpcSetEnv( aRecnoSM0[nI][1] , aRecnoSM0[nI][2] , 'administrador' )

         lMsFinalAuto := .F.
         lMsHelpAuto  := .F.

         LogAdd( @aTexto , Replicate( '-', 128 ) )
         LogAdd( @aTexto , 'Empresa : ' + aRecnoSM0[nI][1] + '/' + aRecnoSM0[nI][3] )

         _nTamFil := Len(AllTrim(SM0->M0_CODFIL))


         //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
         //ณAtualiza o dicionแrio SX3         ณ
         //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
         oProcess:IncRegua1( 'Dicionแrio SX3 ' + Left( aRecnoSM0[nI][1] + ' ' + aRecnoSM0[nI][3] , 20 ) )
         bBloco := MontaBlock('{|x,y| AT00SX3(@x,y) }')
         Eval( bBloco , aTexto , lChkOrd )


         //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
         //ณAtualiza o dicionแrio SXB         ณ
         //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
         oProcess:IncRegua1( 'Dicionแrio SXB ' + Left( aRecnoSM0[nI][1] + ' ' + aRecnoSM0[nI][3] , 20 ) )
         bBloco := MontaBlock('{|x| AT00SXB(@x) }')
         Eval( bBloco , aTexto )


         //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
         //ณAtualiza o dicionแrio SX6         ณ
         //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
         oProcess:IncRegua1( 'Dicionแrio SX6 ' + Left( aRecnoSM0[nI][1] + ' ' + aRecnoSM0[nI][3] , 20 ) )
         bBloco := MontaBlock('{|x,y| AT00SX6(@x,y) }')
         Eval( bBloco , aTexto , If(lChkPar,aRecnoSM0[nI][4],Nil) )


         //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
         //ณAtualiza o dicionแrio SX7         ณ
         //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
         oProcess:IncRegua1( 'Dicionแrio SX7 ' + Left( aRecnoSM0[nI][1] + ' ' + aRecnoSM0[nI][3] , 20 ) )
         bBloco := MontaBlock('{|x| AT00SX7(@x) }')
         Eval( bBloco , aTexto )


         //------------------------------
         // Alteracao fisica dos arquivos
         //------------------------------
         __SetX31Mode( .F. )
         oProcess:SetRegua2( DefRegua(2) )

         For nX := 1 To Len( aArqUpd )

            //Se a Tabela for encontrada neste array, significa que alguma empresa anterior
            //aponta para ela e ja fez toda aplicacao das alteracoes, pulo sem fazer nada
            If !(SubStr(RetSQLName(aArqUpd[nx]),4,2)==aRecnoSM0[nI][1]) .AND. (SubStr(RetSQLName(aArqUpd[nx]),4,2) == '10' .And. aRecnoSM0[nI][1] <> '01')
               oProcess:IncRegua2('Aplicando altera็๕es na base de dados...')
               Loop
            EndIf

            If Select( aArqUpd[nx] ) > 0
               dbSelectArea( aArqUpd[nx] )
               dbCloseArea()
            EndIf

            X31UpdTable( aArqUpd[nx] )

            If __GetX31Error()
               LogAdd( @aTexto , 'Erro.: Ocorreu um erro desconhecido durante a atualiza็ใo da estrutura da tabela : ' + aArqUpd[nx] )
               LogAdd( @aTexto , __GetX31Trace() )
            Else
               If ChkFile(aArqUpd[nx])
                  DbSelectArea(aArqUpd[nx])
               Else
                  LogAdd( @aTexto , 'Erro.: No dicionario de Dados Nao existe a estrutura da tabela : ' + aArqUpd[nx] )
                  LogAdd( @aTexto , __GetX31Trace() )
               EndIf
            EndIf

            oProcess:IncRegua2('Aplicando altera็๕es na base de dados...')

         Next nX

         For nY:= 1 to Len(aX3Add)
             If X3CheckDB( aX3Add[nY] )
                LogAdd( @aTexto , 'Erro.: Ocorreu um erro na cria็ใo do campo no banco de dados : ' + aX3Add[nY] )
             Endif
         Next nY

         __SetX31Mode( .T. )

         RpcClearEnv()

         If !( lOpen := MyOpenSm0Ex(lExclu) )
            lRet := .F.
            Exit
         EndIf

      Next nI

      //Marca a hora Fim do compatibilizador
      cTimeFim := Time()

      If lOpen

         If !Empty(aTexto) .And. ValType(aTexto[1])=='C'
            aTexto := {aTexto}
         EndIf

         For nI := 1 To Len(aTexto)
            For nZ := 1 To Len(aTexto[nI])
               If (lAlertLog := ('warning.' $ lower(aTexto[nI][nZ])) .Or. ('erro.' $ lower(aTexto[nI][nZ])))
                  Exit
               EndIf
            Next nZ
         Next nI

         aSize( aTexto , Len(aTexto)+1 )
	        aIns( aTexto , 1 )
         aTexto[1] := {}

         aAdd( aTexto[1] , Replicate( '-', 128 ) )
         aAdd( aTexto[1] , 'LOG DA ATUALIZACAO DOS DICIONARIOS' )
         aAdd( aTexto[1] , Replicate( '-', 128 ) )

         aAdd( aTexto[1] , ' Dados Ambiente'        )
         aAdd( aTexto[1] , ' --------------------'  )
         aAdd( aTexto[1] , ' Data/Hora Inicio ..:' + cTimeIni )
         aAdd( aTexto[1] , ' Data/Hora Fim......: ' + cTimeFim )
         aAdd( aTexto[1] , ' Duracao............: ' + ElapTime(cTimeIni,cTimeFim) )
         aAdd( aTexto[1] , ' Environment........: ' + GetEnvServer() )
         aAdd( aTexto[1] , ' StartPath..........: ' + GetSrvProfString( 'StartPath', '' ) )
         aAdd( aTexto[1] , ' RootPath...........: ' + GetSrvProfString( 'RootPath', '' ) )
         aAdd( aTexto[1] , ' Versao.............: ' + GetVersao(.T.) )
         aAdd( aTexto[1] , ' Usuario Microsiga..: ' + If(Empty(__cUserID),'000000 Administrador', __cUserId + ' ' +  cUserName) )
         aAdd( aTexto[1] , ' Computer Name......: ' + GetComputerName() )

         aInfo   := GetUserInfo()
         If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
            aAdd( aTexto[1] , ' '  + CRLF )
            aAdd( aTexto[1] , ' Dados Thread' )
            aAdd( aTexto[1] , ' --------------------' )
            aAdd( aTexto[1] , ' Usuario da Rede....: ' + aInfo[nPos][1] )
            aAdd( aTexto[1] , ' Estacao............: ' + aInfo[nPos][2] )
            aAdd( aTexto[1] , ' Programa Inicial...: ' + aInfo[nPos][5] )
            aAdd( aTexto[1] , ' Environment........: ' + aInfo[nPos][6] )
            aAdd( aTexto[1] , ' Conexao............: ' + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), '' ), Chr( 10 ), '' ) ) )
         EndIf

         aAdd( aTexto[1] , ' '  + CRLF )
         aAdd( aTexto[1] , ' Parametros de execucao' )
         aAdd( aTexto[1] , ' ----------------------' )
         aAdd( aTexto[1] , ' Modo do Compat.....: ' + If(lExclu,'Exclusivo','Compartilhado') )
         aAdd( aTexto[1] , ' Check Todos........: ' + If(lChkTod,'.T.','.F.') )
         aAdd( aTexto[1] , ' Check Param p/ Fil.: ' + If(lChkPar,'.T.','.F.') )
         aAdd( aTexto[1] , ' Fixar Empresa......: ' + cFixEmp )
         aAdd( aTexto[1] , ' Check Altera Ordem.: ' + If(lChkOrd,'.T.','.F.') )
         aAdd( aTexto[1] , ' Empresas Selec.....: ' + cEmpSel )

         aAdd( aTexto[1] , ' '  + CRLF )
         aAdd( aTexto[1] , ' Para ver o LOG Completo clique no botใo abaixo !' )

         Define Font oFont Name 'Mono AS' Size 5, 12

         oDlg    := TDialog():New( 003, 000, 340, 417, cTicket + ' - Atualizacao concluida', , , , , CLR_BLACK, CLR_WHITE, , , .T. )
         oTimer  := TTimer():New( 0, { || (If(lAlertLog,MsgStop('Aten็ใo...'+CRLF+'Houve erros/warnings durante a execu็ใo'+CRLF+'Verifique atentamente o LOG !!!'),Nil),oTimer:DeActivate()) }, oDlg )
         oBrowse := TCBrowse():New( 05 , 05, 200, 145,,{'Log de Atualiza็ใo - Resumo'},{100},oDlg,,,,,{||},,oFont,,,,,.F.,,.T.,,.F.,/*bValid*/,.T.,.F.)
         oBrowse:SetArray(aTexto[1])
         oBrowse:oFont := oFont
         oBrowse:AddColumn( TCColumn():New('Log de Atualiza็ใo'     ,{ || aTexto[1][oBrowse:nAt] },,,,'LEFT',,.F.,.T.,,,,.F.,) )

         oTBut1  := TButton():New(153,165,'Encerrar',oDlg,{|| oDlg:End()}, 040, 010, , , .F., .T., .F., , .F., , , .F. )     
         oTBut2  := TButton():New(153,125,'Salvar',oDlg,{|| (cFile:=cGetFile(cMask,'Salvar LOG',1,,.T.),If(!Empty(cFile),SaveLog(cFile,aTexto),Nil))}, 040, 010, , , .F., .T., .F., , .F., , , .F. )
         oTBut3  := TButton():New(153,005,'Ver Log Completo',oDlg,{|| (cFile:=CriaTrab(Nil,.F.)+'.Log',cSave:=GetTempPath(),SaveLog(if(lMacOS,'I:','')+cSave+cFile,aTexto),WaitRun(cComando+AllTrim(cSave+cFile),0),cFile:='')},070,010,,,.F.,.T.,.F.,,.F.,,,.F.)

         oDlg:Activate( , , , .T., { || .T. }, , { || oTimer:Activate() } )

      EndIf

   EndIf

Else

   lRet := .F.

EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ SAVELOG  บAutor  ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Generica para salvar o Log da Operacao do Patch     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compatibilizador de Dicionarios                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SaveLog(cFile,aLog)

Local nHdlLog := 0
Local nI,nZ   := 0

If At('.',cFile) = 0
	  cFile := cFile + '.log'
EndIf

_nHdlLog := fCreate(cFile,Nil,Nil,!lMacOs)

For nI := 1 To Len(aLog)
   For nZ := 1 To Len(aLog[nI])
      If ValType(aLog[nI][nZ]) = 'C' .And. !(aLog[nI][nZ]==' Para ver o LOG Completo clique no botใo abaixo !')
         fWrite(_nHdlLog,aLog[nI][nZ] + CRLF)
      EndIf
   Next nZ
Next nI

fClose(_nHdlLog)

Return( Nil )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณESCEMPRESAบAutor  ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Generica para escolha de Empresa, montado pelo SM0_ บฑฑ
ฑฑบ          ณ Retorna vetor contendo as selecoes feitas.                 บฑฑ
ฑฑบ          ณ Se nao For marcada nenhuma o vetor volta vazio.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EscEmpresa(lExclu)

Local   aSalvAmb := GetArea()
Local   aSalvSM0 := {}
Local   aRet     := {}
Local   aVetor   := {}
Local   oDlg     := Nil
Local   oChkMar  := Nil
Local   oChkPar  := Nil
Local   oChkOrd  := Nil
Local   oLbx     := Nil
Local   oFixEmp  := Nil
Local   oButInv  := Nil
Local   oSay     := Nil
Local   oOk      := LoadBitmap( GetResources(), 'LBOK' )
Local   oNo      := LoadBitmap( GetResources(), 'LBNO' )
Local   lOk      := .F.
Local   cVar     := ''
Local   cNomEmp  := ''
Local   aSelEmp  := {'01','02','03','05','06','07','08','12','14','15','16','17','18','19','20','21','22','40','50','51','70','71','72','75','76','8F','90','96','97','98'}


If !MyOpenSm0Ex(lExclu)
   Return( aRet )
EndIf


dbSelectArea( 'SM0' )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

While !SM0->( EOF() )

   If aScan( aSelEmp , {|x| x==AllTrim(SM0->M0_CODIGO)} ) == 0
      DbSkip()
      Loop
   EndIf

   If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
      aAdd(  aVetor, { .F. , SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
   EndIf

   DBSkip()
End

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title '' From 0, 0 To 270, 396 Pixel

oDlg:cToolTip := 'Tela para M๚ltiplas Sele็๕es de Empresas/Filiais'

oDlg:cTitle := 'Selecione a(s) Empresa(s) para Atualiza็ใo'

@ 10, 10 Listbox  oLbx Var  cVar Fields Header ' ', ' ', 'Empresa' Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| { IIf(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2] , aVetor[oLbx:nAt,4] } }
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChkTod, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 109, 10 CheckBox oChkMar Var lChkTod Prompt 'Todos'   Message 'Marca / Desmarca Todos' Size 40, 007 Pixel Of oDlg on Click MarcaTodos( lChkTod, @aVetor, oLbx )


@ 123, 10 Button oButInv Prompt '&Inverter'  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChkTod, oChkMar ), VerTodos( aVetor, @lChkTod, oChkMar ) ) ;
Message 'Inverter Sele็ใo' Of oDlg

Define SButton From 124, 127 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop 'Confirma a Sele็ใo'  Enable Of oDlg
Define SButton From 124, 160 Type 2 Action ( oDlg:End() ) OnStop 'Abandona a Sele็ใo' Enable Of oDlg

Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( 'SM0' )
dbCloseArea()

Return( aRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMARCATODOSบAutor  ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para marcar/desmarcar todos os itens do    บฑฑ
ฑฑบ          ณ ListBox ativo                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
   aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณINVSELECAOบAutor  ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para inverter selecao do ListBox Ativo     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
   aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณRETSELECAOบAutor  ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar que monta o retorno com as selecoes        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
   If aVetor[nI][1]
      aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
   EndIf
Next nI

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ VERTODOS บAutor  ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para verificar se estao todos marcardos    บฑฑ
ฑฑบ          ณ ou nao                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerTodos( aVetor, lChk, oChkMar )

Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
   lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ MyOpenSM บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento abertura do SM0 modo exclusivo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ MyOpenSM                                                   ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MyOpenSM0Ex(lExclu)

Local lOpen := .F.
Local nLoop := 0

If FindFunction( 'OpenSM0Excl' )
	   For nLoop := 1 To 20
       If OpenSM0Excl( '.F.' )
	          lOpen := .T.
	          Exit
	       EndIf
	       Sleep( 500 )
	   Next nLoop
Else
	   For nLoop := 1 To 20
        dbUseArea( .T.,, 'SIGAMAT.EMP', 'SM0', !lExclu , .F. )

        If !Empty( Select( 'SM0' ) )
           lOpen := .T.
           dbSetIndex( 'SIGAMAT.IND' )
           Exit
        EndIf

        Sleep( 500 )

	   Next nLoop
Endif

If !lOpen
   ApMsgStop( 'Nใo foi possํvel a abertura da tabela ' + ;
              'de empresas' + If(lExclu,' de forma exclusiva.','.') , 'ATENวรO' )
EndIf

Return( lOpen )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ  LogAdd  บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de gravacao do Log de processamento do compatibili- ณฑฑ
ฑฑบ          ณ zador.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ LogAdd( ArrayLog , 'Texto a ser gravado' )                 ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LogAdd(aTxt,cTxt)

If Empty(aTxt)
   aAdd( aTxt , cTxt )
ElseIf ValType(aTxt[1])=='C'
   If Len(aTxt) >= 3000
		aTxt := {aTxt,{}}   	
   	aAdd( aTxt[2] , cTxt )
   Else
      aAdd( aTxt , cTxt )
   EndIf
Else
   If Len(aTxt[Len(aTxt)]) >= 3000
      aAdd( aTxt , {} )
      aAdd( aTxt[Len(aTxt)] , cTxt )
	Else
      aAdd( aTxt[Len(aTxt)] , cTxt )	
   EndIf
EndIf

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ NOTNULL  บAutor  ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Generica para validar o valor do campo, caso esteja บฑฑ
ฑฑบ          ณ com valor Nil, o campo ้ desconsiderado para fins de updat บฑฑ
ฑฑบ          ณ da tabela.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NotNull(xVal)

Local   lRet := .T. 

If ( ValType(xVal) = 'U' ) .Or. ;
   ( ValType(xVal) = 'C' .And. xVal = 'Nil' ) .Or. ;
   ( ValType(xVal) = 'N' .And. xVal < 0     )       
   lRet := .F.
EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ CHECKCOL บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Verifica se um campo exisste no Banco de Dados.            ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ CheckCol(cCampo,cEmpresa)                                  ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CheckCol(_cCampo,_cEmpresa)

Local	_cQry	:= ''

If TcGetDB() == 'ORACLE' 
   _cQry := ' SELECT COUNT(*) EXISTE '
   _cQry += ' FROM ALL_TAB_COLUMNS '
   _cQry += ' WHERE OWNER = (SELECT USERNAME FROM V$SESSION WHERE AUDSID = SYS_CONTEXT(' + SIMPLES + 'userenv' + SIMPLES + ',' + SIMPLES + 'sessionid' + SIMPLES + '))' 
   _cQry += ' AND COLUMN_NAME = ' + SIMPLES + _cCampo + SIMPLES 
   _cQry += ' AND TABLE_NAME = SUBSTR(COLUMN_NAME,1,INSTR(COLUMN_NAME,' + SIMPLES + '_' + SIMPLES + ')-1) || ' +  SIMPLES + _cEmpresa + '0' + SIMPLES 
Else 
   _cQry := ' SELECT COUNT(*) EXISTE ' 
   _cQry += ' FROM syscolumns '
   _cQry += ' WHERE name = ' + SIMPLES + _cCampo + SIMPLES 
EndIf 

If Select('XCOL') > 0
   XCOL->(DbCloseArea())
EndIf

DbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQry),'XCOL',.F.,.T.)

_lRet := ( XCOL->EXISTE > 0 )

XCOL->(DbCloseArea())

Return( _lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ AUDITDIC บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Grava a auditoria das alteracoes realizadas no dicionario  ณฑฑ
ฑฑบ          ณ no banco de dados do AUDIT_TRAIL.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ AuditDic( aDados , aLog )                                  ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AuditDic( aAudit , aTexto )

Local _nI     := 0
Local _nF     := 0
Local _lErro  := .F.
Local _lExec  := .F.
Local _cQuery := ''

If !lAuditDic
   aAudit := {}
   Return( Nil )
EndIf

For _nI := 1 To Len( aAudit )

   _lExec := .T.

   _cQuery := 'INSERT INTO AUDITTRAIL.AUDIT_DICT(AD_DEVNAME, AD_TICKET, AD_EMPRESA, AD_TIME, AD_DATE, AD_OP, AD_TABLE, AD_REGISTRO, AD_FIELD, AD_CONTENT, AD_NEWCONT) '
   _cQuery += 'VALUES(' + SIMPLES + '%VL01%' + SIMPLES + ',' + SIMPLES + '%VL02%' + SIMPLES + ',' + SIMPLES + '%VL03%' + SIMPLES + ','
   _cQuery +=             SIMPLES + '%VL04%' + SIMPLES + ',' + SIMPLES + '%VL05%' + SIMPLES + ',' + SIMPLES + '%VL06%' + SIMPLES + ','
   _cQuery +=             SIMPLES + '%VL07%' + SIMPLES + ',' + SIMPLES + '%VL08%' + SIMPLES + ',' + SIMPLES + '%VL09%' + SIMPLES + ','
   _cQuery +=             SIMPLES + '%VL10%' + SIMPLES + ',' + SIMPLES + '%VL11%' + SIMPLES + ')'

   For _nF := 1 To Len( aAudit[_nI] )

         _cQuery := StrTran(_cQuery,'%VL'+StrZero(_nF,2)+'%',If(Empty(aAudit[_nI][_nF]),' ',StrTran(aAudit[_nI][_nF],Chr(39),Chr(39)+Chr(39))))

   Next _nF

   If ( TCSQLExec(_cQuery) < 0 )
      LogAdd( @aTexto , 'Warning.: Auditoria nao inserida...' )
      LogAdd( @aTexto , 'Script..: ' + _cQuery     )
      LogAdd( @aTexto , 'Retorno.: ' + TCSQLError())
      _lErro := .T.
   EndIf

Next _nI

If _lExec .And. !_lErro
   LogAdd( @aTexto , 'Auditoria registrada com sucesso...' )
EndIf

//-----------------------------------------------------------------
//Chama a Auditoria de Campos Padroes do Dicionario (se for o caso)
//-----------------------------------------------------------------
If lAuditZZA
   For _nI := 1 To Len( aAudit )
      If (AllTrim(aAudit[_nI][09]) $ 'X3_VLDUSER~X3_F3~X3_RELACAO~X2_UNICO~X3_VALID~X3_WHEN~X3_DECIMAL~X3_NIVEL~X3_TAMANHO')
         If Len(aAudit[_nI])>11 .And. !(aAudit[_nI][12]=='U')
            AuditZZA( aAudit[_nI] , @aTexto )
         EndIf
      EndIf
   Next _nI
EndIf

aAudit := {}

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ AUDITZZA บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Grava a auditoria das alteracoes realizadas no dicionario  ณฑฑ
ฑฑบ          ณ no banco de dados na Tabela ZZA - Monitoramento do Dic.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ AuditZZA( aDados , aLog )                                  ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AuditZZA( aAudit , aTexto )

Local _nI     := 0
Local _nF     := 0
Local _lErro  := .F.
Local _cQuery := ''

If !lAuditZZA
   Return( Nil )
EndIf

//Ver se o registro ja existe...
_cQuery := 'SELECT R_E_C_N_O_ REGISTRO FROM ZZA160 '
_cQuery += ' WHERE D_E_L_E_T_ = ' + SIMPLES + ' ' + SIMPLES
_cQuery += ' AND ZZA_FILIAL = ' + SIMPLES + '       ' + SIMPLES
_cQuery += ' AND ZZA_YEMPRE = ' + SIMPLES + cEmpAnt + SIMPLES
_cQuery += ' AND ZZA_YNOMSX = ' + SIMPLES + aAudit[7] + SIMPLES
_cQuery += ' AND ZZA_YCAMPO = ' + SIMPLES + aAudit[9] + SIMPLES
_cQuery += ' AND ZZA_YREGIS = ' + SIMPLES + aAudit[8] + SIMPLES

If Select('TZZA') > 0 ; TZZA->(DbCloseArea()) ; EndIf
DbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),'TZZA',.T.,.T.)

If TZZA->(!Eof())
   _cQuery := 'UPDATE ZZA160 SET ZZA_YCONTE = ' + SIMPLES + If(Empty(aAudit[11]),' ',StrTran(aAudit[11],Chr(39),Chr(39)+Chr(39))) + SIMPLES + ' WHERE R_E_C_N_O_ = ' + cValToChar(TZZA->REGISTRO)
   TZZA->(DbCloseArea())
Else

   _cQuery := 'INSERT INTO ZZA160 (ZZA_FILIAL,ZZA_YEMPRE,ZZA_YFILIA,ZZA_YNOMSX,ZZA_YCAMPO,ZZA_YREGIS,ZZA_YCONTE,ZZA_USERGI,ZZA_USERGA,D_E_L_E_T_,R_E_C_N_O_,ZZA_DTINC,ZZA_USRINC) '
   _cQuery += 'VALUES(' + SIMPLES + '%VL01%' + SIMPLES + ',' + SIMPLES + '%VL02%' + SIMPLES + ',' + SIMPLES + '%VL03%' + SIMPLES + ','
   _cQuery +=             SIMPLES + '%VL04%' + SIMPLES + ',' + SIMPLES + '%VL05%' + SIMPLES + ',' + SIMPLES + '%VL06%' + SIMPLES + ','
   _cQuery +=             SIMPLES + '%VL07%' + SIMPLES + ',' + SIMPLES + '%VL08%' + SIMPLES + ',' + SIMPLES + '%VL09%' + SIMPLES + ','
   _cQuery +=             SIMPLES + '%VL10%' + SIMPLES + ',' + SIMPLES + '%VL11%' + SIMPLES + ',' + SIMPLES + '%VL12%' + SIMPLES + ',' + SIMPLES + '%VL13%' + SIMPLES + ')'

   For _nF := 1 To 13 

      Do Case
         Case _nF = 1
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+'  '+Chr(39))                            		//FILIAL
         Case _nF = 2
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+cEmpAnt+Chr(39))                          		//EMPRESA
         Case _nF = 3
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+'  '+Chr(39))                            		//YFILIAL
         Case _nF = 4
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+ aAudit[7] +Chr(39))                      		//NOME SX
         Case _nF = 5
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+ aAudit[9] +Chr(39))                      		//CAMPO SX
         Case _nF = 6
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+ aAudit[8] +Chr(39))                      		//REGISTRO SX
         Case _nF = 7
            _cQuery := StrTran(_cQuery,'%VL'+StrZero(_nF,2)+'%',If(Empty(aAudit[11]),' ',StrTran(aAudit[11],Chr(39),Chr(39)+Chr(39))))  	//CONTEUDO
         Case _nF = 8
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+'       '+Chr(39))                        		//USER INCLUSAO
         Case _nF = 9
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+'       '+Chr(39))                        		//USER ALTERACAO
         Case _nF = 10
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+' '+Chr(39))                              		//D_E_L_E_T_
         Case _nF = 11
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),'(SELECT NVL(MAX(R_E_C_N_O_)+1,1) FROM ZZA160)')   		//R_E_C_N_O_
         Case _nF = 12
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),  dtos(DATE())  )   										//DATA INCLUSAO
         Case _nF = 13
            _cQuery := StrTran(_cQuery,Chr(39)+'%VL'+StrZero(_nF,2)+'%'+Chr(39),Chr(39)+If(Empty(aAudit[1]),' ',Alltrim(aAudit[1])) +Chr(39) )	//USER INCLUSAO
      EndCase

   Next _nF

EndIf

If ( TCSQLExec(_cQuery) < 0 )
   LogAdd( @aTexto , 'Warning.: Auditoria ZZA nao inserida...' )
   LogAdd( @aTexto , 'Script..: ' + _cQuery     )
   LogAdd( @aTexto , 'Retorno.: ' + TCSQLError())
   _lErro := .T.
EndIf

If !_lErro
   LogAdd( @aTexto , 'Auditoria ZZA registrada com sucesso...' )
EndIf

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ CANADD   บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Valida se os dados constantes do compatibilizador sao      ณฑฑ
ฑฑบ          ณ suficientes para criar um novo registro no dicionario.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ CannAdd( Estrutura , Dados )                               ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CanAdd( aEstru , aDados )

Local _lRet      := .F.
Local _nI        := 0

For _nI := 1 To Len(aEstru)
   If !(_lRet := NotNull(aDados[_nI]))
	     Exit
   EndIf
Next _nI

Return( _lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MAKECHR  บAutor  ณ - JULIO STORINO -  บ Data ณ  09/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ROTINA PARA PREPARAR OS DADOS DOS CAMPOS USADO/OBRIGATORIO บฑฑ
ฑฑบ          ณ DO DICIONARIO PARA O BANCO ORACLE (AUDITORIA)              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MakeCHR( cTxt )

Local _cRet  := ''
Local _nI    := 0

For _nI := 1 To Len(cTxt)
   _cRet += IIF(!Empty(_cRet),' || ','') + 'CHR(' + StrZero(Asc(SubStr(cTxt,_nI,1)),3) + ')'
Next

Return( _cRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ AT00SX3  บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX3 - Campos        ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AT00SX3( aTexto , lOrd )

Local aEstrut   := {}
Local aSX3      := {}
Local cAliasAtu := ''
Local cSeqAtu   := ''
Local cPro      := ''
Local nI        := 0
Local nJ        := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosPRO   := 0
Local nPosTam   := 0
Local nSeqAtu   := 0
Local nPosReal  := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

LogAdd( @aTexto , 'Inicio da Atualizacao do SX3' )

aEstrut := { 'X3_ARQUIVO', ; 
             'X3_ORDEM', ; 
             'X3_CAMPO', ; 
             'X3_TIPO', ; 
             'X3_TAMANHO', ; 
             'X3_DECIMAL', ; 
             'X3_TITULO', ; 
             'X3_TITSPA', ; 
             'X3_TITENG', ; 
             'X3_DESCRIC', ; 
             'X3_DESCSPA', ; 
             'X3_DESCENG', ; 
             'X3_PICTURE', ; 
             'X3_VALID', ; 
             'X3_USADO', ; 
             'X3_RELACAO', ; 
             'X3_F3', ; 
             'X3_NIVEL', ; 
             'X3_RESERV', ; 
             'X3_CHECK', ; 
             'X3_TRIGGER', ; 
             'X3_PROPRI', ; 
             'X3_BROWSE', ; 
             'X3_VISUAL', ; 
             'X3_CONTEXT', ; 
             'X3_OBRIGAT', ; 
             'X3_VLDUSER', ; 
             'X3_CBOX', ; 
             'X3_CBOXSPA', ; 
             'X3_CBOXENG', ; 
             'X3_PICTVAR', ; 
             'X3_WHEN', ; 
             'X3_INIBRW', ; 
             'X3_GRPSXG', ; 
             'X3_FOLDER', ; 
             'X3_PYME', ; 
             'X3_CONDSQL', ; 
             'X3_CHKSQL', ; 
             'X3_IDXSRV', ; 
             'X3_ORTOGRA', ; 
             'X3_IDXFLD', ; 
             'X3_TELA', ; 
             'X3_PICBRV', ; 
             'X3_AGRUP', ; 
             'X3_POSLGT', ; 
             'X3_MODAL' } 


aAdd( aSX3, { ;
   'CNE' , ; //X3_ARQUIVO
   '76' , ; //X3_ORDEM
   'CNE_ETAPOS' , ; //X3_CAMPO
   'C' , ; //X3_TIPO
    6 , ; //X3_TAMANHO
    0 , ; //X3_DECIMAL
   'Etapa OS    ' , ; //X3_TITULO
   'Etapa OS    ' , ; //X3_TITSPA
   'Etapa OS    ' , ; //X3_TITENG
   'Codigo da Etapa          ' , ; //X3_DESCRIC
   'Codigo da Etapa          ' , ; //X3_DESCSPA
   'Codigo da Etapa          ' , ; //X3_DESCENG
   '@!                                           ' , ; //X3_PICTURE
   '                                                                                                                                ' , ; //X3_VALID
   'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ' , ; //X3_USADO
   '                                                                                                                                ' , ; //X3_RELACAO
   'TPACNE' , ; //X3_F3
    1 , ; //X3_NIVEL
   '  x  x x     x  ' , ; //X3_RESERV
   ' ' , ; //X3_CHECK
   'N' , ; //X3_TRIGGER
   'U' , ; //X3_PROPRI
   'S' , ; //X3_BROWSE
   'A' , ; //X3_VISUAL
   'R' , ; //X3_CONTEXT
   '  x     ' , ; //X3_OBRIGAT
   'U_BFMA45HS(FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_TAREOS' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_ETAPOS' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_PRODUT' + DUPLAS + '), .T.)                     ' , ; //X3_VLDUSER
   '                                                                                                                                ' , ; //X3_CBOX
   '                                                                                                                                ' , ; //X3_CBOXSPA
   '                                                                                                                                ' , ; //X3_CBOXENG
   '                    ' , ; //X3_PICTVAR
   '                                                            ' , ; //X3_WHEN
   '                                                                                ' , ; //X3_INIBRW
   '   ' , ; //X3_GRPSXG
   ' ' , ; //X3_FOLDER
   'S' , ; //X3_PYME
   '                                                                                                                                                                                                                                                          ' , ; //X3_CONDSQL
   '                                                                                                                                                                                                                                                          ' , ; //X3_CHKSQL
   'N' , ; //X3_IDXSRV
   'N' , ; //X3_ORTOGRA
   'N' , ; //X3_IDXFLD
   '               ' , ; //X3_TELA
   '                                                  ' , ; //X3_PICBRV
   '   ' , ; //X3_AGRUP
   ' ' , ; //X3_POSLGT
   ' '  } ) //X3_MODAL

aAdd( aSX3, { ;
   'CNE' , ; //X3_ARQUIVO
   '74' , ; //X3_ORDEM
   'CNE_OP    ' , ; //X3_CAMPO
   'C' , ; //X3_TIPO
    14 , ; //X3_TAMANHO
    0 , ; //X3_DECIMAL
   'OP.         ' , ; //X3_TITULO
   '            ' , ; //X3_TITSPA
   '            ' , ; //X3_TITENG
   'Orden Produc             ' , ; //X3_DESCRIC
   '                         ' , ; //X3_DESCSPA
   '                         ' , ; //X3_DESCENG
   '@!                                           ' , ; //X3_PICTURE
   '                                                                                                                                ' , ; //X3_VALID
   'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ' , ; //X3_USADO
   '                                                                                                                                ' , ; //X3_RELACAO
   'SC2ZOP' , ; //X3_F3
    1 , ; //X3_NIVEL
   '  x  x x     x  ' , ; //X3_RESERV
   ' ' , ; //X3_CHECK
   'S' , ; //X3_TRIGGER
   'U' , ; //X3_PROPRI
   'S' , ; //X3_BROWSE
   'A' , ; //X3_VISUAL
   'R' , ; //X3_CONTEXT
   '  x     ' , ; //X3_OBRIGAT
   'U_BFMA49HS(FWFldGet(' + DUPLAS + 'CNE_YCBEM' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '), .T.)                                                                      ' , ; //X3_VLDUSER
   '                                                                                                                                ' , ; //X3_CBOX
   '                                                                                                                                ' , ; //X3_CBOXSPA
   '                                                                                                                                ' , ; //X3_CBOXENG
   '                    ' , ; //X3_PICTVAR
   '                                                            ' , ; //X3_WHEN
   '                                                                                ' , ; //X3_INIBRW
   '   ' , ; //X3_GRPSXG
   ' ' , ; //X3_FOLDER
   'S' , ; //X3_PYME
   '                                                                                                                                                                                                                                                          ' , ; //X3_CONDSQL
   '                                                                                                                                                                                                                                                          ' , ; //X3_CHKSQL
   'N' , ; //X3_IDXSRV
   'N' , ; //X3_ORTOGRA
   'N' , ; //X3_IDXFLD
   '               ' , ; //X3_TELA
   '                                                  ' , ; //X3_PICBRV
   '   ' , ; //X3_AGRUP
   ' ' , ; //X3_POSLGT
   ' '  } ) //X3_MODAL

aAdd( aSX3, { ;
   'CNE' , ; //X3_ARQUIVO
   '75' , ; //X3_ORDEM
   'CNE_TAREOS' , ; //X3_CAMPO
   'C' , ; //X3_TIPO
    6 , ; //X3_TAMANHO
    0 , ; //X3_DECIMAL
   'Tarefa OS   ' , ; //X3_TITULO
   '            ' , ; //X3_TITSPA
   '            ' , ; //X3_TITENG
   'Tarefa da OS             ' , ; //X3_DESCRIC
   '                         ' , ; //X3_DESCSPA
   '                         ' , ; //X3_DESCENG
   '@!                                           ' , ; //X3_PICTURE
   '                                                                                                                                ' , ; //X3_VALID
   'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ' , ; //X3_USADO
   '                                                                                                                                ' , ; //X3_RELACAO
   'TT9CNE' , ; //X3_F3
    1 , ; //X3_NIVEL
   '  x  x x     x  ' , ; //X3_RESERV
   ' ' , ; //X3_CHECK
   'S' , ; //X3_TRIGGER
   'U' , ; //X3_PROPRI
   'S' , ; //X3_BROWSE
   'A' , ; //X3_VISUAL
   'R' , ; //X3_CONTEXT
   '  x     ' , ; //X3_OBRIGAT
   'U_BFMA08HS(FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_TAREOS' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_PRODUT' + DUPLAS + '), .T.)                                             ' , ; //X3_VLDUSER
   '                                                                                                                                ' , ; //X3_CBOX
   '                                                                                                                                ' , ; //X3_CBOXSPA
   '                                                                                                                                ' , ; //X3_CBOXENG
   '                    ' , ; //X3_PICTVAR
   '                                                            ' , ; //X3_WHEN
   '                                                                                ' , ; //X3_INIBRW
   '   ' , ; //X3_GRPSXG
   ' ' , ; //X3_FOLDER
   'S' , ; //X3_PYME
   '                                                                                                                                                                                                                                                          ' , ; //X3_CONDSQL
   '                                                                                                                                                                                                                                                          ' , ; //X3_CHKSQL
   'N' , ; //X3_IDXSRV
   'N' , ; //X3_ORTOGRA
   'N' , ; //X3_IDXFLD
   '               ' , ; //X3_TELA
   '                                                  ' , ; //X3_PICBRV
   '   ' , ; //X3_AGRUP
   ' ' , ; //X3_POSLGT
   ' '  } ) //X3_MODAL


// ----------------------
// Atualizando dicionแrio
// ----------------------

nPosArq := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_ARQUIVO' } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_ORDEM'   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_CAMPO'   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_TAMANHO' } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_GRPSXG'  } )
nPosPRO := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_PROPRI'  } )
nPosReal:= aScan( aEstrut, { |x| AllTrim( x ) == 'X3_CONTEXT'  } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )


dbSelectArea( 'SX3' )
dbSetOrder( 2 )
cAliasAtu := ''

For nI := 1 To Len( aSX3 )

   cPro := ''

   //  ---------------------------------------------------------
   // Verifica se o campo faz parte de um grupo e ajusta tamanho
   //  ---------------------------------------------------------
   If !Empty(nPosSXG) .And. !Empty(nPosTam) .And. NotNull(aSX3[nI][nPosTam]) .And. NotNull(aSX3[nI][nPosSXG])
      SXG->( dbSetOrder( 1 ) )
      If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
         If aSX3[nI][nPosTam] <> SXG->XG_SIZE
            aSX3[nI][nPosTam] := SXG->XG_SIZE
            LogAdd( @aTexto , 'O tamanho do campo ' + aSX3[nI][nPosCpo] + ' no compatibilizador foi ignorado !' )
            LogAdd( @aTexto , 'O mesmo foi mantido em [' + AllTrim( Str( SXG->XG_SIZE ) ) + ']' )
            LogAdd( @aTexto , 'Por pertencer ao grupo de campos [' + SX3->X3_GRPSXG + ']' )
            LogAdd( @aTexto , '' )
         EndIf
      EndIf
   EndIf

   DbSelectArea('SX3')
   DbSetOrder(2)
   If !SX3->( dbSeek( cAudiReg := PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )
      If aSX3[nI][nPosReal] = 'R' 
          aAdd(aX3Add, cAudiReg ) 
      Endif 

      If .Not. ('Z/SZ' $ SubStr(AllTrim(aSX3[nI][nPosArq]),1,3))
         If .Not. ('_Y' $ AllTrim(cAudiReg))
            LogAdd( @aTexto , 'Warning.: O Campo '+ AllTrim(cAudiReg) + ' que esta sendo criado, nใo esta de acordo com a nomenclatura Bom Futuro. Favor verificar!')
         EndIf
      EndIf

      If !CanAdd(aEstrut,aSX3[nI])
         LogAdd( @aTexto , 'Warning.: Campo ' + aSX3[nI][nPosCpo] + ' nao pode ser inserido por falta de dados no compatibilizador !')
         Loop
      EndIf

      //----------------------------
      //Obtem a Propriedade do Campo
      //----------------------------
      If Empty(cPro) ; cPro := aSX3[nI][nPosPro] ; EndIf

      //-------------------------------
      //Busca ultima ocorrencia do alias
      //-------------------------------
      If ( aSX3[nI][nPosArq] <> cAliasAtu )
         cSeqAtu   := '00'
         cAliasAtu := aSX3[nI][nPosArq]

         dbSetOrder( 1 )
         SX3->( dbSeek( cAliasAtu + 'ZZ', .T. ) )
         dbSkip( -1 )

         If ( SX3->X3_ARQUIVO == cAliasAtu )
            cSeqAtu := SX3->X3_ORDEM
         EndIf

         nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
      EndIf

      nSeqAtu++
      cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

      RecLock( 'SX3', .T. )
      LogAdd( @aTexto , 'Criado o campo ' + aSX3[nI][nPosCpo] )
      For nJ := 1 To Len( aSX3[nI] )
         If nJ == 2    // Ordem
            FieldPut( FieldPos( aEstrut[nJ] ), aAudiVal[2]:=cSeqAtu )
            aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'I' , 'SX3' , cAudiReg , aEstrut[nJ] , '' , AllTrim(AllToChar(aAudiVal[2])) , cPro } )
            LogAdd( @aTexto , 'Propriedade SX3 ' + aEstrut[nJ] + ' definida com o valor ' + AllTrim(AllToChar(aAudiVal[2])) )
         ElseIf (FieldPos( aEstrut[nJ] ) > 0) .And. NotNull(aSX3[nI][nJ])
            FieldPut( FieldPos( aEstrut[nJ] ), aAudiVal[2]:=aSX3[nI][nJ] )
            aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'I' , 'SX3' , cAudiReg , aEstrut[nJ] , '' , AllTrim(AllToChar(aAudiVal[2])) , cPro } )
            LogAdd( @aTexto , 'Propriedade SX3 ' + aEstrut[nJ] + ' definida com o valor ' + AllTrim(AllToChar(aAudiVal[2])) )
         EndIf
      Next nJ

      dbCommit()
      MsUnLock()

      If !Empty( aAuditDic )
         If Empty(aScan(aArqUpd,aSX3[nI][nPosArq]))
            aAdd( aArqUpd, aSX3[nI][nPosArq] ) 
         EndIf
         AuditDic( @aAuditDic , @aTexto )
      EndIf

   Else

      //----------------------------
      //Obtem a Propriedade do Campo
      //----------------------------
      If Empty(cPro) ; cPro := aSX3[nI][nPosPro] ; EndIf

      //  -----------------------
      // Verifica todos os campos
      //  -----------------------
      For nJ := 1 To Len( aSX3[nI] )

         //  ----------------------------------------
         // Se o campo estiver diferente da estrutura
         //  ----------------------------------------
         If NotNull(aSX3[nI][nJ]) .And. ;
            aEstrut[nJ] == SX3->( FieldName( FieldPos(aEstrut[nJ]) ) ) .And. ;
            If(aEstrut[nJ] $ 'X3_USADO/X3_OBRIGAT/X3_RESERV',SX3->( FieldGet( FieldPos(aEstrut[nJ]) ) ),PadR( StrTran( AllToChar( SX3->( FieldGet( FieldPos(aEstrut[nJ]) ) ) )	, ' ', '' ), 250 )) <>  ;
            If(aEstrut[nJ] $ 'X3_USADO/X3_OBRIGAT/X3_RESERV',AllToChar( aSX3[nI][nJ] ),PadR( StrTran( AllToChar( aSX3[nI][nJ] )           								, ' ', '' ), 250 )) .And. ;
            If( lOrd , .T. , AllTrim( SX3->( FieldName( FieldPos(aEstrut[nJ]) ) ) ) <> 'X3_ORDEM' )

            LogAdd( @aTexto , 'Alterado o campo ' + aSX3[nI][nPosCpo] + '   ' + PadR( SX3->( FieldName( FieldPos(aEstrut[nJ]) ) ), 10 ) ) 
            LogAdd( @aTexto , 'De [' + RTrim( AllToChar( aAudiVal[1]:=SX3->( FieldGet( FieldPos(aEstrut[nJ]) ) ) ) ) + ']' + ' para [' + RTrim( AllToChar( aAudiVal[2]:=aSX3[nI][nJ] ) ) + ']' )

            RecLock( 'SX3', .F. )
            FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
            dbCommit()
            MsUnLock()

            aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'U' , 'SX3' , cAudiReg , aEstrut[nJ] , AllTrim(AllToChar(aAudiVal[1])) , AllTrim(AllToChar(aAudiVal[2])) , cPro } )

         EndIf

      Next nJ

      If !Empty( aAuditDic )
         If Empty(aScan(aArqUpd,aSX3[nI][nPosArq]))
            aAdd( aArqUpd, aSX3[nI][nPosArq] ) 
         EndIf
         AuditDic( @aAuditDic , @aTexto )
      EndIf

   EndIf

   oProcess:IncRegua2( 'Atualizando Campos (SX3)...' )

Next nI

//------------------------------------------------------------------	
//     Verifica se todos os campos existem no Banco de Dados			 	
//------------------------------------------------------------------	
For nI := 1 To Len( aSX3 )
   If Empty( aScan( aArqUpd , aSX3[nI][nPosArq] ) )
	     If !CheckCol( aSX3[nI][nPosCpo] , Left(Right(RetSQLName(aSX3[nI][nPosArq]),3),2) )
         aAdd( aArqUpd , aSX3[nI][nPosArq] )
      EndIf
   EndIf
Next nI

LogAdd( @aTexto , 'Final da Atualizacao do SX3' )
LogAdd( @aTexto , Replicate( '-', 128 ) )

Return( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ AT00SXB  บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SXB - Consultas Pad ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AT00SXB( aTexto )
Local aEstrut   := {}
Local aSXB      := {}
Local nI        := 0
Local nJ        := 0

LogAdd( @aTexto , 'Inicio da Atualizacao do SXB' )

aEstrut := { 'XB_ALIAS',  'XB_TIPO'   , 'XB_SEQ'    , 'XB_COLUNA' , 'XB_DESCRI', ; 
             'XB_DESCSPA', 'XB_DESCENG', 'XB_CONTEM', 'XB_WCONTEM' }

aAdd( aSXB, { ; 
   'TPACNE' , ; //XB_ALIAS
   '1' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   'DB' , ; //XB_COLUNA
   'Etapas              ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TPA                                                                                                                                                                                                                                                       ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TPACNE' , ; //XB_ALIAS
   '2' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '01' , ; //XB_COLUNA
   'Etapa               ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   '                                                                                                                                                                                                                                                          ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TPACNE' , ; //XB_ALIAS
   '2' , ; //XB_TIPO
   '02' , ; //XB_SEQ
   '01' , ; //XB_COLUNA
   'Descri็ใo           ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   '                                                                                                                                                                                                                                                          ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TPACNE' , ; //XB_ALIAS
   '4' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '01' , ; //XB_COLUNA
   'Etapa               ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TPA_ETAPA                                                                                                                                                                                                                                                 ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TPACNE' , ; //XB_ALIAS
   '4' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '02' , ; //XB_COLUNA
   'Descri็ใo           ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TPA_DESCRI                                                                                                                                                                                                                                                ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TPACNE' , ; //XB_ALIAS
   '4' , ; //XB_TIPO
   '02' , ; //XB_SEQ
   '01' , ; //XB_COLUNA
   'Descri็ใo           ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TPA_DESCRI                                                                                                                                                                                                                                                ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TPACNE' , ; //XB_ALIAS
   '4' , ; //XB_TIPO
   '02' , ; //XB_SEQ
   '02' , ; //XB_COLUNA
   'Etapa               ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TPA_ETAPA                                                                                                                                                                                                                                                 ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TPACNE' , ; //XB_ALIAS
   '5' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '  ' , ; //XB_COLUNA
   '                    ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TPA->TPA_ETAPA                                                                                                                                                                                                                                            ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TPACNE' , ; //XB_ALIAS
   '6' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '  ' , ; //XB_COLUNA
   '                    ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'U_BFMA45HS(FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_TAREOS' + DUPLAS + '), TPA->TPA_ETAPA, FWFldGet(' + DUPLAS + 'CNE_PRODUT' + DUPLAS + '))                                                                                                                                                            ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TT9CNE' , ; //XB_ALIAS
   '1' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   'DB' , ; //XB_COLUNA
   'Tarefas             ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TT9                                                                                                                                                                                                                                                       ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TT9CNE' , ; //XB_ALIAS
   '2' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '01' , ; //XB_COLUNA
   'Tarefa              ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   '                                                                                                                                                                                                                                                          ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TT9CNE' , ; //XB_ALIAS
   '2' , ; //XB_TIPO
   '02' , ; //XB_SEQ
   '01' , ; //XB_COLUNA
   'Descri็ใo           ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   '                                                                                                                                                                                                                                                          ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TT9CNE' , ; //XB_ALIAS
   '4' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '01' , ; //XB_COLUNA
   'Tarefa              ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TT9_TAREFA                                                                                                                                                                                                                                                ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TT9CNE' , ; //XB_ALIAS
   '4' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '02' , ; //XB_COLUNA
   'Descri็ใo           ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TT9_DESCRI                                                                                                                                                                                                                                                ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TT9CNE' , ; //XB_ALIAS
   '4' , ; //XB_TIPO
   '02' , ; //XB_SEQ
   '01' , ; //XB_COLUNA
   'Descri็ใo           ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TT9_DESCRI                                                                                                                                                                                                                                                ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TT9CNE' , ; //XB_ALIAS
   '4' , ; //XB_TIPO
   '02' , ; //XB_SEQ
   '02' , ; //XB_COLUNA
   'Tarefa              ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TT9_TAREFA                                                                                                                                                                                                                                                ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TT9CNE' , ; //XB_ALIAS
   '5' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '  ' , ; //XB_COLUNA
   '                    ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'TT9->TT9_TAREFA                                                                                                                                                                                                                                           ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM

aAdd( aSXB, { ; 
   'TT9CNE' , ; //XB_ALIAS
   '6' , ; //XB_TIPO
   '01' , ; //XB_SEQ
   '  ' , ; //XB_COLUNA
   '                    ' , ; //XB_DESCRI
   '                    ' , ; //XB_DESCSPA
   '                    ' , ; //XB_DESCENG
   'U_BFMA08HS(FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '), TT9->TT9_TAREFA, FWFldGet(' + DUPLAS + 'CNE_PRODUT' + DUPLAS + '))                                                                                                                                                                                   ' , ; //XB_CONTEM
   '                                                                                                                                                                                                                                                          ' } ) //XB_WCONTEM


// ----------------------
// Atualizando dicionแrio
// ----------------------

dbSelectArea( 'SXB' )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )

   If Empty( aSXB[nI][1] )
      Loop
   EndIf

   If !SXB->( dbSeek( cAudiReg := PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

      If !CanAdd(aEstrut,aSXB[nI])
         LogAdd( @aTexto , 'Warning.: Consulta Padrao ' + aSXB[nI][1] + ' nao pode ser inserido por falta de dados no compatibilizador !')
         Loop
      EndIf

      RecLock( 'SXB', .T. )

      For nJ := 1 To Len( aSXB[nI] )
         If FieldPos( aEstrut[nJ] ) > 0 .And. NotNull(aSXB[nI][nJ])
            FieldPut( FieldPos( aEstrut[nJ] ), aAudiVal[2]:=aSXB[nI][nJ] )
            aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'I' , 'SXB' , cAudiReg , aEstrut[nJ] , '' , AllTrim(AllToChar(aAudiVal[2])) } )
         EndIf
      Next nJ

      dbCommit()
      MsUnLock()

      If !Empty( aAuditDic )
         LogAdd( @aTexto , 'Foi incluํda a consulta padrใo ' + aSXB[nI][1] )
         AuditDic( @aAuditDic , @aTexto )
      EndIf

   Else

      // ------------------------
      // Verifica todos os campos
      // ------------------------
      For nJ := 1 To Len( aSXB[nI] )

         // -----------------------------------------
         // Se o campo estiver diferente da estrutura
         // -----------------------------------------
         If NotNull(aSXB[nI][nJ]) .And. ;
            aEstrut[nJ] == SXB->( FieldName( nJ ) ) .And. ; 
            StrTran( AllToChar( SXB->( FieldGet( nJ ) ) ), ' ', '' ) <> ; 
            StrTran( AllToChar( aSXB[nI][nJ]            ), ' ', '' )

            RecLock( 'SXB', .F. )
            aAudiVal[1]:=SXB->(FieldGet(FieldPos(aEstrut[nJ])))
            FieldPut( FieldPos( aEstrut[nJ] ), aAudiVal[2]:=aSXB[nI][nJ] )
            aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'U' , 'SXB' , cAudiReg , aEstrut[nJ] , AllTrim(AllToChar(aAudiVal[1])) , AllTrim(AllToChar(aAudiVal[2])) } )
            dbCommit()
            MsUnLock()

         EndIf

      Next nJ

      If !Empty( aAuditDic )
         LogAdd( @aTexto , 'Foi Alterada a consulta padrao ' + aSXB[nI][1] )
         AuditDic( @aAuditDic , @aTexto )
      EndIf

   EndIf

   oProcess:IncRegua2( 'Atualizando Consultas Padr๕es (SXB)...' )

Next nI

LogAdd( @aTexto , 'Final da Atualizacao do SXB' )
LogAdd( @aTexto , Replicate( '-', 128 ) )


Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ AT00SX6  บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX6 - Parโmetros    ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AT00SX6( aTexto , aFils )

Local aEstrut   := {}
Local aSX6Temp  := {}
Local aSX6      := {}
Local cFilPar   := ''
Local lReclock  := .T.
Local nI        := 0
Local nJ        := 0
Local nY        := 0

Default aFils   := {1}

LogAdd( @aTexto , 'Inicio da Atualizacao do SX6' )
aEstrut := { 'X6_FIL', ; 
             'X6_VAR', ; 
             'X6_TIPO', ; 
             'X6_DESCRIC', ; 
             'X6_DSCSPA', ; 
             'X6_DSCENG', ; 
             'X6_DESC1', ; 
             'X6_DSCSPA1', ; 
             'X6_DSCENG1', ; 
             'X6_DESC2', ; 
             'X6_DSCSPA2', ; 
             'X6_DSCENG2', ; 
             'X6_CONTEUD', ; 
             'X6_CONTSPA', ; 
             'X6_CONTENG', ; 
             'X6_PROPRI', ; 
             'X6_PYME', ; 
             'X6_VALID', ; 
             'X6_INIT', ; 
             'X6_DEFPOR', ; 
             'X6_DEFSPA', ; 
             'X6_DEFENG', ; 
             'X6_EXPDEST' } 


aSX6Temp := {}
If NotNull('       ') .And. Len('       ') <>  _nTamFil
   If Empty('       ')
      	//Ajusta o tamanho em espacos
       aAdd( aSX6Temp , Space(_nTamFil) )  //X6_FIL
   Else
      //Pega a filial desta empresa que estou posicionado
      aAdd( aSX6Temp , cFilAnt )   //X6_FIL
   EndIf
Else
   aAdd( aSX6Temp , '       ' )  //X6_FIL
EndIf
aAdd( aSX6Temp , 'MV_YOISCPP' )  //X6_VAR
aAdd( aSX6Temp , 'Nil' )  //X6_TIPO
aAdd( aSX6Temp , 'Op็๕es de Integra็ใo de Gera็ใo de (SC, SP, PC e M' )  //X6_DESCRIC
aAdd( aSX6Temp , 'Nil' )  //X6_DSCSPA
aAdd( aSX6Temp , 'Nil' )  //X6_DSCENG
aAdd( aSX6Temp , 'C) via OS, informe os valores separados por ' + DUPLAS + '|' + DUPLAS + '(pi' )  //X6_DESC1
aAdd( aSX6Temp , 'Nil' )  //X6_DSCSPA1
aAdd( aSX6Temp , 'Nil' )  //X6_DSCENG1
aAdd( aSX6Temp , 'pe)                                               ' )  //X6_DESC2
aAdd( aSX6Temp , 'Nil' )  //X6_DSCSPA2
aAdd( aSX6Temp , 'Nil' )  //X6_DSCENG2
aAdd( aSX6Temp , 'SC;SP;PC;MC                                                                                                                                                                                                                                               ' )  //X6_CONTEUD
aAdd( aSX6Temp , 'Nil' )  //X6_CONTSPA
aAdd( aSX6Temp , 'Nil' )  //X6_CONTENG
aAdd( aSX6Temp , 'Nil' )  //X6_PROPRI
aAdd( aSX6Temp , 'Nil' )  //X6_PYME
aAdd( aSX6Temp , 'Nil' )  //X6_VALID
aAdd( aSX6Temp , 'Nil' )  //X6_INIT
aAdd( aSX6Temp , 'Nil' )  //X6_DEFPOR
aAdd( aSX6Temp , 'Nil' )  //X6_DEFSPA
aAdd( aSX6Temp , 'Nil' )  //X6_DEFENG
aAdd( aSX6Temp , 'Nil' )  //X6_EXPDEST
aAdd( aSX6 , aSX6Temp )


aSX6Temp := {}
If NotNull('1008   ') .And. Len('1008   ') <>  _nTamFil
   If Empty('1008   ')
      	//Ajusta o tamanho em espacos
       aAdd( aSX6Temp , Space(_nTamFil) )  //X6_FIL
   Else
      //Pega a filial desta empresa que estou posicionado
      aAdd( aSX6Temp , cFilAnt )   //X6_FIL
   EndIf
Else
   aAdd( aSX6Temp , '1008   ' )  //X6_FIL
EndIf
aAdd( aSX6Temp , 'MV_YOISCPP' )  //X6_VAR
aAdd( aSX6Temp , 'Nil' )  //X6_TIPO
aAdd( aSX6Temp , 'Op็๕es de Integra็ใo de Gera็ใo de (SC, SP, PC e M' )  //X6_DESCRIC
aAdd( aSX6Temp , 'Nil' )  //X6_DSCSPA
aAdd( aSX6Temp , 'Nil' )  //X6_DSCENG
aAdd( aSX6Temp , 'C) via OS, informe os valores separados por ' + DUPLAS + '|' + DUPLAS + '(pi' )  //X6_DESC1
aAdd( aSX6Temp , 'Nil' )  //X6_DSCSPA1
aAdd( aSX6Temp , 'Nil' )  //X6_DSCENG1
aAdd( aSX6Temp , 'pe)                                               ' )  //X6_DESC2
aAdd( aSX6Temp , 'Nil' )  //X6_DSCSPA2
aAdd( aSX6Temp , 'Nil' )  //X6_DSCENG2
aAdd( aSX6Temp , 'SC;SP;PC;MC                                                                                                                                                                                                                                               ' )  //X6_CONTEUD
aAdd( aSX6Temp , 'Nil' )  //X6_CONTSPA
aAdd( aSX6Temp , 'Nil' )  //X6_CONTENG
aAdd( aSX6Temp , 'Nil' )  //X6_PROPRI
aAdd( aSX6Temp , 'Nil' )  //X6_PYME
aAdd( aSX6Temp , 'Nil' )  //X6_VALID
aAdd( aSX6Temp , 'Nil' )  //X6_INIT
aAdd( aSX6Temp , 'Nil' )  //X6_DEFPOR
aAdd( aSX6Temp , 'Nil' )  //X6_DEFSPA
aAdd( aSX6Temp , 'Nil' )  //X6_DEFENG
aAdd( aSX6Temp , 'Nil' )  //X6_EXPDEST
aAdd( aSX6 , aSX6Temp )


aSX6Temp := {}
If NotNull('1009   ') .And. Len('1009   ') <>  _nTamFil
   If Empty('1009   ')
      	//Ajusta o tamanho em espacos
       aAdd( aSX6Temp , Space(_nTamFil) )  //X6_FIL
   Else
      //Pega a filial desta empresa que estou posicionado
      aAdd( aSX6Temp , cFilAnt )   //X6_FIL
   EndIf
Else
   aAdd( aSX6Temp , '1009   ' )  //X6_FIL
EndIf
aAdd( aSX6Temp , 'MV_YOISCPP' )  //X6_VAR
aAdd( aSX6Temp , 'Nil' )  //X6_TIPO
aAdd( aSX6Temp , 'Op็๕es de Integra็ใo de Gera็ใo de (SC, SP, PC e M' )  //X6_DESCRIC
aAdd( aSX6Temp , 'Nil' )  //X6_DSCSPA
aAdd( aSX6Temp , 'Nil' )  //X6_DSCENG
aAdd( aSX6Temp , 'C) via OS, informe os valores separados por ' + DUPLAS + '|' + DUPLAS + '(pi' )  //X6_DESC1
aAdd( aSX6Temp , 'Nil' )  //X6_DSCSPA1
aAdd( aSX6Temp , 'Nil' )  //X6_DSCENG1
aAdd( aSX6Temp , 'pe)                                               ' )  //X6_DESC2
aAdd( aSX6Temp , 'Nil' )  //X6_DSCSPA2
aAdd( aSX6Temp , 'Nil' )  //X6_DSCENG2
aAdd( aSX6Temp , 'SC;SP;PC;MC                                                                                                                                                                                                                                               ' )  //X6_CONTEUD
aAdd( aSX6Temp , '                                                                                                                                                                                                                                                          ' )  //X6_CONTSPA
aAdd( aSX6Temp , '                                                                                                                                                                                                                                                          ' )  //X6_CONTENG
aAdd( aSX6Temp , 'Nil' )  //X6_PROPRI
aAdd( aSX6Temp , 'Nil' )  //X6_PYME
aAdd( aSX6Temp , 'Nil' )  //X6_VALID
aAdd( aSX6Temp , 'Nil' )  //X6_INIT
aAdd( aSX6Temp , 'Nil' )  //X6_DEFPOR
aAdd( aSX6Temp , 'Nil' )  //X6_DEFSPA
aAdd( aSX6Temp , 'Nil' )  //X6_DEFENG
aAdd( aSX6Temp , 'Nil' )  //X6_EXPDEST
aAdd( aSX6 , aSX6Temp )

// ----------------------
// Atualizando dicionแrio
// ----------------------

dbSelectArea( 'SX6' )
dbSetOrder( 1 )

For nI := 1 To Len( aSX6 )

   For nY	:= 1 To Len( aFils )

      cFilPar := If(lChkPar,aFils[nY],aSX6[nI][1])

      If !SX6->( dbSeek( cAudiReg := cFilPar + aSX6[nI][2] ) )
         If !CanAdd(aEstrut,aSX6[nI])
            LogAdd( @aTexto , 'Warning.: Parametro ' + cFilPar + '/' + aSX6[nI][2] + ' nao pode ser inserido por falta de dados no compatibilizador !')
            Loop
         EndIf

         RecLock( 'SX6', .T. )

         For nJ := 1 To Len( aSX6[nI] )

            If nJ = 1    //Filial
               FieldPut( FieldPos( aEstrut[nJ] ), aAudiVal[2]:=cFilPar )
               aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'I' , 'SX6' , cAudiReg , aEstrut[nJ] , '' , AllTrim(AllToChar(aAudiVal[2])) } )
            Else
               If FieldPos( aEstrut[nJ] ) > 0 .And. NotNull(aSX6[nI][nJ])
                  FieldPut( FieldPos( aEstrut[nJ] ), aAudiVal[2]:=aSX6[nI][nJ] )
                  aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'I' , 'SX6' , cAudiReg , aEstrut[nJ] , '' , AllTrim(AllToChar(aAudiVal[2])) } )
               EndIf

            EndIf

         Next nJ

         dbCommit()
         MsUnLock()

         If !Empty( aAuditDic )
            LogAdd( @aTexto , 'Foi incluํdo o parametro ' + cFilPar + '/' + aSX6[nI][2] )
            AuditDic( @aAuditDic , @aTexto )
         EndIf

      Else

         RecLock( 'SX6', .F. )

         //Comeco do 3 pois o 1 eh filial e o 2 eh o parametro, e foi encontrado, entao sao iguais.
         For nJ := 3 To Len( aSX6[nI] )

            If FieldPos( aEstrut[nJ] ) > 0 .And. NotNull(aSX6[nI][nJ]) .And. ;
               PadR( StrTran( AllToChar( aAudiVal[1]:=SX6->( FieldGet( FieldPos(aEstrut[nJ]) ) ) )	, ' ' , '' ), 250 ) <> ;
               PadR( StrTran( AllToChar( aAudiVal[2]:=aSX6[nI][nJ] )                                , ' ' , '' ), 250 ) 
               FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
               aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'U' , 'SX6' , cAudiReg , aEstrut[nJ] , AllTrim(AllToChar(aAudiVal[1])) , AllTrim(AllToChar(aAudiVal[2])) } )
            EndIf

         Next nJ

         dbCommit()
         MsUnLock()

         If !Empty( aAuditDic )
            LogAdd( @aTexto , 'Foi alterado o parametro ' + cFilPar + '/' + aSX6[nI][2] )
            AuditDic( @aAuditDic , @aTexto )
         EndIf

      EndIf
   Next nY

   oProcess:IncRegua2( 'Atualizando Parโmetros (SX6)...')

Next nI

LogAdd( @aTexto , 'Final da Atualizacao do SX6' )
LogAdd( @aTexto , Replicate( '-', 128 ) )

Return( .T. )/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ AT00SX7  บ Autor ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX7 - Gatilhos      ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AT00SX7( aTexto )
Local aEstrut   := {}
Local aSX7      := {}
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )

LogAdd( @aTexto , 'Inicio da Atualizacao do SX7' )

aEstrut := { 'X7_CAMPO', 'X7_SEQUENC', 'X7_REGRA', 'X7_CDOMIN', 'X7_TIPO', 'X7_SEEK', ;
             'X7_ALIAS', 'X7_ORDEM'  , 'X7_CHAVE', 'X7_CONDIC', 'X7_PROPRI' }

aAdd( aSX7, { ;
            'CNE_OP    ' , ; //X7_CAMPO
            '001' , ; //X7_SEQUENC
            'POSICIONE(' + DUPLAS + 'STJ' + DUPLAS + ',1,FWxFilial(' + DUPLAS + 'STJ' + DUPLAS + ')+SubStr(FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '),1,TamSX3(' + DUPLAS + 'TJ_ORDEM' + DUPLAS + ')[1]),' + DUPLAS + 'TJ_CCUSTO' + DUPLAS + ')                                                                                                      ' , ; //X7_REGRA
            'CNE_CC    ' , ; //X7_CDOMIN
            'P' , ; //X7_TIPO
            'N' , ; //X7_SEEK
            '   ' , ; //X7_ALIAS
             0  , ; //X7_ORDEM
            '                                                                                                                                                                                                        ' , ; //X7_CHAVE
            '                                        ' , ; //X7_CONDIC
            'U'   ; //X7_PROPRI
     } )

aAdd( aSX7, { ;
            'CNE_OP    ' , ; //X7_CAMPO
            '002' , ; //X7_SEQUENC
            'U_BFMA48HS(FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_PRODUT' + DUPLAS + '),, ' + DUPLAS + 'TAREFA' + DUPLAS + ')                                                                                                                                       ' , ; //X7_REGRA
            'CNE_TAREOS' , ; //X7_CDOMIN
            'P' , ; //X7_TIPO
            'N' , ; //X7_SEEK
            '   ' , ; //X7_ALIAS
             0  , ; //X7_ORDEM
            '                                                                                                                                                                                                        ' , ; //X7_CHAVE
            '                                        ' , ; //X7_CONDIC
            'U'   ; //X7_PROPRI
     } )

aAdd( aSX7, { ;
            'CNE_OP    ' , ; //X7_CAMPO
            '003' , ; //X7_SEQUENC
            'U_BFMA48HS(FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_PRODUT' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_TAREOS' + DUPLAS + '), ' + DUPLAS + 'ETAPA' + DUPLAS + ')                                                                                                                 ' , ; //X7_REGRA
            'CNE_ETAPOS' , ; //X7_CDOMIN
            'P' , ; //X7_TIPO
            'N' , ; //X7_SEEK
            '   ' , ; //X7_ALIAS
             0  , ; //X7_ORDEM
            '                                                                                                                                                                                                        ' , ; //X7_CHAVE
            '                                        ' , ; //X7_CONDIC
            'U'   ; //X7_PROPRI
     } )

aAdd( aSX7, { ;
            'CNE_OP    ' , ; //X7_CAMPO
            '004' , ; //X7_SEQUENC
            'U_MA48HSBM(FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '))                                                                                                                                                                          ' , ; //X7_REGRA
            'CNE_YCBEM ' , ; //X7_CDOMIN
            'P' , ; //X7_TIPO
            'N' , ; //X7_SEEK
            '   ' , ; //X7_ALIAS
             0  , ; //X7_ORDEM
            '                                                                                                                                                                                                        ' , ; //X7_CHAVE
            '                                        ' , ; //X7_CONDIC
            'U'   ; //X7_PROPRI
     } )

aAdd( aSX7, { ;
            'CNE_TAREOS' , ; //X7_CAMPO
            '001' , ; //X7_SEQUENC
            'U_BFMA48HS(FWFldGet(' + DUPLAS + 'CNE_OP' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_PRODUT' + DUPLAS + '), FWFldGet(' + DUPLAS + 'CNE_TAREOS' + DUPLAS + '), ' + DUPLAS + 'ETAPA' + DUPLAS + ')                                                                                                                 ' , ; //X7_REGRA
            'CNE_ETAPOS' , ; //X7_CDOMIN
            'P' , ; //X7_TIPO
            'N' , ; //X7_SEEK
            '   ' , ; //X7_ALIAS
             0  , ; //X7_ORDEM
            '                                                                                                                                                                                                        ' , ; //X7_CHAVE
            '                                        ' , ; //X7_CONDIC
            'U'   ; //X7_PROPRI
     } )


// ----------------------
// Abre Area SX3 (Trigger)
// ----------------------
DbSelectArea( 'SX3' )
DbSetOrder( 2 )

// ----------------------
// Atualizando dicionแrio
// ----------------------

DbSelectArea( 'SX7' )
DbSetOrder( 1 )

For nI := 1 To Len( aSX7 )

   DbSelectArea( 'SX7' )

   If !SX7->( dbSeek( cAudiReg := PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

      If !CanAdd(aEstrut,aSX7[nI])
         LogAdd( @aTexto , 'Warning.: Gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] + ' nao pode ser inserido por falta de dados no compatibilizador !')
         Loop
      EndIf

      RecLock( 'SX7', .T. )

      For nJ := 1 To Len( aSX7[nI] )
         If FieldPos( aEstrut[nJ] ) > 0  .And. NotNull(aSX7[nI][nJ])
            FieldPut( FieldPos( aEstrut[nJ] ), aAudiVal[2]:=aSX7[nI][nJ] )
            aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'I' , 'SX7' , cAudiReg , aEstrut[nJ] , '' , AllTrim(AllToChar(aAudiVal[2])) } )
         EndIf
      Next nJ

      dbCommit()
      MsUnLock()

      If !Empty( aAuditDic )
         LogAdd( @aTexto , 'Foi Incluํdo o gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] )
         AuditDic( @aAuditDic , @aTexto )
      EndIf

      //----------------------------------------------
      //Verificando o campo X3_TRIGGER do campo no SX3
      //----------------------------------------------
      If SX3->( dbSeek( cAudiReg := PadR( aSX7[nI][1], nTamSeek ) ) )
         If !((aAudiVal[1]:=SX3->X3_TRIGGER)=='S')
            RecLock('SX3',.F.)
            SX3->X3_TRIGGER := aAudiVal[2] := 'S'
            SX3->(MsUnlock())
            aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'U' , 'SX3' , cAudiReg , 'X3_TRIGGER' , AllTrim(AllToChar(aAudiVal[1])) , AllTrim(AllToChar(aAudiVal[2])) } )
         EndIf
         If !Empty( aAuditDic )
            LogAdd( @aTexto , 'Foi Alterado o campo ' + aSX7[nI][1] + ' - X3_TRIGGER para S' )
            AuditDic( @aAuditDic , @aTexto )
         EndIf
      EndIf

   Else

      RecLock( 'SX7', .F. )

      For nJ := 1 To Len( aSX7[nI] )
         If FieldPos( aEstrut[nJ] ) > 0  .And. NotNull(aSX7[nI][nJ]) .And. ;
            PadR( StrTran( AllToChar( aAudiVal[1]:=SX7->( FieldGet( FieldPos(aEstrut[nJ]) ) ) )	, ' ' , '' ), 250 ) <> ;
            PadR( StrTran( AllToChar( aAudiVal[2]:=aSX7[nI][nJ] )                                , ' ' , '' ), 250 ) 
            FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
            aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'U' , 'SX7' , cAudiReg , aEstrut[nJ] , AllTrim(AllToChar(aAudiVal[1])) , AllTrim(AllToChar(aAudiVal[2])) } )
         EndIf
      Next nJ

      dbCommit()
      MsUnLock()

      If !Empty( aAuditDic )
         LogAdd( @aTexto , 'Foi Alterado o gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] )
         AuditDic( @aAuditDic , @aTexto )
      EndIf

      //----------------------------------------------
      //Verificando o campo X3_TRIGGER do campo no SX3
      //----------------------------------------------
      If SX3->( dbSeek( cAudiReg := PadR( aSX7[nI][1], nTamSeek ) ) )
         If !((aAudiVal[1]:=SX3->X3_TRIGGER)=='S')
            RecLock('SX3',.F.)
            SX3->X3_TRIGGER := aAudiVal[2] := 'S'
            SX3->(MsUnlock())
            aAdd( aAuditDic , { cDevName , cTicket , cEmpAnt , Time() , DtoS(Date()) , 'U' , 'SX3' , cAudiReg , 'X3_TRIGGER' , AllTrim(AllToChar(aAudiVal[1])) , AllTrim(AllToChar(aAudiVal[2])) } )
         EndIf
         If !Empty( aAuditDic )
            LogAdd( @aTexto , 'Foi Alterado o campo ' + aSX7[nI][1] + ' - X3_TRIGGER para S' )
            AuditDic( @aAuditDic , @aTexto )
         EndIf
      EndIf

   EndIf

   oProcess:IncRegua2( 'Atualizando Gatilhos (SX7)...')

Next nI

LogAdd( @aTexto , 'Final da Atualizacao do SX7' )
LogAdd( @aTexto , Replicate( '-', 128 ) )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ DEFREGUA บAutor  ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Generica para informar a quantidade de registros    บฑฑ
ฑฑบ          ณ a ser processada pela regua2.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DefRegua( nI )

Local nRegua := 0 

If nI = 1
   nRegua := 4
Else
   nRegua := 29
EndIf

Return( nRegua )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณX3CheckDBบAutor  ณ HELITOM SILVA      บ Data ณ  22/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Generica para verificar se os campos criados no SX3 บฑฑ
ฑฑบ          ณ foram criados na tabela no Oracle.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function X3CheckDB( cX3Field )
Local lRet     := .T.
Local aAreaSX3 := SX3->(GetArea())
Local aAreaSX2 := SX2->(GetArea())

SX3->(dbSetOrder(2)) //X3_CAMPO
SX3->(dbSeek(cX3Field))

SX2->(dbSetOrder(1)) //X2_CHAVE
SX2->(dbSeek(SX3->X3_ARQUIVO))

BeginSql Alias 'SX3DB'
Select Nvl(Count( * ) , 0 ) As X3DB
From
ALL_TAB_COLUMNS
Where
   TABLE_NAME  = %exp:SX2->X2_ARQUIVO% And
   COLUMN_NAME = %exp:SX3->X3_CAMPO%
EndSql

If .Not. SX3DB->(Eof())
   If SX3DB->(X3DB) = 0
      lRet := .F.
   Endif
Endif

SX3DB->(DbCloseArea())

Return( lRet )
