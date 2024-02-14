codeunit 51516058 "Loan AutoRecoveries"
{
    trigger OnRun()
    begin
        //FnRecoverMemberLoanArrears();
        FnRecoverArrearsUsingLoansTable();
    end;

    procedure FnRecoverMemberLoanArrears()
    var
        LoansRegister: record "Loans Register";
        MemberTable: record Customer;
        FOSABalance: Decimal;
        SurestepFactory: Codeunit "SURESTEP Factory";
        RunningBal: Decimal;
        GenJournalLine: record "Gen. Journal Line";
        LineNo: Integer;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        JobqeueTable: record "Job Queue Entry";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'RECOVERY');
        IF GenJournalLine.Find('-') THEN begin
            GenJournalLine.DeleteAll();
        end;
        FOSABalance := 0;
        MemberTable.reset;
        MemberTable.SetAutoCalcFields(MemberTable."Total Arrears", MemberTable."Principal Arrears", MemberTable."Interest Arrears");
        if MemberTable.find('-') then begin
            repeat
                //Member FOSA Account Bal
                FOSABalance := 0;
                FOSABalance := SurestepFactory.FnGetFosaAccountBalanceUsingBOSA(MemberTable."No.");
                RunningBal := 0;
                RunningBal := FOSABalance;
                if (MemberTable."Total Arrears" > 0) then begin
                    LoansRegister.Reset();
                    LoansRegister.SetRange(LoansRegister.Posted, true);
                    LoansRegister.SetRange(LoansRegister."Recovery Mode", LoansRegister."Recovery Mode"::"Direct Debits");
                    LoansRegister.SetRange(LoansRegister."Client Code", MemberTable."No.");
                    LoansRegister.SetAutoCalcFields(LoansRegister."Oustanding Interest", LoansRegister."Outstanding Balance", LoansRegister."Interest In Arrears", LoansRegister."Principal In Arrears");
                    if LoansRegister.Find('-') then begin
                        repeat
                            //Recover Loan Interest
                            if (RunningBal > 0) and (LoansRegister."Interest In Arrears" > 0) then begin
                                LineNo := LineNo + 10000;
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := 'General';
                                GenJournalLine."Journal Batch Name" := 'RECOVERY';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                GenJournalLine."Account No." := LoansRegister."Client Code";
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                GenJournalLine."Document No." := LoansRegister."Loan  No.";
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := Format(LoansRegister."Recovery Mode") + '-Interest Paid';
                                if RunningBal < LoansRegister."Interest In Arrears" then begin
                                    GenJournalLine.Amount := -RunningBal;
                                end else begin
                                    GenJournalLine.Amount := -LoansRegister."Interest In Arrears";
                                end;
                                GenJournalLine.VALIDATE(GenJournalLine.Amount);

                                IF LoansRegister.Source = LoansRegister.Source::BOSA THEN BEGIN
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                                END ELSE
                                    IF LoansRegister.Source = LoansRegister.Source::FOSA THEN BEGIN
                                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                    END ELSE
                                        IF LoansRegister.Source = LoansRegister.Source::MICRO THEN
                                            GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
                                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranch(LoansRegister."Client Code");
                                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                                IF (GenJournalLine.Amount <> 0) THEN
                                    GenJournalLine.INSERT;

                                LineNo := LineNo + 10000;
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := 'General';
                                GenJournalLine."Journal Batch Name" := 'RECOVERY';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine."Account No." := SurestepFactory.FnGetFosaAccount(LoansRegister."Client Code");
                                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                GenJournalLine."Document No." := LoansRegister."Loan  No.";
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := Format(LoansRegister."Recovery Mode") + '-Interest Paid';
                                if RunningBal < LoansRegister."Interest In Arrears" then begin
                                    GenJournalLine.Amount := RunningBal;
                                end else begin
                                    GenJournalLine.Amount := LoansRegister."Interest In Arrears";
                                end;
                                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranch(LoansRegister."Client Code");
                                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                IF (GenJournalLine.Amount <> 0) THEN
                                    GenJournalLine.INSERT;
                                RunningBal := RunningBal - GenJournalLine.Amount;
                            end;
                            //Recover Principal
                            if (RunningBal > 0) and (LoansRegister."Principal In Arrears" > 0) then begin
                                LineNo := LineNo + 10000;
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := 'General';
                                GenJournalLine."Journal Batch Name" := 'RECOVERY';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                GenJournalLine."Account No." := LoansRegister."Client Code";
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                GenJournalLine."Document No." := LoansRegister."Loan  No.";
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := Format(LoansRegister."Recovery Mode") + '-Principal Paid';
                                if RunningBal < LoansRegister."Principal In Arrears" then begin
                                    GenJournalLine.Amount := -RunningBal;
                                end else begin
                                    GenJournalLine.Amount := -LoansRegister."Principal In Arrears";
                                end;
                                GenJournalLine.VALIDATE(GenJournalLine.Amount);

                                IF LoansRegister.Source = LoansRegister.Source::BOSA THEN BEGIN
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                                END ELSE
                                    IF LoansRegister.Source = LoansRegister.Source::FOSA THEN BEGIN
                                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                    END ELSE
                                        IF LoansRegister.Source = LoansRegister.Source::MICRO THEN
                                            GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
                                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranch(LoansRegister."Client Code");
                                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                                IF (GenJournalLine.Amount <> 0) THEN
                                    GenJournalLine.INSERT;

                                LineNo := LineNo + 10000;
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := 'General';
                                GenJournalLine."Journal Batch Name" := 'RECOVERY';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine."Account No." := SurestepFactory.FnGetFosaAccount(LoansRegister."Client Code");
                                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                GenJournalLine."Document No." := LoansRegister."Loan  No.";
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := Format(LoansRegister."Recovery Mode") + '-Principal Paid';
                                if RunningBal < LoansRegister."Principal In Arrears" then begin
                                    GenJournalLine.Amount := RunningBal;
                                end else begin
                                    GenJournalLine.Amount := LoansRegister."Principal In Arrears";
                                end;
                                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranch(LoansRegister."Client Code");
                                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                IF (GenJournalLine.Amount <> 0) THEN
                                    GenJournalLine.INSERT;
                                RunningBal := RunningBal - GenJournalLine.Amount;
                            end;
                        until LoansRegister.Next = 0;
                    end;
                end;
                //Post Lines
                GenJournalLine.Reset();
                GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
                GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'RECOVERY');
                GenJournalLine.SETRANGE(GenJournalLine."Document No.", LoansRegister."Loan  No.");
                IF GenJournalLine.Find('-') THEN begin
                    REPEAT
                        GLPosting.RUN(GenJournalLine);
                    UNTIL GenJournalLine.NEXT = 0;
                end;
                GenJournalLine.Reset();
                GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
                GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'RECOVERY');
                GenJournalLine.SETRANGE(GenJournalLine."Document No.", LoansRegister."Loan  No.");
                IF GenJournalLine.Find('-') THEN begin
                    GenJournalLine.DeleteAll();
                end;
            until MemberTable.Next = 0;
        end;
    end;

    procedure FnRecoverArrearsUsingLoansTable()
    var
        LoansRegister: record "Loans Register";
        MemberTable: record Customer;
        FOSABalance: Decimal;
        SurestepFactory: Codeunit "SURESTEP Factory";
        RunningBal: Decimal;
        GenJournalLine: record "Gen. Journal Line";
        LineNo: Integer;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        JobqeueTable: record "Job Queue Entry";
        LoansTotal: Integer;
        Reached: integer;
        PercentageDone: Decimal;
        DialogBox: Dialog;

    begin
        GenJournalLine.Reset();
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'RECOVERY');
        IF GenJournalLine.Find('-') THEN begin
            GenJournalLine.DeleteAll();
        end;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister.Posted, true);
        LoansRegister.SetRange(LoansRegister."Recovery Mode", LoansRegister."Recovery Mode"::"Direct Debits");
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Principal In Arrears", LoansRegister."Interest In Arrears", LoansRegister."Amount in Arrears");
        LoansRegister.SetFilter(LoansRegister."Amount in Arrears", '>%1', 0);
        IF LoansRegister.Find('-') THEN begin
            LoansTotal := 0;
            LoansTotal := LoansRegister.Count();
            Reached := 0;
            PercentageDone := 0;
            repeat
                Reached := Reached + 1;
                PercentageDone := (Reached / LoansTotal) * 100;
                DialogBox.Open('Processing ' + Format(Reached) + ' of ' + Format(LoansTotal) + ': Percentage= ' + Format(Round(PercentageDone)));

                FOSABalance := 0;
                FOSABalance := SurestepFactory.FnGetFosaAccountBalanceUsingBOSA(MemberTable."No.");
                RunningBal := 0;
                RunningBal := FOSABalance;
                IF (RunningBal > 0) and (LoansRegister."Interest In Arrears" > 0) THEN begin
                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'General';
                    GenJournalLine."Journal Batch Name" := 'RECOVERY';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                    GenJournalLine."Account No." := LoansRegister."Client Code";
                    GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := LoansRegister."Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := Format(LoansRegister."Recovery Mode") + '-Interest Paid';
                    if RunningBal < LoansRegister."Interest In Arrears" then begin
                        GenJournalLine.Amount := -RunningBal;
                    end else begin
                        GenJournalLine.Amount := -LoansRegister."Interest In Arrears";
                    end;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);

                    IF LoansRegister.Source = LoansRegister.Source::BOSA THEN BEGIN
                        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                    END ELSE
                        IF LoansRegister.Source = LoansRegister.Source::FOSA THEN BEGIN
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        END ELSE
                            IF LoansRegister.Source = LoansRegister.Source::MICRO THEN
                                GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranch(LoansRegister."Client Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                    GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                    IF (GenJournalLine.Amount <> 0) THEN
                        GenJournalLine.INSERT;

                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'General';
                    GenJournalLine."Journal Batch Name" := 'RECOVERY';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Account No." := SurestepFactory.FnGetFosaAccount(LoansRegister."Client Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := LoansRegister."Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := Format(LoansRegister."Recovery Mode") + '-Interest Paid';
                    if RunningBal < LoansRegister."Interest In Arrears" then begin
                        GenJournalLine.Amount := RunningBal;
                    end else begin
                        GenJournalLine.Amount := LoansRegister."Interest In Arrears";
                    end;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranch(LoansRegister."Client Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                    IF (GenJournalLine.Amount <> 0) THEN
                        GenJournalLine.INSERT;
                    RunningBal := RunningBal - GenJournalLine.Amount;
                end;
                //Recover Principal
                if (RunningBal > 0) and (LoansRegister."Principal In Arrears" > 0) then begin
                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'General';
                    GenJournalLine."Journal Batch Name" := 'RECOVERY';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                    GenJournalLine."Account No." := LoansRegister."Client Code";
                    GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := LoansRegister."Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := Format(LoansRegister."Recovery Mode") + '-Principal Paid';
                    if RunningBal < LoansRegister."Principal In Arrears" then begin
                        GenJournalLine.Amount := -RunningBal;
                    end else begin
                        GenJournalLine.Amount := -LoansRegister."Principal In Arrears";
                    end;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);

                    IF LoansRegister.Source = LoansRegister.Source::BOSA THEN BEGIN
                        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                    END ELSE
                        IF LoansRegister.Source = LoansRegister.Source::FOSA THEN BEGIN
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        END ELSE
                            IF LoansRegister.Source = LoansRegister.Source::MICRO THEN
                                GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranch(LoansRegister."Client Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                    GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                    IF (GenJournalLine.Amount <> 0) THEN
                        GenJournalLine.INSERT;

                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'General';
                    GenJournalLine."Journal Batch Name" := 'RECOVERY';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Account No." := SurestepFactory.FnGetFosaAccount(LoansRegister."Client Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := LoansRegister."Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := Format(LoansRegister."Recovery Mode") + '-Principal Paid';
                    if RunningBal < LoansRegister."Principal In Arrears" then begin
                        GenJournalLine.Amount := RunningBal;
                    end else begin
                        GenJournalLine.Amount := LoansRegister."Principal In Arrears";
                    end;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranch(LoansRegister."Client Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                    IF (GenJournalLine.Amount <> 0) THEN
                        GenJournalLine.INSERT;
                    RunningBal := RunningBal - GenJournalLine.Amount;
                end;
                //Post Lines
                GenJournalLine.Reset();
                GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
                GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'RECOVERY');
                GenJournalLine.SETRANGE(GenJournalLine."Document No.", LoansRegister."Loan  No.");
                IF GenJournalLine.Find('-') THEN begin
                    REPEAT
                        GLPosting.RUN(GenJournalLine);
                    UNTIL GenJournalLine.NEXT = 0;
                end;
                GenJournalLine.Reset();
                GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
                GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'RECOVERY');
                GenJournalLine.SETRANGE(GenJournalLine."Document No.", LoansRegister."Loan  No.");
                IF GenJournalLine.Find('-') THEN begin
                    GenJournalLine.DeleteAll();
                end;
            until LoansRegister.Next = 0;
            DialogBox.Close();
        end;
    end;

}
