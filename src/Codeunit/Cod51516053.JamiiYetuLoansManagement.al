codeunit 51516053 "Jamii Yetu Loans Management"
{
    trigger OnRun()
    begin
        FnRecoverLoanArrears();
    end;

    procedure FnRecoverLoanArrears()
    var
        LoansRegister: Record "Loans Register";
        InterestArrears: Decimal;
        FosaBalance: Decimal;
        SurestepFactory: Codeunit "SURESTEP Factory";
        AmountToDeduct: Decimal;
        TransactionTypes: enum TransactionTypesEnum;
        AccountType: Enum "Gen. Journal Account Type";
        LoanDimension: Code[20];
        PrincipalArrears: Decimal;
    begin
        LoansRegister.Reset();
        LoansRegister.SetFilter(LoansRegister."Date filter", '..' + Format(Today));
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest", LoansRegister."Scheduled Interest Payments", LoansRegister."Interest Paid", LoansRegister."Scheduled Principle Payments", LoansRegister."Principal Paid", LoansRegister."Principal In Arrears", LoansRegister."Interest In Arrears");
        if LoansRegister.Find('-') then begin
            repeat
                InterestArrears := 0;
                FosaBalance := 0;
                AmountToDeduct := 0;
                LoanDimension := '';
                //Direct Debits
                if LoansRegister."Recovery Mode" = LoansRegister."Recovery Mode"::"Direct Debits" then begin
                    //********************************************Recover Interest
                    InterestArrears := LoansRegister."Interest In Arrears";
                    //...........Make sure Int Arrears is greater than zero
                    if InterestArrears < 0 then begin
                        InterestArrears := 0;
                    end;
                    //FnGetMember Account Balance
                    FosaBalance := SurestepFactory.FnGetFosaAccountBalanceUsingBOSA(LoansRegister."Client Code");
                    //Get Amount To Deduct
                    if FosaBalance > InterestArrears then begin
                        AmountToDeduct := InterestArrears;
                    end else
                        if FosaBalance <= InterestArrears then begin
                            AmountToDeduct := FosaBalance;
                        end;
                    if LoansRegister.Source = LoansRegister.Source::MICRO THEN begin
                        LoanDimension := 'MICRO';
                    end ELSE
                        if LoansRegister.Source = LoansRegister.Source::BOSA THEN begin
                            LoanDimension := 'BOSA';
                        end ELSE
                            if LoansRegister.Source = LoansRegister.Source::FOSA THEN begin
                                LoanDimension := 'FOSA';
                            end;
                    //Insert Interest Arrears To Gl & Post
                    //...........Debit Vendor A/c
                    SurestepFactory.FnCreateGnlJournalLine('GENERAL', 'SYSRECOVER', 'RECOVERY', 1000, TransactionTypes::"0", AccountType::Vendor, SurestepFactory.FnGetFosaAccount(LoansRegister."Client Code"), Today, AmountToDeduct, LoanDimension, LoansRegister."Loan  No.", 'Loan Interest Recovered to-' + Format(LoansRegister."Loan  No."), LoansRegister."Loan  No.");
                    //...........Credit Loan Account
                    SurestepFactory.FnCreateGnlJournalLine('GENERAL', 'SYSRECOVER', 'RECOVERY', 1001, TransactionTypes::"Insurance Paid", AccountType::Customer, (LoansRegister."Client Code"), Today, -AmountToDeduct, LoanDimension, LoansRegister."Loan  No.", 'Loan Interest Recovered from-' + Format(SurestepFactory.FnGetFosaAccount(LoansRegister."Client Code")), LoansRegister."Loan  No.");
                    //...........Post Loan
                    SurestepFactory.FnPostGnlJournalLine('GENERAL', 'SYSRECOVER');
                    //********************************************Recover Principal
                    PrincipalArrears := 0;
                    FosaBalance := 0;
                    AmountToDeduct := 0;
                    LoanDimension := '';
                    PrincipalArrears := LoansRegister."Principal In Arrears";
                    if PrincipalArrears < 0 then begin
                        PrincipalArrears := 0;
                    end;
                    //FnGetMember Account Balance
                    FosaBalance := 0;
                    FosaBalance := SurestepFactory.FnGetFosaAccountBalanceUsingBOSA(LoansRegister."Client Code");
                    //Get Amount To Deduct
                    if FosaBalance > PrincipalArrears then begin
                        AmountToDeduct := 0;
                        AmountToDeduct := PrincipalArrears;
                    end else
                        if FosaBalance <= PrincipalArrears then begin
                            AmountToDeduct := 0;
                            AmountToDeduct := FosaBalance;
                        end;
                    LoanDimension := '';
                    if LoansRegister.Source = LoansRegister.Source::MICRO THEN begin
                        LoanDimension := 'MICRO';
                    end ELSE
                        if LoansRegister.Source = LoansRegister.Source::BOSA THEN begin
                            LoanDimension := 'BOSA';
                        end ELSE
                            if LoansRegister.Source = LoansRegister.Source::FOSA THEN begin
                                LoanDimension := 'FOSA';
                            end;
                    //Insert Interest Arrears To Gl & Post
                    //...........Debit Vendor A/c
                    SurestepFactory.FnCreateGnlJournalLine('GENERAL', 'SYSRECOVER', 'RECOVERY', 1000, TransactionTypes::"0", AccountType::Vendor, SurestepFactory.FnGetFosaAccount(LoansRegister."Client Code"), Today, AmountToDeduct, LoanDimension, LoansRegister."Loan  No.", 'Loan Principle Recovered to-' + Format(LoansRegister."Loan  No."), LoansRegister."Loan  No.");
                    //...........Credit Loan Account
                    SurestepFactory.FnCreateGnlJournalLine('GENERAL', 'SYSRECOVER', 'RECOVERY', 1001, TransactionTypes::Repayment, AccountType::Customer, (LoansRegister."Client Code"), Today, -AmountToDeduct, LoanDimension, LoansRegister."Loan  No.", 'Loan Principle Recovered from-' + Format(SurestepFactory.FnGetFosaAccount(LoansRegister."Client Code")), LoansRegister."Loan  No.");
                    //...........Post Loan
                    SurestepFactory.FnPostGnlJournalLine('GENERAL', 'SYSRECOVER');
                end;
            until LoansRegister.Next = 0;
        end;
    end;

}