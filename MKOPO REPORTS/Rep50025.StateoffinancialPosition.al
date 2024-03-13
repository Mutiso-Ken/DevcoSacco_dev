#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50025 "State of financial Position"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/StatementOfFinancialPosition.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
#pragma warning disable AL0275
        dataitem("Company Information"; "Company Information")
#pragma warning restore AL0275
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(FinancialYear; FinancialYear)
            {
            }
            column(Date; Date)
            {
            }
            column(Asat; Asat)
            {
            }
            column(Name; "Company Information".Name)
            {
            }
            column(Cashinhand; Cashinhand)
            {
            }
            column(Cashatbank; Cashatbank)
            {
            }
            column(CashCashEquivalent; CashCashEquivalent)
            {
            }
            column(LCashCashEquivalent; LCashCashEquivalent)
            {
            }
            column(PrepaymentsSundryReceivables; PrepaymentsSundryReceivables)
            {
            }
            column(FinancialInvestments; FinancialInvestments)
            {
            }
            column(LFinancialInvestments; LFinancialInvestments)
            {

            }
            column(InterestonMemberdeposits; InterestonMemberdeposits)
            {

            }
            column(LInterestonMemberDeposits; LInterestonMemberDeposits)
            {

            }
            column(GovernmentSecurities; GovernmentSecurities)
            {
            }
            column(Placement; Placement)
            {
            }
            column(CurrentYear; CurrentYear)
            {

            }
            column(PreviousYear; PreviousYear)
            {

            }
            column(EndofLastyear; EndofLastyear) { }
            column(CommercialPapers; CommercialPapers)
            {
            }
            column(CollectiveInvestment; CollectiveInvestment)
            {
            }
            column(Derivatives; Derivatives)
            {
            }
            column(EquityInvestments; EquityInvestments)
            {
            }
            column(Investmentincompanies; Investmentincompanies)
            {
            }
            column(GrossLoanPortfolio; GrossLoanPortfolio)
            {
            }
            column(LGrossLoanPortfolio; LGrossLoanPortfolio)
            {
            }
            column(PropertyEquipment; PropertyEquipment)
            {
            }
            column(LPropertyEquipment; LPropertyEquipment)
            {
            }
            column(AllowanceforLoanLoss; AllowanceforLoanLoss)
            {
            }
            column(Nonwithdrawabledeposits; Nonwithdrawabledeposits)
            {
            }
            column(LNonwithdrawabledeposits; LNonwithdrawabledeposits)
            {
            }
            column(TaxPayable; TaxPayable)
            {
            }
            column(DeferredTaxLiability; DeferredTaxLiability)
            {
            }
            column(RetirementBenefitsLiability; RetirementBenefitsLiability)
            {
            }
            column(OtherLiabilities; OtherLiabilities)
            {
            }
            column(ExternalBorrowings; ExternalBorrowings)
            {
            }
            column(TotalLiabilities; TotalLiabilities)
            {
            }
            column(ShareCapital; ShareCapital)
            {
            }
            column(LShareCapital;LShareCapital)
            {  }
            column(StatutoryReserve; StatutoryReserve)
            {
            }
            column(LStatutoryReserve; LStatutoryReserve)
            {
            }
            column(OtherReserves; OtherReserves)
            {
            }
            column(RevaluationReserves; RevaluationReserves)
            {
            }
            column(ProposedDividends; ProposedDividends)
            {
            }
            column(AdjustmenttoEquity; AdjustmenttoEquity)
            {
            }
            column(PrioryarRetainedEarnings; PrioryarRetainedEarnings)
            {
            }
            column(CurrentYearSurplus; CurrentYearSurplus)
            {
            }
            column(TaxRecoverable; TaxRecoverable)
            {
            }
            column(ReceivableandPrepayments; ReceivableandPrepayments)
            {
            }
            column(LReceivableandPrepayments; LReceivableandPrepayments)
            {
            }
            column(DeferredTaxAssets; DeferredTaxAssets)
            {
            }
            column(RetirementBenefitAssets; RetirementBenefitAssets)
            {
            }
            column(OtherAssets; OtherAssets)
            {
            }
            column(LOtherAssets; LOtherAssets)
            {
            }
            column(IntangibleAssets; IntangibleAssets)
            {
            }
            column(LIntangibleAssets; LIntangibleAssets)
            {
            }
            column(PrepaidLeaseentals; PrepaidLeaseentals)
            {
            }
            column(InvestmentProperties; InvestmentProperties)
            {
            }
            column(DividendPayable; DividendPayable)
            {
            }
            column(LDividendPayable; LDividendPayable)
            {
            }
            column(NetLoanPortfolio; NetLoanPortfolio)
            {
            }
            column(AccountsReceivables; AccountsReceivables)
            {
            }
            column(PropertyEquipmentOtheassets; PropertyEquipmentOtheassets)
            {
            }
            column(LPropertyEquipmentOtheassets; LPropertyEquipmentOtheassets)
            {
            }
            column(AccountsPayableOtherLiabilities; AccountsPayableOtherLiabilities)
            {
            }
            column(CapitalGrants; CapitalGrants)
            {
            }
            column(EQUITY; EQUITY)
            {
            }
            column(RetainedEarnings; RetainedEarnings)
            {
            }
            column(OtherEquityAccounts; OtherEquityAccounts)
            {
            }
            column(TotalEquity; TotalEquity)
            {
            }
            column(TotalLiabilitiesandEquity; TotalLiabilitiesandEquity)
            {
            }
            column(TotalLiabilitiesNew; TotalLiabilitiesNew)
            {
            }
            column(TotalAssets; TotalAssets)
            {
            }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                InputDate: Date;
                DateFormula: Text;
                DateExpr: Text;
            begin
                CashCashEquivalent := 0;
                DateFormula := '<-CY-1D>';
                DateExpr := '<-1y>';
                InputDate := Asat;

                EndofLastyear := CalcDate(DateFormula, Asat);
                CurrentYear := Date2DMY(EndofLastyear, 3);
                LastYearButOne := CalcDate(DateExpr, EndofLastyear);
                PreviousYear := CurrentYear - 1;
                //Sharecapital
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Capital adequecy", '%1', GLAccount."capital adequecy"::ShareCapital);
                if GLAccount.FindSet then begin
                    repeat
                        ShareCapitalValue := 0;
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', AsAt);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            ShareCapital := GLEntry.Amount * -1;
                        end;
                        ShareCapital := ShareCapital + ShareCapital;

                    until GLAccount.Next = 0;
                end;

                // //Sharecapital 
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Capital adequecy", '%1', GLAccount."capital adequecy"::ShareCapital);
                if GLAccount.FindSet then begin
                    repeat
                        ShareCapitalValue := 0;
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                           LShareCapital := GLEntry.Amount * -1;
                        end;
                        LShareCapital := LShareCapital + LShareCapital;

                    until GLAccount.Next = 0;
                end;
                // statutory reserve
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Capital adequecy", '%1', GLAccount."capital adequecy"::StatutoryReserve);
                if GLAccount.FindSet then begin
                    repeat
                        ShareCapitalValue := 0;
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', AsAt);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StatutoryReserve += GLEntry.Amount * -1;
                        end;
                    until GLAccount.Next = 0;

                end;

                //interest on Member deposits
                InterestonMemberdeposits := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::InterestonMemberdeposits);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            InterestonMemberdeposits += 1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                LInterestonMemberdeposits := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::InterestonMemberdeposits);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LInterestonMemberdeposits += 1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                Cashinhand := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::Cashinhand);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            Cashinhand += 1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                LCashinhand := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::Cashinhand);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LCashinhand += 1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                Cashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::Cashatbank);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            Cashatbank += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                LCashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::Cashatbank);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LCashatbank += GLEntry.Amount;

                        end;
                    until GLAccount.Next = 0;

                end;
                //gross loan portfolio
                GrossLoanPortfolio := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::GrossLoanPortfolio);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            GrossLoanPortfolio += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                LGrossLoanPortfolio := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::GrossLoanPortfolio);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LGrossLoanPortfolio += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;

                //property and equipments

                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::PropertyEquipment);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            PropertyEquipment += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::PropertyEquipment);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LPropertyEquipment += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;

                //allowance for loan loss
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::AllowanceforLoanLoss);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', Asat);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            AllowanceforLoanLoss += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //prepayments and sandry receivables
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::PrepaymentsSundryReceivables);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', Asat);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            PrepaymentsSundryReceivables += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //non withdrawal
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::Nonwithdrawabledeposits);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            Nonwithdrawabledeposits += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::Nonwithdrawabledeposits);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LNonwithdrawabledeposits += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //share capital
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::ShareCapital);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', Asat);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            ShareCapital += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //prior year
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::PrioryarRetainedEarnings);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', Asat);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            PrioryarRetainedEarnings += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //statutory
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::StatutoryReserve);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StatutoryReserve += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::StatutoryReserve);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LStatutoryReserve += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //other reserves
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::OtherReserves);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', Asat);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            OtherReserves += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //revaluation reservs
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::RevaluationReserves);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', Asat);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            RevaluationReserves += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //tax payable
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::TaxPayable);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', Asat);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            TaxPayable += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //other liabilities
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP2, '%1', GLAccount.Statementoffp2::OtherLiabilities);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', Asat);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            OtherLiabilities += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //investment in company shares
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::Investmentincompanies);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            Investmentincompanies += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::Investmentincompanies);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LInvestmentincompanies += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //other assets
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::"Other Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            OtherAssets += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::"Other Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LOtherAssets += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //intangible assets
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::IntangibleAssets);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            IntangibleAssets += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.StatementOfFP, '%1', GLAccount.Statementoffp::IntangibleAssets);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LIntangibleAssets += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                //Account Receivable
                ReceivableandPrepayments := 0;
                GLAccount.Reset;
                GLAccount.SetRange(GLAccount."No.", '1449');
                GLAccount.SetFilter(GLAccount."Date Filter", '<=%1', EndofLastyear);
                if GLAccount.FindSet then begin
                    GLAccount.CalcFields(GLAccount."Net Change");
                    ReceivableandPrepayments := GLAccount."Net Change";
                end;
                //dividends Payable
                DividendPayable := 0;
                GLAccount.Reset;
                GLAccount.SetRange(GLAccount."No.", '1807');
                GLAccount.SetFilter(GLAccount."Date Filter", '<=%1', EndofLastyear);
                if GLAccount.FindSet then begin
                    GLAccount.CalcFields(GLAccount."Net Change");
                    DividendPayable := GLAccount."Net Change";
                end;

                LDividendPayable := 0;
                GLAccount.Reset;
                GLAccount.SetRange(GLAccount."No.", '1807');
                GLAccount.SetFilter(GLAccount."Date Filter", '<=%1', LastYearButOne);
                if GLAccount.FindSet then begin
                    GLAccount.CalcFields(GLAccount."Net Change");
                    LDividendPayable := GLAccount."Net Change";
                end;

                LReceivableandPrepayments := 0;
                GLAccount.Reset;
                GLAccount.SetRange(GLAccount."No.", '1449');
                GLAccount.SetFilter(GLAccount."Date Filter", '<=%1', LastYearButOne);
                if GLAccount.FindSet then begin
                    GLAccount.CalcFields(GLAccount."Net Change");
                    LReceivableandPrepayments := GLAccount."Net Change";
                end;
                //current year surplus
                CurrentYearSurplus := 0;
                GLAccount.Reset;
                GLAccount.SetRange(GLAccount."No.", '2999');
                GLAccount.SetFilter(GLAccount."Date Filter", '<=%1', Asat);
                if GLAccount.FindSet then begin
                    GLAccount.CalcFields(GLAccount."Net Change");
                    CurrentYearSurplus := CurrentYearSurplus + GLAccount."Net Change";
                end;
                //MESSAGE(FORMAT(CurrentYearSurplus));

                CashCashEquivalent := Cashatbank + Cashinhand;
                LCashCashEquivalent := LCashatbank + LCashinhand;
                FinancialInvestments := GovernmentSecurities + Placement + CollectiveInvestment + Derivatives + EquityInvestments + Investmentincompanies + CommercialPapers;
                LFinancialInvestments := GovernmentSecurities + Placement + CollectiveInvestment + Derivatives + EquityInvestments + Investmentincompanies + CommercialPapers;
                NetLoanPortfolio := GrossLoanPortfolio + AllowanceforLoanLoss;
                AccountsReceivables := TaxRecoverable + DeferredTaxAssets + RetirementBenefitAssets;
                PropertyEquipmentOtheassets := InvestmentProperties + PropertyEquipment + PrepaidLeaseentals + OtherAssets + IntangibleAssets;
                LPropertyEquipmentOtheassets := LInvestmentProperties + LPropertyEquipment + LPrepaidLeaseentals + LOtherAssets + LIntangibleAssets;
                TotalAssets := CashCashEquivalent + FinancialInvestments + NetLoanPortfolio + AccountsReceivables + PropertyEquipmentOtheassets + PrepaymentsSundryReceivables;


                AccountsPayableOtherLiabilities := TaxPayable + DividendPayable + DeferredTaxLiability + ExternalBorrowings + RetirementBenefitsLiability + OtherLiabilities;
                EQUITY := ShareCapital + CapitalGrants;
                RetainedEarnings := PrioryarRetainedEarnings - CurrentYearSurplus;
                OtherEquityAccounts := StatutoryReserve + OtherReserves + RevaluationReserves + AdjustmenttoEquity + ProposedDividends;
                TotalEquity := EQUITY + RetainedEarnings + OtherEquityAccounts;
                TotalLiabilitiesNew := Nonwithdrawabledeposits + AccountsPayableOtherLiabilities;
                TotalLiabilitiesandEquity := TotalEquity + TotalLiabilitiesNew;
            end;

            trigger OnPreDataItem()
            begin
                Date := CalcDate('-CY', Asat);
                DateFilter := Format(Date) + '..' + Format(Asat);
                DateFilter11 := Format(Date) + '..' + Format(Asat);
                FinancialYear := Date2dmy(Asat, 3);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Asat; Asat)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asat';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
