#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516495 "Recovery From Salaries"
{
    DefaultLayout = RDLC;
    Caption = 'General Loan Recoveries Report';
    RDLCLayout = './Layouts/Recovery From Salaries.rdlc';


    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            DataItemTableView = sorting("Client Code") order(ascending) where(Posted = const(true));
            RequestFilterFields = Source, "Loan  No.", "Client Code", "Branch Code", "Loan Product Type", "Date filter";
            PrintOnlyIfDetail = false;
            column(ReportForNavId_1; 1)
            {
            }
            column(NextCount; NextCount)
            {

            }
            column(Issued_Date; "Issued Date")
            {
            }
            column(Expected_Date_of_Completion; "Expected Date of Completion")
            {
            }
            column(LoanProduct; "Loan Product Type")
            {
            }
            column(Entry; NextCount)
            {
            }
            column(PrinciplePaid; PrinciplePaid)
            {
            }
            column(InterestPaid; InterestPaid)
            {
            }
            column(LoanNo; "Loans Register"."Loan  No.")
            {
            }

            column(MemberNumber; "Loans Register"."Client Code")
            {
            }

            column(Name; "Loans Register"."Client Name")
            {
            }
            column(ApprovedAmount; "Loans Register"."Approved Amount")
            {
            }
            column(OutstandingBalance; CurrentLoanBalance)
            {
            }

            trigger OnAfterGetRecord()
            begin
                LoansReg.SetAutocalcFields(LoansReg."Interest Paid", LoansReg."Principal Paid", LoansReg."Loan Last Pay Date");
                LoansReg.SetFilter(LoansReg."Date filter", DateFilter);
                if LoansReg.Get("Loans Register"."Loan  No.") then begin
                    //...........Get Principle Paid
                    PrinciplePaid := 0;
                    PrinciplePaid := (LoansReg."Principal Paid") * -1;
                    //...........Get Interest Paid
                    InterestPaid := 0;
                    InterestPaid := (LoansReg."Interest Paid") * -1;
                    //..........Expected Loan Balance
                    ExpectedLoanBal := 0;
                    ExpectedLoanBal := LoansReg."Schedule Loan Amount Issued" - LoansReg."Scheduled Principle Payments";
                    //...........Current Loan Balance
                    CurrentLoanBalance := 0;
                    CurrentLoanBalance := FnGetFilterPeriodLoanBal(LoansReg."Loan  No.", AsAt);               //.........................Expected Pay
                    TotalExpectedRepayment := 0;
                    TotalExpectedRepayment := PrinciplePaid + InterestPaid;
                    //..........................................
                    if (TotalExpectedRepayment <= 0) then begin
                        CurrReport.Skip;
                    end;
                    NextCount := NextCount + 1;
                end;

            end;

            trigger OnPreDataItem()
            begin
                PrepaidAmounts := 0;
                PrinciplePaid := 0;
                InterestPaid := 0;
                ExpectedLoanBal := 0;
                NoOfMonthsInArrears := 0;
                LoanArrears := 0;
                CurrentLoanBalance := 0;
                DaysInArrears := 0;
                NextCount := 0;
                InterestArrears := 0;
                TotalExpectedRepayment := 0;
                //..................................................
                "Loans Register".SetFilter("Loans Register"."Loan Last Pay Date", DateFilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        DateFilter := "Loans Register".GetFilter("Loans Register"."Date filter");
        if DateFilter = '' then begin
            DateFilter := '..' + Format(Today);
        end;
        //.....................................Get the AsAt for data formating
        if CopyStr(DateFilter, 1, 2) = '..' then begin
            AsAt := 0D;
            Evaluate(AsAt, CopyStr(DateFilter, 3, 100));//Assign As At
        end else
            if STRLEN(DateFilter) = 18 then begin
                AsAt := 0D;
                Evaluate(AsAt, CopyStr(DateFilter, 11, 100));//Assign As At
            end
            else
                if CopyStr(DateFilter, 1, 8) = DateFilter then begin
                    AsAt := 0D;
                    Evaluate(AsAt, CopyStr(DateFilter, 1, 100));//Assign As At
                end;

    end;

    local procedure FnGetFilterPeriodLoanBal(LoanNo: Code[30]; AsAt: Date): Decimal
    var
        LoansRegister: Record "Loans Register";
    begin
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
        LoansRegister.SetFilter(LoansRegister."Date filter", '..' + Format(AsAt));
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance");
        if LoansRegister.Find('-') then begin
            exit(LoansRegister."Outstanding Balance");
        end;
    end;

    var
        LoansReg: Record "Loans Register";
        DateFilter: Text;
        ExpectedLoanBal: Decimal;
        CurrentLoanBalance: Decimal;
        LoanArrears: Decimal;
        NoOfMonthsInArrears: Decimal;
        DaysInArrears: Decimal;
        LoanBalanceDisplay: Decimal;
        InterestArrears: Decimal;
        DaysInArrearsDisplay: Integer;
        AmountInArrearsDisplay: Decimal;
        InterestPaid: Decimal;
        TotalExpectedRepayment: Decimal;
        InterestInArrearsDisplay: Decimal;
        LoanCategoryDisplay: Text;
        PerformingDisplay: Decimal;
        WatchDisplay: Decimal;
        StandardDisplay: Decimal;
        DoubtfulDisplay: Decimal;
        LossDisplay: Decimal;
        NextCount: Integer;
        PrepaidAmounts: Decimal;
        AsAt: Date;
        Day: Integer;
        Month: Integer;
        Year: Integer;
        PrinciplePaid: Decimal;
}

