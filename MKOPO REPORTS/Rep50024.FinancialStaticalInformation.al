report 50024 FinancialStaticalInformation
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/FinancialStaticalInformation.rdlc';


    dataset
    {
        dataitem("Sacco Information"; "Sacco Information")
        {
            column(Code; Code)
            {

            }
            column(Active; Active) { }
            column(Dormant; Dormant) { }
            column(LActive; LActive) { }
            column(LDormant; LDormant) { }
            column(NumberofEmployees; NumberofEmployees) { }
            column(LNumberofEmployees; LNumberofEmployees) { }
            column(TotalAssets; TotalAssets) { }
            column(LTotalAssets; LTotalAssets) { }
            column(DepositAmount; (DepositAmount * -1)) { }
            column(LDepositAmount; (LDepositAmount * -1)) { }
            column(LoanBalance; LoanBalance) { }
            column(LLoanBalance; LLoanBalance) { }
            column(FinancialAssets; FinancialAssets) { }
            column(LFinancialAssets; LFinancialAssets) { }
            column(CorecapitaltoAssetsRatio; CorecapitaltoAssetsRatio) { }
            column(LCorecapitaltoAssetsRatio; LCorecapitaltoAssetsRatio) { }
            column(Corecapital; Corecapital) { }
            column(LCorecapital; LCorecapital) { }
            column(CorecapitaltoDepositsRatio; CorecapitaltoDepositsRatio) { }
            column(LCorecapitaltoDepositsRatio; LCorecapitaltoDepositsRatio) { }
            column(LExternalBorrowingtoAssetsRatio; LExternalBorrowingtoAssetsRatio) { }
            column(ExternalBorrowingtoAssetsRatio; ExternalBorrowingtoAssetsRatio) { }
            column(LiquidAssetstoTotalassetslongtermliabilities; LiquidAssetstoTotalassetslongtermliabilities) { }
            column(LLiquidAssetstoTotalassetslongtermliabilities; LLiquidAssetstoTotalassetslongtermliabilities) { }
            column(NoSaccoBraches; NoSaccoBraches)
            {

            }
            column(CurrentYear; CurrentYear)
            {

            }
            column(PreviousYear; PreviousYear)
            {

            }
            column(EndofLastyear; EndofLastyear)
            {

            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                InputDate: Date;
                DateFormula: Text;
                DateExpr: Text;

            begin
                DateFormula := '<-CY-1D>';
                DateExpr := '<-1y>';
                InputDate := Asat;

                EndofLastyear := CalcDate(DateFormula, Asat);
                CurrentYear := Date2DMY(EndofLastyear, 3);
                LastYearButOne := CalcDate(DateExpr, EndofLastyear);
                PreviousYear := CurrentYear - 1;
                //Date := DMY2DATE(Day,Month,Year);


                LNumberofEmployees := 0;
                NumberofEmployees := 0;
                Active := 0;
                Dormant := 0;
                LActive := 0;
                LDormant := 0;
                LLoanBalance := 0;
                Equityinvestment := 0;
                // FinancialAssets := 0;
                // LFinancialAssets := 0;
                SubsidiaryandRelated := 0;
                cust.Reset();
                cust.SetFilter(Cust."Customer Type", '=%1', Cust."Customer Type"::Member);
                if Cust.Find('-') then begin
                    Cust.SetFilter(Cust.Status, '=%1', Cust.Status::Active);
                    Cust.SetFilter(Cust."Registration Date", '<=%1', EndofLastyear);
                    if FindSet() then
                        Active := Cust.Count;
                    Cust.SetFilter(Cust.Status, '=%1', Cust.Status::Dormant);
                    Cust.SetFilter(Cust."Registration Date", '<=%1', EndofLastyear);
                    if FindSet() then
                        Dormant := Cust.Count;

                    Cust.SetFilter(Cust.Status, '=%1', Cust.Status::Active);
                    Cust.SetFilter(Cust."Registration Date", '<=%1', LastYearButOne);
                    if FindSet() then
                        LActive := Cust.Count;

                    Cust.SetFilter(Cust.Status, '=%1', Cust.Status::Dormant);
                    Cust.SetFilter(Cust."Registration Date", '<=%1', LastYearButOne);
                    if FindSet() then
                        LDormant := Cust.Count;
                end;
                //Number of Sacco Employees
                Emp.reset;
                Emp.SetFilter(Emp.Status, '%1', Emp.Status::Active);
                if FindSet() then begin
                    Emp.SetFilter(Emp."Joining Date", '<=%1', EndofLastyear);
                    if FindSet() then
                        NumberofEmployees := Emp.Count;

                    Emp.SetFilter(Emp."Joining Date", '<=%1', LastYearButOne);
                    if FindSet() then
                        LNumberofEmployees := Emp.Count;//LNumberofEmployees
                end;
                //Chart of Accounts
                //Total assets
                GL.Reset();

                GL.SetRange(Gl."No.", '1499');
                GL.SetFilter(GL."Date Filter", '..%1', EndofLastyear);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");

                    TotalAssets := GL."Net Change";
                end;
                //Total assets

                GL.SetRange(Gl."No.", '1499');
                GL.SetFilter(GL."Date Filter", '..%1', LastYearButOne);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    LTotalAssets := GL."Net Change";
                end;

                //Members' deposits

                GL.SetRange(Gl."No.", '1681');
                GL.SetFilter(GL."Date Filter", '..%1', EndofLastyear);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");

                    DepositAmount := GL."Net Change";
                end;
                GL.SetRange(Gl."No.", '1681');
                GL.SetFilter(GL."Date Filter", '..%1', LastYearButOne);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    LDepositAmount := GL."Net Change";
                end;

                //Member Loans

                GL.SetRange(Gl."No.", '1249');
                GL.SetFilter(GL."Date Filter", '..%1', EndofLastyear);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    LoanBalance := GL."Net Change";
                end;
                GL.SetRange(Gl."No.", '1249');
                GL.SetFilter(GL."Date Filter", '..%1', LastYearButOne);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    LLoanBalance := GL."Net Change";
                end;
                //Key Ratios
                GL.SetFilter(Gl."No.", '1351');
                GL.SetFilter(GL."Date Filter", '..%1', EndofLastyear);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    FinancialAssets := GL."Net Change";
                    Message('fiman %1', FinancialAssets);
                end;
                GL.SetRange(Gl."No.", '1351');
                GL.SetFilter(GL."Date Filter", '..%1', LastYearButOne);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    LFinancialAssets := GL."Net Change";
                end;
                //Liquid Assest
                GL.Reset();
                GL.SetRange(Gl."No.", '1329');
                GL.SetFilter(GL."Date Filter", '..%1', EndofLastyear);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    LiquidAssets := GL."Net Change";
                end;
                GL.Reset();
                GL.SetRange(Gl."No.", '1329');
                GL.SetFilter(GL."Date Filter", '..%1', LastYearButOne);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    LLiquidAssets := GL."Net Change";
                end;

                //Long Term Liablites
                GL.Reset();
                GL.SetRange(Gl."No.", '1649');
                GL.SetFilter(GL."Date Filter", '..%1', EndofLastyear);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    LongtermLiablities := GL."Net Change";
                end;
                GL.Reset();
                GL.SetRange(Gl."No.", '1649');
                GL.SetFilter(GL."Date Filter", '..%1', LastYearButOne);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    LLongtermliabilities := GL."Net Change";
                end;
                //equity
                GL.SetRange(GL."Form2E(investment)", GL."form2e(investment)"::Equityinvestment);
                GL.SetFilter(GL."Date Filter", '..%1', EndofLastyear);
                if GL.FindSet() then begin
                    Gl.CalcFields(GL."Net Change");
                    Equityinvestment += GL."Net Change";
                    //Message('Equityinvestment %1', Equityinvestment);
                end;
                //subsidary
                GL.SetFilter(GL."Form2E(investment)", '%1', GL."form2e(investment)"::subsidiaryandrelatedentities);
                GL.SetFilter(GL."Date Filter", '..%1', LastYearButOne);
                if GL.FindSet() then begin
                    repeat
                        Gl.CalcFields(GL."Net Change");
                        SubsidiaryandRelated += GL."Net Change";
                    until GL.Next = 0;
                end;
                //OtherInvestments

                GL.SetFilter(GL."Form2E(investment)", '%1', GL."form2e(investment)"::Otherinvestments);
                GL.SetFilter(GL."Date Filter", '..%1', LastYearButOne);
                if GL.FindSet() then begin
                    repeat
                        Gl.CalcFields(GL."Net Change");
                        Otherinvestments += GL."Net Change";
                    until GL.next = 0;
                end;
                //Core capital
                CoreCapital := 0;
                GL.Reset;
                GL.SetFilter(GL."Form2E(investment)", '%1', GL."form2e(investment)"::Core_Capital);
                if GL.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        GLEntry.SetRange(GLEntry."G/L Account No.", GL."No.");
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            CoreCapitalOldLastyear += GLEntry.Amount * -1;
                        end
                    until GL.Next = 0;

                end;
                CoreCapital := 0;
                GL.Reset;
                GL.SetFilter(GL."Form2E(investment)", '%1', GL."form2e(investment)"::Core_Capital);
                if GL.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        GLEntry.SetRange(GLEntry."G/L Account No.", GL."No.");
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            CoreCapitalOldLastyearButone += GLEntry.Amount * -1;
                        end
                    until GL.Next = 0;
                end;
                GL.Reset;
                GL.SetFilter(GL."Capital adequecy", '%1', GL."capital adequecy"::NetSurplusaftertax);
                if GL.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GL."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            NetSurplusaftertax += (GLEntry.Amount * 50 / 100) * -1;
                        end;

                    until GL.Next = 0;

                end;
                GL.Reset;
                GL.SetFilter(GL."Capital adequecy", '%1', GL."capital adequecy"::NetSurplusaftertax);
                if GL.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GL."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LNetSurplusaftertax += (GLEntry.Amount * 50 / 100) * -1;
                        end;

                    until GL.Next = 0;

                end;
                GL.Reset;
                GL.SetFilter(GL."Capital adequecy", '%1', GL."capital adequecy"::InvestmentsinSubsidiary);
                if GL.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GL."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            InvestmentsinSubsidiary += GLEntry.Amount;
                        end;

                    until GL.Next = 0;

                end;
                GL.Reset;
                GL.SetFilter(GL."Capital adequecy", '%1', GL."capital adequecy"::InvestmentsinSubsidiary);
                if GL.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GL."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', LastYearButOne);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LInvestmentsinSubsidiary += GLEntry.Amount;
                        end;

                    until GL.Next = 0;

                end;

                Corecapital := CoreCapitalOldLastyear + NetSurplusaftertax - InvestmentsinSubsidiary;
                LCorecapital := (CoreCapitalOldLastyearButone + LNetSurplusaftertax) - LInvestmentsinSubsidiary;
                if TotalAssets > 0 then
                    CorecapitaltoAssetsRatio := Corecapital / TotalAssets;
                if LTotalAssets > 0 then
                    LCorecapitaltoAssetsRatio := LCorecapital / LTotalAssets;
                if DepositAmount > 0 then
                    CorecapitaltoDepositsRatio := Corecapital / DepositAmount;
                if LDepositAmount > 0 then
                    CorecapitaltoDepositsRatio := LCorecapital / LDepositAmount;
                if DepositAmount > 0 then
                    LiquidAssetstoTotalassetslongtermliabilities := LiquidAssets / (LongtermLiablities + DepositAmount);
                if LDepositAmount > 0 then
                    LLiquidAssetstoTotalassetslongtermliabilities := LLiquidAssets / (LLongtermliabilities + LDepositAmount);


            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Asat; Asat)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }
    }

    var
        Cust: Record Customer;
        Active: Integer;
        Dormant: Integer;
        LActive: Integer;
        LDormant: Integer;
        LongtermLiablities: Decimal;
        LLongtermliabilities: Decimal;
        CorecapitaltoAssetsRatio: Decimal;
        CorecapitaltoDepositsRatio: Decimal;
        ExternalBorrowingtoAssetsRatio: Decimal;
        LExternalBorrowingtoAssetsRatio: Decimal;
        LCorecapitaltoDepositsRatio: Decimal;
        LCorecapitaltoAssetsRatio: Decimal;
        LiquidAssetstoTotalassetslongtermliabilities: Decimal;
        LLiquidAssetstoTotalassetslongtermliabilities: Decimal;
        LiquidAssets: Decimal;
        LLiquidAssets: Decimal;
        GLEntry: Record "G/L Entry";
        Asat: Date;
        CoreCapitalOldLastyear: Decimal;
        CoreCapitalOldLastyearButone: Decimal;
        Corecapital: Decimal;
        LCorecapital: Decimal;
        NetSurplusaftertax: Decimal;
        LNetSurplusaftertax: Decimal;
        InvestmentsinSubsidiary: Decimal;
        LInvestmentsinSubsidiary: Decimal;
        FinancialAssets: Decimal;
        LFinancialAssets: Decimal;
        Otherinvestments: Decimal;
        StartDate: Date;
        CurrentYear: Integer;
        PreviousYear: Integer;
        EndofLastyear: date;
        LastYearButOne: Date;
        NumberofEmployees: Integer;
        LNumberofEmployees: Integer;
        Emp: Record "Payroll Employee.";
        TotalAssets: Decimal;
        LTotalAssets: Decimal;
        SubsidiaryandRelated: Decimal;
        GL: Record "G/L Account";
        DepositAmount: Decimal;
        LDepositAmount: Decimal;
        LoanBalance: Decimal;
        LLoanBalance: Decimal;
        Equityinvestment: Decimal;



}