#pragma warning disable AL0275
        //PropertyEquipmentOtheassets := InvestmentProperties + PropertyEquipment + PrepaidLeaseentals + OtherAssets + IntangibleAssets;
        LInvestmentProperties: Decimal;
        ShareCapitalValue: Decimal;
        LPropertyEquipment: Decimal;
        LPrepaidLeaseentals: Decimal;
        LIntangibleAssets: Decimal;
        LOtherAssets: Decimal;
        PreviousYear: Integer;
        LInterestonMemberDeposits: Decimal;
        InterestonMemberdeposits: Decimal;
        EndofLastyear: date;
        LastYearButOne: Date;
        CurrentYear: Integer;
        ReceivableandPrepayments: Decimal;
        LReceivableandPrepayments: Decimal;
        CompanyInformation: Record "Company Information";
#pragma warning restore AL0275
        Cashinhand: Decimal;
        FinancialYear: Integer;
        StartDate: Date;
        Cashatbank: Decimal;
        LCashatbank: Decimal;
        LCashinhand: Decimal;
        CashCashEquivalent: Decimal;
        LCashCashEquivalent: Decimal;
#pragma warning disable AL0275
        GLEntry: Record "G/L Entry";
        LGrossLoanPortfolio: Decimal;
        GLAccount: Record "G/L Account";
