Codeunit 51516030 "LoansClassificationCodeUnit"
{

    trigger OnRun()
    begin
    end;

    var
        LoansReg: Record "Loans Register";
        RepaymentSchedule: Record "Loan Repayment Schedule";
        MemberLedgerEntry: Record "Cust. Ledger Entry";
        LoanBalAsAtFilterDate: Decimal;
        ScheduleExpectedLoanBal: Decimal;
        ArreasPresent: Decimal;
        LoansRegTablw: Record "Loans Register";


    procedure FnClassifyLoan(LoanNo: Code[30]; AsAt: Date)
    begin
        //..................Check if Loan expected date of completion is attained,if yes loan is loss
        if IsLoanSupposedToBeCompleted(LoanNo, AsAt) = true then begin
            //Mark LoaN As A Loss
            LoansRegTablw.Reset;
            LoansRegTablw.SetAutocalcFields(LoansRegTablw."Outstanding Balance");
            LoansRegTablw.SetRange(LoansRegTablw."Loan  No.", LoanNo);
            if LoansRegTablw.Find('-') then begin
                if LoansRegTablw."Outstanding Balance" > 0 then begin
                    LoansRegTablw."Amount in Arrears" := LoansRegTablw."Outstanding Balance";
                    IF LoansRegTablw.Installments = 0 THEN begin
                        LoansRegTablw.Installments := 12;
                    end;
                    LoansRegTablw."No of Months in Arrears" := ROUND(LoansRegTablw."Amount in Arrears" / LoansRegTablw.Installments, 1, '=');
                    LoansRegTablw."Loans Category-SASRA" := LoansRegTablw."Loans Category-SASRA"::Loss;
                    LoansRegTablw."Loans Category-SASRA" := LoansRegTablw."loans category-sasra"::Loss;
                end else
                    if LoansRegTablw."Outstanding Balance" <= 0 then begin
                        LoansRegTablw."Amount in Arrears" := 0;
                        LoansRegTablw."No of Months in Arrears" := 0;
                        LoansRegTablw."Loans Category-SASRA" := LoansRegTablw."Loans Category-SASRA"::Perfoming;
                        LoansRegTablw."Loans Category-SASRA" := LoansRegTablw."loans category-sasra"::Perfoming;
                    end;
                LoansRegTablw.Modify(true);
            end;
        end
        else
            if IsLoanSupposedToBeCompleted(LoanNo, AsAt) = false then begin
                //Check member ledger entry to know loan balance as at that date was how much
                LoanBalAsAtFilterDate := 0;
                LoanBalAsAtFilterDate := GetLoanBalAsAtFilterDate(LoanNo, AsAt);
                //Check repayment schedule to know the expected balance
                ScheduleExpectedLoanBal := 0;
                ScheduleExpectedLoanBal := GetExpectedBalAsPerSchedule(LoanNo, AsAt);
                //Determine if any areas
                ArreasPresent := 0;
                if LoanBalAsAtFilterDate > ScheduleExpectedLoanBal then begin
                    ArreasPresent := LoanBalAsAtFilterDate - ScheduleExpectedLoanBal;
                end
                else
                    if LoanBalAsAtFilterDate <= ScheduleExpectedLoanBal then begin
                        ArreasPresent := 0;
                    end;
                //MESSAGE('The loan balance is '+FORMAT(LoanBalAsAtFilterDate)+' the expected balance is '+FORMAT(ScheduleExpectedLoanBal));
                //if there are areas then,,determine the days in areas
                if ArreasPresent > 0 then begin
                    //--Function to Get Days In Arrears and modify;
                    FnUpdateLoanStatusWithArrears(LoanNo, ArreasPresent);
                end
                else
                    if ArreasPresent <= 0 then begin
                        FnUpdateLoanStatusNonArrears(LoanNo);
                    end;
            end;
        //Classify
    end;

    local procedure GetLoanBalAsAtFilterDate(LoanNos: Code[30]; FilterDate: Date): Decimal
    var
        TotalPayments: Decimal;
    begin
        TotalPayments := 0;
        MemberLedgerEntry.Reset;
        MemberLedgerEntry.SetFilter(MemberLedgerEntry."Transaction Type", '%1|%2', MemberLedgerEntry."transaction type"::Loan, MemberLedgerEntry."transaction type"::Repayment);
        MemberLedgerEntry.SetRange(MemberLedgerEntry."Loan No", LoanNos);
        MemberLedgerEntry.SetFilter(MemberLedgerEntry."Posting Date", '%1..%2', 0D, FilterDate);
        MemberLedgerEntry.SetRange(MemberLedgerEntry.Reversed, false);
        if MemberLedgerEntry.Find('-') then begin
            repeat
                TotalPayments += MemberLedgerEntry."Amount Posted";
            until MemberLedgerEntry.Next = 0;
        end;
        exit(TotalPayments);
    end;

    local procedure GetExpectedBalAsPerSchedule(LoanNos: Code[20]; DateFiltering: Date): Decimal
    var
        ScheduleExpectedBal: Decimal;
    begin
        ScheduleExpectedBal := 0;
        RepaymentSchedule.Reset;
        RepaymentSchedule.SetRange(RepaymentSchedule."Loan No.", LoanNos);
        RepaymentSchedule.SetFilter(RepaymentSchedule."Repayment Date", '%1..%2', 0D, DateFiltering);
        if RepaymentSchedule.FindLast then begin
            repeat
                ScheduleExpectedBal := ROUND(RepaymentSchedule."Loan Balance");
            until RepaymentSchedule.Next = 0;
        end;
        exit(ScheduleExpectedBal);
    end;

    local procedure FnUpdateLoanStatusNonArrears(LoanNo: Code[30])
    begin
        LoansReg.Reset;
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        if LoansReg.Find('-') then begin
            LoansReg."Amount in Arrears" := 0;
            LoansReg."No of Months in Arrears" := 0;
            LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Perfoming;
            LoansReg."Loans Category-SASRA" := LoansReg."Loans Category-SASRA"::Perfoming;
            LoansReg.Modify(true);
        end;
    end;

    local procedure FnUpdateLoanStatusWithArrears(LoanNo: Code[30]; AmountInArearsPassed: Decimal)
    begin
        LoansReg.Reset;
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        if LoansReg.Find('-') then begin
            LoansReg."Amount in Arrears" := AmountInArearsPassed;
            //..................................................................................Repayment
            IF LoansRegTablw.Installments = 0 THEN begin
                LoansRegTablw.Installments := 12;
            end;
            LoansReg."No of Months in Arrears" := ROUND(AmountInArearsPassed / LoansReg.Repayment, 1, '=');
            if LoansReg."No of Months in Arrears" = 0 then begin
                LoansReg."Loans Category-SASRA" := LoansReg."Loans Category-SASRA"::Perfoming;
                LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Perfoming;
            end else
                if (LoansReg."No of Months in Arrears" = 1) then begin
                    LoansReg."Loans Category-SASRA" := LoansReg."Loans Category-SASRA"::Watch;
                    LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Watch;
                end
                else
                    if (LoansReg."No of Months in Arrears" > 1) and (LoansReg."No of Months in Arrears" <= 6) then begin
                        LoansReg."Loans Category-SASRA" := LoansReg."Loans Category-SASRA"::Substandard;
                        LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Substandard;
                    end else
                        if (LoansReg."No of Months in Arrears" > 6) and (LoansReg."No of Months in Arrears" <= 12) then begin
                            LoansReg."Loans Category-SASRA" := LoansReg."Loans Category-SASRA"::Doubtful;
                            LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Doubtful;
                        end else
                            if (LoansReg."No of Months in Arrears" > 12) then begin
                                LoansReg."Loans Category-SASRA" := LoansReg."Loans Category-SASRA"::Loss;
                                LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Loss;
                            end;
            LoansReg.Modify(true);
        end;
    end;

    local procedure IsLoanSupposedToBeCompleted(LoanNoss: Code[20]; datefilter: Date): Boolean
    begin
        LoansReg.Reset;
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNoss);
        if LoansReg.Find('-') then begin
            if LoansReg."Expected Date of Completion" <= datefilter then begin
                exit(true);
            end
            else
                if LoansReg."Expected Date of Completion" > datefilter then begin
                    exit(false);
                end;
        end;
    end;
}

