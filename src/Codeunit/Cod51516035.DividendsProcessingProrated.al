codeunit 51516035 "Dividends Processing-Prorated"
{
    trigger OnRun()
    begin
    end;

    var
        MemberRegister: Record customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DividendsProgression: Record "Dividends Progression";
        DivRegister: Record "Dividends Register Flat Rate";
        SaccoGenSetUp: Record "Sacco General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        ComputerSharesInterestEarned: Decimal;
        EntryNo: Integer;
        VanSharesInterestEarned: Decimal;
        PreferentialSharesInterestEarned: Decimal;
        LiftSharesInterestEarned: Decimal;
        TambaaSharesInterestEarned: Decimal;
        PepeaSharesInterestEarned: Decimal;
        HousingSharesInterestEarned: Decimal;
        NWDSharesInterestEarned: Decimal;
        FOSASharesInterestEarned: Decimal;
        NetDividendsPayableToMember: Decimal;
        CapitalizedDividendAmount: Decimal;
        NetTransferToFOSA: Decimal;
        RunningBalance: Decimal;
    //.................................Dividends Processing Prorated start
    procedure FnProcessDividendsProrated(MemberNo: Code[50]; StartDate: Date; EndDate: Date)
    begin
        MemberRegister.reset;
        MemberRegister.SetRange(MemberRegister."No.", MemberNo);
        MemberRegister.SetAutoCalcFields(MemberRegister."Current Shares", MemberRegister."Fosa Shares", MemberRegister."Computer Shares", MemberRegister."van Shares", MemberRegister."Preferencial Building Shares", MemberRegister."Lift Shares", MemberRegister."Tamba Shares", MemberRegister."Pepea Shares", MemberRegister."Housing Deposits");
        if MemberRegister.find('-') then begin
            //2 Delete Previous Entries Of the Member
            DividendsProgression.Reset();
            DividendsProgression.SetRange(DividendsProgression."Member No", MemberNo);
            DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
            if DividendsProgression.Find('-') then begin
                DividendsProgression.DeleteAll();
            end;
            //1 Get NWD Shares Earned
            NWDSharesInterestEarned := 0;
            NWDSharesInterestEarned := FnProcessInterestEarnedOnCurrentShares(MemberRegister."No.", StartDate, EndDate, MemberRegister."Current Shares");
            //2 Get FOSA Shares Interest Earned
            FOSASharesInterestEarned := 0;
            FOSASharesInterestEarned := FnProcessInterestEarnedOnFOSAShares(MemberRegister."No.", StartDate, EndDate, MemberRegister."Fosa Shares");
            //3 Computer Shares Interest Earned
            ComputerSharesInterestEarned := 0;
            ComputerSharesInterestEarned := FnProcessInterestEarnedOnComputerShares(MemberRegister."No.", StartDate, EndDate, MemberRegister."Computer Shares");
            //4 Van Shares Interest Earned
            VanSharesInterestEarned := 0;
            VanSharesInterestEarned := FnProcessInterestEarnedOnVanShares(MemberRegister."No.", StartDate, EndDate, MemberRegister."van Shares");
            //5 Preferential Shares Interest Earned
            PreferentialSharesInterestEarned := 0;
            PreferentialSharesInterestEarned := FnProcessInterestEarnedOnPreferentialShares(MemberRegister."No.", StartDate, EndDate, MemberRegister."Preferencial Building Shares");
            //6 Lift Shares Interest Earned
            LiftSharesInterestEarned := 0;
            LiftSharesInterestEarned := FnProcessInterestEarnedOnLiftShares(MemberRegister."No.", StartDate, EndDate, MemberRegister."Lift Shares");
            //7 Tambaa Shares Interest Earned
            TambaaSharesInterestEarned := 0;
            TambaaSharesInterestEarned := FnProcessInterestEarnedOnTambaaShares(MemberRegister."No.", StartDate, EndDate, MemberRegister."Tamba Shares");
            //8 Pepea Shares Interest Earned
            PepeaSharesInterestEarned := 0;
            PepeaSharesInterestEarned := FnProcessInterestEarnedOnPepeaShares(MemberRegister."No.", StartDate, EndDate, MemberRegister."Pepea Shares");
            //9 Housing Shares Interest Earned
            HousingSharesInterestEarned := 0;
            HousingSharesInterestEarned := FnProcessInterestEarnedOnHousingShares(MemberRegister."No.", StartDate, EndDate, MemberRegister."Housing Deposits");
            //--------------GET NET DIVIDENDS PAYABLE TO MEMBER(Inclusive of capitalzed amount)
            NetDividendsPayableToMember := 0;
            NetDividendsPayableToMember := ComputerSharesInterestEarned + FOSASharesInterestEarned + NWDSharesInterestEarned + VanSharesInterestEarned + PreferentialSharesInterestEarned + LiftSharesInterestEarned + PepeaSharesInterestEarned + TambaaSharesInterestEarned + HousingSharesInterestEarned;
            //--------------Get Capitalized Amount
            CapitalizedDividendAmount := 0;
            CapitalizedDividendAmount := FnCapitalizeDividendsAmount(NetDividendsPayableToMember, MemberRegister."No.", EndDate);
            //--------------Net Transfer To  Member FOSA A/c
            NetTransferToFOSA := 0;
            NetTransferToFOSA := FnTransferNetDividendToFOSA((NetDividendsPayableToMember - CapitalizedDividendAmount), MemberRegister."No.", EndDate);
            //--------------Deduct processing fees

            //--------------Recover Dividend Loan interest
            If FnOutstandingDivLoanIntBal(MemberRegister."No.") > 0 then begin
                RunningBalance := FnRecoverOutstDivInterest(MemberRegister."No.", NetTransferToFOSA, EndDate);
            end;
            //--------------Recover Dividend Loan Balance
            if RunningBalance > 0 then begin
                FnRecoverOutstDivBal(MemberRegister."No.", RunningBalance, EndDate);
            end;
        end;
    end;

    local procedure FnProcessInterestEarnedOnCurrentShares(No: Code[20]; StartDate: Date; EndDate: Date; CurrentShares: Decimal): Decimal
    var
        QualifyingDepositContribs: Decimal;
        GrossNWDMonth1: Decimal;
        GrossNWDMonth2: Decimal;
        GrossNWDMonth3: Decimal;
        GrossNWDMonth4: Decimal;
        GrossNWDMonth5: Decimal;
        GrossNWDMonth6: Decimal;
        GrossNWDMonth7: Decimal;
        GrossNWDMonth8: Decimal;
        GrossNWDMonth9: Decimal;
        GrossNWDMonth10: Decimal;
        GrossNWDMonth11: Decimal;
        GrossNWDMonth12: Decimal;
        TotalGrossNWD: Decimal;
    begin
        //-----------------------1st month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', 0D, CalcDate('CM', StartDate));//End date of first month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', StartDate);
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 12 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth1 := DividendsProgression."Gross Current Shares";
        //---------2nd month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('1M', StartDate))), CalcDate('CM', (CalcDate('1M', StartDate))));//End date of 2nd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('1M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 11 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth2 := DividendsProgression."Gross Current Shares";

        //---------3rd month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('2M', StartDate))), CalcDate('CM', (CalcDate('2M', StartDate))));//End date of 3rd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('2M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 10 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth3 := DividendsProgression."Gross Current Shares";

        //---------4th month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('3M', StartDate))), CalcDate('CM', (CalcDate('3M', StartDate))));//End date of 4 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('3M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 9 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth4 := DividendsProgression."Gross Current Shares";

        //---------5th month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('4M', StartDate))), CalcDate('CM', (CalcDate('4M', StartDate))));//End date of 5 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('4M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 8 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth5 := DividendsProgression."Gross Current Shares";

        //---------6th month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('5M', StartDate))), CalcDate('CM', (CalcDate('5M', StartDate))));//End date of 6 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('5M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 7 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth6 := DividendsProgression."Gross Current Shares";

        //---------7th month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('6M', StartDate))), CalcDate('CM', (CalcDate('6M', StartDate))));//End date of 7 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('6M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 6 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth7 := DividendsProgression."Gross Current Shares";

        //---------8th month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('7M', StartDate))), CalcDate('CM', (CalcDate('7M', StartDate))));//End date of 8 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('7M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 5 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth8 := DividendsProgression."Gross Current Shares";


        //---------9th month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('8M', StartDate))), CalcDate('CM', (CalcDate('8M', StartDate))));//End date of 9 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('8M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 4 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth9 := DividendsProgression."Gross Current Shares";

        //---------10th month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('9M', StartDate))), CalcDate('CM', (CalcDate('9M', StartDate))));//End date of 10 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('9M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 3 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth10 := DividendsProgression."Gross Current Shares";

        //---------11th month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('10M', StartDate))), CalcDate('CM', (CalcDate('10M', StartDate))));//End date of 11 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('10M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 2 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth11 := DividendsProgression."Gross Current Shares";

        //---------12th month
        QualifyingDepositContribs := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('11M', StartDate))), CalcDate('CM', (CalcDate('11M', StartDate))));//End date of 12 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingDepositContribs += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Init();
        DividendsProgression."Member No" := No;
        DividendsProgression.Date := CalcDate('CM', (CalcDate('11M', StartDate)));
        DividendsProgression."Qualifying Current Shares" := (QualifyingDepositContribs) * 1 / 12;
        DividendsProgression."Gross Current Shares" := (DividendsProgression."Qualifying Current Shares" * ((SaccoGenSetUp."Interest On Current Shares") / 100));
        DividendsProgression."WTax-Current Shares" := DividendsProgression."Gross Current Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        DividendsProgression."Net Current Shares" := DividendsProgression."Gross Current Shares" - DividendsProgression."WTax-Current Shares";
        DividendsProgression."Dividend Year" := format(DATE2DMY((EndDate), 3));
        DividendsProgression.Insert();
        GrossNWDMonth12 := DividendsProgression."Gross Current Shares";
        //4 Insert To GL's
        //A)GROSS
        TotalGrossNWD := 0;
        TotalGrossNWD := GrossNWDMonth1 + GrossNWDMonth2 + GrossNWDMonth3 + GrossNWDMonth4 + GrossNWDMonth5 + GrossNWDMonth6 + GrossNWDMonth7 + GrossNWDMonth8 + GrossNWDMonth9 + GrossNWDMonth10 + GrossNWDMonth11 + GrossNWDMonth12;
        //i)Bank Account
        SaccoGenSetUp.Get();
        SaccoGenSetUp.TestField(SaccoGenSetUp."Dividends Paying Bank Account");
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
        GenJournalLine."Account No." := SaccoGenSetUp."Dividends Paying Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On NWD Year-' + format(DATE2DMY((EndDate), 3)) + ' paid to-' + Format(No);
        GenJournalLine.Amount := TotalGrossNWD;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //ii)Member Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On NWD Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -TotalGrossNWD;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //B)WTX
        SaccoGenSetUp.Get();
        if DivRegister."WTX -Current Shares" <> 0 then begin
            SaccoGenSetUp.TestField(SaccoGenSetUp."Withholding Tax Account");
        end;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Witholding Tax On-Gross Interest(NWD) Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := TotalGrossNWD * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Withholding Tax Account";
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit(TotalGrossNWD);
    end;

    //------------------------------------------------------------------------------------------------------------------------------------------------
    local procedure FnProcessInterestEarnedOnFOSAShares(No: Code[20]; StartDate: Date; EndDate: Date; FosaShares: Decimal): Decimal
    var
        QualifyingFOSAShares: Decimal;
        GrossMonth1: Decimal;
        GrossMonth2: Decimal;
        GrossMonth3: Decimal;
        GrossMonth4: Decimal;
        GrossMonth5: Decimal;
        GrossMonth6: Decimal;
        GrossMonth7: Decimal;
        GrossMonth8: Decimal;
        GrossMonth9: Decimal;
        GrossMonth10: Decimal;
        GrossMonth11: Decimal;
        GrossMonth12: Decimal;
        TotalGross: Decimal;
    begin
        //-----------------------1st month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', 0D, CalcDate('CM', StartDate));//End date of first month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', StartDate));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 12 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth1 := DividendsProgression."Gross FOSA Shares";
        //---------2nd month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('1M', StartDate))), CalcDate('CM', (CalcDate('1M', StartDate))));//End date of 2nd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('1M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 11 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth2 := DividendsProgression."Gross FOSA Shares";

        //---------3rd month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('2M', StartDate))), CalcDate('CM', (CalcDate('2M', StartDate))));//End date of 3rd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('2M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 10 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth3 := DividendsProgression."Gross FOSA Shares";

        //---------4th month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('3M', StartDate))), CalcDate('CM', (CalcDate('3M', StartDate))));//End date of 4 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('3M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 9 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth4 := DividendsProgression."Gross FOSA Shares";

        //---------5th month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('4M', StartDate))), CalcDate('CM', (CalcDate('4M', StartDate))));//End date of 5 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('4M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 8 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth5 := DividendsProgression."Gross FOSA Shares";

        //---------6th month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('5M', StartDate))), CalcDate('CM', (CalcDate('5M', StartDate))));//End date of 6 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('5M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 7 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth6 := DividendsProgression."Gross FOSA Shares";

        //---------7th month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('6M', StartDate))), CalcDate('CM', (CalcDate('6M', StartDate))));//End date of 7 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('6M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 6 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth7 := DividendsProgression."Gross FOSA Shares";

        //---------8th month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('7M', StartDate))), CalcDate('CM', (CalcDate('7M', StartDate))));//End date of 8 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('7M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 5 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth8 := DividendsProgression."Gross FOSA Shares";


        //---------9th month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('8M', StartDate))), CalcDate('CM', (CalcDate('8M', StartDate))));//End date of 9 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('8M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 4 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth9 := DividendsProgression."Gross FOSA Shares";

        //---------10th month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('9M', StartDate))), CalcDate('CM', (CalcDate('9M', StartDate))));//End date of 10 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('9M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 3 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth10 := DividendsProgression."Gross FOSA Shares";

        //---------11th month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"FOSA Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('10M', StartDate))), CalcDate('CM', (CalcDate('10M', StartDate))));//End date of 11 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('10M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 2 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth11 := DividendsProgression."Gross FOSA Shares";

        //---------12th month
        QualifyingFOSAShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Deposit Contribution");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('11M', StartDate))), CalcDate('CM', (CalcDate('11M', StartDate))));//End date of 12 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingFOSAShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('11M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying FOSA Shares" := (QualifyingFOSAShares) * 1 / 12;
            DividendsProgression."Gross FOSA Shares" := (DividendsProgression."Qualifying FOSA Shares" * ((SaccoGenSetUp."Interest On FOSA Shares") / 100));
            DividendsProgression."WTax-FOSA Shares" := DividendsProgression."Gross FOSA Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net FOSA Shares" := DividendsProgression."Gross FOSA Shares" - DividendsProgression."WTax-FOSA Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth12 := DividendsProgression."Gross FOSA Shares";
        //4 Insert To GL's
        //A)GROSS
        TotalGross := 0;
        TotalGross := GrossMonth1 + GrossMonth2 + GrossMonth3 + GrossMonth4 + GrossMonth5 + GrossMonth6 + GrossMonth7 + GrossMonth8 + GrossMonth9 + GrossMonth10 + GrossMonth11 + GrossMonth12;
        //i)Bank Account
        SaccoGenSetUp.Get();
        SaccoGenSetUp.TestField(SaccoGenSetUp."Dividends Paying Bank Account");
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
        GenJournalLine."Account No." := SaccoGenSetUp."Dividends Paying Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On FOSA Shares Year-' + format(DATE2DMY((EndDate), 3)) + ' paid to-' + Format(No);
        GenJournalLine.Amount := TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //ii)Member Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On FOSA Shares Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //B)WTX
        SaccoGenSetUp.Get();
        if DivRegister."WTX -Current Shares" <> 0 then begin
            SaccoGenSetUp.TestField(SaccoGenSetUp."Withholding Tax Account");
        end;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Witholding Tax On-Gross Interest(FOSA Shares) Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := TotalGross * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Withholding Tax Account";
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit(TotalGross);
    end;
    //------------------------------------------------------------------------------------------------------------------------------------------------
    local procedure FnProcessInterestEarnedOnComputerShares(No: Code[20]; StartDate: Date; EndDate: Date; ComputerShares: Decimal): Decimal
    var
        QualifyingComputerShares: Decimal;
        GrossMonth1: Decimal;
        GrossMonth2: Decimal;
        GrossMonth3: Decimal;
        GrossMonth4: Decimal;
        GrossMonth5: Decimal;
        GrossMonth6: Decimal;
        GrossMonth7: Decimal;
        GrossMonth8: Decimal;
        GrossMonth9: Decimal;
        GrossMonth10: Decimal;
        GrossMonth11: Decimal;
        GrossMonth12: Decimal;
        TotalGross: Decimal;
    begin
        //-----------------------1st month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', 0D, CalcDate('CM', StartDate));//End date of first month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', StartDate));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 12 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth1 := DividendsProgression."Gross Computer Shares";
        //---------2nd month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('1M', StartDate))), CalcDate('CM', (CalcDate('1M', StartDate))));//End date of 2nd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('1M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 11 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth2 := DividendsProgression."Gross Computer Shares";

        //---------3rd month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('2M', StartDate))), CalcDate('CM', (CalcDate('2M', StartDate))));//End date of 3rd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('2M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 10 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth3 := DividendsProgression."Gross Computer Shares";

        //---------4th month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('3M', StartDate))), CalcDate('CM', (CalcDate('3M', StartDate))));//End date of 4 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('3M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 9 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth4 := DividendsProgression."Gross Computer Shares";

        //---------5th month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('4M', StartDate))), CalcDate('CM', (CalcDate('4M', StartDate))));//End date of 5 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('4M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 8 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth5 := DividendsProgression."Gross Computer Shares";

        //---------6th month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('5M', StartDate))), CalcDate('CM', (CalcDate('5M', StartDate))));//End date of 6 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('5M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 7 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth6 := DividendsProgression."Gross Computer Shares";

        //---------7th month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('6M', StartDate))), CalcDate('CM', (CalcDate('6M', StartDate))));//End date of 7 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('6M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 6 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth7 := DividendsProgression."Gross Computer Shares";

        //---------8th month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('7M', StartDate))), CalcDate('CM', (CalcDate('7M', StartDate))));//End date of 8 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('7M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 5 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth8 := DividendsProgression."Gross Computer Shares";


        //---------9th month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('8M', StartDate))), CalcDate('CM', (CalcDate('8M', StartDate))));//End date of 9 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('8M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 4 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth9 := DividendsProgression."Gross Computer Shares";

        //---------10th month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('9M', StartDate))), CalcDate('CM', (CalcDate('9M', StartDate))));//End date of 10 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('9M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 3 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth10 := DividendsProgression."Gross Computer Shares";

        //---------11th month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('10M', StartDate))), CalcDate('CM', (CalcDate('10M', StartDate))));//End date of 11 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('10M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 2 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth11 := DividendsProgression."Gross Computer Shares";

        //---------12th month
        QualifyingComputerShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Computer Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('11M', StartDate))), CalcDate('CM', (CalcDate('11M', StartDate))));//End date of 12 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingComputerShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('11M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Computer Shares" := (QualifyingComputerShares) * 1 / 12;
            DividendsProgression."Gross Computer Shares" := (DividendsProgression."Qualifying Computer Shares" * ((SaccoGenSetUp."Interest On Computer Shares") / 100));
            DividendsProgression."WTax-Computer Shares" := DividendsProgression."Gross Computer Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Computer Shares" := DividendsProgression."Gross Computer Shares" - DividendsProgression."WTax-Computer Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth12 := DividendsProgression."Gross Computer Shares";
        //4 Insert To GL's
        //A)GROSS
        TotalGross := 0;
        TotalGross := GrossMonth1 + GrossMonth2 + GrossMonth3 + GrossMonth4 + GrossMonth5 + GrossMonth6 + GrossMonth7 + GrossMonth8 + GrossMonth9 + GrossMonth10 + GrossMonth11 + GrossMonth12;
        //i)Bank Account
        SaccoGenSetUp.Get();
        SaccoGenSetUp.TestField(SaccoGenSetUp."Dividends Paying Bank Account");
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
        GenJournalLine."Account No." := SaccoGenSetUp."Dividends Paying Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Computer Shares Year-' + format(DATE2DMY((EndDate), 3)) + ' paid to-' + Format(No);
        GenJournalLine.Amount := TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //ii)Member Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Computer Shares Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //B)WTX
        SaccoGenSetUp.Get();
        if DivRegister."WTX -Current Shares" <> 0 then begin
            SaccoGenSetUp.TestField(SaccoGenSetUp."Withholding Tax Account");
        end;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Witholding Tax On-Gross Interest(Computer Shares) Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := TotalGross * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Withholding Tax Account";
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit(TotalGross);
    end;
    //---------------------------------------------------------------------------------------------
    local procedure FnProcessInterestEarnedOnVanShares(No: Code[20]; StartDate: Date; EndDate: Date; vanShares: Decimal): Decimal
    var
        QualifyingVanShares: Decimal;
        GrossMonth1: Decimal;
        GrossMonth2: Decimal;
        GrossMonth3: Decimal;
        GrossMonth4: Decimal;
        GrossMonth5: Decimal;
        GrossMonth6: Decimal;
        GrossMonth7: Decimal;
        GrossMonth8: Decimal;
        GrossMonth9: Decimal;
        GrossMonth10: Decimal;
        GrossMonth11: Decimal;
        GrossMonth12: Decimal;
        TotalGross: Decimal;
    begin
        //-----------------------1st month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', 0D, CalcDate('CM', StartDate));//End date of first month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', StartDate));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 12 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth1 := DividendsProgression."Gross Van Shares";
        //---------2nd month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('1M', StartDate))), CalcDate('CM', (CalcDate('1M', StartDate))));//End date of 2nd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('1M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 11 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth2 := DividendsProgression."Gross Van Shares";

        //---------3rd month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('2M', StartDate))), CalcDate('CM', (CalcDate('2M', StartDate))));//End date of 3rd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('2M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 10 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth3 := DividendsProgression."Gross Van Shares";

        //---------4th month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('3M', StartDate))), CalcDate('CM', (CalcDate('3M', StartDate))));//End date of 4 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('3M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 9 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth4 := DividendsProgression."Gross Van Shares";

        //---------5th month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('4M', StartDate))), CalcDate('CM', (CalcDate('4M', StartDate))));//End date of 5 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('4M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 8 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth5 := DividendsProgression."Gross Van Shares";

        //---------6th month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('5M', StartDate))), CalcDate('CM', (CalcDate('5M', StartDate))));//End date of 6 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('5M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 7 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth6 := DividendsProgression."Gross Van Shares";

        //---------7th month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('6M', StartDate))), CalcDate('CM', (CalcDate('6M', StartDate))));//End date of 7 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('6M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 6 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth7 := DividendsProgression."Gross Van Shares";

        //---------8th month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('7M', StartDate))), CalcDate('CM', (CalcDate('7M', StartDate))));//End date of 8 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('7M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 5 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth8 := DividendsProgression."Gross Van Shares";


        //---------9th month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('8M', StartDate))), CalcDate('CM', (CalcDate('8M', StartDate))));//End date of 9 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('8M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 4 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth9 := DividendsProgression."Gross Van Shares";

        //---------10th month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('9M', StartDate))), CalcDate('CM', (CalcDate('9M', StartDate))));//End date of 10 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('9M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 3 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth10 := DividendsProgression."Gross Van Shares";

        //---------11th month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('10M', StartDate))), CalcDate('CM', (CalcDate('10M', StartDate))));//End date of 11 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('10M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 2 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth11 := DividendsProgression."Gross Van Shares";

        //---------12th month
        QualifyingVanShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('11M', StartDate))), CalcDate('CM', (CalcDate('11M', StartDate))));//End date of 12 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingVanShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('11M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Van Shares" := (QualifyingVanShares) * 1 / 12;
            DividendsProgression."Gross Van Shares" := (DividendsProgression."Qualifying Van Shares" * ((SaccoGenSetUp."Interest On Van Shares") / 100));
            DividendsProgression."WTax-Van Shares" := DividendsProgression."Gross Van Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Van Shares" := DividendsProgression."Gross Van Shares" - DividendsProgression."WTax-Van Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth12 := DividendsProgression."Gross Van Shares";
        //4 Insert To GL's
        //A)GROSS
        TotalGross := 0;
        TotalGross := GrossMonth1 + GrossMonth2 + GrossMonth3 + GrossMonth4 + GrossMonth5 + GrossMonth6 + GrossMonth7 + GrossMonth8 + GrossMonth9 + GrossMonth10 + GrossMonth11 + GrossMonth12;
        //i)Bank Account
        SaccoGenSetUp.Get();
        SaccoGenSetUp.TestField(SaccoGenSetUp."Dividends Paying Bank Account");
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
        GenJournalLine."Account No." := SaccoGenSetUp."Dividends Paying Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Van Shares Year-' + format(DATE2DMY((EndDate), 3)) + ' paid to-' + Format(No);
        GenJournalLine.Amount := TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //ii)Member Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Van Shares Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //B)WTX
        SaccoGenSetUp.Get();
        if DivRegister."WTX -Current Shares" <> 0 then begin
            SaccoGenSetUp.TestField(SaccoGenSetUp."Withholding Tax Account");
        end;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Witholding Tax On-Gross Interest(Van Shares) Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := TotalGross * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Withholding Tax Account";
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit(TotalGross);
    end;

    local procedure FnProcessInterestEarnedOnPreferentialShares(No: Code[20]; StartDate: Date; EndDate: Date; PreferentialShares: Decimal): Decimal
    var
        QualifyingPreferentialShares: Decimal;
        GrossMonth1: Decimal;
        GrossMonth2: Decimal;
        GrossMonth3: Decimal;
        GrossMonth4: Decimal;
        GrossMonth5: Decimal;
        GrossMonth6: Decimal;
        GrossMonth7: Decimal;
        GrossMonth8: Decimal;
        GrossMonth9: Decimal;
        GrossMonth10: Decimal;
        GrossMonth11: Decimal;
        GrossMonth12: Decimal;
        TotalGross: Decimal;
    begin
        //-----------------------1st month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', 0D, CalcDate('CM', StartDate));//End date of first month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', StartDate));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 12 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth1 := DividendsProgression."Gross Preferential Shares";
        //---------2nd month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('1M', StartDate))), CalcDate('CM', (CalcDate('1M', StartDate))));//End date of 2nd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('1M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 11 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth2 := DividendsProgression."Gross Preferential Shares";

        //---------3rd month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('2M', StartDate))), CalcDate('CM', (CalcDate('2M', StartDate))));//End date of 3rd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('2M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 10 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth3 := DividendsProgression."Gross Preferential Shares";

        //---------4th month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('3M', StartDate))), CalcDate('CM', (CalcDate('3M', StartDate))));//End date of 4 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('3M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 9 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth4 := DividendsProgression."Gross Preferential Shares";

        //---------5th month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('4M', StartDate))), CalcDate('CM', (CalcDate('4M', StartDate))));//End date of 5 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('4M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 8 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth5 := DividendsProgression."Gross Preferential Shares";

        //---------6th month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('5M', StartDate))), CalcDate('CM', (CalcDate('5M', StartDate))));//End date of 6 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('5M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 7 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth6 := DividendsProgression."Gross Preferential Shares";

        //---------7th month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('6M', StartDate))), CalcDate('CM', (CalcDate('6M', StartDate))));//End date of 7 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('6M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 6 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth7 := DividendsProgression."Gross Preferential Shares";

        //---------8th month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('7M', StartDate))), CalcDate('CM', (CalcDate('7M', StartDate))));//End date of 8 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('7M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 5 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth8 := DividendsProgression."Gross Preferential Shares";


        //---------9th month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('8M', StartDate))), CalcDate('CM', (CalcDate('8M', StartDate))));//End date of 9 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('8M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 4 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth9 := DividendsProgression."Gross Preferential Shares";

        //---------10th month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('9M', StartDate))), CalcDate('CM', (CalcDate('9M', StartDate))));//End date of 10 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('9M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 3 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth10 := DividendsProgression."Gross Preferential Shares";

        //---------11th month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('10M', StartDate))), CalcDate('CM', (CalcDate('10M', StartDate))));//End date of 11 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('10M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 2 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth11 := DividendsProgression."Gross Preferential Shares";

        //---------12th month
        QualifyingPreferentialShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Preferencial Building Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('11M', StartDate))), CalcDate('CM', (CalcDate('11M', StartDate))));//End date of 12 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPreferentialShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('11M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Preferential Shares" := (QualifyingPreferentialShares) * 1 / 12;
            DividendsProgression."Gross Preferential Shares" := (DividendsProgression."Qualifying Preferential Shares" * ((SaccoGenSetUp."Interest On PreferentialShares") / 100));
            DividendsProgression."WTax-Preferential Shares" := DividendsProgression."Gross Preferential Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Preferential Shares" := DividendsProgression."Gross Preferential Shares" - DividendsProgression."WTax-Preferential Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth12 := DividendsProgression."Gross Preferential Shares";
        //4 Insert To GL's
        //A)GROSS
        TotalGross := 0;
        TotalGross := GrossMonth1 + GrossMonth2 + GrossMonth3 + GrossMonth4 + GrossMonth5 + GrossMonth6 + GrossMonth7 + GrossMonth8 + GrossMonth9 + GrossMonth10 + GrossMonth11 + GrossMonth12;
        //i)Bank Account
        SaccoGenSetUp.Get();
        SaccoGenSetUp.TestField(SaccoGenSetUp."Dividends Paying Bank Account");
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
        GenJournalLine."Account No." := SaccoGenSetUp."Dividends Paying Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Preferential Shares Year-' + format(DATE2DMY((EndDate), 3)) + ' paid to-' + Format(No);
        GenJournalLine.Amount := TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //ii)Member Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Preferential Shares Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //B)WTX
        SaccoGenSetUp.Get();
        if DivRegister."WTX -Current Shares" <> 0 then begin
            SaccoGenSetUp.TestField(SaccoGenSetUp."Withholding Tax Account");
        end;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Witholding Tax On-Gross Interest(Preferential Shares) Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := TotalGross * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Withholding Tax Account";
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit(TotalGross);
    end;
    //-------------------------------------------------------------------------------------------
    local procedure FnProcessInterestEarnedOnLiftShares(No: Code[20]; StartDate: Date; EndDate: Date; LiftShares: Decimal): Decimal
    var
        QualifyingLiftShares: Decimal;
        GrossMonth1: Decimal;
        GrossMonth2: Decimal;
        GrossMonth3: Decimal;
        GrossMonth4: Decimal;
        GrossMonth5: Decimal;
        GrossMonth6: Decimal;
        GrossMonth7: Decimal;
        GrossMonth8: Decimal;
        GrossMonth9: Decimal;
        GrossMonth10: Decimal;
        GrossMonth11: Decimal;
        GrossMonth12: Decimal;
        TotalGross: Decimal;
    begin
        //-----------------------1st month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', 0D, CalcDate('CM', StartDate));//End date of first month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', StartDate));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 12 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth1 := DividendsProgression."Gross Lift Shares";
        //---------2nd month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('1M', StartDate))), CalcDate('CM', (CalcDate('1M', StartDate))));//End date of 2nd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('1M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 11 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth2 := DividendsProgression."Gross Lift Shares";

        //---------3rd month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('2M', StartDate))), CalcDate('CM', (CalcDate('2M', StartDate))));//End date of 3rd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('2M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 10 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth3 := DividendsProgression."Gross Lift Shares";

        //---------4th month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('3M', StartDate))), CalcDate('CM', (CalcDate('3M', StartDate))));//End date of 4 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('3M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 9 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth4 := DividendsProgression."Gross Lift Shares";

        //---------5th month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('4M', StartDate))), CalcDate('CM', (CalcDate('4M', StartDate))));//End date of 5 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('4M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 8 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth5 := DividendsProgression."Gross Lift Shares";

        //---------6th month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('5M', StartDate))), CalcDate('CM', (CalcDate('5M', StartDate))));//End date of 6 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('5M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 7 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth6 := DividendsProgression."Gross Lift Shares";

        //---------7th month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('6M', StartDate))), CalcDate('CM', (CalcDate('6M', StartDate))));//End date of 7 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('6M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 6 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth7 := DividendsProgression."Gross Lift Shares";

        //---------8th month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Van Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('7M', StartDate))), CalcDate('CM', (CalcDate('7M', StartDate))));//End date of 8 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('7M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 5 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth8 := DividendsProgression."Gross Lift Shares";


        //---------9th month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('8M', StartDate))), CalcDate('CM', (CalcDate('8M', StartDate))));//End date of 9 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('8M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 4 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth9 := DividendsProgression."Gross Lift Shares";

        //---------10th month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('9M', StartDate))), CalcDate('CM', (CalcDate('9M', StartDate))));//End date of 10 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('9M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 3 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth10 := DividendsProgression."Gross Lift Shares";

        //---------11th month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('10M', StartDate))), CalcDate('CM', (CalcDate('10M', StartDate))));//End date of 11 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('10M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 2 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth11 := DividendsProgression."Gross Lift Shares";

        //---------12th month
        QualifyingLiftShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Lift Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('11M', StartDate))), CalcDate('CM', (CalcDate('11M', StartDate))));//End date of 12 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingLiftShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('11M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Lift Shares" := (QualifyingLiftShares) * 1 / 12;
            DividendsProgression."Gross Lift Shares" := (DividendsProgression."Qualifying Lift Shares" * ((SaccoGenSetUp."Interest On LiftShares") / 100));
            DividendsProgression."WTax-Lift Shares" := DividendsProgression."Gross Lift Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Lift Shares" := DividendsProgression."Gross Lift Shares" - DividendsProgression."WTax-Lift Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth12 := DividendsProgression."Gross Lift Shares";
        //4 Insert To GL's
        //A)GROSS
        TotalGross := 0;
        TotalGross := GrossMonth1 + GrossMonth2 + GrossMonth3 + GrossMonth4 + GrossMonth5 + GrossMonth6 + GrossMonth7 + GrossMonth8 + GrossMonth9 + GrossMonth10 + GrossMonth11 + GrossMonth12;
        //i)Bank Account
        SaccoGenSetUp.Get();
        SaccoGenSetUp.TestField(SaccoGenSetUp."Dividends Paying Bank Account");
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
        GenJournalLine."Account No." := SaccoGenSetUp."Dividends Paying Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Lift Shares Year-' + format(DATE2DMY((EndDate), 3)) + ' paid to-' + Format(No);
        GenJournalLine.Amount := TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //ii)Member Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Lift Shares Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //B)WTX
        SaccoGenSetUp.Get();
        if DivRegister."WTX -Current Shares" <> 0 then begin
            SaccoGenSetUp.TestField(SaccoGenSetUp."Withholding Tax Account");
        end;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Witholding Tax On-Gross Interest(Lift Shares) Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := TotalGross * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Withholding Tax Account";
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit(TotalGross);
    end;
    //------------------------------------------------------------------------------------------------
    local procedure FnProcessInterestEarnedOnTambaaShares(No: Code[20]; StartDate: Date; EndDate: Date; TambaShares: Decimal): Decimal
    var
        QualifyingTambaaShares: Decimal;
        GrossMonth1: Decimal;
        GrossMonth2: Decimal;
        GrossMonth3: Decimal;
        GrossMonth4: Decimal;
        GrossMonth5: Decimal;
        GrossMonth6: Decimal;
        GrossMonth7: Decimal;
        GrossMonth8: Decimal;
        GrossMonth9: Decimal;
        GrossMonth10: Decimal;
        GrossMonth11: Decimal;
        GrossMonth12: Decimal;
        TotalGross: Decimal;
    begin
        //-----------------------1st month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', 0D, CalcDate('CM', StartDate));//End date of first month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', StartDate));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 12 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth1 := DividendsProgression."Gross Tambaa Shares";
        //---------2nd month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('1M', StartDate))), CalcDate('CM', (CalcDate('1M', StartDate))));//End date of 2nd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('1M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 11 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth2 := DividendsProgression."Gross Tambaa Shares";

        //---------3rd month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('2M', StartDate))), CalcDate('CM', (CalcDate('2M', StartDate))));//End date of 3rd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('2M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 10 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth3 := DividendsProgression."Gross Tambaa Shares";

        //---------4th month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('3M', StartDate))), CalcDate('CM', (CalcDate('3M', StartDate))));//End date of 4 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('3M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 9 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth4 := DividendsProgression."Gross Tambaa Shares";

        //---------5th month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('4M', StartDate))), CalcDate('CM', (CalcDate('4M', StartDate))));//End date of 5 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('4M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 8 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth5 := DividendsProgression."Gross Tambaa Shares";

        //---------6th month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('5M', StartDate))), CalcDate('CM', (CalcDate('5M', StartDate))));//End date of 6 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('5M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 7 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth6 := DividendsProgression."Gross Tambaa Shares";

        //---------7th month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('6M', StartDate))), CalcDate('CM', (CalcDate('6M', StartDate))));//End date of 7 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('6M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 6 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth7 := DividendsProgression."Gross Tambaa Shares";

        //---------8th month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('7M', StartDate))), CalcDate('CM', (CalcDate('7M', StartDate))));//End date of 8 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('7M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 5 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth8 := DividendsProgression."Gross Tambaa Shares";


        //---------9th month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('8M', StartDate))), CalcDate('CM', (CalcDate('8M', StartDate))));//End date of 9 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('8M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 4 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth9 := DividendsProgression."Gross Tambaa Shares";

        //---------10th month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('9M', StartDate))), CalcDate('CM', (CalcDate('9M', StartDate))));//End date of 10 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('9M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 3 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth10 := DividendsProgression."Gross Tambaa Shares";

        //---------11th month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('10M', StartDate))), CalcDate('CM', (CalcDate('10M', StartDate))));//End date of 11 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('10M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 2 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth11 := DividendsProgression."Gross Tambaa Shares";

        //---------12th month
        QualifyingTambaaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Tamba Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('11M', StartDate))), CalcDate('CM', (CalcDate('11M', StartDate))));//End date of 12 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingTambaaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('11M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Tambaa Shares" := (QualifyingTambaaShares) * 1 / 12;
            DividendsProgression."Gross Tambaa Shares" := (DividendsProgression."Qualifying Tambaa Shares" * ((SaccoGenSetUp."Interest On TambaaShares") / 100));
            DividendsProgression."WTax-Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Tambaa Shares" := DividendsProgression."Gross Tambaa Shares" - DividendsProgression."WTax-Tambaa Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth12 := DividendsProgression."Gross Tambaa Shares";
        //4 Insert To GL's
        //A)GROSS
        TotalGross := 0;
        TotalGross := GrossMonth1 + GrossMonth2 + GrossMonth3 + GrossMonth4 + GrossMonth5 + GrossMonth6 + GrossMonth7 + GrossMonth8 + GrossMonth9 + GrossMonth10 + GrossMonth11 + GrossMonth12;
        //i)Bank Account
        SaccoGenSetUp.Get();
        SaccoGenSetUp.TestField(SaccoGenSetUp."Dividends Paying Bank Account");
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
        GenJournalLine."Account No." := SaccoGenSetUp."Dividends Paying Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Tambaa Shares Year-' + format(DATE2DMY((EndDate), 3)) + ' paid to-' + Format(No);
        GenJournalLine.Amount := TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //ii)Member Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Tambaa Shares Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //B)WTX
        SaccoGenSetUp.Get();
        if DivRegister."WTX -Current Shares" <> 0 then begin
            SaccoGenSetUp.TestField(SaccoGenSetUp."Withholding Tax Account");
        end;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Witholding Tax On-Gross Interest(Tambaa Shares) Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := TotalGross * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Withholding Tax Account";
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit(TotalGross);
    end;
    //----------------------------------------------------------------------------------------------
    local procedure FnProcessInterestEarnedOnPepeaShares(No: Code[20]; StartDate: Date; EndDate: Date; PepeaShares: Decimal): Decimal
    var
        QualifyingPepeaShares: Decimal;
        GrossMonth1: Decimal;
        GrossMonth2: Decimal;
        GrossMonth3: Decimal;
        GrossMonth4: Decimal;
        GrossMonth5: Decimal;
        GrossMonth6: Decimal;
        GrossMonth7: Decimal;
        GrossMonth8: Decimal;
        GrossMonth9: Decimal;
        GrossMonth10: Decimal;
        GrossMonth11: Decimal;
        GrossMonth12: Decimal;
        TotalGross: Decimal;
    begin
        //-----------------------1st month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', 0D, CalcDate('CM', StartDate));//End date of first month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', StartDate));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 12 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth1 := DividendsProgression."Gross Pepea Shares";
        //---------2nd month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('1M', StartDate))), CalcDate('CM', (CalcDate('1M', StartDate))));//End date of 2nd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('1M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 11 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth2 := DividendsProgression."Gross Pepea Shares";

        //---------3rd month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('2M', StartDate))), CalcDate('CM', (CalcDate('2M', StartDate))));//End date of 3rd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('2M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 10 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth3 := DividendsProgression."Gross Pepea Shares";

        //---------4th month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('3M', StartDate))), CalcDate('CM', (CalcDate('3M', StartDate))));//End date of 4 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('3M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 9 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth4 := DividendsProgression."Gross Pepea Shares";

        //---------5th month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('4M', StartDate))), CalcDate('CM', (CalcDate('4M', StartDate))));//End date of 5 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('4M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 8 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth5 := DividendsProgression."Gross Pepea Shares";

        //---------6th month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('5M', StartDate))), CalcDate('CM', (CalcDate('5M', StartDate))));//End date of 6 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('5M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 7 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth6 := DividendsProgression."Gross Pepea Shares";

        //---------7th month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('6M', StartDate))), CalcDate('CM', (CalcDate('6M', StartDate))));//End date of 7 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('6M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 6 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth7 := DividendsProgression."Gross Pepea Shares";

        //---------8th month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('7M', StartDate))), CalcDate('CM', (CalcDate('7M', StartDate))));//End date of 8 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('7M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 5 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth8 := DividendsProgression."Gross Pepea Shares";


        //---------9th month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('8M', StartDate))), CalcDate('CM', (CalcDate('8M', StartDate))));//End date of 9 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('8M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 4 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth9 := DividendsProgression."Gross Pepea Shares";

        //---------10th month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('9M', StartDate))), CalcDate('CM', (CalcDate('9M', StartDate))));//End date of 10 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('9M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 3 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth10 := DividendsProgression."Gross Pepea Shares";

        //---------11th month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('10M', StartDate))), CalcDate('CM', (CalcDate('10M', StartDate))));//End date of 11 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('10M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 2 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth11 := DividendsProgression."Gross Pepea Shares";

        //---------12th month
        QualifyingPepeaShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Pepea Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('11M', StartDate))), CalcDate('CM', (CalcDate('11M', StartDate))));//End date of 12 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingPepeaShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('11M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Pepea Shares" := (QualifyingPepeaShares) * 1 / 12;
            DividendsProgression."Gross Pepea Shares" := (DividendsProgression."Qualifying Pepea Shares" * ((SaccoGenSetUp."Interest On PepeaShares") / 100));
            DividendsProgression."WTax-Pepea Shares" := DividendsProgression."Gross Pepea Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Pepea Shares" := DividendsProgression."Gross Pepea Shares" - DividendsProgression."WTax-Pepea Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth12 := DividendsProgression."Gross Pepea Shares";
        //4 Insert To GL's
        //A)GROSS
        TotalGross := 0;
        TotalGross := GrossMonth1 + GrossMonth2 + GrossMonth3 + GrossMonth4 + GrossMonth5 + GrossMonth6 + GrossMonth7 + GrossMonth8 + GrossMonth9 + GrossMonth10 + GrossMonth11 + GrossMonth12;
        //i)Bank Account
        SaccoGenSetUp.Get();
        SaccoGenSetUp.TestField(SaccoGenSetUp."Dividends Paying Bank Account");
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
        GenJournalLine."Account No." := SaccoGenSetUp."Dividends Paying Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Pepea Shares Year-' + format(DATE2DMY((EndDate), 3)) + ' paid to-' + Format(No);
        GenJournalLine.Amount := TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //ii)Member Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Pepea Shares Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //B)WTX
        SaccoGenSetUp.Get();
        if DivRegister."WTX -Current Shares" <> 0 then begin
            SaccoGenSetUp.TestField(SaccoGenSetUp."Withholding Tax Account");
        end;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Witholding Tax On-Gross Interest(Pepea Shares) Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := TotalGross * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Withholding Tax Account";
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit(TotalGross);
    end;
    //-------------------------------------------------------------------------------------------------------------------
    local procedure FnProcessInterestEarnedOnHousingShares(No: Code[20]; StartDate: Date; EndDate: Date; Housing: Decimal): Decimal
    var
        QualifyingHousingShares: Decimal;
        GrossMonth1: Decimal;
        GrossMonth2: Decimal;
        GrossMonth3: Decimal;
        GrossMonth4: Decimal;
        GrossMonth5: Decimal;
        GrossMonth6: Decimal;
        GrossMonth7: Decimal;
        GrossMonth8: Decimal;
        GrossMonth9: Decimal;
        GrossMonth10: Decimal;
        GrossMonth11: Decimal;
        GrossMonth12: Decimal;
        TotalGross: Decimal;
    begin
        //-----------------------1st month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', 0D, CalcDate('CM', StartDate));//End date of first month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', StartDate));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 12 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth1 := DividendsProgression."Gross Housing Shares";
        //---------2nd month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('1M', StartDate))), CalcDate('CM', (CalcDate('1M', StartDate))));//End date of 2nd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('1M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 11 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth2 := DividendsProgression."Gross Housing Shares";

        //---------3rd month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('2M', StartDate))), CalcDate('CM', (CalcDate('2M', StartDate))));//End date of 3rd month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('2M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 10 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth3 := DividendsProgression."Gross Housing Shares";

        //---------4th month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('3M', StartDate))), CalcDate('CM', (CalcDate('3M', StartDate))));//End date of 4 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();

        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('3M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 9 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth4 := DividendsProgression."Gross Housing Shares";

        //---------5th month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('4M', StartDate))), CalcDate('CM', (CalcDate('4M', StartDate))));//End date of 5 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('4M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 8 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth5 := DividendsProgression."Gross Housing Shares";

        //---------6th month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('5M', StartDate))), CalcDate('CM', (CalcDate('5M', StartDate))));//End date of 6 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('5M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 7 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth6 := DividendsProgression."Gross Housing Shares";

        //---------7th month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('6M', StartDate))), CalcDate('CM', (CalcDate('6M', StartDate))));//End date of 7 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('6M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 6 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth7 := DividendsProgression."Gross Housing Shares";

        //---------8th month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('7M', StartDate))), CalcDate('CM', (CalcDate('7M', StartDate))));//End date of 8 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('7M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 5 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth8 := DividendsProgression."Gross Housing Shares";


        //---------9th month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('8M', StartDate))), CalcDate('CM', (CalcDate('8M', StartDate))));//End date of 9 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('8M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 4 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth9 := DividendsProgression."Gross Housing Shares";

        //---------10th month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('9M', StartDate))), CalcDate('CM', (CalcDate('9M', StartDate))));//End date of 10 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('9M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 3 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth10 := DividendsProgression."Gross Housing Shares";

        //---------11th month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('10M', StartDate))), CalcDate('CM', (CalcDate('10M', StartDate))));//End date of 11 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('10M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 2 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth11 := DividendsProgression."Gross Housing Shares";

        //---------12th month
        QualifyingHousingShares := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", No);
        CustLedgerEntry.SetRange(CustLedgerEntry."Transaction Type", CustLedgerEntry."Transaction Type"::"Housing Deposits Shares");
        CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', CalcDate('-CM', (CalcDate('11M', StartDate))), CalcDate('CM', (CalcDate('11M', StartDate))));//End date of 12 month
        IF CustLedgerEntry.FIND('-') then begin
            repeat
                QualifyingHousingShares += (CustLedgerEntry."Amount Posted") * -1;
            until CustLedgerEntry.next = 0;
        end;

        SaccoGenSetUp.Get();
        DividendsProgression.Reset();
        DividendsProgression.SetRange(DividendsProgression."Member No", No);
        DividendsProgression.SetRange(DividendsProgression."Dividend Year", format(DATE2DMY((EndDate), 3)));
        DividendsProgression.SetRange(DividendsProgression.Date, CalcDate('CM', (CalcDate('11M', StartDate))));
        IF DividendsProgression.Find('-') THEN begin
            DividendsProgression."Qualifying Housing Shares" := (QualifyingHousingShares) * 1 / 12;
            DividendsProgression."Gross Housing Shares" := (DividendsProgression."Qualifying Housing Shares" * ((SaccoGenSetUp."Interest On HousingShares") / 100));
            DividendsProgression."WTax-Housing Shares" := DividendsProgression."Gross Housing Shares" * (SaccoGenSetUp."Withholding Tax (%)" / 100);
            DividendsProgression."Net Housing Shares" := DividendsProgression."Gross Housing Shares" - DividendsProgression."WTax-Housing Shares";
            DividendsProgression.Modify(true);
        end;
        GrossMonth12 := DividendsProgression."Gross Housing Shares";
        //4 Insert To GL's
        //A)GROSS
        TotalGross := 0;
        TotalGross := GrossMonth1 + GrossMonth2 + GrossMonth3 + GrossMonth4 + GrossMonth5 + GrossMonth6 + GrossMonth7 + GrossMonth8 + GrossMonth9 + GrossMonth10 + GrossMonth11 + GrossMonth12;
        //i)Bank Account
        SaccoGenSetUp.Get();
        SaccoGenSetUp.TestField(SaccoGenSetUp."Dividends Paying Bank Account");
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
        GenJournalLine."Account No." := SaccoGenSetUp."Dividends Paying Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Housing Shares Year-' + format(DATE2DMY((EndDate), 3)) + ' paid to-' + Format(No);
        GenJournalLine.Amount := TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //ii)Member Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Gross Interest Earned On Housing Shares Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -TotalGross;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //B)WTX
        SaccoGenSetUp.Get();
        if DivRegister."WTX -Current Shares" <> 0 then begin
            SaccoGenSetUp.TestField(SaccoGenSetUp."Withholding Tax Account");
        end;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Witholding Tax On-Gross Interest(Housing Shares) Year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := TotalGross * (SaccoGenSetUp."Withholding Tax (%)" / 100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Withholding Tax Account";
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit(TotalGross);
    end;
    //*******************************************************************************************************************************************************************************

    local procedure FnCapitalizeDividendsAmount(NetDividendsPayableToMember: Decimal; No: Code[20]; EndDate: Date): Decimal
    begin
        SaccoGenSetUp.Get();
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Capitalized dividends year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := (NetDividendsPayableToMember * ((SaccoGenSetUp."Dividends Capitalization Rate") / 100));
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //--
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Capitalized dividends year-' + format(DATE2DMY((EndDate), 3));
        GenJournalLine.Amount := -(NetDividendsPayableToMember * ((SaccoGenSetUp."Dividends Capitalization Rate") / 100));
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Pepea Shares";
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        exit((NetDividendsPayableToMember * ((SaccoGenSetUp."Dividends Capitalization Rate") / 100)));
    end;

    local procedure FnTransferNetDividendToFOSA(arg: Decimal; No: Code[20]; EndDate: Date): Decimal
    begin
        //Withdrawal from member dividend account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := No;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Net Dividends Year-' + format(DATE2DMY((EndDate), 3)) + ' TO Fosa Account';
        GenJournalLine.Amount := arg;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Dividend;
        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //Credit MemberFOSA Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DIVIDEND';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
        GenJournalLine."Account No." := FnGetMemberFOSAAc(No);
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Net Dividends Year-' + format(DATE2DMY((EndDate), 3)) + 'earned';
        GenJournalLine.Amount := -arg;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //..............................Modify the dividends register with the Net Amount Transfered To FOSA
        DivRegister.Reset();
        DivRegister.SetRange(DivRegister."Member No", No);
        DivRegister.SetRange(DivRegister."Dividend Year", format(DATE2DMY((EndDate), 3)));
        if DivRegister.Find('-') = true then begin
            DivRegister."Net Pay To FOSA" := (arg);
            DivRegister.Modify(true);
        end;
        exit(arg);

    end;


    local procedure FnGetMemberBranchCode(No: Code[20]): Code[20]
    begin
        MemberRegister.reset;
        MemberRegister.SetRange(MemberRegister."No.", No);
        if MemberRegister.Find('-') then begin
            exit(MemberRegister."Global Dimension 2 Code");
        end;
    end;

    local procedure FnGetMemberFOSAAc(No: Code[20]): Code[20]
    var
        VendorAccount: Record Vendor;
    begin
        VendorAccount.Reset();
        VendorAccount.SetRange(VendorAccount."BOSA Account No", No);
        VendorAccount.SetRange(VendorAccount."Account Type", 'ORDINARY');
        if VendorAccount.Find('-') then begin
            exit(VendorAccount."No.");
        end;
    end;

    local procedure FnOutstandingDivLoanIntBal(No: Code[20]): Decimal
    var
        LoansReg: Record "Loans Register";
    begin
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Client Code", No);
        LoansReg.SetRange(LoansReg."Loan Product Type", 'DIVIDEND');
        LoansReg.SetAutoCalcFields(LoansReg."Oustanding Interest");
        LoansReg.SetFilter(LoansReg."Oustanding Interest", '>%1', 0);
        IF LoansReg.Find('-') = true THEN begin
            exit(LoansReg."Oustanding Interest");
        end ELSE
            IF LoansReg.Find('-') = false THEN begin
                exit(0);
            end;
    end;

    local procedure FnRecoverOutstDivInterest(No: Code[20]; NetTransferToFOSA: Decimal; EndDate: Date): Decimal
    var
        LoansReg: Record "Loans Register";
        AmountDeducted: Decimal;
    begin
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Client Code", No);
        LoansReg.SetRange(LoansReg."Loan Product Type", 'DIVIDEND');
        LoansReg.SetAutoCalcFields(LoansReg."Oustanding Interest");
        LoansReg.SetFilter(LoansReg."Oustanding Interest", '>%1', 0);
        AmountDeducted := 0;
        IF LoansReg.Find('-') = true THEN begin
            if LoansReg."Oustanding Interest" >= NetTransferToFOSA then begin
                AmountDeducted := NetTransferToFOSA;
            end else
                if LoansReg."Oustanding Interest" < NetTransferToFOSA then begin
                    AmountDeducted := LoansReg."Oustanding Interest";
                end;
            //Deduct Member FOSA Account
            LineNo := LineNo + 10000;
            GenJournalLine.Init;
            GenJournalLine."Journal Template Name" := 'GENERAL';
            GenJournalLine."Journal Batch Name" := 'DIVIDEND';
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
            GenJournalLine."Account No." := FnGetMemberFOSAAc(No);
            GenJournalLine.Validate(GenJournalLine."Account No.");
            GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
            GenJournalLine."Posting Date" := Today;
            GenJournalLine.Description := 'Recovered Dividend Advance Interest-' + format(LoansReg."Loan  No.");
            GenJournalLine.Amount := AmountDeducted;
            GenJournalLine.Validate(GenJournalLine.Amount);
            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
            GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
            if GenJournalLine.Amount <> 0 then
                GenJournalLine.Insert;

            LineNo := LineNo + 10000;
            GenJournalLine.Init;
            GenJournalLine."Journal Template Name" := 'GENERAL';
            GenJournalLine."Journal Batch Name" := 'DIVIDEND';
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
            GenJournalLine."Account No." := No;
            GenJournalLine.Validate(GenJournalLine."Account No.");
            GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
            GenJournalLine."Posting Date" := Today;
            GenJournalLine.Description := 'Recovered Dividend Advance Interest from dividends year-' + format(DATE2DMY((EndDate), 3));
            GenJournalLine.Amount := -AmountDeducted;
            GenJournalLine.Validate(GenJournalLine.Amount);
            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";
            GenJournalLine."Loan No" := LoansReg."Loan  No.";
            GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
            GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
            if GenJournalLine.Amount <> 0 then
                GenJournalLine.Insert;
        end;
        exit(NetTransferToFOSA - AmountDeducted);
    end;

    local procedure FnRecoverOutstDivBal(No: Code[20]; RunningBalance: Decimal; EndDate: Date)
    var
        LoansReg: Record "Loans Register";
        AmountDeducted: Decimal;
    begin
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Client Code", No);
        LoansReg.SetRange(LoansReg."Loan Product Type", 'DIVIDEND');
        LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance");
        LoansReg.SetFilter(LoansReg."Outstanding Balance", '>%1', 0);
        AmountDeducted := 0;
        IF LoansReg.Find('-') = true THEN begin
            if LoansReg."Outstanding Balance" >= NetTransferToFOSA then begin
                AmountDeducted := NetTransferToFOSA;
            end else
                if LoansReg."Outstanding Balance" < NetTransferToFOSA then begin
                    AmountDeducted := LoansReg."Outstanding Balance";
                end;
            //Deduct Member FOSA Account
            LineNo := LineNo + 10000;
            GenJournalLine.Init;
            GenJournalLine."Journal Template Name" := 'GENERAL';
            GenJournalLine."Journal Batch Name" := 'DIVIDEND';
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
            GenJournalLine."Account No." := FnGetMemberFOSAAc(No);
            GenJournalLine.Validate(GenJournalLine."Account No.");
            GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
            GenJournalLine."Posting Date" := Today;
            GenJournalLine.Description := 'Recovered Dividend Advance Principle-' + format(LoansReg."Loan  No.");
            GenJournalLine.Amount := AmountDeducted;
            GenJournalLine.Validate(GenJournalLine.Amount);
            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
            GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
            if GenJournalLine.Amount <> 0 then
                GenJournalLine.Insert;

            LineNo := LineNo + 10000;
            GenJournalLine.Init;
            GenJournalLine."Journal Template Name" := 'GENERAL';
            GenJournalLine."Journal Batch Name" := 'DIVIDEND';
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
            GenJournalLine."Account No." := No;
            GenJournalLine.Validate(GenJournalLine."Account No.");
            GenJournalLine."Document No." := format(DATE2DMY((EndDate), 3)) + 'DIVIDEND';
            GenJournalLine."Posting Date" := Today;
            GenJournalLine.Description := 'Recovered Dividend Advance Principle from dividends year-' + format(DATE2DMY((EndDate), 3));
            GenJournalLine.Amount := -AmountDeducted;
            GenJournalLine.Validate(GenJournalLine.Amount);
            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
            GenJournalLine."Loan No" := LoansReg."Loan  No.";
            GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
            GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranchCode(No);
            if GenJournalLine.Amount <> 0 then
                GenJournalLine.Insert;
        end;
    end;
}