#pragma warning restore AL0275
        DateFilter: Text;
        Date: Date;
        DateFilter11: Text;
        Asat: Date;
        PrepaymentsSundryReceivables: Decimal;
        FinancialInvestments: Decimal;
        LFinancialInvestments: Decimal;
        GovernmentSecurities: Decimal;
        Placement: Decimal;
        CommercialPapers: Decimal;
        CollectiveInvestment: Decimal;
        Derivatives: Decimal;
        EquityInvestments: Decimal;
        Investmentincompanies: Decimal;
        LInvestmentincompanies: Decimal;
        GrossLoanPortfolio: Decimal;
        PropertyEquipment: Decimal;
        AllowanceforLoanLoss: Decimal;
        Nonwithdrawabledeposits: Decimal;
        LNonwithdrawabledeposits: Decimal;
        TaxPayable: Decimal;
        RetirementBenefitsLiability: Decimal;
        OtherLiabilities: Decimal;
        DeferredTaxLiability: Decimal;
        ExternalBorrowings: Decimal;
        TotalLiabilities: Decimal;
        ShareCapital: Decimal;
        LShareCapital: Decimal;
        StatutoryReserve: Decimal;
        LStatutoryReserve: Decimal;
        OtherReserves: Decimal;
        RevaluationReserves: Decimal;
        ProposedDividends: Decimal;
        AdjustmenttoEquity: Decimal;
        PrioryarRetainedEarnings: Decimal;
        CurrentYearSurplus: Decimal;
        TaxRecoverable: Decimal;
        DeferredTaxAssets: Decimal;
        RetirementBenefitAssets: Decimal;
        OtherAssets: Decimal;
        IntangibleAssets: Decimal;
        PrepaidLeaseentals: Decimal;
        InvestmentProperties: Decimal;
        DividendPayable: Decimal;
        LDividendPayable: Decimal;
        NetLoanPortfolio: Decimal;
        AccountsReceivables: Decimal;
        PropertyEquipmentOtheassets: Decimal;
        LPropertyEquipmentOtheassets: Decimal;
        AccountsPayableOtherLiabilities: Decimal;
        CapitalGrants: Decimal;
        EQUITY: Decimal;
        RetainedEarnings: Decimal;
        OtherEquityAccounts: Decimal;
        TotalEquity: Decimal;
        TotalLiabilitiesandEquity: Decimal;
        TotalLiabilitiesNew: Decimal;
        TotalAssets: Decimal;
}

