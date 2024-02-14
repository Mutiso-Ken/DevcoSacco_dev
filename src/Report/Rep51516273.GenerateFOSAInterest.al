#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516273 "Generate FOSA Interest"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Generate FOSA Interest.rdlc';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            trigger OnAfterGetRecord()
            begin


                IntRate := 0;
                AccruedInt := 0;
                MidMonthFactor := 1;
                MinBal := false;
                RIntDays := IntDays;
                AsAt := StartDate;
                LowestBal := 0;
                Bal := 0;


                if AccountType.Get(Vendor."Account Type") then begin
                    if AccountType."Earns Interest" = true then begin

                        //Loop thru days of the month
                        repeat
                            RIntDays := RIntDays - 1;

                            DFilter := '01/01/06..' + Format(PDate);

                            Account.Reset;
                            Account.SetRange(Account."No.", "No.");
                            Account.SetFilter(Account."Date Filter", DFilter);
                            if Account.Find('-') then begin
                                Account.CalcFields(Account."Net Change (LCY)");
                                Error('....%1',Account."Net Change (LCY)");
                                Bal := Account."Net Change (LCY)";
                                if Account."Net Change (LCY)" >= AccountType."Interest Calc Min Balance" then begin
                                    AccountType.TestField(AccountType."Interest Rate");
                                    IntRate := AccountType."Interest Rate";
                                    if LowestBal = 0 then
                                        LowestBal := Account."Net Change (LCY)";

                                    if LowestBal > Account."Net Change (LCY)" then
                                        LowestBal := Account."Net Change (LCY)";
                                end else begin
                                    MinBal := true;
                                end;
                            end;

                            AsAt := CalcDate('1D', AsAt);
                        until RIntDays = 0;

                        AccruedInt := ROUND(LowestBal * (IntRate / 100), 0.1, '<');

                    end;

                    if MinBal = true then
                        AccruedInt := 0;

                    if (Vendor."No." = '5-02-09276-00') or (Vendor."No." = '5-02-09565-00') or
                       (Vendor."No." = '5-07--01') then
                        AccruedInt := 0;




                    if AccruedInt > 0 then begin

                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'PURCHASES';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Journal Batch Name" := 'INTCALC';
                        GenJournalLine."Document No." := DocNo;
                        GenJournalLine."External Document No." := Vendor."No.";
                        GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                        GenJournalLine."Account No." := AccountType."Interest Expense Account";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := PDate;
                        GenJournalLine.Description := Vendor.Name;
                        GenJournalLine.Validate(GenJournalLine."Currency Code");
                        GenJournalLine.Amount := AccruedInt;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := AccountType."Interest Payable Account";
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                        GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                        if GenJournalLine."Shortcut Dimension 1 Code" = '' then
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;


                        IntBufferNo := IntBufferNo + 1;

                        InterestBuffer.Init;
                        InterestBuffer.No := IntBufferNo;
                        InterestBuffer."Account No" := Vendor."No.";
                        //InterestBuffer."Account Name":=Vendor.Name;
                        InterestBuffer."Account Type" := Vendor."Account Type";
                        InterestBuffer."Interest Date" := PDate;
                        InterestBuffer."Interest Amount" := AccruedInt;
                        InterestBuffer."User ID" := UserId;
                        if InterestBuffer."Interest Amount" <> 0 then
                            InterestBuffer.Insert(true);
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin

                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'PURCHASES');
                GenJournalLine.SetRange("Journal Batch Name", 'INTCALC');
                GenJournalLine.DeleteAll;

                DocNo := 'INT EARNED';
                if PDate = 0D then
                    PDate := Today;

                InterestBuffer.Reset;
                if InterestBuffer.Find('+') then
                    IntBufferNo := InterestBuffer.No;

                StartDate := CalcDate('-1M', CalcDate('1D', PDate));
                IntDays := (Today - StartDate) + 1;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        GenJournalLine: Record "Gen. Journal Line";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Account: Record Vendor;
        AccountType: Record "Account Types-Saving Products";
        LineNo: Integer;
        InterestBuffer: Record "Interest Buffer";
        IntRate: Decimal;
        DocNo: Code[10];
        PDate: Date;
        IntBufferNo: Integer;
        MidMonthFactor: Decimal;
        DaysInMonth: Integer;
        StartDate: Date;
        IntDays: Integer;
        AsAt: Date;
        MinBal: Boolean;
        AccruedInt: Decimal;
        RIntDays: Integer;
        Bal: Decimal;
        DFilter: Text[50];
        FixedDtype: Record "Fixed Deposit Type";
        DURATION: Integer;
        Dfilter2: Date;
        Dfilter3: Text[30];
        LowestBal: Decimal;
}

