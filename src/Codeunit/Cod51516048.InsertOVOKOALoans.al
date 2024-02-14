codeunit 51516048 "Insert OVOKOALoans"
{
    trigger OnRun()
    var
        VendorTable: Record Vendor;
    begin
        // ImportedLoans.reset;
        // if ImportedLoans.Find('-') then begin
        //     ImportedLoans.DeleteAll();
        // end;
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Loan Product Type", 'OVERDRAFT');
        IF LoansReg.Find('-') THEN begin
            LoansReg.DeleteAll();
        end;
        //...............................
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", 'General');
        GenJournalLine.SETRANGE("Journal Batch Name", 'LOANS');
        GenJournalLine.DELETEALL;
        ImportedLoans.Reset();
        if ImportedLoans.Find('-') then begin
            repeat
                //....................Repeat
                VendorTable.Reset();
                VendorTable.SetRange(VendorTable."No.", ImportedLoans."Vendor No");
                if VendorTable.Find('-') then begin
                    ImportedLoans."Client Code" := VendorTable."BOSA Account No";
                    ImportedLoans.Modify(true);
                end;
                Commit();
            //....................Insert Bosa No
            until ImportedLoans.Next = 0;
        end;
        ImportedLoans.Reset();
        if ImportedLoans.Find('-') then begin
            repeat
                //.................................Insert Loan Detail
                LoansReg.Init();
                LoansReg."Loan  No." := ImportedLoans."Loan No";
                LoansReg."Client Code" := ImportedLoans."Client Code";
                LoansReg."Application Date" := ImportedLoans."Application Date";
                LoansReg."Loan Product Type" := 'OVERDRAFT';
                LoansReg.Source := LoansReg.Source::FOSA;
                LoansReg."Loan Product Type Name" := 'OVERDRAFT';
                LoansReg.Interest := ImportedLoans."Overdraft Period";
                LoansReg."Interest Calculation Method" := LoansReg."Interest Calculation Method"::"Flat Rate";
                LoansReg."Repayment Method" := LoansReg."Repayment Method"::Constants;
                LoansReg.Installments := ImportedLoans."Overdraft Period";
                LoansReg."Max. Installments" := ImportedLoans."Overdraft Period";
                LoansReg."Max. Loan Amount" := 10000000;
                LoansReg."Requested Amount" := ImportedLoans."Applied Amount";
                LoansReg."Approved Amount" := ImportedLoans."Applied Amount";
                LoansReg."Captured By" := ImportedLoans."Captured By";
                LoansReg."Captured By" := ImportedLoans."Captured By";
                LoansReg."Loan Status" := LoansReg."Loan Status"::Issued;
                LoansReg."Loan Status" := LoansReg."Loan Status"::Issued;
                LoansReg."Global Dimension 1 Code" := 'FOSA';
                LoansReg."Account No" := ImportedLoans."Vendor No";
                LoansReg."Recovery Mode" := ImportedLoans."Repayment Method";
                LoansReg."Mode of Disbursement" := LoansReg."Mode of Disbursement"::"Cheque";
                LoansReg."Posted By" := ImportedLoans."Captured By";
                LoansReg."Posting Date" := ImportedLoans."Loan Disbursement Date";
                LoansReg.Posted := true;
                LoansReg."Repayment Frequency" := LoansReg."Repayment Frequency"::Monthly;
                LoansReg.INSERT(true);

                //......................................................
                LineNo := LineNo + 10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'General';
                GenJournalLine."Journal Batch Name" := 'LOANS';
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                GenJournalLine."Account No." := ImportedLoans."Client Code";
                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Loan;
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No." := 'Balance B/d-' + Format(Today);
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := 'Balance B/d-' + Format(Today) + ' ' + 'Overdraft';
                GenJournalLine.Amount := ImportedLoans."Loan Balance";
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No." := 'IMPORT OP';
                GenJournalLine."Loan No" := ImportedLoans."Loan No";
                GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);
            until ImportedLoans.Next = 0;
        end;
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        ImportedLoans: Record "Loan Imported";
        LineNo: Integer;
        LoansReg: Record "Loans Register";
}
