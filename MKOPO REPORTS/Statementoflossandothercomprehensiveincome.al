report 50026 StatementProfitorloss
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Statementoflossorloss.rdlc';

    dataset
    {
        dataitem("Sacco Information"; "Sacco Information")
        {
            column(Code; Code)
            {

            }
            column(InterestonLoans; InterestonLoans)
            {

            }
            column(Otherincome; Otherincome)
            {

            }
            column(InterestExpenses; InterestExpenses)
            {

            }
            column(NetFeeandcommission; NetFeeandcommission)
            {

            }
            column(OtherOperatingincome; OtherOperatingincome)
            {

            }
            column(Gainloassasrisongfromderecongnition; Gainloassasrisongfromderecongnition)
            {

            }
            column(ImpairmentLosses; ImpairmentLosses)
            {

            }
            column(Governanceexpenses; Governanceexpenses)
            {

            }
            column(Makertingexpenses; Makertingexpenses)
            {

            }

            column(staffcosts; staffcosts)
            {

            }
            column(OtherOperatingExpenses; OtherOperatingExpenses)
            {

            }
            column(LOtherOperatingExpenses; LOtherOperatingExpenses)
            {

            }
            column(otheradministrativeexpenses; otheradministrativeexpenses)
            {

            }
            column(profitorLossbeforetax; profitorLossbeforetax)
            {

            }
            column(NotRecGainLossonPropertyandequipmenrevaluation; NotRecGainLossonPropertyandequipmenrevaluation)
            {

            }
            column(NotRecGainlossonequityinstatFVTOCI; NotRecGainlossonequityinstatFVTOCI)
            {

            }
            column(NotRecRemeasurementofdefinedassetLiability; NotRecRemeasurementofdefinedassetLiability)
            {

            }
            column(NotRecEffectofchangeinrareofdefferedtax; NotRecEffectofchangeinrareofdefferedtax)
            {

            }
            column(NotDefferedtax; NotDefferedtax)
            {

            }
            column(RecGainlossonequityinstatFVTOCI; RecGainlossonequityinstatFVTOCI)
            {

            }
            column(RecEffectofchangeinrateofdefferedtax; RecEffectofchangeinrateofdefferedtax)
            {

            }
            column(RecDefferedtax; RecDefferedtax)
            {

            }
            column(OthercomprehensiveIncome; OthercomprehensiveIncome)
            {

            }
            ///last year but One
            column(LInterestonLoans; LInterestonLoans)
            {

            }
            column(LOtherincome; LOtherincome)
            {

            }
            column(LInterestExpenses; LInterestExpenses)
            {

            }
            column(LNetFeeandcommission; LNetFeeandcommission)
            {

            }
            column(LOtherOperatingincome; LOtherOperatingincome)
            {

            }

            column(LGainloassasrisongfromderecongnition; LGainloassasrisongfromderecongnition)
            {

            }
            column(LImpairmentLosses; LImpairmentLosses)
            {

            }
            column(LGovernanceexpenses; LGovernanceexpenses)
            {

            }
            column(LMakertingexpenses; LMakertingexpenses)
            {

            }

            column(Lstaffcosts; Lstaffcosts)
            {

            }
            column(Lotheradministrativeexpenses; Lotheradministrativeexpenses)
            {

            }
            column(LprofitorLossbeforetax; LprofitorLossbeforetax)
            {

            }
            column(LNotRecGainLossonPropertyandequipmenrevaluation; LNotRecGainLossonPropertyandequipmenrevaluation)
            {

            }
            column(LNotRecGainlossonequityinstatFVTOCI; LNotRecGainlossonequityinstatFVTOCI)
            {

            }
            column(LNotRecRemeasurementofdefinedassetLiability; LNotRecRemeasurementofdefinedassetLiability)
            {

            }
            column(LNotRecEffectofchangeinrareofdefferedtax; LNotRecEffectofchangeinrareofdefferedtax)
            {

            }
            column(LNotDefferedtax; LNotDefferedtax)
            {

            }
            column(LRecGainlossonequityinstatFVTOCI; LRecGainlossonequityinstatFVTOCI)
            {

            }
            column(LRecEffectofchangeinrateofdefferedtax; LRecEffectofchangeinrateofdefferedtax)
            {

            }
            column(LRecDefferedtax; LRecDefferedtax)
            {

            }
            column(LOthercomprehensiveIncome; LOthercomprehensiveIncome)
            {

            }
            column(EndofLastyear; EndofLastyear)
            {

            }
            column(CurrentYear; CurrentYear)
            {

            }
            column(PreviousYear; PreviousYear)
            {

            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                DateFormula: Text;
                DateExpr: Text;
                InputDate: Date;

            begin
                DateFormula := '<-CY-1D>';
                DateExpr := '<-1y>';
                InputDate := Asat;

                EndofLastyear := CalcDate(DateFormula, Asat);
                CurrentYear := Date2DMY(EndofLastyear, 3);
                LastYearButOne := CalcDate(DateExpr, EndofLastyear);
                PreviousYear := CurrentYear - 1;


                //Revenues
                //Interest on Loans
                InterestonLoans := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::InterestonLoanPortfolio);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            InterestonLoans += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                LInterestonLoans := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::InterestonLoanPortfolio);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LInterestonLoans += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;
                //OtherInterestIncome
                Otherincome := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::OtherInterestIncome);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            Otherincome += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                LOtherincome := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::OtherInterestIncome);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LOtherincome += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;
                //Interest Exepenses
                InterestExpenses := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::InterestExpenses);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            InterestExpenses += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                LInterestExpenses := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::InterestExpenses);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LInterestExpenses += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;
                //Netfeeincome
                NetFeeandcommission := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::NetFeeandcommission);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            NetFeeandcommission += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                LNetFeeandcommission := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::InterestExpenses);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LNetFeeandcommission += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;
                //Otheroperatingincome
                OtherOperatingincome := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::OtherOperatingincome);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            OtherOperatingincome += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                OtherOperatingincome := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Form2F(Statement of C Income)", '%1', GLAccount."form2f(statement of c income)"::OtherOperatingincome);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LOtherOperatingincome += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                // Date := CalcDate('-CY -1D', AsAt);
                // DateFilter := Format(Date) + '..' + Format(AsAt);
                // DateFilter11 := Format(Date) + '..' + Format(AsAt);
                // FinancialYear := Date2dmy(AsAt, 3);
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
    var
        DateFilter: Text;
        LDatefilter: Text;
        Date: Date;
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        myInt: Integer;
        Asat: Date;
        EndofLastyear: Date;
        LastYearButOne: Date;
        CurrentYear: Integer;
        PreviousYear: Integer;
        InterestonLoans: Decimal;
        Otherincome: Decimal;
        InterestExpenses: Decimal;
        NetFeeandcommission: Decimal;
        OtherOperatingincome: Decimal;
        OtherOperatingExpenses: Decimal;
        Gainloassasrisongfromderecongnition: Decimal;
        ImpairmentLosses: Decimal;
        Governanceexpenses: Decimal;
        Makertingexpenses: Decimal;
        staffcosts: Decimal;
        otheradministrativeexpenses: Decimal;
        profitorLossbeforetax: Decimal;
        NotRecGainLossonPropertyandequipmenrevaluation: Decimal;
        NotRecGainlossonequityinstatFVTOCI: Decimal;
        NotRecRemeasurementofdefinedassetLiability: Decimal;
        NotRecEffectofchangeinrareofdefferedtax: Decimal;
        NotDefferedtax: Decimal;
        RecGainlossonequityinstatFVTOCI: Decimal;
        RecEffectofchangeinrateofdefferedtax: Decimal;
        RecDefferedtax: Decimal;
        OthercomprehensiveIncome: Decimal;

        //Last Year
        LInterestonLoans: Decimal;
        LOtherincome: Decimal;
        LInterestExpenses: Decimal;
        LNetFeeandcommission: Decimal;
        LOtherOperatingincome: Decimal;
        LOtherOperatingExpenses: Decimal;
        LGainloassasrisongfromderecongnition: Decimal;
        LImpairmentLosses: Decimal;
        LGovernanceexpenses: Decimal;
        LMakertingexpenses: Decimal;
        Lstaffcosts: Decimal;
        Lotheradministrativeexpenses: Decimal;
        LprofitorLossbeforetax: Decimal;
        LNotRecGainLossonPropertyandequipmenrevaluation: Decimal;
        LNotRecGainlossonequityinstatFVTOCI: Decimal;
        LNotRecRemeasurementofdefinedassetLiability: Decimal;
        LNotRecEffectofchangeinrareofdefferedtax: Decimal;
        LNotDefferedtax: Decimal;
        LRecGainlossonequityinstatFVTOCI: Decimal;
        LRecEffectofchangeinrateofdefferedtax: Decimal;
        LRecDefferedtax: Decimal;
        LOthercomprehensiveIncome: Decimal;
}