codeunit 51516010 "Charge FOSA Account Maintain"
{
    trigger OnRun()
    begin
        // FnInitiateGLs();
        // FnChargeFOSAAccountMaintainance();
        // FnAutoPostGls();
    end;

    procedure FnChargeFOSAAccountMaintainance()
    begin
        DocNo := '';
        DocNo := FnGetDocNo();
        Vendor.Reset();
        Vendor.SetRange(Vendor."Account Type", 'ORDINARY');
        Vendor.SetRange(Vendor."Debtor Type", Vendor."Debtor Type"::"FOSA Account");
        Vendor.SetRange(Vendor.Status, Vendor.Status::Active);
        Vendor.SetAutoCalcFields(Vendor."FOSA Balance");
        Vendor.SetFilter(Vendor."FOSA Balance", '>%1', 60);
        if Vendor.Find('-') then begin
            repeat
                LineNo := LineNo + 10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Line No." := LineNo + 10000;
                GenJournalLine."Journal Batch Name" := 'ACCM';
                GenJournalLine."Document No." := DocNo;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No." := Vendor."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := DocNo + '-Account Maintanance Fee';
                GenJournalLine.Amount := 50;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No." := '5418';
                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                //-----------------------------
                LineNo := LineNo + 10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Line No." := LineNo + 10000;
                GenJournalLine."Journal Batch Name" := 'ACCM';
                GenJournalLine."Document No." := DocNo;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No." := Vendor."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := DocNo + '-Account maintainance Excise Duty';
                GenJournalLine.Amount := 10;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No." := '3326';
                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
            until Vendor.Next = 0;
        end;
    end;

    procedure FnInitiateGLs()
    begin
        //delete journal line
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", 'General');
        GenJournalLine.SETRANGE("Journal Batch Name", 'ACCM');
        GenJournalLine.DELETEALL;
        GenBatches.RESET;
        GenBatches.SETRANGE(GenBatches."Journal Template Name", 'General');
        GenBatches.SETRANGE(GenBatches.Name, 'ACCM');
        IF GenBatches.FIND('-') = FALSE THEN BEGIN
            GenBatches.INIT;
            GenBatches."Journal Template Name" := 'General';
            GenBatches.Name := 'ACCM';
            GenBatches.Description := 'Account Maintainance Fee';
            GenBatches.INSERT;
        END;
    end;

    procedure FnAutoPostGls()
    var
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", 'General');
        GenJournalLine.SETRANGE("Journal Batch Name", 'ACCM');
        IF GenJournalLine.FIND('-') THEN BEGIN
            REPEAT
                GLPosting.RUN(GenJournalLine);
            UNTIL GenJournalLine.NEXT = 0;
            //Send Email of posted Entries
            FnSendEmail();
            //...................................Delete Entries
            GenJournalLine.RESET;
            GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
            GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'ACCM');
            IF GenJournalLine.Find('-') THEN begin
                GenJournalLine.DeleteAll();
            end;
        end;
    end;

    local procedure FnSendEmail()
    begin
        //Message('Procedure FnSendEmail not implemented.');
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


    //.................................................................................
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenBatches: Record "Gen. Journal Batch";
        LineNo: Integer;
        LoansRegister: Record "Loans Register";
        LoanType: Record "Loan Products Setup";
        DocNo: text;
        Vendor: Record Vendor;
}
