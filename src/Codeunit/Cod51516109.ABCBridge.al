#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516109 ABCBridge
{
    // 
    // Balance enquiry:
    // 1)Get acc no
    // 2)Use the acc no to get member balance
    // Get Member Statement
    // 1)Get Account no
    // 2)Ged vendor.no
    // 3) Get List of latest transactions


    trigger OnRun()
    begin
        //MESSAGE(FnGetStatement('L01001022335'));
        //Message(FnGetMemberBal('L01001022335'));
    end;

    var
        Vend: Record Vendor;
        VendLedg: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        AccountTypes: Record "Account Types-Saving Products";
        miniBalance: Decimal;
        accBalance: Decimal;
        minimunCount: Integer;
        VendorLedgEntry: Record "Vendor Ledger Entry";
        amount: Decimal;
        Loans: Integer;
        dateExpression: Text[20];
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        dashboardDataFilter: Date;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        SurePESAApplications: Record "SurePESA Applications";
        GenJournalLine: Record "Gen. Journal Line";
        GenBatches: Record "Gen. Journal Batch";
        LineNo: Integer;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        SurePESATrans: Record "SurePESA Transactions";
        GenLedgerSetup: Record "General Ledger Setup";
        Charges: Record "Interest Rates";
        MobileCharges: Decimal;
        MobileChargesACC: Text[20];
        SurePESACommACC: Code[20];
        SurePESACharge: Decimal;
        ExcDuty: Decimal;
        TempBalance: Decimal;
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
        msg: Text[1000];
        accountName1: Text[40];
        accountName2: Text[40];
        fosaAcc: Text[30];
        bosaNo: Text[20];
        RanNo: Text[20];
        PaybillRecon: Code[10];
        ChargeAmount: Decimal;
        glamount: Decimal;
        varLoan: Text[500];
        loanamt: Decimal;
        description: Code[100];
        hlamount: Decimal;
        commision: Decimal;
        Mstatus: Code[10];
        MpesaAccount: Code[50];
        MPESACharge: Decimal;
        GenSetUp: Record "General Ledger Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        VarReceivableAccount: Code[20];
        SFactory: Codeunit "SURESTEP Factory";
        Mrowcount: Integer;
        CloudPESACharge: Decimal;
        TotalCharges: Decimal;
        CloudPESATrans: Record "SurePESA Transactions";
        CloudPESACommACC: Code[50];
        MPESARecon: Code[50];
        LoanOut: Decimal;
        countTrans: Decimal;
        AbcAtmTransactions: Record "ABC ATM Transactions";


    procedure FnGetMemberBal(Acc_No: Text) Bal: Text
    begin
        Vend.Reset;
        Vend.SetRange(Vend."No.", Acc_No);
        if Vend.FindFirst then begin
            Vend.CalcFields("Balance (LCY)");
            Bal := Format(Vend."Balance (LCY)" - (Vend."ATM Transactions" + Vend."Uncleared Cheques" + Vend."EFT Transactions"));
        end;
        exit(Bal);
    end;


    procedure FnGetStatement(Acc_no: Code[20]) statementlist: Text
    var
        Statement: Text[250];
        Reversed: Boolean;
        Amt: Decimal;
        "Count": Integer;
    begin
        Vend.Reset;
        Vend.SetRange(Vend."No.", Acc_no);
        if Vend.Find('-') then begin
            VendLedg.Reset;
            VendLedg.SetRange(VendLedg.Reversed, false);
            VendLedg.SetCurrentkey("Entry No.");
            VendLedg.Ascending(false);
            VendLedg.SetRange("Vendor No.", Vend."No.");
            if VendLedg.FindSet then begin
                statementlist := '';
                repeat
                    VendLedg.CalcFields(Amount);
                    Amt := VendLedg.Amount;
                    if Amt < 1 then Amt := Amt * -1;

                    statementlist := statementlist + Format(VendLedg."Posting Date") + ':::' + CopyStr(VendLedg.Description, 1, 25) + ':::' + Format(Amt) + '::::';
                    Count := Count + 1;
                    if Count > 5 then exit
                until VendLedg.Next = 0;
            end;
        end
    end;


    procedure FundsTransferFOSA(DeditAccount: Text[20]; CreditAccount: Text[20]; DocNumber: Text[30]; amount: Decimal; TransDate: Date; TransId: Integer; TranMode: Text[20]; TranType: Text[20]) result: Text[30]
    var
        bankAccount: Text[30];
        transCharges: Decimal;
        transDescription: Text[50];
        transactionType: Option;
    begin


        //TransId:=1000;
        AbcAtmTransactions.Reset;
        AbcAtmTransactions.SetRange(AbcAtmTransactions."Trace ID", Format(TransId));
        if AbcAtmTransactions.Find('-') then begin
            result := 'REFEXISTS';
        end else begin

            Vendor.Reset;
            Vendor.SetRange(Vendor."No.", DeditAccount);
            if Vendor.Find('-') then begin

                Vendor.CalcFields(Vendor."Balance (LCY)");
                // TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");


                // ** is it within sacco atm (teller 28) or external atm (bank0043)?
                case TranMode of
                    '1':
                        bankAccount := 'TELLER 28';
                    '2':
                        bankAccount := 'BANK0043';
                    else
                        bankAccount := '';
                end;


                // ** is it atm (1003) or pos (2003)?
                case TranType of
                    '1003':
                        begin
                            transCharges := 80;
                            transDescription := 'ATM Withdrawal';
                        end;
                    '2003':
                        begin
                            transCharges := 0;
                            transDescription := 'POS Withdrawal';
                        end;
                end;


                // IF (TempBalance>amount+MobileCharges+SurePESACharge) THEN BEGIN
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'ATMTRANS');
                GenJournalLine.DeleteAll;
                //end of deletion

                GenBatches.Reset;
                GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                GenBatches.SetRange(GenBatches.Name, 'ATMTRANS');

                if GenBatches.Find('-') = false then begin
                    GenBatches.Init;
                    GenBatches."Journal Template Name" := 'GENERAL';
                    GenBatches.Name := 'ATMTRANS';
                    GenBatches.Description := 'ABC ATM Transactions';
                    GenBatches.Validate(GenBatches."Journal Template Name");
                    GenBatches.Validate(GenBatches.Name);
                    GenBatches.Insert;
                end;

                //Dr
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Account No." := DeditAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."External Document No." := Format(TransId);
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := transDescription;
                GenJournalLine.Amount := amount;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //Cr
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                GenJournalLine."Account No." := bankAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."External Document No." := DeditAccount;
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := DeditAccount + ' ' + transDescription;
                GenJournalLine.Amount := amount * -1;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if Vend.Get(DeditAccount) then begin
                    GenJournalLine."Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                end;
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //DEBIT THE VENDOR WITH WITHDRAWAL CHARGES..................//
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Account No." := DeditAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine."External Document No." := DeditAccount;
                GenJournalLine.Description := transDescription + ' Charges';
                GenJournalLine.Amount := transCharges;
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                if Vend.Get(DeditAccount) then begin
                    GenJournalLine."Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                end;
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //...........CREDIT G/L WITH ATM Withdrawal Fees....///

                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                GenJournalLine."Account No." := '5493';
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine."External Document No." := DeditAccount;
                GenJournalLine.Description := transDescription + ' Charges';
                GenJournalLine.Amount := transCharges * -1;
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //...DEBIT EXCISE DUTY......///


                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Account No." := DeditAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine."External Document No." := DeditAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := transDescription + ' Excise Duty';
                GenJournalLine.Amount := transCharges * 0.2;
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //CREDIT  EXCISE DUTY G/L ACCOUNT ...................///

                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                GenJournalLine."Account No." := '3326';//GenSetup."Excise Duty G/L Acc.";
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := transDescription + ' Excise Duty';
                GenJournalLine.Amount := (transCharges * 0.2) * -1;
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                if Vend.Get(DeditAccount) then begin
                    GenJournalLine."Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                end;
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //Post
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'ATMTRANS');
                if GenJournalLine.Find('-') then begin
                    repeat
                        GLPosting.Run(GenJournalLine);
                    until GenJournalLine.Next = 0;

                    AbcAtmTransactions.Init;
                    AbcAtmTransactions."Trace ID" := Format(TransId);
                    AbcAtmTransactions.Description := transDescription;
                    AbcAtmTransactions."Document Date" := Today;
                    AbcAtmTransactions."Account No" := DeditAccount;
                    AbcAtmTransactions."Account Name" := Vendor.Name;
                    AbcAtmTransactions."Telephone Number" := Vendor."Phone No.";
                    AbcAtmTransactions."Credit Account" := CreditAccount;
                    AbcAtmTransactions.Amount := amount;
                    AbcAtmTransactions.Posted := true;
                    AbcAtmTransactions.Status := AbcAtmTransactions.Status::Completed;
                    AbcAtmTransactions."ATM Card No" := DeditAccount;
                    AbcAtmTransactions."Posting Date" := Today;
                    AbcAtmTransactions."Date Posted" := CurrentDateTime;
                    AbcAtmTransactions.Comments := 'Success|' + TranMode + '|' + TranType;
                    //AbcAtmTransactions.Client := Vendor."BOSA Account No";
                    case TranType of
                        '1001':
                            begin
                                transactionType := AbcAtmTransactions."transaction type"::"Balance Enquiry";
                            end;
                        '1002':
                            begin
                                transactionType := AbcAtmTransactions."transaction type"::"Mini Statement";
                            end;
                        '1003':
                            begin
                                transactionType := AbcAtmTransactions."transaction type"::"ATM Transaction";
                            end;
                        '2003':
                            begin
                                transactionType := AbcAtmTransactions."Transaction Type"::"POS Transaction";
                            end;
                    end;
                    AbcAtmTransactions."Transaction Type" := transactionType;
                    AbcAtmTransactions."Transaction Time" := Time;
                    AbcAtmTransactions.Charge := transCharges;
                    if transdescription = 'POS Withdrawal' then begin
                        AbcAtmTransactions."POS Trans" := true;
                    end else begin
                        AbcAtmTransactions."POS Trans" := false;
                    end;
                    AbcAtmTransactions.Insert;

                    result := 'TRUE';
                end;

            end

        end;
    end;


    procedure SMSMessage(documentNo: Text[30]; accfrom: Text[30]; phone: Text[20]; message: Text[250]; addition: Text[250])
    begin
        iEntryNo := 0;
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end else begin
            iEntryNo := 1;
        end;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Batch No" := documentNo;
        SMSMessages."Document No" := documentNo;
        SMSMessages."Account No" := accfrom;
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'ATM Transactions';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        SMSMessages."SMS Message" := message;
        ///SMSMessages."Additional sms":=addition;
        SMSMessages."Telephone No" := phone;
        if SMSMessages."Telephone No" <> '' then
            SMSMessages.Insert;
    end;


    procedure FnRevTransferFOSA(DeditAccount: Text[20]; CreditAccount: Text[20]; DocNumber: Text[30]; amount: Decimal; TransDate: Date; TransId: Integer) result: Text[30]
    var
        originalAmount: Decimal;
        tranmode: Text[20];
        trantype: Text[20];
        transcharges: Decimal;
        transdescription: Text[50];
        BankAccount: Text[30];
        strcomments: Text[100];
    begin

        //TransId:=1000;
        AbcAtmTransactions.Reset;
        AbcAtmTransactions.SetRange(AbcAtmTransactions."Trace ID", Format(TransId));
        if AbcAtmTransactions.Find('-') then begin
            originalAmount := AbcAtmTransactions.Amount;

            strcomments := ConvertStr(AbcAtmTransactions.Comments, '|', ',');

            tranmode := SelectStr(2, strcomments);
            trantype := SelectStr(3, strcomments);

            Vendor.Reset;
            Vendor.SetRange(Vendor."No.", DeditAccount);
            if Vendor.Find('-') then begin

                // ** is it within sacco atm (teller 28) or external atm (bank0043)?
                case tranmode of
                    '1':
                        BankAccount := 'TELLER 28';
                    '2':
                        BankAccount := 'BANK0043';
                    else
                        BankAccount := '';
                end;


                // ** is it atm (1003) or pos (2003)?
                case trantype of
                    '1003':
                        begin
                            transcharges := 80;
                            transdescription := 'ATM Withdrawal Reversal';
                        end;
                    '2003':
                        begin
                            transcharges := 0;
                            transdescription := 'POS Withdrawal Reversal';
                        end;
                end;

                Vendor.CalcFields(Vendor."Balance (LCY)");
                // TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");


                // IF (TempBalance>amount+MobileCharges+SurePESACharge) THEN BEGIN
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'ATMTRANS');
                GenJournalLine.DeleteAll;
                //end of deletion

                GenBatches.Reset;
                GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                GenBatches.SetRange(GenBatches.Name, 'ATMTRANS');

                if GenBatches.Find('-') = false then begin
                    GenBatches.Init;
                    GenBatches."Journal Template Name" := 'GENERAL';
                    GenBatches.Name := 'ATMTRANS';
                    GenBatches.Description := 'SUREPESA Tranfers';
                    GenBatches.Validate(GenBatches."Journal Template Name");
                    GenBatches.Validate(GenBatches.Name);
                    GenBatches.Insert;
                end;

                //Cr
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Account No." := DeditAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."External Document No." := Format(TransId);
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := transdescription + ' Reversal';
                GenJournalLine.Amount := originalAmount * -1;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //Dr
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                GenJournalLine."Account No." := BankAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."External Document No." := DeditAccount;
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := transdescription + ' Reversal';
                GenJournalLine.Amount := originalAmount;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //CREDIT THE VENDOR WITH WITHDRAWAL CHARGES..................//
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Account No." := DeditAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine."External Document No." := DeditAccount;
                GenJournalLine.Description := transDescription + ' Charges';
                GenJournalLine.Amount := transCharges * -1;
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                if Vend.Get(DeditAccount) then begin
                    GenJournalLine."Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                end;
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //...........DEBIT G/L WITH ATM Withdrawal Fees....///

                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                GenJournalLine."Account No." := '5493';
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine."External Document No." := DeditAccount;
                GenJournalLine.Description := transDescription + ' Charges';
                GenJournalLine.Amount := transCharges;
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //DR EXCISE DUTY G/L ACCOUNT ...................///
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                GenJournalLine."Account No." := '3326';//GenSetup."Excise Duty G/L Acc.";
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := transdescription + ' E/D Reversal';
                GenJournalLine.Amount := (transcharges * 0.2);
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                if Vend.Get(DeditAccount) then begin
                    GenJournalLine."Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                end;
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //CR EXCISE DUTY......///
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                GenJournalLine."Document No." := Format(TransId);
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Account No." := DeditAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine."External Document No." := DeditAccount;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := transdescription + ' E/D Reversal';
                GenJournalLine.Amount := (transcharges * 0.2) * -1;
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //Post
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'ATMTRANS');
                if GenJournalLine.Find('-') then begin
                    repeat
                        GLPosting.Run(GenJournalLine);
                    until GenJournalLine.Next = 0;
                end;

                AbcAtmTransactions.Init;
                AbcAtmTransactions."Trace ID" := Format(TransId) + 'R';
                AbcAtmTransactions.Description := transdescription;
                AbcAtmTransactions."Document Date" := Today;
                AbcAtmTransactions."Account No" := DeditAccount;
                AbcAtmTransactions."Account Name" := Vendor.Name;
                AbcAtmTransactions."Credit Account" := CreditAccount;
                AbcAtmTransactions."Telephone Number" := Vendor."Phone No.";
                AbcAtmTransactions.Amount := amount;
                AbcAtmTransactions.Posted := true;
                AbcAtmTransactions."Posting Date" := Today;
                AbcAtmTransactions."Date Posted" := CurrentDateTime;
                AbcAtmTransactions.Comments := 'Success';
                AbcAtmTransactions.Status := AbcAtmTransactions.Status::Completed;
                AbcAtmTransactions.Client := Vendor."BOSA Account No";
                AbcAtmTransactions."Transaction Type" := AbcAtmTransactions."transaction type"::Reversals;
                AbcAtmTransactions."Transaction Time" := Time;
                if transdescription = 'POS Withdrawal Reversal' then begin
                    AbcAtmTransactions."POS Trans" := true;
                end else begin
                    AbcAtmTransactions."POS Trans" := false;
                end;
                AbcAtmTransactions.Insert;

                result := 'TRUE';
            end

        end else begin
            result := 'REFNOTEXISTS';
        end;
    end;
}

