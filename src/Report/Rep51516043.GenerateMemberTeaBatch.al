#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516043 "Generate Member Tea Batch"
{
    ProcessingOnly = true;
    dataset
    {
        dataitem("Periodics Processing Lines"; "Periodics Processing Lines")
        {
            DataItemTableView = sorting("Document No") where(posted = const(false));
            RequestFilterFields = "Document No";
            column(Document_No; "Document No")
            {
            }
            trigger OnPreDataItem()
            begin
                IF IssueDate = 0D THEN
                    ERROR('You must specify the last issue date.');

                STORegister.RESET;
                STORegister.SETRANGE(STORegister."Document No.", PostingDocumentNo);
                STORegister.SETRANGE(STORegister.Date, PostingDate);
                STORegister.SETRANGE(STORegister."Transfered to EFT", FALSE);
                IF STORegister.FIND('-') THEN begin
                    STORegister.DELETEALL;
                end;

                IF FundsUser.GET(USERID) THEN BEGIN
                    FundsUser.TESTFIELD(FundsUser."Salaries Template");
                    FundsUser.TESTFIELD(FundsUser."Salaries Batch");
                    BATCH_TEMPLATE := FundsUser."Salaries Template";
                    BATCH_NAME := FundsUser."Salaries Batch";

                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", BATCH_TEMPLATE);
                    GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", BATCH_NAME);
                    IF GenJournalLine.FINDSET THEN BEGIN
                        GenJournalLine.DELETEALL;
                    END;
                    //--------------------------------
                    SaccoGenSetUp.GET();
                    ExciseFee := 0;
                    ProcFee := 0;
                    IF Charges.GET('TEA') THEN BEGIN
                        ProcGLAccount := Charges."GL Account";
                    END;
                    IF Charges.GET('TEAPAY') THEN BEGIN
                        TeaPayGLAccount := Charges."GL Account";
                    END;
                END else begin
                    Error('Restricted, No user batch is allocated to your user id');
                end;
            END;

            trigger OnAfterGetRecord()
            var
                DialogBox: Dialog;
                TotalCount: Integer;
                ReachedNo: Integer;//597218.80
            begin
                PeriodicProcessingLines.Reset();
                PeriodicProcessingLines.SetRange(PeriodicProcessingLines."Document No", "Periodics Processing Lines"."Document No");
                PeriodicProcessingLines.SetAutoCalcFields(PeriodicProcessingLines."Total Amount", PeriodicProcessingLines."No. Of Counts");
                PeriodicProcessingLines.SetRange(PeriodicProcessingLines."No. Of Counts", 1);
                TotalCount := 0;
                TotalCount := PeriodicProcessingLines.Count();
                ReachedNo := 0;
                PeriodicProcessingLines.SetRange(PeriodicProcessingLines."Account No", "Periodics Processing Lines"."Account No");
                if PeriodicProcessingLines.Find('-') then begin
                    repeat
                        //......determine if is the first in entry number if greater than 1
                        // if (PeriodicProcessingLines."No. Of Counts" > 1) and (FnIsFirstEntry(PeriodicProcessingLines."Entry No", PeriodicProcessingLines."Account No", PeriodicProcessingLines."Document No") = false) then
                        //     CurrReport.Skip();
                        //.......................Insert entries
                        if VendorTable.get(PeriodicProcessingLines."Account No") then begin
                            DActivity := VendorTable."Global Dimension 1 Code";
                            DBranch := VendorTable."Global Dimension 2 Code";
                            //...............Insert Tea Lines To GL
                            NetAmountPaidToMember := 0;
                            NetAmountPaidToMember := FnProcessMemberEntriesToGL(PeriodicProcessingLines."Total Amount", PeriodicProcessingLines."Account No", PostingDocumentNo, PostingDate, DActivity, DBranch, ExciseFee, ProcFee);
                            //...............Check Account Balance
                            AvailableBal := 0;
                            VendorTable.CalcFields(VendorTable."FOSA Balance", VendorTable."Uncleared Cheques", VendorTable."ATM Transactions");
                            AvailableBal := (VendorTable."FOSA Balance" - (VendorTable."Uncleared Cheques" + VendorTable."ATM Transactions"));
                            if VendorAccountTypes.Get(VendorTable."Account Type") then begin
                                AvailableBal := AvailableBal - VendorAccountTypes."Minimum Balance";
                            end;
                            //..............New Account Balance plus salary net amount
                            AvailableBal := AvailableBal + NetAmountPaidToMember;

                            //..............
                            if AvailableBal < 0 then begin
                                AvailableBal := 0;
                            end;
                            //...............Recover Interest On Loans
                            //(Overdraft)
                            if AvailableBal > 0 then begin
                                BalanceAfterInterestRecovery := 0;
                                BalanceAfterInterestRecovery := AvailableBal;
                                BalanceAfterInterestRecovery := FnRecoverMemberInterestOnOverdraft(BalanceAfterInterestRecovery, PeriodicProcessingLines."Account No", PostingDocumentNo, PostingDate, DActivity, DBranch, VendorTable."BOSA Account No");
                            end;
                            //(Other Loans)
                            if BalanceAfterInterestRecovery > 0 then begin
                                BalanceAfterInterestRecovery := FnRecoverMemberInterestOnLoans(BalanceAfterInterestRecovery, PeriodicProcessingLines."Account No", PostingDocumentNo, PostingDate, DActivity, DBranch, VendorTable."BOSA Account No");

                            end;
                            //...............Recover Principal
                            //Overdraft
                            if BalanceAfterInterestRecovery > 0 then begin
                                BalanceAfterPrincipleRecovery := 0;
                                BalanceAfterPrincipleRecovery := BalanceAfterInterestRecovery;
                                BalanceAfterPrincipleRecovery := FnRecoverMemberPrincipleOnOverdraft(BalanceAfterPrincipleRecovery, PeriodicProcessingLines."Account No", PostingDocumentNo, PostingDate, DActivity, DBranch, VendorTable."BOSA Account No");

                            end;
                            //Other Loans
                            if BalanceAfterPrincipleRecovery > 0 then begin
                                BalanceAfterPrincipleRecovery := FnRecoverMemberPrincipleOnLoans(BalanceAfterPrincipleRecovery, PeriodicProcessingLines."Account No", PostingDocumentNo, PostingDate, DActivity, DBranch, VendorTable."BOSA Account No");

                            end;
                            //................Process Standing orders
                            if BalanceAfterPrincipleRecovery > 0 then begin
                                BalanceAfterStandingOrderRecovery := 0;
                                BalanceAfterStandingOrderRecovery := BalanceAfterPrincipleRecovery;
                                BalanceAfterStandingOrderRecovery := FnRecoverMemberStandingOrders(BalanceAfterPrincipleRecovery, PeriodicProcessingLines."Account No", PostingDocumentNo, PostingDate, DActivity, DBranch, VendorTable."BOSA Account No");
                            end;
                        end;
                    until PeriodicProcessingLines.Next = 0;
                end;
                //DialogBox.Close();
            end;

        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(IssueDate; IssueDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Last Loans Issue Date';
                    ShowMandatory = true;
                }
                field(BalanceCutOffDate; BalanceCutOffDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Balance CutOf fDate';
                    ShowMandatory = true;
                }
                field(DontChargeProcFee; DontChargeProcFee)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dont Charge Processing Fee';
                }
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
        //............................Get Document No Used In Filter
        FilterDocNo := '';
        FilterDocNo := "Periodics Processing Lines".GetFilter("Periodics Processing Lines"."Document No");
        if FilterDocNo = '' then begin
            Error('The document No used in Page Is Required');
        end;
        PostingDocumentNo := FnGetPostingDocumentNo(FilterDocNo);//Get the document Posting No
        PostingDate := FnGetThePostingDate(FilterDocNo);//Get the 
    end;

    trigger OnInitReport()
    begin

    end;

    trigger OnPostReport()
    begin
        Message('Successfully Generated');
    end;

    var
        FilterDocNo: code[100];
        PostingDate: date;
        DActivity: Code[50];
        NetAmountPaidToMember: Decimal;
        AvailableBal: Decimal;
        DBranch: Code[50];
        BalanceAfterInterestRecovery: Decimal;
        SaccoGenSetUp: Record "Sacco General Set-Up";
        FundsUser: Record "Funds User Setup";
        STORegister: Record "Standing Order Register";
        GenJournalLine: Record "Gen. Journal Line";
        IssueDate: date;
        ProcFee: Decimal;
        TeaPayGLAccount: code[50];
        VendorAccountTypes: record "Account Types-Saving Products";
        VendorTable: Record Vendor;
        BalanceCutOffDate: date;
        DontChargeProcFee: Boolean;
        BATCH_TEMPLATE: Code[100];
        BATCH_NAME: Code[100];
        LineNo: Integer;

        PostingDocumentNo: Code[100];
        BalanceAfterPrincipleRecovery: Decimal;
        PeriodicProcessingHeader: Record "Periodics Processing Header";
        SalFee: Decimal;
        BalanceAfterStandingOrderRecovery: Decimal;
        StandingOrderRegister: Record "Standing Order Register";
        StandingOrders: record "Standing Orders";
        ExciseFee: Decimal;
        Charges: Record Charges;
        ProcGLAccount: Code[100];
        PeriodicProcessingLines: Record "Periodics Processing Lines";

    local procedure FnGetPostingDocumentNo(FilterDocNo: Code[100]): Code[100]
    begin
        PeriodicProcessingHeader.Reset();
        PeriodicProcessingHeader.SetRange(PeriodicProcessingHeader."Document No", FilterDocNo);
        if PeriodicProcessingHeader.Find('-') = true then begin
            exit(PeriodicProcessingHeader."Posting Document No");
        end else
            if PeriodicProcessingHeader.Find('-') = false then begin
                Error('Please Specify the Posting Document No on page header');
            end;
    end;

    local procedure FnGetThePostingDate(FilterDocNo: Code[100]): Date
    begin
        PeriodicProcessingHeader.Reset();
        PeriodicProcessingHeader.SetRange(PeriodicProcessingHeader."Document No", FilterDocNo);
        if PeriodicProcessingHeader.Find('-') = true then begin
            exit(PeriodicProcessingHeader."Posting Date");
        end else
            if PeriodicProcessingHeader.Find('-') = false then begin
                Error('Please Specify the Posting Date No on page header');
            end;
    end;

    local procedure FnProcessMemberEntriesToGL(Amount: Decimal; AccountNo: Code[100]; PostingDocumentNo: Code[100]; PostingDate: Date; DActivity: Code[50]; DBranch: Code[50]; ExciseFee: Decimal; ProcFee: Decimal): Decimal
    var
        NetPay: Decimal;
        TeaCommissions: Record "Tea Commissions";
    begin
        NetPay := 0;
        //..............................Tea Gross
        LineNo := LineNo + 1000;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
        GenJournalLine."Journal Batch Name" := BATCH_NAME;
        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Document No." := PostingDocumentNo;
        GenJournalLine."External Document No." := PostingDocumentNo;
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine.Description := 'Tea Processed ' + Format(PostingDocumentNo);
        GenJournalLine.Amount := -Amount;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        NetPay := (GenJournalLine.Amount) * -1;
        //................................Tea Processing Fee
        //...............Get processing charges graduated
        SaccoGenSetUp.Get();
        ExciseFee := 0;
        ProcFee := 0;
        TeaCommissions.Reset();
        if TeaCommissions.Find('-') then begin
            repeat
                if (NetPay >= TeaCommissions."Lower Bound") and (NetPay <= TeaCommissions."Upper Bound") then begin
                    ProcFee := TeaCommissions.Charge;
                    ExciseFee := ProcFee * (SaccoGenSetUp."Excise Duty(%)" / 100);
                end;
            until TeaCommissions.Next = 0;
        end;
        //...............Get processing charges graduated
        LineNo := LineNo + 1000;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
        GenJournalLine."Journal Batch Name" := BATCH_NAME;
        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Document No." := PostingDocumentNo;
        GenJournalLine."External Document No." := PostingDocumentNo;
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine.Description := 'Tea Processing Fee ' + Format(PostingDocumentNo);
        GenJournalLine.Amount := ProcFee;
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := ProcGLAccount;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        NetPay := NetPay - (GenJournalLine.Amount);
        //...............................Excise Duty
        LineNo := LineNo + 1000;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
        GenJournalLine."Journal Batch Name" := BATCH_NAME;
        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Document No." := PostingDocumentNo;
        GenJournalLine."External Document No." := PostingDocumentNo;
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine.Description := 'Excise Duty Fee ' + Format(PostingDocumentNo);
        GenJournalLine.Amount := ExciseFee;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        SaccoGenSetUp.get();
        GenJournalLine."Bal. Account No." := SaccoGenSetUp."Excise Duty Account";
        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        //.................Exit With The Net Pay
        NetPay := NetPay - (GenJournalLine.Amount);
        exit(NetPay);
    end;


    local procedure FnRecoverMemberInterestOnLoans(AvailableBal: Decimal; AccountNo: Code[100]; PostingDocumentNo: Code[100]; PostingDate: Date; DActivity: Code[50]; DBranch: Code[50]; BOSAAccountNo: Code[20]): Decimal
    var
        LoansRegister: Record "Loans Register";
        InterestToRecover: Decimal;
        MemberBalanceAfterInterestPay: Decimal;
    begin
        InterestToRecover := 0;
        MemberBalanceAfterInterestPay := 0;
        MemberBalanceAfterInterestPay := AvailableBal;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Client Code", BOSAAccountNo);
        LoansRegister.SetFilter(LoansRegister."Loan Disbursement Date", '..' + Format(IssueDate));
        LoansRegister.SetRange(LoansRegister."Recovery Mode", LoansRegister."Recovery Mode"::Tea);
        LoansRegister.SetFilter(LoansRegister."Loan Product Type", '<>%1', 'OVERDRAFT');
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest", LoansRegister."Interest Paid", LoansRegister."Principal Paid");
        if LoansRegister.Find('-') then begin
            repeat
                if MemberBalanceAfterInterestPay > 0 then begin
                    if LoansRegister."Oustanding Interest" > 0 then begin
                        if (LoansRegister."Loan Product Type" = 'OVERDRAFT') or (LoansRegister.Source = LoansRegister.Source::MICRO) OR (LoansRegister."Loan Product Type" = 'OKOA') THEN begin
                            InterestToRecover := 0;
                            InterestToRecover := FnGetInterestScheduled(LoansRegister."Loan  No.", LoansRegister."Interest Paid", LoansRegister."Client Code")
                        end else begin
                            InterestToRecover := 0;
                            if LoansRegister."Oustanding Interest" > 0 then begin
                                InterestToRecover := LoansRegister."Oustanding Interest";
                            end
                        end;
                        if LoansRegister."Oustanding Interest" <= 0 then begin
                            InterestToRecover := LoansRegister."Oustanding Interest";
                        end;
                        //..................Recovery Interest Lines
                        //********Cr Loan Account
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."Account No." := LoansRegister."Client Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Posting Date" := PostingDate;
                        GenJournalLine.Description := 'Interest Paid';
                        IF MemberBalanceAfterInterestPay > InterestToRecover then
                            GenJournalLine.Amount := InterestToRecover * -1
                        ELSE
                            GenJournalLine.Amount := MemberBalanceAfterInterestPay * -1;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        //********Dr Vendor Account
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."Account No." := AccountNo;
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Posting Date" := PostingDate;
                        GenJournalLine.Description := 'Interest Paid to -' + Format(LoansRegister."Loan  No.") + '-' + LoansRegister."Loan Product Type";
                        IF MemberBalanceAfterInterestPay > InterestToRecover THEN
                            GenJournalLine.Amount := InterestToRecover
                        ELSE
                            GenJournalLine.Amount := MemberBalanceAfterInterestPay;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        //..................Reset Member Balance
                        MemberBalanceAfterInterestPay := MemberBalanceAfterInterestPay - GenJournalLine.Amount;
                    end;
                end;
            until LoansRegister.Next = 0;
        end;
        exit(MemberBalanceAfterInterestPay);
    end;

    local procedure FnGetInterestScheduled(LoanNo: Code[30]; InterestPaid: Decimal; ClientCode: Code[50]): Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedInterestToDate: Decimal;
        InterestToRecover: Decimal;
        CUSTLEDGER: Record "Cust. Ledger Entry";
        PaidAmount: Decimal;
    begin
        ExpectedInterestToDate := 0;
        InterestToRecover := 0;
        PaidAmount := 0;
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange(LoanRepaymentSchedule."Loan No.", LoanNo);
        LoanRepaymentSchedule.SetFilter(LoanRepaymentSchedule."Repayment Date", '..' + Format(CalcDate('CM', Today)));
        if LoanRepaymentSchedule.Find('-') then begin
            repeat
                ExpectedInterestToDate += LoanRepaymentSchedule."Monthly Interest";
            until LoanRepaymentSchedule.Next = 0;
        end;
        //........................
        // CUSTLEDGER.Reset();
        // CUSTLEDGER.SetRange(CUSTLEDGER."Customer No.", ClientCode);
        // CUSTLEDGER.SetRange(CUSTLEDGER."Loan No", LoanNo);
        // CUSTLEDGER.SetRange(CUSTLEDGER.Reversed, false);
        // CUSTLEDGER.SetRange(CUSTLEDGER."Transaction Type", CUSTLEDGER."Transaction Type"::"Interest Paid");
        // if CUSTLEDGER.Find('-') then begin
        //     repeat
        //         PaidAmount += (CUSTLEDGER."Amount Posted") * -1;
        //     until CUSTLEDGER.Next = 0;
        // end;
        //........................
        InterestToRecover := ExpectedInterestToDate - (InterestPaid * -1);
        if InterestToRecover > 0 then begin
            exit(InterestToRecover);
        end else
            if InterestToRecover <= 0 then begin
                exit(0);
            end;
    end;

    local procedure FnRecoverMemberPrincipleOnLoans(BalanceAfterPrincipleRecovery: Decimal; AccountNo: Code[100]; PostingDocumentNo: Code[100]; PostingDate: Date; DActivity: Code[50]; DBranch: Code[50]; BOSAAccountNo: Code[20]): Decimal
    var
        LoansRegister: Record "Loans Register";
        PrincipleToRecover: Decimal;
        MemberBalanceAfterPrinciplePay: Decimal;
    begin
        PrincipleToRecover := 0;
        MemberBalanceAfterPrinciplePay := 0;
        MemberBalanceAfterPrinciplePay := BalanceAfterPrincipleRecovery;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Client Code", BOSAAccountNo);
        LoansRegister.SetRange(LoansRegister."Recovery Mode", LoansRegister."Recovery Mode"::Tea);
        LoansRegister.SetFilter(LoansRegister."Loan Product Type", '<>%1', 'OVERDRAFT');
        LoansRegister.SetFilter(LoansRegister."Loan Disbursement Date", '..' + Format(IssueDate));
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest", LoansRegister."Principal Paid");
        if LoansRegister.Find('-') then begin
            repeat
                if MemberBalanceAfterPrinciplePay > 0 then begin
                    if LoansRegister."Outstanding Balance" > 0 then begin
                        if (LoansRegister."Loan Product Type" = 'OVERDRAFT') OR (LoansRegister."Loan Product Type" = 'OKOA') THEN begin
                            PrincipleToRecover := 0;
                            PrincipleToRecover := LoansRegister."Loan Principle Repayment";
                        end else begin
                            PrincipleToRecover := 0;
                            PrincipleToRecover := LoansRegister."Loan Principle Repayment";
                        end;
                        //********Cr Loan Account
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."Account No." := LoansRegister."Client Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Posting Date" := PostingDate;
                        GenJournalLine.Description := 'Loan Principle Paid';
                        IF MemberBalanceAfterPrinciplePay > PrincipleToRecover then
                            GenJournalLine.Amount := PrincipleToRecover * -1
                        ELSE
                            GenJournalLine.Amount := MemberBalanceAfterPrinciplePay * -1;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        //********Dr Vendor Account
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."Account No." := AccountNo;
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Posting Date" := PostingDate;
                        GenJournalLine.Description := 'Principle repayment Paid to -' + Format(LoansRegister."Loan  No.") + '-' + LoansRegister."Loan Product Type";
                        IF MemberBalanceAfterPrinciplePay > PrincipleToRecover THEN
                            GenJournalLine.Amount := PrincipleToRecover
                        ELSE
                            GenJournalLine.Amount := MemberBalanceAfterPrinciplePay;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        //..................Reset Member Balance
                        MemberBalanceAfterPrinciplePay := MemberBalanceAfterPrinciplePay - GenJournalLine.Amount;
                    end;
                end;
            until LoansRegister.Next = 0;
        end;
        exit(MemberBalanceAfterPrinciplePay);
    end;

    local procedure FnGetPrincipleScheduled(LoanNo: Code[30]; PrincipalPaid: Decimal; ClientCode: Code[50]): Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedPrincipleToDate: Decimal;
        PrincipleToRecover: Decimal;
        CUSTLEDGER: Record "Cust. Ledger Entry";
        PaidAmount: Decimal;
    begin
        PaidAmount := 0;
        ExpectedPrincipleToDate := 0;
        PrincipleToRecover := 0;
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange(LoanRepaymentSchedule."Loan No.", LoanNo);
        LoanRepaymentSchedule.SetFilter(LoanRepaymentSchedule."Repayment Date", '%1..%2', 0D, (CalcDate('CM', Today)));
        if LoanRepaymentSchedule.Find('-') then begin
            repeat
                ExpectedPrincipleToDate += LoanRepaymentSchedule."Principal Repayment";
            until LoanRepaymentSchedule.Next = 0;
        end;
        CUSTLEDGER.Reset();
        CUSTLEDGER.SetRange(CUSTLEDGER."Customer No.", ClientCode);
        CUSTLEDGER.SetRange(CUSTLEDGER."Loan No", LoanNo);
        CUSTLEDGER.SetRange(CUSTLEDGER.Reversed, false);
        CUSTLEDGER.SetRange(CUSTLEDGER."Transaction Type", CUSTLEDGER."Transaction Type"::Repayment);
        if CUSTLEDGER.Find('-') then begin
            repeat
                PaidAmount += (CUSTLEDGER."Amount Posted") * -1;
            until CUSTLEDGER.Next = 0;
        end;
        PrincipleToRecover := ExpectedPrincipleToDate - PaidAmount;
        if PrincipleToRecover > 0 then begin
            exit(PrincipleToRecover);
        end else
            if PrincipleToRecover <= 0 then begin
                exit(0);
            end;
    end;

    local procedure FnRecoverMemberStandingOrders(BalanceAfterPrincipleRecovery: Decimal; AccountNo: Code[100]; PostingDocumentNo: Code[100]; PostingDate: Date; DActivity: Code[50]; DBranch: Code[50]; BOSAAccountNo: Code[20]): Decimal
    var
        StandingOrderRegister: Record "Standing Order Register";
        StandingOrders: record "Standing Orders";
        AmountDed: Decimal;
        DedStatus: enum "STO Status";
        ActualSTO: Decimal;
        RunBal: Decimal;
        AccountTypeS: Record "Account Types-Saving Products";
        ChargeAmount: Decimal;
    begin
        AmountDed := 0;
        StandingOrders.Effected := FALSE;
        StandingOrders.Unsuccessfull := FALSE;
        StandingOrders.Balance := 0;
        StandingOrders.Reset();
        StandingOrders.SetRange(StandingOrders."Source Account No.", AccountNo);
        StandingOrders.SetRange(StandingOrders.Status, StandingOrders.Status::Approved);
        StandingOrders.SetRange(StandingOrders."Income Type", StandingOrders."Income Type"::Tea);
        if StandingOrders.Find('-') then begin
            repeat
                Charges.RESET;
                IF StandingOrders."Destination Account Type" = StandingOrders."Destination Account Type"::External then begin
                    Charges.SETRANGE(Charges."Charge Type", Charges."Charge Type"::"External Standing Order Fee")
                end
                ELSE
                    Charges.SETRANGE(Charges."Charge Type", Charges."Charge Type"::"Standing Order Fee");
                IF Charges.FIND('-') THEN BEGIN
                    BalanceAfterPrincipleRecovery := BalanceAfterPrincipleRecovery - Charges."Charge Amount";
                END;
                //..............................
                IF StandingOrders."Next Run Date" = 0D THEN begin
                    StandingOrders."Next Run Date" := StandingOrders."Effective/Start Date";
                end;
                //..............................StandingOrders
                IF BalanceAfterPrincipleRecovery >= StandingOrders.Amount THEN BEGIN
                    AmountDed := StandingOrders.Amount;
                    DedStatus := DedStatus::Successfull;
                    IF StandingOrders.Amount >= StandingOrders.Balance THEN BEGIN
                        StandingOrders.Balance := 0;
                        StandingOrders.Unsuccessfull := FALSE;
                    END ELSE BEGIN
                        StandingOrders.Balance := StandingOrders.Balance - StandingOrders.Amount;
                        StandingOrders.Unsuccessfull := TRUE;
                    END;
                END ELSE BEGIN
                    IF StandingOrders."Don't Allow Partial Deduction" = TRUE THEN BEGIN
                        AmountDed := 0;
                        DedStatus := DedStatus::Failed;
                        StandingOrders.Balance := StandingOrders.Amount;
                        StandingOrders.Unsuccessfull := TRUE;

                    END ELSE BEGIN
                        AmountDed := AvailableBal;
                        DedStatus := DedStatus::"Partial Deduction";
                        StandingOrders.Balance := StandingOrders.Amount - AmountDed;
                        StandingOrders.Unsuccessfull := TRUE;
                    END;
                END;
                IF AmountDed < 0 THEN BEGIN
                    AmountDed := 0;
                    DedStatus := DedStatus::Failed;

                    StandingOrders.Balance := StandingOrders.Amount;
                    StandingOrders.Unsuccessfull := TRUE;
                END;
                //..........................................
                IF AmountDed > 0 THEN BEGIN
                    ActualSTO := 0;
                    IF StandingOrders."Destination Account Type" = StandingOrders."Destination Account Type"::BOSA THEN BEGIN
                        ActualSTO := PostBOSAEntries(AmountDed, StandingOrders."No.", StandingOrders."BOSA Account No.", ActualSTO);//448
                        AmountDed := ActualSTO;
                    END;
                    LineNo := LineNo + 10000;

                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                    GenJournalLine."Journal Batch Name" := BATCH_NAME;
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                    GenJournalLine."Document No." := PostingDocumentNo;
                    GenJournalLine."External Document No." := StandingOrders."Destination Account No.";
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Account No." := StandingOrders."Source Account No.";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date" := PostingDate;
                    GenJournalLine.Description := 'Standing Order ' + StandingOrders."No.";
                    GenJournalLine.Amount := AmountDed;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    RunBal := BalanceAfterPrincipleRecovery;
                    RunBal := RunBal - AmountDed;

                    IF StandingOrders."Destination Account Type" <> StandingOrders."Destination Account Type"::BOSA THEN BEGIN

                        LineNo := LineNo + 10000;

                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."External Document No." := StandingOrders."Source Account No.";
                        IF StandingOrders."Destination Account Type" = StandingOrders."Destination Account Type"::Internal THEN BEGIN
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                            GenJournalLine."Account No." := StandingOrders."Destination Account No.";
                        END ELSE BEGIN
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                            AccountTypeS.get();
                            GenJournalLine."Account No." := AccountTypeS."Standing Orders Suspense";
                        END;
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := TODAY;
                        GenJournalLine.Description := 'Standing Order ' + StandingOrders."No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                        GenJournalLine.Amount := -AmountDed;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;

                    END;

                END;
                //Standing Order Charges
                IF AmountDed > 0 THEN BEGIN
                    Charges.RESET;
                    ChargeAmount := 0;
                    Charges.GET('STO');
                    Charges.RESET;
                    IF StandingOrders."Destination Account Type" = StandingOrders."Destination Account Type"::External THEN
                        Charges.SETRANGE(Charges."Charge Type", Charges."Charge Type"::"External Standing Order Fee")
                    ELSE
                        Charges.SETRANGE(Charges."Charge Type", Charges."Charge Type"::"Standing Order Fee");
                    IF Charges.FIND('-') THEN BEGIN
                        ChargeAmount := Charges."Charge Amount";
                    END;
                    IF (Charges."Charge Type" = Charges."Charge Type"::"Standing Order Fee") OR (Charges."Charge Type" = Charges."Charge Type"::"External Standing Order Fee")
                    THEN BEGIN
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."Account No." := StandingOrders."Source Account No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := PostingDate;
                        GenJournalLine.Description := Charges.Description;
                        GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                        GenJournalLine.Amount := ChargeAmount;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := Charges."GL Account";
                        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                    END;
                END ELSE BEGIN
                    IF AccountTypeS.Code <> 'WSS' THEN BEGIN
                        Charges.RESET;
                        Charges.SETRANGE(Charges."Charge Type", Charges."Charge Type"::"Failed Standing Order Fee");
                        IF Charges.FIND('-') THEN BEGIN
                            LineNo := LineNo + 10000;

                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                            GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                            GenJournalLine."Journal Batch Name" := BATCH_NAME;
                            GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                            GenJournalLine."Document No." := PostingDocumentNo;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                            GenJournalLine."Account No." := StandingOrders."Source Account No.";
                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := TODAY;
                            GenJournalLine.Description := Charges.Description;
                            GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                            GenJournalLine.Amount := ChargeAmount;
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                            GenJournalLine."Bal. Account No." := Charges."GL Account";
                            GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            IF GenJournalLine.Amount <> 0 THEN
                                GenJournalLine.INSERT;
                        END;
                    end;
                end;
                StandingOrders.Effected := TRUE;
                StandingOrders."Date Reset" := TODAY;
                StandingOrders.MODIFY;


                STORegister.INIT;
                STORegister."Register No." := '';
                STORegister.VALIDATE(STORegister."Register No.");
                STORegister."Standing Order No." := StandingOrders."No.";
                STORegister."Source Account No." := StandingOrders."Source Account No.";
                STORegister."Staff/Payroll No." := StandingOrders."Staff/Payroll No.";
                STORegister.Date := TODAY;
                STORegister."Account Name" := StandingOrders."Account Name";
                STORegister."Destination Account Type" := StandingOrders."Destination Account Type";
                STORegister."Destination Account No." := StandingOrders."Destination Account No.";
                STORegister."Destination Account Name" := StandingOrders."Destination Account Name";
                STORegister."BOSA Account No." := StandingOrders."BOSA Account No.";
                STORegister."Effective/Start Date" := StandingOrders."Effective/Start Date";
                STORegister."End Date" := StandingOrders."End Date";
                STORegister.Duration := StandingOrders.Duration;
                STORegister.Frequency := StandingOrders.Frequency;
                STORegister."Don't Allow Partial Deduction" := StandingOrders."Don't Allow Partial Deduction";
                STORegister."Deduction Status" := DedStatus;
                STORegister.Remarks := StandingOrders.Remarks;
                STORegister.Amount := StandingOrders.Amount;
                STORegister."Amount Deducted" := AmountDed;
                IF StandingOrders."Destination Account Type" = StandingOrders."Destination Account Type"::External THEN
                    STORegister.EFT := TRUE;
                STORegister."Document No." := PostingDocumentNo;
                STORegister.INSERT(TRUE);
            until StandingOrders.Next = 0;
        end;
    end;

    local procedure PostBOSAEntries(AmountDed: Decimal; No: Code[20]; BOSAAccountNo: Code[20]; ActualSTO: Decimal): Decimal
    var
        BOSABank: Code[100];
        STORunBal: Decimal;
        ReceiptAllocations: Record "Receipt Allocation";
        ReceiptAmount: Decimal;
        Loans: Record "Loans Register";
    begin
        //BOSA Cash Book Entry
        IF StandingOrders."Destination Account No." = '502-00-000300-00' THEN
            BOSABank := '13865'
        ELSE
            IF StandingOrders."Destination Account No." = '502-00-000303-00' THEN
                BOSABank := '070006';

        IF AmountDed > 0 THEN BEGIN
            STORunBal := AmountDed;
            ReceiptAllocations.RESET;
            ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No", No);
            ReceiptAllocations.SETRANGE(ReceiptAllocations."Member No", BOSAAccountNo);
            IF ReceiptAllocations.FIND('-') THEN BEGIN
                REPEAT
                    ReceiptAllocations."Amount Balance" := 0;
                    ReceiptAllocations."Interest Balance" := 0;
                    ReceiptAmount := ReceiptAllocations.Amount;

                    //Check Loan Balances
                    IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Repayment THEN BEGIN
                        Loans.RESET;
                        Loans.SETRANGE(Loans."Loan  No.", ReceiptAllocations."Loan No.");
                        IF Loans.FIND('-') = true THEN BEGIN
                            Loans.CALCFIELDS(Loans."Outstanding Balance", Loans."Oustanding Interest");
                            IF ReceiptAmount > Loans."Outstanding Balance" THEN
                                ReceiptAmount := Loans."Outstanding Balance";

                            IF Loans."Oustanding Interest" > 0 THEN
                                ReceiptAmount := ReceiptAmount - Loans."Oustanding Interest";
                        end else
                            IF Loans.FIND('-') = false THEN begin
                                //CurrReport.Skip();
                                ERROR('Loan No. %1 not Found. :- %2', ReceiptAllocations."Loan No.", ReceiptAllocations."Document No");

                            end;
                    end;

                    IF ReceiptAmount < 0 THEN
                        ReceiptAmount := 0;

                    IF STORunBal < 0 THEN
                        STORunBal := 0;
                    //.............................
                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                    GenJournalLine."Journal Batch Name" := BATCH_NAME;
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := PostingDocumentNo;
                    GenJournalLine."External Document No." := StandingOrders."No.";
                    GenJournalLine."Posting Date" := PostingDate;
                    GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::Customer;
                    GenJournalLine."Account No." := ReceiptAllocations."Member No";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine.Description := FORMAT(ReceiptAllocations."Transaction Type") + '-' + StandingOrders."No.";
                    IF STORunBal > ReceiptAmount THEN
                        GenJournalLine.Amount := -ReceiptAmount
                    ELSE
                        GenJournalLine.Amount := -STORunBal;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Deposit Contribution" THEN
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution"
                    ELSE
                        IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Repayment THEN
                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment
                        ELSE
                            IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Benevolent Fund" THEN
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Benevolent Fund"
                            ELSE
                                IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Registration Fee" THEN
                                    GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Registration Fee"
                                ELSE
                                    IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Pepea Shares" THEN
                                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Pepea Shares"
                                    ELSE
                                        IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"FOSA Shares" THEN
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"FOSA Shares"
                                        ELSE
                                            // IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Tambaa Shares" THEN
                                            //     GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Tamba Shares"
                                            // ELSE
                                                IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Changamka Shares" THEN
                                                    GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Changamka Shares"
                                                ELSE
                                                    IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Shares Capital" THEN
                                                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Shares Capital";
                    GenJournalLine."Loan No" := ReceiptAllocations."Loan No.";
                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;

                    ReceiptAllocations."Amount Balance" := ReceiptAllocations."Amount Balance" + (GenJournalLine.Amount * -1);

                    STORunBal := STORunBal + GenJournalLine.Amount;
                    ActualSTO := ActualSTO + (GenJournalLine.Amount * -1);
                    IF STORunBal < 0 THEN
                        STORunBal := 0;
                    IF (ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Repayment) THEN BEGIN
                        LineNo := LineNo + 10000;
                        Loans.RESET;
                        Loans.SETRANGE(Loans."Loan  No.", ReceiptAllocations."Loan No.");
                        IF Loans.FIND('-') THEN BEGIN
                            Loans.CALCFIELDS(Loans."Oustanding Interest");
                            ReceiptAmount := Loans."Oustanding Interest";
                        END ELSE
                            //CurrReport.Skip();
                         ERROR('Loan No. %1 not Found. :- %2', ReceiptAllocations."Loan No.", ReceiptAllocations."Document No");
                        IF ReceiptAmount < 0 THEN
                            ReceiptAmount := 0;

                        IF ReceiptAmount > 0 THEN BEGIN
                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                            GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                            GenJournalLine."Journal Batch Name" := BATCH_NAME;
                            GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Document No." := PostingDocumentNo;
                            GenJournalLine."External Document No." := StandingOrders."No.";
                            GenJournalLine."Posting Date" := PostingDate;
                            GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::Customer;
                            GenJournalLine."Account No." := ReceiptAllocations."Member No";
                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                            GenJournalLine.Description := 'Interest Paid ' + StandingOrders."No.";
                            IF STORunBal > ReceiptAmount THEN
                                GenJournalLine.Amount := -ReceiptAmount
                            ELSE
                                GenJournalLine.Amount := -STORunBal;
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                            GenJournalLine."Loan No" := ReceiptAllocations."Loan No.";
                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            IF GenJournalLine.Amount <> 0 THEN
                                GenJournalLine.INSERT;
                            ReceiptAllocations."Interest Balance" := ReceiptAllocations."Interest Balance" + (GenJournalLine.Amount * -1);

                            STORunBal := STORunBal + GenJournalLine.Amount;
                            ActualSTO := ActualSTO + (GenJournalLine.Amount * -1);


                        END;
                    END;

                    ReceiptAllocations.MODIFY;

                UNTIL ReceiptAllocations.NEXT = 0;
                exit(ActualSTO);
            END;
        end;
    end;

    local procedure FnRecoverMemberInterestOnOverdraft(BalanceAfterInterestRecovery: Decimal; AccountNo: Code[100]; PostingDocumentNo: Code[100]; PostingDate: Date; DActivity: Code[50]; DBranch: Code[50]; BOSAAccountNo: Code[20]): Decimal
    var
        LoansRegister: Record "Loans Register";
        InterestToRecover: Decimal;
        MemberBalanceAfterInterestPay: Decimal;
    begin
        InterestToRecover := 0;
        MemberBalanceAfterInterestPay := 0;
        MemberBalanceAfterInterestPay := BalanceAfterInterestRecovery;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Client Code", BOSAAccountNo);
        LoansRegister.SetFilter(LoansRegister."Loan Disbursement Date", '..' + Format(IssueDate));
        LoansRegister.SetFilter(LoansRegister."Loan Product Type", '%1', 'OVERDRAFT');
        LoansRegister.SetRange(LoansRegister."Recovery Mode", LoansRegister."Recovery Mode"::Tea);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest", LoansRegister."Interest Paid", LoansRegister."Principal Paid");
        if LoansRegister.Find('-') then begin
            repeat
                if MemberBalanceAfterInterestPay > 0 then begin
                    if LoansRegister."Oustanding Interest" > 0 then begin
                        InterestToRecover := 0;
                        InterestToRecover := FnGetInterestScheduledOverdraft(LoansRegister."Loan  No.", LoansRegister."Interest Paid", LoansRegister."Client Code", LoansRegister."Oustanding Interest");
                        //..................Recovery Interest Lines
                        //********Cr Loan Account
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."Account No." := LoansRegister."Client Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Posting Date" := PostingDate;
                        GenJournalLine.Description := 'Interest Paid';
                        IF MemberBalanceAfterInterestPay > InterestToRecover then
                            GenJournalLine.Amount := InterestToRecover * -1
                        ELSE
                            GenJournalLine.Amount := MemberBalanceAfterInterestPay * -1;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        //********Dr Vendor Account
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."Account No." := AccountNo;
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Posting Date" := PostingDate;
                        GenJournalLine.Description := 'Interest Paid to -' + Format(LoansRegister."Loan  No.") + '-' + LoansRegister."Loan Product Type";
                        IF MemberBalanceAfterInterestPay > InterestToRecover THEN
                            GenJournalLine.Amount := InterestToRecover
                        ELSE
                            GenJournalLine.Amount := MemberBalanceAfterInterestPay;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        //..................Reset Member Balance
                        MemberBalanceAfterInterestPay := MemberBalanceAfterInterestPay - GenJournalLine.Amount;
                    end;
                end;
            until LoansRegister.Next = 0;
        end;
        exit(MemberBalanceAfterInterestPay);
    end;

    local procedure FnGetInterestScheduledOverdraft(LoanNo: Code[30]; InterestPaid: Decimal; ClientCode: Code[50]; OustandingInterest: Decimal): Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedInterestToDate: Decimal;
        InterestToRecover: Decimal;
        CUSTLEDGER: Record "Cust. Ledger Entry";
        PaidAmount: Decimal;
    begin
        ExpectedInterestToDate := 0;
        InterestToRecover := 0;
        PaidAmount := 0;
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange(LoanRepaymentSchedule."Loan No.", LoanNo);
        LoanRepaymentSchedule.SetFilter(LoanRepaymentSchedule."Repayment Date", '..' + Format(CalcDate('CM', Today)));
        if LoanRepaymentSchedule.Find('-') then begin
            repeat
                ExpectedInterestToDate += LoanRepaymentSchedule."Monthly Interest";
            until LoanRepaymentSchedule.Next = 0;
        end;
        //........................
        InterestToRecover := ExpectedInterestToDate - (InterestPaid * -1);
        if InterestToRecover > 0 then begin
            exit(InterestToRecover);
        end else
            if InterestToRecover <= 0 then begin
                exit(0);
            end;
    end;


    local procedure FnRecoverMemberPrincipleOnOverdraft(BalanceAfterPrincipleRecovery: Decimal; AccountNo: Code[100]; PostingDocumentNo: Code[100]; PostingDate: Date; DActivity: Code[50]; DBranch: Code[50]; BOSAAccountNo: Code[20]): Decimal
    var
        LoansRegister: Record "Loans Register";
        PrincipleToRecover: Decimal;
        MemberBalanceAfterPrinciplePay: Decimal;
    begin
        PrincipleToRecover := 0;
        MemberBalanceAfterPrinciplePay := 0;
        MemberBalanceAfterPrinciplePay := BalanceAfterPrincipleRecovery;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Client Code", BOSAAccountNo);
        LoansRegister.SetFilter(LoansRegister."Loan Disbursement Date", '..' + Format(IssueDate));
        LoansRegister.SetFilter(LoansRegister."Loan Product Type", '%1', 'OVERDRAFT');
        LoansRegister.SetRange(LoansRegister."Recovery Mode", LoansRegister."Recovery Mode"::Tea);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest", LoansRegister."Principal Paid");
        if LoansRegister.Find('-') then begin
            repeat
                if MemberBalanceAfterPrinciplePay > 0 then begin
                    if LoansRegister."Outstanding Balance" > 0 then begin
                        PrincipleToRecover := 0;
                        PrincipleToRecover := LoansRegister."Loan Principle Repayment";
                        //********Cr Loan Account
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."Account No." := LoansRegister."Client Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Posting Date" := PostingDate;
                        GenJournalLine.Description := 'Loan Principle Paid';
                        IF MemberBalanceAfterPrinciplePay > PrincipleToRecover then
                            GenJournalLine.Amount := PrincipleToRecover * -1
                        ELSE
                            GenJournalLine.Amount := MemberBalanceAfterPrinciplePay * -1;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        //********Dr Vendor Account
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name");
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name");
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."Account No." := AccountNo;
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := PostingDocumentNo;
                        GenJournalLine."Posting Date" := PostingDate;
                        GenJournalLine.Description := 'Principle repayment Paid to -' + Format(LoansRegister."Loan  No.") + '-' + LoansRegister."Loan Product Type";
                        IF MemberBalanceAfterPrinciplePay > PrincipleToRecover THEN
                            GenJournalLine.Amount := PrincipleToRecover
                        ELSE
                            GenJournalLine.Amount := MemberBalanceAfterPrinciplePay;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        //..................Reset Member Balance
                        MemberBalanceAfterPrinciplePay := MemberBalanceAfterPrinciplePay - GenJournalLine.Amount;
                    end;
                end;
            until LoansRegister.Next = 0;
        end;
        exit(MemberBalanceAfterPrinciplePay);
    end;

    local procedure FnIsFirstEntry(EntryNo: Integer; AccountNo: Code[100]; DocumentNo: Code[20]): Boolean
    var
        ProcessLines: record "Periodics Processing Lines";
    begin
        ProcessLines.Reset();
        ProcessLines.SetRange(ProcessLines."Document No", DocumentNo);
        ProcessLines.SetRange(ProcessLines."Account No", AccountNo);
        IF ProcessLines.FindFirst() THEN begin
            IF ProcessLines."Entry No" <> EntryNo then begin
                exit(false);
            end else
                IF ProcessLines."Entry No" = EntryNo then begin
                    exit(true);
                end;
        end;
        exit(false);
    end;
}