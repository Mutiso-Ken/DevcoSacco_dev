#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516017 "UpdateLoanClassification"
{

    trigger OnRun()
    begin
        //FnUpdateLoanStatus('LN001618');
    end;

    var
        LoansReg: Record "Loans Register";
        PrPaid: Decimal;
        PrExp: Decimal;
        outInt: Decimal;
        Variance: Decimal;
        LoansSchedule: Record "Loan Repayment Schedule";
        ExpectedPaymentsToDate: Decimal;
        AmountInArrears: Decimal;
        NoOfMonthsInArrears: Decimal;


    procedure FnUpdateLoanStatus(LoanNo: Code[50])//As at today
    begin
        LoansReg.Reset;
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        if LoansReg.Find('-') then begin
            if LoansReg.Repayment < 0 then begin
                LoansReg.Validate("Approved Amount");
            end;
            LoansReg.CalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest", LoansReg."Schedule Repayments");
            if LoansReg."Outstanding Balance" + LoansReg."Oustanding Interest" > 0 then begin
                ExpectedPaymentsToDate := 0;
                PrPaid := 0;
                PrExp := 0;
                outInt := 0;
                LoansSchedule.Reset;
                LoansSchedule.SetRange(LoansSchedule."Loan No.", LoanNo);
                LoansSchedule.SetFilter(LoansSchedule."Repayment Date", '%1..%2', 0D, Today);
                if LoansSchedule.Find('-') then begin
                    repeat
                        ExpectedPaymentsToDate += LoansSchedule."Monthly Repayment";
                    until LoansSchedule.Next = 0;
                end;
                Variance := (LoansReg."Outstanding Balance" + LoansReg."Oustanding Interest") - (LoansReg."Approved Amount" - ExpectedPaymentsToDate);

            end;
            //--------------------------------------------------------------------Variance=No of Months In Arrears
            if Variance < 0 then begin
                Variance := 0;
            end;
            if LoansReg.Repayment > 0 then begin
                NoOfMonthsInArrears := 0;
                NoOfMonthsInArrears := ROUND(Variance / LoansReg.Repayment, 1, '<');
            end else
                if LoansReg.Repayment <= 0 then begin
                    NoOfMonthsInArrears := 0;
                    NoOfMonthsInArrears := ROUND(Variance / 12, 1, '<');
                end;
            AmountInArrears := 0;

            AmountInArrears := Variance;
            //---------------------------------------------------------------------
            case NoOfMonthsInArrears of
                0:
                    begin
                        LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Perfoming;
                        LoansReg."No of Months in Arrears" := NoOfMonthsInArrears;
                        LoansReg."Amount in Arrears" := AmountInArrears;
                        LoansReg.Modify;
                    end;
                1:
                    begin
                        LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Watch;
                        LoansReg."No of Months in Arrears" := NoOfMonthsInArrears;
                        LoansReg."Amount in Arrears" := AmountInArrears;
                        LoansReg.Modify;
                    end;
                2, 3, 4, 5, 6:
                    begin
                        LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Substandard;
                        LoansReg."No of Months in Arrears" := NoOfMonthsInArrears;
                        LoansReg."Amount in Arrears" := AmountInArrears;
                        LoansReg.Modify;
                    end;
                7, 8, 9, 10, 11, 12:
                    begin
                        LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Doubtful;
                        LoansReg."No of Months in Arrears" := NoOfMonthsInArrears;
                        LoansReg."Amount in Arrears" := AmountInArrears;
                        LoansReg.Modify;
                    end
                else begin
                    LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Loss;
                    LoansReg."No of Months in Arrears" := NoOfMonthsInArrears;
                    LoansReg."Amount in Arrears" := AmountInArrears;
                    LoansReg.Modify;
                end;
            end;
        
        end;
        //--------------------------------------------------------------------
    end;


    procedure FnCheckPreviousLoanStatus(LoanNo: Code[50]; AsAt: text[100]): text[100]//without updating records
    begin
        LoansReg.Reset;
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        if LoansReg.Find('-') then begin
            if LoansReg.Repayment < 0 then begin
                LoansReg.Validate("Approved Amount");
            end;
            LoansReg.SetFilter(LoansReg."Date filter", AsAt);
            LoansReg.CalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest", LoansReg."Schedule Repayments");
            if LoansReg."Outstanding Balance" + LoansReg."Oustanding Interest" > 0 then begin
                ExpectedPaymentsToDate := 0;
                PrPaid := 0;
                PrExp := 0;
                outInt := 0;
                LoansSchedule.Reset;
                LoansSchedule.SetRange(LoansSchedule."Loan No.", LoanNo);
                LoansSchedule.SetFilter(LoansSchedule."Repayment Date", AsAt);
                if LoansSchedule.Find('-') then begin
                    repeat
                        ExpectedPaymentsToDate += LoansSchedule."Monthly Repayment";
                    until LoansSchedule.Next = 0;
                end;
                Variance := (LoansReg."Outstanding Balance" + LoansReg."Oustanding Interest") - (LoansReg."Approved Amount" - ExpectedPaymentsToDate);

            end;
            //--------------------------------------------------------------------Variance=No of Months In Arrears
            if Variance < 0 then begin
                Variance := 0;
            end;
            if LoansReg.Repayment > 0 then begin
                NoOfMonthsInArrears := 0;
                NoOfMonthsInArrears := ROUND(Variance / LoansReg.Repayment, 1, '<');
            end else
                if LoansReg.Repayment <= 0 then begin
                    NoOfMonthsInArrears := 0;
                    NoOfMonthsInArrears := ROUND(Variance / 12, 1, '<');
                end;
            AmountInArrears := 0;

            AmountInArrears := Variance;
            //---------------------------------------------------------------------
            case NoOfMonthsInArrears of
                0:
                    begin
                        Exit('Performing');
                    end;
                1:
                    begin
                        Exit('Watch');
                    end;
                2, 3, 4, 5, 6:
                    begin
                        Exit('Substandard');
                    end;
                7, 8, 9, 10, 11, 12:
                    begin
                        Exit('Doubtful');
                    end
                else begin
                    Exit('Loss');
                end;
            end;
        end;
        //--------------------------------------------------------------------
    end;

}

