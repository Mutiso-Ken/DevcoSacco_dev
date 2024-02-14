codeunit 51516029 "Generate Loan Interest"
{
    trigger OnRun()
    begin

    end;

    procedure FnGenerateBOSATodayInterest()
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister.Source, LoansRegister.Source::BOSA);
        LoansRegister.SetRange(LoansRegister."Check Int", false);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
        LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
        IF LoansRegister.Find('-') THEN begin
            repeat
                //.................check the loan repayment type
                if LoansRegister."Recovery Mode" = LoansRegister."Recovery Mode"::Salary then begin
                    if Today = DMY2DATE(15, DATE2DMY(Today, 2), DATE2DMY(Today, 3)) then begin
                        if FnInterestIsAlreadyLoaded(LoansRegister."Loan  No.") = false then begin
                            FnInitiateGLs();
                            FnGenerateBOSALoansInterest();
                            FnAutoPostGls();
                        end;
                    end;
                end else
                    if LoansRegister."Recovery Mode" <> LoansRegister."Recovery Mode"::Salary then begin
                        //-------------Check if loanrepayment schedule says the loan payments ae due today
                        LoanRepaymentSchedule.Reset();
                        LoanRepaymentSchedule.SetRange(LoanRepaymentSchedule."Repayment Date", Today);
                        if LoanRepaymentSchedule.find('-') then begin
                            if FnInterestIsAlreadyLoaded(LoansRegister."Loan  No.") = false then begin
                                FnInitiateGLs();
                                FnGenerateBOSALoansInterest();
                                FnAutoPostGls();
                            end;
                        end;
                    end;
            until LoansRegister.Next = 0;
        end;

    end;

    local procedure FnGenerateFOSALoansInterest()
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister.Source, LoansRegister.Source::FOSA);
        LoansRegister.SetRange(LoansRegister."Check Int", false);
        LoansRegister.SetRange(LoansRegister."Loan Product Type", '<>%1', 'OVERDRAFT');
        LoansRegister.SetRange(LoansRegister."Loan Product Type", '<>%1', 'OKOA');
        LoansRegister.SetFilter(LoansRegister."Issued Date", '%1..%2', 0D, Today);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
        LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
        IF LoansRegister.Find('-') THEN begin
            repeat
                //----------------//Dont run interest for loans that members are marked as Deceased,loans that are expired and interest outstanding>=loan balance
                if (LoansRegister."Outstanding Balance" > LoansRegister."Oustanding Interest") and (FnMemberIsDeceased(LoansRegister."Client Code")) = false then begin
                    //Charge Interest
                    FnInsertGlEntries();
                end;
            until LoansRegister.Next = 0;
        end;
        //.....................................
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister.Source, LoansRegister.Source::FOSA);
        LoansRegister.SetRange(LoansRegister."Check Int", false);
        LoansRegister.SetRange(LoansRegister."Loan Product Type", '%1', 'INUA BIASHARA');
        LoansRegister.SetFilter(LoansRegister."Issued Date", '%1..%2', 0D, Today);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
        LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
        IF LoansRegister.Find('-') THEN begin
            repeat
                if (LoansRegister."Outstanding Balance" > LoansRegister."Oustanding Interest") and (FnMemberIsDeceased(LoansRegister."Client Code")) = false then begin
                    //.................check the loan repayment type
                    if LoansRegister."Recovery Mode" = LoansRegister."Recovery Mode"::Salary then begin
                        if Today = DMY2DATE(15, DATE2DMY(Today, 2), DATE2DMY(Today, 3)) then begin
                            if FnInterestIsAlreadyLoaded(LoansRegister."Loan  No.") = false then begin
                                FnInitiateGLs();
                                FnGenerateBOSALoansInterest();
                                FnAutoPostGls();
                            end;
                        end;
                    end else
                        if LoansRegister."Recovery Mode" <> LoansRegister."Recovery Mode"::Salary then begin
                            //-------------Check if loanrepayment schedule says the loan payments ae due today
                            LoanRepaymentSchedule.Reset();
                            LoanRepaymentSchedule.SetRange(LoanRepaymentSchedule."Repayment Date", Today);
                            if LoanRepaymentSchedule.find('-') then begin
                                if FnInterestIsAlreadyLoaded(LoansRegister."Loan  No.") = false then begin
                                    FnInitiateGLs();
                                    FnGenerateBOSALoansInterest();
                                    FnAutoPostGls();
                                end;
                            end;
                        end;

                end;
            until LoansRegister.Next = 0;
        end;
    end;

    local procedure FnGenerateBOSALoansInterest()
    var
    begin
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister.Source, LoansRegister.Source::BOSA);
        LoansRegister.SetRange(LoansRegister."Check Int", false);
        LoansRegister.SetFilter(LoansRegister."Issued Date", '%1..%2', 0D, Today);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
        LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
        IF LoansRegister.Find('-') THEN begin
            repeat
                //----------------//Dont run interest for loans that members are marked as Deceased,loans that are expired and interest outstanding>=loan balance
                if (LoansRegister."Outstanding Balance" > LoansRegister."Oustanding Interest") and (FnMemberIsDeceased(LoansRegister."Client Code")) = false then begin
                    //Charge Interest
                    FnInsertGlEntries();
                end;
            until LoansRegister.Next = 0;
        end;
    end;

    local procedure FnGenerateMICROLoansInterest()
    begin
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister.Source, LoansRegister.Source::MICRO);
        LoansRegister.SetRange(LoansRegister."Check Int", false);
        LoansRegister.SetFilter(LoansRegister."Issued Date", '%1..%2', 0D, Today);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
        LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
        IF LoansRegister.Find('-') THEN begin
            repeat
                //----------------//Dont run interest for loans that members are marked as Deceased,loans that are expired and interest outstanding>=loan balance
                if (LoansRegister."Outstanding Balance" > LoansRegister."Oustanding Interest") and (FnMemberIsDeceased(LoansRegister."Client Code")) = false then begin
                    //Charge Interest
                    FnInsertGlEntries();
                end;
            until LoansRegister.Next = 0;
        end;
    end;

    local procedure FnMemberIsDeceased(ClientCode: Code[50]): Boolean
    var
        Customer: record customer;
    begin
        Customer.Reset();
        Customer.SetRange(Customer."No.", ClientCode);
        if Customer.find('-') then begin
            if Customer.Status = Customer.status::Deceased then begin
                exit(true);
            end;
        end;
        exit(false);
    end;

    local procedure FnInitiateGLs()
    begin
        //delete journal line
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", 'General');
        GenJournalLine.SETRANGE("Journal Batch Name", 'INT DUE');
        GenJournalLine.DELETEALL;
        GenBatches.RESET;
        GenBatches.SETRANGE(GenBatches."Journal Template Name", 'General');
        GenBatches.SETRANGE(GenBatches.Name, 'INT DUE');
        IF GenBatches.FIND('-') = FALSE THEN BEGIN
            GenBatches.INIT;
            GenBatches."Journal Template Name" := 'General';
            GenBatches.Name := 'INT DUE';
            GenBatches.Description := 'Interest Due';
            GenBatches.INSERT;
        END;
    end;

    local procedure FnInsertGlEntries()
    begin
        LineNo := LineNo + 10000;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'General';
        GenJournalLine."Journal Batch Name" := 'INT DUE';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
        GenJournalLine."Account No." := LoansRegister."Client Code";
        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Due";
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Document No." := DocNo;
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := DocNo + ' ' + 'Interest charged';
        GenJournalLine.Amount := ROUND(LoansRegister."Outstanding Balance" * (LoansRegister.Interest / 1200), 0.05, '>');
        IF LoansRegister."Repayment Method" = LoansRegister."Repayment Method"::"Straight Line" THEN
            GenJournalLine.Amount := ROUND(LoansRegister."Approved Amount" * (LoansRegister.Interest / 1200), 0.05, '>');
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        IF LoanType.GET(LoansRegister."Loan Product Type") THEN BEGIN
            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
            GenJournalLine."Bal. Account No." := LoanType."Loan Interest Account";
            GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
        END;

        IF LoansRegister.Source = LoansRegister.Source::BOSA THEN BEGIN
            GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        END ELSE
            IF LoansRegister.Source = LoansRegister.Source::FOSA THEN BEGIN
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
            END ELSE
                IF LoansRegister.Source = LoansRegister.Source::MICRO THEN
                    GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranch(LoansRegister."Client Code");
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
        IF (GenJournalLine.Amount <> 0) THEN
            GenJournalLine.INSERT;
    end;

    local procedure FnGetMemberBranch(ClientCode: Code[50]): Code[20]
    var
        Cust: Record Customer;
    begin
        Cust.RESET;
        Cust.SETRANGE(Cust."No.", ClientCode);
        IF Cust.FIND('-') THEN BEGIN
            EXIT(Cust."Global Dimension 2 Code");
        END;
    end;

    local procedure FnGetDocNo(): Text
    begin
        case DATE2DMY(Today, 2) of
            1:
                begin
                    exit('Jan-' + Format(DATE2DMY(Today, 3)))
                end;
            2:
                begin
                    exit('Feb-' + Format(DATE2DMY(Today, 3)))
                end;
            3:
                begin
                    exit('March-' + Format(DATE2DMY(Today, 3)))
                end;
            4:
                begin
                    exit('April-' + Format(DATE2DMY(Today, 3)))
                end;
            5:
                begin
                    exit('May-' + Format(DATE2DMY(Today, 3)))
                end;
            6:
                begin
                    exit('June-' + Format(DATE2DMY(Today, 3)))
                end;
            7:
                begin
                    exit('July-' + Format(DATE2DMY(Today, 3)))
                end;
            8:
                begin
                    exit('Aug-' + Format(DATE2DMY(Today, 3)))
                end;
            9:
                begin
                    exit('Sep-' + Format(DATE2DMY(Today, 3)))
                end;
            10:
                begin
                    exit('Oct-' + Format(DATE2DMY(Today, 3)))
                end;
            11:
                begin
                    exit('Nov-' + Format(DATE2DMY(Today, 3)))
                end;
            12:
                begin
                    exit('Dec-' + Format(DATE2DMY(Today, 3)))
                end;
        end;
    end;

    local procedure FnAutoPostGls()
    var
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", 'General');
        GenJournalLine.SETRANGE("Journal Batch Name", 'INT DUE');
        IF GenJournalLine.FIND('-') THEN BEGIN
            REPEAT
                GLPosting.RUN(GenJournalLine);
            UNTIL GenJournalLine.NEXT = 0;
            //Send Email of posted Entries
            FnSendEmail();
            //...................................Delete Entries
            GenJournalLine.RESET;
            GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
            GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'INT DUE');
            IF GenJournalLine.Find('-') THEN begin
                GenJournalLine.DeleteAll();
            end;
        end;
    end;

    local procedure FnSendEmail()
    begin
        //Message('Email Part Not created');
    end;

    local procedure FnInterestIsAlreadyLoaded(LoanNo: Code[30]): Boolean
    var
        custledgerEntry: record "Cust. Ledger Entry";
    begin
        custledgerEntry.Reset();
        custledgerEntry.SetRange(custledgerEntry."Posting Date", Today);
        custledgerEntry.SetRange(custledgerEntry."Transaction Type", custledgerEntry."Transaction Type"::"Interest Due");
        if custledgerEntry.Find('-') = true then begin
            exit(true);
        end else
            if custledgerEntry.Find('-') = false then begin
                exit(false);
            end;
    end;
    ///--------------------------------------------------------------------------
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenBatches: Record "Gen. Journal Batch";
        LineNo: Integer;
        LoansRegister: Record "Loans Register";
        LoanType: Record "Loan Products Setup";
        DocNo: text;

}
