#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516896 "Micro_Fin_Schedule"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Transction Type"; Option)
        {
            Enabled = false;
            OptionCaption = 'Savings,Repayment,Interest Paid,Registration Paid,Insurance ,Penalty';
            OptionMembers = Savings,Repayment,"Interest Paid","Registration Paid","Insurance ",Penalty;

            trigger OnValidate()
            begin

            end;
        }
        field(3; "Account Type"; Option)
        {
            Enabled = false;
            OptionCaption = 'Customer,Vendor,G/L Account';
            OptionMembers = Customer,Vendor,"G/L Account";
        }
        field(4; "Account Number"; Code[20])
        {
            TableRelation = Customer where("Customer Posting Group" = filter('MICRO'),
                                                      "Group Account" = filter(false));

            trigger OnValidate()
            begin


                Member.Reset;
                Member.SetRange(Member."No.", "Account Number");
                if Member.Find('-') then
                    "Account Name" := Member.Name;
                // "Group Code" := Member."Group Account No";

            end;
        }
        field(5; "Account Name"; Text[150])
        {
        }
        field(6; Amount; Decimal)
        {

            trigger OnValidate()
            var
                LoansReg: Record "Loans Register";
                ScheduleExpectedIntPay: Decimal;
                ScheduleExpectedPrincPay: Decimal;
            begin
                "Interest Amount" := 0;
                "Principle Amount" := 0;
                "Excess Amount" := 0;
                RunningBAL := 0;
                RunningBAL := Amount - Savings;
                if RunningBAL < 0 then begin
                    Savings := Amount;
                end;
                LoansReg.reset;
                LoansReg.SetRange(LoansReg."Client Code", "Account Number");
                LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
                LoansReg.SetFilter(LoansReg."Outstanding Balance", '>%1', 0);
                if LoansReg.Find('-') then begin
                    "Loans No." := LoansReg."Loan  No.";
                    "Outstanding Balance" := LoansReg."Outstanding Balance";
                    "Interest Amount" := LoansReg."Oustanding Interest";
                    "Expected Principle Amount" := LoansReg."Outstanding Balance";
                    "Expected Interest" := LoansReg."Oustanding Interest";
                    //...................Update Amount to be paid
                    ScheduleExpectedIntPay := 0;
                    if "Expected Interest" > 0 then begin
                        //Check Expected Pay As Per Schedule
                        ScheduleExpectedIntPay := 0;
                        ScheduleExpectedIntPay := FnGetScheduleIntPay("Loan No.");
                        if RunningBAL > 0 then begin
                            if RunningBAL > ScheduleExpectedIntPay then begin
                                "Interest Amount" := ScheduleExpectedIntPay;
                            end
                            else
                                if RunningBAL <= ScheduleExpectedIntPay then begin
                                    "Interest Amount" := RunningBAL;
                                end;
                        end else
                            if RunningBAL <= 0 then begin
                                "Interest Amount" := 0;
                            end;
                    end;
                    RunningBAL := RunningBAL - "Interest Amount";
                    ScheduleExpectedPrincPay := 0;
                    ScheduleExpectedPrincPay := FnGetSchedulePrincPay("Loan No.");
                    if ScheduleExpectedPrincPay > 0 then begin
                        if RunningBAL > 0 then begin
                            if RunningBAL > ScheduleExpectedPrincPay then
                                "Principle Amount" := ScheduleExpectedPrincPay
                            else
                                "Principle Amount" := RunningBAL;
                        end else
                            if RunningBAL <= 0 then begin
                                "Principle Amount" := 0;
                            end;
                    end;
                    RunningBAL := RunningBAL - "Principle Amount";
                    if RunningBAL > 0 then begin
                        "Excess Amount" := RunningBAL;
                    end else
                        if RunningBAL <= 0 then begin
                            "Excess Amount" := 0;
                        end;
                end;
            end;

        }
        field(7; "Loan No."; Code[20])
        {

            trigger OnValidate()
            var
                LoansReg: Record "Loans Register";
                ScheduleExpectedIntPay: Decimal;
                ScheduleExpectedPrincPay: Decimal;
            begin

                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Loan  No.", "Loan No.");
                LoanApp.SetAutoCalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                if LoanApp.Find('-') then begin
                    if LoanApp.Posted = false then begin
                        Error('Loan Must be posted');
                    end;
                    if (LoanApp."Outstanding Balance" <= 0) and (LoanApp."Oustanding Interest" <= 0) then begin
                        Error('Loan Balance and interest are already  paid fully');
                    end;
                    "Interest Amount" := 0;
                    "Principle Amount" := 0;
                    "Excess Amount" := 0;
                    RunningBAL := 0;
                    RunningBAL := Amount - Savings;
                    if RunningBAL < 0 then begin
                        Savings := Amount;
                    end;
                    LoansReg.reset;
                    LoansReg.SetRange(LoansReg."Loan  No.", "Loan No.");
                    LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
                    LoansReg.SetFilter(LoansReg."Outstanding Balance", '>%1', 0);
                    if LoansReg.Find('-') then begin
                        "Loans No." := LoansReg."Loan  No.";
                        "Outstanding Balance" := LoansReg."Outstanding Balance";
                        "Interest Amount" := LoansReg."Oustanding Interest";
                        "Expected Principle Amount" := LoansReg."Outstanding Balance";
                        "Expected Interest" := LoansReg."Oustanding Interest";
                        //...................Update Amount to be paid
                        ScheduleExpectedIntPay := 0;
                        if "Expected Interest" > 0 then begin
                            //Check Expected Pay As Per Schedule
                            ScheduleExpectedIntPay := 0;
                            ScheduleExpectedIntPay := FnGetScheduleIntPay("Loan No.");
                            if RunningBAL > 0 then begin
                                if RunningBAL > ScheduleExpectedIntPay then begin
                                    "Interest Amount" := ScheduleExpectedIntPay
                                end
                                else
                                    if RunningBAL <= ScheduleExpectedIntPay then begin
                                        "Interest Amount" := RunningBAL;
                                    end;
                            end else
                                if RunningBAL <= 0 then begin
                                    "Interest Amount" := 0;
                                end;
                        end;
                        RunningBAL := RunningBAL - "Interest Amount";
                        ScheduleExpectedPrincPay := 0;
                        ScheduleExpectedPrincPay := FnGetSchedulePrincPay("Loan No.");
                        if ScheduleExpectedPrincPay > 0 then begin
                            if RunningBAL > 0 then begin
                                if RunningBAL > ScheduleExpectedPrincPay then
                                    "Principle Amount" := ScheduleExpectedPrincPay
                                else
                                    "Principle Amount" := RunningBAL;
                            end else
                                if RunningBAL <= 0 then begin
                                    "Principle Amount" := 0;
                                end;
                        end;
                        RunningBAL := RunningBAL - "Principle Amount";
                        if RunningBAL > 0 then begin
                            "Excess Amount" := RunningBAL;
                        end else
                            if RunningBAL <= 0 then begin
                                "Excess Amount" := 0;
                            end;
                    end;
                end;
            end;
        }
        field(8; "G/L Account"; Code[20])
        {
            Enabled = false;
            TableRelation = "G/L Account"."No.";
        }
        field(9; "Group Code"; Code[20])
        {
        }
        field(90000; "Expected Principle Amount"; Decimal)
        {
            Editable = false;
        }
        field(51516001; "Expected Interest"; Decimal)
        {
            Editable = false;
        }
        field(51516002; Savings; Decimal)
        {

            trigger OnValidate()
            var
                LoansReg: Record "Loans Register";
                ScheduleExpectedIntPay: Decimal;
                ScheduleExpectedPrincPay: Decimal;
            begin
                "Interest Amount" := 0;
                "Principle Amount" := 0;
                "Excess Amount" := 0;
                RunningBAL := 0;
                RunningBAL := Amount - Savings;
                if RunningBAL < 0 then begin
                    Savings := Amount;
                end;
                LoansReg.reset;
                LoansReg.SetRange(LoansReg."Client Code", "Account Number");
                LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
                LoansReg.SetFilter(LoansReg."Outstanding Balance", '>%1', 0);
                if LoansReg.Find('-') then begin
                    "Loans No." := LoansReg."Loan  No.";
                    "Outstanding Balance" := LoansReg."Outstanding Balance";
                    "Interest Amount" := LoansReg."Oustanding Interest";
                    "Expected Principle Amount" := LoansReg."Outstanding Balance";
                    "Expected Interest" := LoansReg."Oustanding Interest";
                    //...................Update Amount to be paid
                    ScheduleExpectedIntPay := 0;
                    if "Expected Interest" > 0 then begin
                        //Check Expected Pay As Per Schedule
                        ScheduleExpectedIntPay := 0;
                        ScheduleExpectedIntPay := FnGetScheduleIntPay("Loan No.");
                        if RunningBAL > 0 then begin
                            if RunningBAL > ScheduleExpectedIntPay then begin
                                "Interest Amount" := ScheduleExpectedIntPay;
                            end
                            else
                                if RunningBAL <= ScheduleExpectedIntPay then begin
                                    "Interest Amount" := RunningBAL;
                                end;
                        end else
                            if RunningBAL <= 0 then begin
                                "Interest Amount" := 0;
                            end;
                    end;
                    RunningBAL := RunningBAL - "Interest Amount";
                    ScheduleExpectedPrincPay := 0;
                    ScheduleExpectedPrincPay := FnGetSchedulePrincPay("Loan No.");
                    if ScheduleExpectedPrincPay > 0 then begin
                        if RunningBAL > 0 then begin
                            if RunningBAL > ScheduleExpectedPrincPay then
                                "Principle Amount" := ScheduleExpectedPrincPay
                            else
                                "Principle Amount" := RunningBAL;
                        end else
                            if RunningBAL <= 0 then begin
                                "Principle Amount" := 0;
                            end;
                    end;
                    RunningBAL := RunningBAL - "Principle Amount";
                    if RunningBAL > 0 then begin
                        "Excess Amount" := RunningBAL;
                    end else
                        if RunningBAL <= 0 then begin
                            "Excess Amount" := 0;
                        end;
                end;
            end;

        }
        field(51516003; "Interest Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                //if "Interest Amount" > "Expected Interest" then
                //Error('Amount cannot be more than the interest amount');
            end;
        }
        field(51516004; "Principle Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                //if "Principle Amount" > OutBal then
                //Error('Amount cannot be more than the oustanding balance');
            end;
        }
        field(51516005; "Expected Penalty Charge"; Decimal)
        {
        }
        field(51516006; "Penalty Amount"; Decimal)
        {
        }
        field(51516007; "Expected MF Insurance"; Decimal)
        {
        }
        field(51516008; "MF Insurance Amount"; Decimal)
        {
        }
        field(51516009; "Expected Appraisal"; Decimal)
        {
        }
        field(51516010; "Appraisal Amount"; Decimal)
        {
        }
        field(51516011; "Branch Code"; Code[20])
        {
        }
        field(51516012; "Loan Application Fee"; Decimal)
        {
        }
        field(51516013; "Registration Fee"; Decimal)
        {
        }
        field(51516014; "Loan Insurance Fee"; Decimal)
        {
        }
        field(51516015; "Printing_Stationary Fee"; Decimal)
        {
        }
        field(51516016; "Outstanding Balance"; Decimal)
        {
            Editable = false;
        }
        field(51516017; "Loans No."; Code[50])
        {
            TableRelation = "Loans Register"."Loan  No." where(Posted = const(true),
                                                                Source = const(MICRO),
                                                                "Client Code" = field("Account Number"));

            trigger OnValidate()
            var
                LoansReg: Record "Loans Register";
            begin
                "Interest Amount" := 0;
                "Principle Amount" := 0;
                "Excess Amount" := 0;
                RunningBAL := 0;
                RunningBAL := Amount - Savings;
                LoansReg.reset;
                LoansReg.SetRange(LoansReg."Loan  No.", "Loans No.");
                LoansReg.SetRange(LoansReg.Posted, false);
                LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
                if LoansReg.Find('-') then begin
                    "Loans No." := LoansReg."Loan  No.";
                    "Outstanding Balance" := LoansReg."Outstanding Balance";
                    "Interest Amount" := LoansReg."Oustanding Interest";
                    "Expected Principle Amount" := LoansReg."Outstanding Balance";
                    "Expected Interest" := LoansReg."Oustanding Interest";
                    //...................Update Amount to be paid
                    if "Expected Interest" > 0 then begin
                        if RunningBAL > 0 then begin
                            if RunningBAL > "Expected Interest" then begin
                                "Interest Amount" := "Expected Interest"
                            end
                            else
                                if RunningBAL <= "Expected Interest" then begin
                                    "Interest Amount" := RunningBAL;
                                end;
                        end;
                    end;
                    RunningBAL := RunningBAL - "Interest Amount";
                    if "Expected Principle Amount" > 0 then begin
                        if RunningBAL > 0 then begin
                            if RunningBAL > "Expected Principle Amount" then
                                "Principle Amount" := "Expected Principle Amount"
                            else
                                "Principle Amount" := RunningBAL;
                        end;
                    end;
                    RunningBAL := RunningBAL - "Principle Amount";
                    if RunningBAL > 0 then
                        "Excess Amount" := RunningBAL;
                end;
            end;
        }
        field(51516018; OutBal; Decimal)
        {
            Editable = false;
        }
        field(51516019; "Total Savings"; Decimal)
        {
        }
        field(51516020; "Excess Amount"; Decimal)
        {
        }
        field(51516021; "Loan Payment Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Loan Payment Amount" > 0 then begin
                    if "Expected Interest" > 0 then begin
                        if "Loan Payment Amount" <= "Expected Interest" then begin
                            "Interest Amount" := "Loan Payment Amount";
                            "Principle Amount" := 0;
                        end else
                            if "Loan Payment Amount" > "Expected Interest" then begin
                                "Interest Amount" := "Expected Interest";
                                "Principle Amount" := "Loan Payment Amount" - "Expected Interest";
                            end;
                    end else
                        if "Expected Interest" <= 0 then begin
                            "Interest Amount" := 0;
                            "Principle Amount" := "Loan Payment Amount";
                        end;

                end else
                    if "Loan Payment Amount" < 0 then begin
                        Error('Cannot be less than zero');
                    end

            end;
        }
    }

    keys
    {
        key(Key1; "No.", "Account Number")
        {
            Clustered = true;
            SumIndexFields = Amount, Savings;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Trans.Reset;
        if Trans.Get("No.") then
            if Trans.Posted = true then
                Error('Cannot delete a posted transaction');
    end;

    trigger OnInsert()
    begin
        Trans.Reset;
        if Trans.Get("No.") then
            if Trans.Posted = true then
                Error('Cannot modify a posted transaction');
    end;

    trigger OnModify()
    begin
        Trans.Reset;
        if Trans.Get("No.") then
            if Trans.Posted = true then
                Error('Cannot modify a posted transaction');
    end;

    trigger OnRename()
    begin
        Trans.Reset;
        if Trans.Get("No.") then
            if Trans.Posted = true then
                Error('Cannot modify a posted transaction');
    end;

    local procedure FnGetScheduleIntPay(LoanNo: Code[20]): Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedIntPayment: Decimal;
        InterestArrears: Decimal;
        InterestPaid: Decimal;
    begin
        ExpectedIntPayment := 0;
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange(LoanRepaymentSchedule."Loan No.", LoanNo);
        LoanRepaymentSchedule.SetFilter(LoanRepaymentSchedule."Repayment Date", '..' + Format(Today));
        if LoanRepaymentSchedule.Find('-') = true then begin
            repeat
                ExpectedIntPayment += LoanRepaymentSchedule."Monthly Interest";
            until LoanRepaymentSchedule.Next = 0;
            InterestArrears := 0;
            InterestPaid := 0;
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetRange(CustLedgerEntry."Loan No", LoanNo);
            CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Interest Paid");
            if CustLedgerEntry.Find('-') then begin
                repeat
                    InterestPaid += CustLedgerEntry."Amount Posted";
                until CustLedgerEntry.Next = 0;
            end;
            InterestArrears := ExpectedIntPayment - InterestPaid;
            if InterestArrears > 0 then begin
                exit(InterestArrears);
            end else
                if InterestArrears <= 0 then begin
                    exit(0);
                end;
        end else
            if LoanRepaymentSchedule.Find('-') = false then begin
                LoanRepaymentSchedule.Reset();
                LoanRepaymentSchedule.SetRange(LoanRepaymentSchedule."Loan No.", LoanNo);
                LoanRepaymentSchedule.SetFilter(LoanRepaymentSchedule."Repayment Date", '..' + Format(CalcDate('1M', Today)));
                if LoanRepaymentSchedule.Find('-') = true then begin
                    repeat
                        ExpectedIntPayment += LoanRepaymentSchedule."Monthly Interest";
                    until LoanRepaymentSchedule.Next = 0;
                    InterestArrears := 0;
                    InterestPaid := 0;
                    CustLedgerEntry.Reset();
                    CustLedgerEntry.SetRange(CustLedgerEntry."Loan No", LoanNo);
                    CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Interest Paid");
                    if CustLedgerEntry.Find('-') then begin
                        repeat
                            InterestPaid += CustLedgerEntry."Amount Posted";
                        until CustLedgerEntry.Next = 0;
                    end;
                    InterestArrears := ExpectedIntPayment - InterestPaid;
                    if InterestArrears > 0 then begin
                        exit(InterestArrears);
                    end else
                        if InterestArrears <= 0 then begin
                            exit(0);
                        end;
                end;
            end;

    end;

    local procedure FnGetSchedulePrincPay(LoanNo: Code[20]): Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedPrincPayment: Decimal;
        PrincArrears: Decimal;
        PrincPaid: Decimal;
    begin
        ExpectedPrincPayment := 0;
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange(LoanRepaymentSchedule."Loan No.", LoanNo);
        LoanRepaymentSchedule.SetFilter(LoanRepaymentSchedule."Repayment Date", '..' + Format(Today));
        if LoanRepaymentSchedule.Find('-') = true then begin
            repeat
                ExpectedPrincPayment += LoanRepaymentSchedule."Principal Repayment";
            until LoanRepaymentSchedule.Next = 0;
            PrincArrears := 0;
            PrincPaid := 0;
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetRange(CustLedgerEntry."Loan No", LoanNo);
            CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::Repayment);
            if CustLedgerEntry.Find('-') then begin
                repeat
                    PrincPaid += CustLedgerEntry."Amount Posted";
                until CustLedgerEntry.Next = 0;
            end;
            PrincArrears := ExpectedPrincPayment - PrincPaid;
            if PrincArrears > 0 then begin
                exit(PrincArrears);
            end else
                if PrincArrears <= 0 then begin
                    exit(0);
                end;
        end else
            if LoanRepaymentSchedule.Find('-') = false then begin
                LoanRepaymentSchedule.Reset();
                LoanRepaymentSchedule.SetRange(LoanRepaymentSchedule."Loan No.", LoanNo);
                LoanRepaymentSchedule.SetFilter(LoanRepaymentSchedule."Repayment Date", '..' + Format(CalcDate('1M', Today)));
                if LoanRepaymentSchedule.Find('-') = true then begin
                    repeat
                        ExpectedPrincPayment += LoanRepaymentSchedule."Principal Repayment";
                    until LoanRepaymentSchedule.Next = 0;
                    PrincArrears := 0;
                    PrincPaid := 0;
                    CustLedgerEntry.Reset();
                    CustLedgerEntry.SetRange(CustLedgerEntry."Loan No", LoanNo);
                    CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::Repayment);
                    if CustLedgerEntry.Find('-') then begin
                        repeat
                            PrincPaid += CustLedgerEntry."Amount Posted";
                        until CustLedgerEntry.Next = 0;
                    end;
                    PrincArrears := ExpectedPrincPayment - PrincPaid;
                    if PrincArrears > 0 then begin
                        exit(PrincArrears);
                    end else
                        if PrincArrears <= 0 then begin
                            exit(0);
                        end;
                end;
            end;

    end;

    var
        Vend: Record Vendor;
        GL: Record "G/L Account";
        RunningBAL: Decimal;
        LoanApp: Record "Loans Register";
        Trans: Record Micro_Fin_Transactions;
        Member: Record Customer;
        GetLoans: Record "Loans Register";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GenlSetUp: Record "Sacco General Set-Up";
        Text001: label 'Monthly contribution cannot be less than minimum contributions of  Kshs%1';
}

