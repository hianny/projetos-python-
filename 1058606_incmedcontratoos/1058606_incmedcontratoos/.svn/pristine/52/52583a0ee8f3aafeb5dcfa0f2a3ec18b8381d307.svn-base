#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"


/*/{Protheus.doc} User Function CN120ITM
@description Ponto de Entrada utilizado para fazer tratamentos adicionais
        ao gerar pedido de compra/venda no gestao de contratos. Antigo P.E CN120ITM, CN120PED
@type User Function
@author Jared Ribeiro
@since 24/08/2022
@version Protheus 12
@param Nil
@return Nil
@example Nil
@obs #GESTAODECONTRATO #MEDICAO
@see https://tdn.totvs.com/pages/releaseview.action?pageId=271385565
/*/
User Function CN121PED()

	Local __stt      := u___stt(procname(0),"CN121PED")

	Local aSaveLines := {}
	Local aCab       := PARAMIXB[1]
	Local _aItens    := PARAMIXB[2]
	Local aResult    := Array(2)
	Local nJ         := 0
	Local nK         := If(!Empty(_aItens), Len(_aItens), 0)
	Local oModel     := Nil
	Local oGrid      := Nil
	Local lCompra    := .F.
	Local _nPosItem  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_ITEMED" }), 0)
	Local _nPosCC    := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_CC"     }), 0)
	Local _nPosCLVL  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_CLVL"   }), 0)
	Local _nPosPLVER := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_YPLVER" }), 0)
	Local _nPosPLPCO := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_YPLPCO" }), 0)
	Local _nPosPROJ  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_CODPROJ"}), 0)
	Local _nPosOper  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_OPER"   }), 0)
	Local _nPosLoc   := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_LOCAL"  }), 0)
	Local _nPosObCtr := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_YOBSMED"}), 0)
	Local _nPosUnit  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_PRECO"  }), 0)
	Local _nPosObs   := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_OBS"    }), 0)
	Local _nPosQtde  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_QUANT"  }), 0)
	Local _nPosTota  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_TOTAL"  }), 0)
	Local _nPosApro  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_XGRAPRO"}), 0)

    //Danyel Bernuci 30/07/2013 13:33:11hrs, Solicitado por Gilmar: Tratamentos para gravar informacoes do IPI
	Local _nPosBIpi  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_BASEIPI"}), 0)
	Local _nPosVIpi  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_VALIPI" }), 0)
	Local _nPosAIpi  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_IPI"    }), 0)

    //Kaique Mathias 13/03/2014 13:33:11hrs, Solicitado por Gilmar: Tratamentos para gravar informacoes do Desconto
	Local _nPosVlDesc:= If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_VLDESC" }), 0)
	Local _nPosDesc  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_DESC"   }), 0)

    //Chamado 276137 - Tornar o campo de operacao obrigatório - Alexandre Lima
	Local _nPosCdBem := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_YCODBEM"}), 0)
	Local _nPosCodF  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_CODPFAB"}), 0)

	Local _nPosCodF  := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_CODPFAB"}), 0)

	Local _nPosICMST := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_ICMSRET" }), 0)

	Local _nPosOP     := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_OP" }), 0)
	Local _nPosTareOS := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_YTAREOS" }), 0)
	Local _nPosEtapOS := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_YETAPOS" }), 0)
	Local _nPosContra := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_CONTRA" }), 0)
	Local _nPosRevisa := If(!Empty(_aItens), Ascan(_aItens[nK],{|x| x[1] == "C7_CONTREV" }), 0)

	If !(Empty(aCab) .Or. Empty(_aItens))

		oModel  := FwModelActive()
		oGrid   := oModel:GetModel('CNEDETAIL')
		lCompra := Cn121RetSt( "COMPRA" , 0, /*cPlan*/, /*cContra*/, .T., oModel )

		If lCompra

			aSaveLines := FwSaveRows()

			For nJ := 1 to oGrid:Length()

				oGrid:GoLine(nJ)

				If !oGrid:IsDeleted()

					For nK := 1 to Len(_aItens)

						//Tratativas do antigo P.E CN120PED - Atualiza a Observação apenas no primeiro item do pedido
						If nK == 1 .And. Empty(_nPosObs) .And. !Empty(oModel:GetValue("CNDMASTER", "CND_OBS"))
							Aadd(_aItens[nK],{"C7_OBS",oModel:GetValue("CNDMASTER", "CND_OBS"),nil})
						ElseIf !Empty(_nPosObs) .And. Empty(_aItens[nK,_nPosObs,2])
							_aItens[nK,_nPosObs,2]  := oModel:GetValue("CNDMASTER", "CND_OBS")
						Endif

						If oGrid:GetValue("CNE_ITEM") == _aItens[nK, _nPosItem, 2]

							//Tratativas do antigo P.E CN120ITM
							If Empty(_nPosBIpi) .And. CNE->(FieldPos("CNE_YBSIPI"))>0 .And. !Empty(oGrid:GetValue("CNE_YBSIPI"))
								Aadd(_aItens[nK],{"C7_BASEIPI",oGrid:GetValue("CNE_YBSIPI"),nil})
							ElseIf !Empty(_nPosBIpi) .And. Empty(_aItens[nK,_nPosBIpi,2]) .And. CNE->(FieldPos("CNE_YBSIPI"))>0 .And. !Empty(oGrid:GetValue("CNE_YBSIPI"))
								_aItens[nK,_nPosBIpi,2] := oGrid:GetValue("CNE_YBSIPI")
							Endif

							If Empty(_nPosVIpi) .And. CNE->(FieldPos("CNE_YVLIPI"))>0 .And. !Empty(oGrid:GetValue("CNE_YVLIPI"))
								Aadd(_aItens[nK],{"C7_VALIPI",oGrid:GetValue("CNE_YVLIPI"),nil})
							ElseIf !Empty(_nPosVIpi) .And. Empty(_aItens[nK,_nPosVIpi,2]) .And. CNE->(FieldPos("CNE_YVLIPI"))>0 .And. !Empty(oGrid:GetValue("CNE_YVLIPI"))
								_aItens[nK,_nPosVIpi,2] := oGrid:GetValue("CNE_YVLIPI")
							Endif

							If Empty(_nPosAIpi) .And. CNE->(FieldPos("CNE_YIPI"))>0 .And. !Empty(oGrid:GetValue("CNE_YIPI"))
								Aadd(_aItens[nK],{"C7_IPI",oGrid:GetValue("CNE_YIPI"),nil})
							ElseIf !Empty(_nPosAIpi) .And. Empty(_aItens[nK,_nPosAIpi,2]) .And. CNE->(FieldPos("CNE_YIPI"))>0 .And. !Empty(oGrid:GetValue("CNE_YIPI"))
								_aItens[nK,_nPosAIpi,2] := oGrid:GetValue("CNE_YIPI")
							Endif

							If Empty(_nPosCC) .And. !Empty(oGrid:GetValue("CNE_CC"))
								Aadd(_aItens[nK],{"C7_CC",oGrid:GetValue("CNE_CC"),nil})
							ElseIf !Empty(_nPosCC) .And. Empty(_aItens[nK,_nPosCC,2]) .And. !Empty(oGrid:GetValue("CNE_CC"))
								_aItens[nK,_nPosCC,2] := oGrid:GetValue("CNE_CC")
							Endif

							If Empty(_nPosCLVL) .And. !Empty(oGrid:GetValue("CNE_CLVL"))
								Aadd(_aItens[nK],{"C7_CLVL",oGrid:GetValue("CNE_CLVL"),nil})
							ElseIf !Empty(_nPosCLVL) .And. Empty(_aItens[nK,_nPosCLVL,2]) .And. !Empty(oGrid:GetValue("CNE_CLVL"))
								_aItens[nK,_nPosCLVL,2] := oGrid:GetValue("CNE_CLVL")
							Endif

							If Empty(_nPosOper) .And. !Empty(oGrid:GetValue("CNE_OPER"))
								Aadd(_aItens[nK],{"C7_OPER",oGrid:GetValue("CNE_OPER"),nil})
							ElseIf !Empty(_nPosOper) .And. Empty(_aItens[nK,_nPosOper,2]) .And. !Empty(oGrid:GetValue("CNE_OPER"))
								_aItens[nK,_nPosOper,2] := oGrid:GetValue("CNE_OPER")
							Endif

							If Empty(_nPosCdBem) .AND. CNE->(FieldPos("CNE_YCBEM"))>0 .And. !Empty(oGrid:GetValue("CNE_YCBEM"))
								Aadd(_aItens[nK],{"C7_YCODBEM",oGrid:GetValue("CNE_YCBEM"),nil})
							ElseIf !Empty(_nPosCdBem) .And. Empty(_aItens[nK,_nPosCdBem,2]) .And. !Empty(oGrid:GetValue("CNE_YCBEM"))
								_aItens[nK,_nPosCdBem,2]:= oGrid:GetValue("CNE_YCBEM")
							Endif

							If Empty(_nPosPLPCO) .And. !Empty(oGrid:GetValue("CNE_YPLPCO"))
								Aadd(_aItens[nK],{"C7_YPLPCO",oGrid:GetValue("CNE_YPLPCO"),nil})
							ElseIf !Empty(_nPosPLPCO) .And. Empty(_aItens[nK,_nPosPLPCO,2]) .And. !Empty(oGrid:GetValue("CNE_YPLPCO"))
								_aItens[nK,_nPosPLPCO,2] := oGrid:GetValue("CNE_YPLPCO")
							Endif

							If Empty(_nPosPLVER) .And. !Empty(oGrid:GetValue("CNE_YPLVER"))
								Aadd(_aItens[nK],{"C7_YPLVER",oGrid:GetValue("CNE_YPLVER"),nil})
							ElseIf !Empty(_nPosPLVER) .And. Empty(_aItens[nK,_nPosPLVER,2]) .And. !Empty(oGrid:GetValue("CNE_YPLVER"))
								_aItens[nK,_nPosPLVER,2] := oGrid:GetValue("CNE_YPLVER")
							Endif

							If Empty(_nPosLoc) .And. !Empty(oGrid:GetValue("CNE_LOCAL"))
								Aadd(_aItens[nK],{"C7_LOCAL",oGrid:GetValue("CNE_LOCAL"),nil})
							ElseIf !Empty(_nPosLoc) .And. Empty(_aItens[nK,_nPosLoc,2]) .And. !Empty(oGrid:GetValue("CNE_LOCAL"))
								_aItens[nK,_nPosLoc,2] := oGrid:GetValue("CNE_LOCAL")
							Endif

							If Empty(_nPosPROJ) .And. !Empty(oGrid:GetValue("CNE_CODPRO"))
								Aadd(_aItens[nK],{"C7_CODPROJ",oGrid:GetValue("CNE_CODPRO"),nil})
							ElseIf !Empty(_nPosPROJ) .And. Empty(_aItens[nK,_nPosPROJ,2]) .And. !Empty(oGrid:GetValue("CNE_CODPRO"))
								_aItens[nK,_nPosPROJ,2] := oGrid:GetValue("CNE_CODPRO")
							Endif

							If Empty(_nPosObCtr) .And. !Empty(oGrid:GetValue("CNE_YOBSPC"))
								Aadd(_aItens[nK],{"C7_YOBSMED",oGrid:GetValue("CNE_YOBSPC"),nil})
							ElseIf !Empty(_nPosObCtr) .And. Empty(_aItens[nK,_nPosObCtr,2]) .And. !Empty(oGrid:GetValue("CNE_YOBSPC"))
								_aItens[nK,_nPosObCtr,2] := oGrid:GetValue("CNE_YOBSPC")
							Endif

							If Empty(_nPosVlDesc) .And. !Empty(oGrid:GetValue("CNE_VLDESC"))
								Aadd(_aItens[nK],{"C7_VLDESC",oGrid:GetValue("CNE_VLDESC"),nil})
							ElseIf !Empty(_nPosVlDesc) .And. Empty(_aItens[nK,_nPosVlDesc,2])
								_aItens[nK,_nPosVlDesc,2] := oGrid:GetValue("CNE_VLDESC")
							Endif

							If Empty(_nPosDesc) .And. !Empty(oGrid:GetValue("CNE_PDESC"))
								Aadd(_aItens[nK],{"C7_DESC",oGrid:GetValue("CNE_PDESC"),nil})
							ElseIf !Empty(_nPosDesc) .And. Empty(_aItens[nK,_nPosDesc,2])
								_aItens[nK,_nPosDesc,2] := oGrid:GetValue("CNE_PDESC")
							Endif

							//Tratativas do antigo P.E CN120PED
							If Empty(_nPosApro) .And. !Empty(oModel:GetValue("CNDMASTER", "CND_APROV"))
								Aadd(_aItens[nK],{"C7_XGRAPRO",oModel:GetValue("CNDMASTER", "CND_APROV"),nil})
							ElseIf !Empty(_nPosApro) .And. Empty(_aItens[nK,_nPosApro,2])
								_aItens[nK,_nPosApro,2] := oModel:GetValue("CNDMASTER", "CND_APROV")
							Endif

							If !( _aItens[nK,_nPosUnit,2] == oGrid:GetValue("CNE_VLUNIT") )
								_aItens[nK,_nPosUnit,2] := oGrid:GetValue("CNE_VLUNIT")
								_aItens[nK,_nPosTota,2] := _aItens[nK,_nPosUnit,2] * _aItens[nK][_nPosQtde][2]
							EndIf
							If Empty(_nPosCodF) .And. !Empty(oGrid:GetValue("CNE_YCODFA"))
								Aadd(_aItens[nK],{"C7_CODPFAB",oGrid:GetValue("CNE_YCODFA"),nil})
							ElseIf !Empty(_nPosCodF) .And. Empty(_aItens[nK,_nPosCodF,2])
								_aItens[nK,_nPosCodF,2] := oGrid:GetValue("CNE_YCODFA")
							EndIf

							If Empty(_nPosCodF) .And. !Empty(oGrid:GetValue("CNE_YCODFA"))
								Aadd(_aItens[nK],{"C7_CODPFAB",oGrid:GetValue("CNE_YCODFA"),nil})
							ElseIf !Empty(_nPosCodF) .And. Empty(_aItens[nK,_nPosCodF,2])
								_aItens[nK,_nPosCodF,2] := oGrid:GetValue("CNE_YCODFA")
							Endif

							//Chamado: 940077 - 10/12/2023 - Jared Ribeiro
							//Envia o valor do ICMS ST da medição para o pedido de compra
							If Empty(_nPosICMST) .And. CNE->(FieldPos("CNE_YICMST"))>0 .And. !Empty(oGrid:GetValue("CNE_YICMST"))
								Aadd(_aItens[nK],{"C7_ICMSRET",oGrid:GetValue("CNE_YICMST"),nil})
							ElseIf !Empty(_nPosICMST) .And. Empty(_aItens[nK,_nPosICMST,2]) .And. CNE->(FieldPos("CNE_YICMST"))>0 .And. !Empty(oGrid:GetValue("CNE_YICMST"))
								_aItens[nK,_nPosICMST,2] := oGrid:GetValue("CNE_YICMST")
							Endif
                            
                            // 15/05/2024, Helitom Silva, Envia dados da OP-Tarefa-Etapa referente a OS e Insumo de Origem para o pedido de compra
							If Empty(_nPosOP) .and. CNE->(FieldPos("CNE_OP")) > 0 .and. !Empty(oGrid:GetValue("CNE_OP"))
								Aadd(_aItens[nK], {"C7_OP", oGrid:GetValue("CNE_OP"), Nil})
							ElseIf !Empty(_nPosOP) .and. Empty(_aItens[nK, _nPosOP, 2]) .and. CNE->(FieldPos("CNE_OP")) > 0 .and. !Empty(oGrid:GetValue("CNE_OP"))
								_aItens[nK, _nPosOP, 2] := oGrid:GetValue("CNE_OP")
							EndIf

							If Empty(_nPosTareOS) .and. CNE->(FieldPos("CNE_TAREOS")) > 0 .and. !Empty(oGrid:GetValue("CNE_TAREOS"))
								Aadd(_aItens[nK], {"C7_YTAREOS", oGrid:GetValue("CNE_TAREOS"), Nil})
							ElseIf !Empty(_nPosTareOS) .and. Empty(_aItens[nK, _nPosTareOS, 2]) .and. CNE->(FieldPos("CNE_TAREOS")) > 0 .and. !Empty(oGrid:GetValue("CNE_TAREOS"))
								_aItens[nK,_nPosTareOS, 2] := oGrid:GetValue("CNE_TAREOS")
							EndIf

							If Empty(_nPosEtapOS) .and. CNE->(FieldPos("CNE_ETAPOS")) > 0 .and. !Empty(oGrid:GetValue("CNE_ETAPOS"))
								Aadd(_aItens[nK], {"C7_YETAPOS", oGrid:GetValue("CNE_ETAPOS"), Nil})
							ElseIf !Empty(_nPosEtapOS) .and. Empty(_aItens[nK, _nPosEtapOS, 2]) .and. CNE->(FieldPos("CNE_ETAPOS")) > 0 .and. !Empty(oGrid:GetValue("CNE_ETAPOS"))
								_aItens[nK, _nPosEtapOS, 2] := oGrid:GetValue("CNE_ETAPOS")
							Endif
							
							If Empty(_nPosContra) .and. CNE->(FieldPos("CNE_CONTRA")) > 0 .and. !Empty(oGrid:GetValue("CNE_CONTRA"))
								Aadd(_aItens[nK], {"C7_CONTRA", oGrid:GetValue("CNE_CONTRA"), Nil})
							ElseIf !Empty(_nPosContra) .and. Empty(_aItens[nK, _nPosContra, 2]) .and. CNE->(FieldPos("CNE_CONTRA")) > 0 .and. !Empty(oGrid:GetValue("CNE_CONTRA"))
								_aItens[nK, _nPosContra, 2] := oGrid:GetValue("CNE_CONTRA")
							EndIf

							If Empty(_nPosRevisa) .and. CNE->(FieldPos("CNE_REVISA")) > 0 .and. !Empty(oGrid:GetValue("CNE_REVISA"))
								Aadd(_aItens[nK], {"C7_CONTREV", oGrid:GetValue("CNE_REVISA"), Nil})
							ElseIf !Empty(_nPosRevisa) .and. Empty(_aItens[nK, _nPosRevisa, 2]) .and. CNE->(FieldPos("CNE_REVISA")) > 0 .and. !Empty(oGrid:GetValue("CNE_REVISA"))
								_aItens[nK, _nPosRevisa, 2] := oGrid:GetValue("CNE_REVISA")
							EndIf

						Endif

					Next nK

				Endif

			Next nJ

			FWRestRows( aSaveLines )

		Endif

	EndIf

	aResult[1] := aCab
	aResult[2] := _aItens

Return aResult
