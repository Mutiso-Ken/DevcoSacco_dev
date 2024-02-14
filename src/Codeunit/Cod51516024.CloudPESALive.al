#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516024 CloudPESALive
{

    trigger OnRun()
    begin

    end;

    var
        Vendor: Record Vendor;
        branchcode: Code[10];
        AccountTypes: Record "Account Types-Saving Products";
        miniBalance: Decimal;
        accBalance: Decimal;
        minimunCount: Integer;
        VendorLedgEntry: Record "Vendor Ledger Entry";
        amount: Decimal;
        Loans: Integer;
        LoansRegister: Record "Loans Register";
        LoanProductsSetup: Record "Loan Products Setup";
        Members: Record Customer;
        dateExpression: Text[20];
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        dashboardDataFilter: Date;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        MemberLedgerEntry: Record "Cust. Ledger Entry";
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
        msg: Text[250];
        accountName1: Text[40];
        accountName2: Text[40];
        fosaAcc: Text[30];
        LoanGuaranteeDetails: Record "Loans Guarantee Details";
        bosaNo: Text[20];
        MPESARecon: Text[20];
        TariffDetails: Record "CloudPESA Tariffs";
        MPESACharge: Decimal;
        TotalCharges: Decimal;
        ExxcDuty: label '3326';
        PaybillTrans: Record "CloudPESA MPESA Trans";
        PaybillRecon: Code[30];
        fosaConst: label 'ORDINARY';
        GLEntries: Record "G/L Entry";
        CloudPESATrans: Record "SurePESA Transactions";
        airtimeAcc: Code[50];
        CloudPESACharge: Decimal;
        VarIssuedDate: Date;
        MpesaDisbus: Record "Mobile Loans";
        docNo: Code[30];
        batch: Code[30];
        SaccoSet: Record "Sacco General Set-Up";
        CloudPESACommACC: Code[20];
        UserSetup: Record "User Setup";
        User: Record "User Setup";
        "count": Integer;
        AgentAccounts: Record "Agent Applications";
        StartDate: Date;
        EndDate: Date;
        SurestepFactory: Codeunit "SURESTEP Factory";


    procedure CustomerRegistration(TransactionType: Integer; MobileNumber: Text; CustomerName: Text; IDNumber: Text; PayrollNumbers: Text; AccountNumber: Text) response: Text
    begin

        begin
            SurePESAApplications.Reset;
            SurePESAApplications.SetRange(SurePESAApplications.SentToServer, false);
            if SurePESAApplications.Find('-') then begin
                response := '[';
                repeat
                    SurePESAApplications.SentToServer := true;
                    SurePESAApplications.Modify;
                    response += '{"TransactionType":' + '"' + Format(TransactionType) + '"' + ',"MobileNumber": ' + '"' + CopyStr(SurePESAApplications.Telephone, 2, 13) + '"' + ',"CustomerName":' + '"' + SurePESAApplications."Account Name" + '"' +
                ',"ID Number": ' + '"' + SurePESAApplications."ID No" + '"' + ',"AccountNumber":' + '"' + SurePESAApplications."Account No" + '"';
                    minimunCount := minimunCount + 1;
                    if minimunCount > 4 then begin
                        response += '}';
                        response += ']';
                        exit;
                    end;
                    if SurePESAApplications.Next = 1 then begin
                        response += '},';
                    end else
                        if SurePESAApplications.Next = 0 then begin
                            response += '}';
                        end

                until SurePESAApplications.Next = 0;
                response += ']';
            end
            else begin
                response := '{"Status":"No records to fetch"}'
            end;
        end;
    end;


    procedure UpdateCustomerRegistration(idNumber: Text[30]) response: Text
    begin
        begin
            SurePESAApplications.Reset;
            SurePESAApplications.SetRange(SurePESAApplications.SentToServer, false);
            SurePESAApplications.SetRange(SurePESAApplications."ID No", idNumber);
            if SurePESAApplications.Find('-') then begin
                SurePESAApplications.SentToServer := true;
                SurePESAApplications.Modify;
                response := '{"Status": "Modified"}';
            end
            else begin
                response := '"Status": "Failed to modify"}';
            end
        end;
    end;


    procedure DebitAdvise(AccNumber: Text; TransactionType: Integer; TransactionAmount: Decimal; TransactionCode: Text; Narration: Text) response: Text
    var
        BalanceAcc: Decimal;
    begin
        SurePESATrans.Reset;
        SurePESATrans.SetRange(SurePESATrans."Document No", TransactionCode);
        if SurePESATrans.Find('-') then begin
            if SurePESATrans.Posted = true then begin
                response := 'REFEXISTS';
            end
            else begin
                Vendor.Reset;
                Vendor.SetRange(Vendor."No.", AccNumber);
                Vendor.SetFilter(Vendor."Account Type", '%1|%2|%3|%4', 'ORDINARY', 'CURRENT', 'JUNIOR', 'GROUP');
                if Vendor.Find('-') then
                    AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                if AccountTypes.Find('-') then begin
                    miniBalance := AccountTypes."Minimum Balance";
                end;
                Vendor.CalcFields(Vendor."Balance (LCY)");
                Vendor.CalcFields(Vendor."ATM Transactions");
                Vendor.CalcFields(Vendor."Uncleared Cheques");
                Vendor.CalcFields(Vendor."EFT Transactions");
                BalanceAcc := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance);


                GenLedgerSetup.Reset;
                GenLedgerSetup.Get;
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
                GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

                SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
                MobileChargesACC := GenLedgerSetup."M-banking Charges Acc";

                MobileCharges := GetCharge(TransactionAmount, 'SACCOGEN');
                SurePESACharge := GenLedgerSetup."CloudPESA Charge";

                ExcDuty := (20 / 100) * (MobileCharges);
                TotalCharges := SurePESACharge + MobileCharges;

                MPESACharge := GetCharge(TransactionAmount, 'MPESA');
                SurePESACharge := GetCharge(TransactionAmount, 'VENDWD');
                MobileCharges := GetCharge(TransactionAmount, 'SACCOWD');

                ExcDuty := (20 / 100) * (MobileCharges + SurePESACharge);
                TotalCharges := SurePESACharge + MobileCharges + ExcDuty + MPESACharge;
                //BalanceAcc:=BalanceAcc-TotalCharges;

                TariffDetails.Reset;
                TariffDetails.SetRange(TariffDetails.Code, 'MPESA');
                TariffDetails.SetRange(TariffDetails."Lower Limit");
                TariffDetails.SetRange(TariffDetails."Upper Limit");
                if TariffDetails.Find('-') then begin
                    //IAN ADDED CODE
                    if Vendor."Balance (LCY)" < (miniBalance + TransactionAmount + TotalCharges) then begin
                        response := '{' +
                                  ' "StatusCode": 42,' +
                                  ' "StatusDescription": "Failed - Insufficient Funds"' +
                                  '}';
                        exit;
                    end else
                        if accBalance < TariffDetails."Lower Limit" then begin
                            response := '{' +
                                      ' "StatusCode": 42,' + '"StatusDescription": "Minimum Withdrawal Limit is Ksh. "' + '"' + Format(TariffDetails."Lower Limit") + '"}';
                            exit;
                        end else
                            if TransactionAmount > TariffDetails."Upper Limit" then
                                response := '{' +
                                          ' "StatusCode": 42,' + '"StatusDescription": "Maximum Withdrawal Limit is Ksh."' + '"' + Format(TariffDetails."Upper Limit") + '"}';
                end
                else begin
                    // END ADDED CODE
                    GenLedgerSetup.Reset;
                    GenLedgerSetup.Get;
                    GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
                    GenLedgerSetup.TestField(GenLedgerSetup."MPESA Recon Acc");
                    GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

                    SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
                    MobileChargesACC := GenLedgerSetup."M-banking Charges Acc";
                    MPESARecon := GenLedgerSetup."MPESA Recon Acc";

                    MobileCharges := GetCharge(TransactionAmount, 'SACCOWD');
                    MPESACharge := GetCharge(TransactionAmount, 'MPESA');
                    SurePESACharge := 10;//GenLedgerSetup."CloudPESA Charge";

                    ExcDuty := (20 / 100) * (MobileCharges);
                    TotalCharges := SurePESACharge + MobileCharges + ExcDuty;

                    Vendor.Reset;
                    Vendor.SetRange(Vendor."Phone No.", AccNumber);
                    Vendor.SetFilter(Vendor."Account Type", '%1|%2|%3|%4', 'ORDINARY', 'JUNIOR', 'CURRENT', 'GROUP');
                    if Vendor.Find('-') then begin
                        Vendor.CalcFields(Vendor."Balance (LCY)");
                        TempBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance);
                        if TempBalance > (miniBalance + TransactionAmount + TotalCharges) then begin
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                            GenJournalLine.DeleteAll;
                            //end of deletion

                            GenBatches.Reset;
                            GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                            GenBatches.SetRange(GenBatches.Name, 'MPESAWITHD');

                            if GenBatches.Find('-') = false then begin
                                GenBatches."Journal Template Name" := 'GENERAL';
                                GenBatches.Name := 'MPESAWITHD';
                                GenBatches.Description := Narration;
                                GenBatches.Validate(GenBatches."Journal Template Name");
                                GenBatches.Validate(GenBatches.Name);
                                GenBatches.Modify;
                            end;
                            // Debit Customer Acc
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := Vendor."No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                            GenJournalLine."Bal. Account No." := MPESARecon;
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Document No." := TransactionCode;
                            GenJournalLine."External Document No." := Vendor."No.";
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := Narration;
                            GenJournalLine.Amount := TransactionAmount;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            // Debit Withdrawal Charges
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := Vendor."No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := TransactionCode;
                            GenJournalLine."External Document No." := Vendor."No.";
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Mobile Withdrawal Charges';
                            GenJournalLine.Amount := TotalCharges;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            // Debit MPESA Charges
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := Vendor."No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                            GenJournalLine."Bal. Account No." := MPESARecon;
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Document No." := TransactionCode;
                            GenJournalLine."External Document No." := Vendor."No.";
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'MPESA Withdrawal Charges';
                            GenJournalLine.Amount := MPESACharge;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            // Credit Excise Duty
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                            GenJournalLine."Account No." := Format(ExxcDuty);
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := TransactionCode;
                            GenJournalLine."External Document No." := MobileChargesACC;
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Excise duty-Mobile Withdrawal';
                            GenJournalLine.Amount := ExcDuty * -1;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            // Credit Mobile Transactions Acc
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                            GenJournalLine."Account No." := MobileChargesACC;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := TransactionCode;
                            GenJournalLine."External Document No." := MobileChargesACC;
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Mobile Withdrawal Charges';
                            GenJournalLine.Amount := MobileCharges * -1;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            //Credit Vendor Commision
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                            GenJournalLine."Account No." := SurePESACommACC;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := TransactionCode;
                            GenJournalLine."External Document No." := MobileChargesACC;
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Mobile Withdrawal Charges';
                            GenJournalLine.Amount := -SurePESACharge;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            // Start of Posting
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                            if GenJournalLine.Find('-') then begin
                                repeat
                                    GLPosting.Run(GenJournalLine);
                                until GenJournalLine.Next = 0;
                            end;
                            // End of Posting

                            //Start of Deletion
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                            GenJournalLine.DeleteAll;
                            //End of Deletion


                            SurePESATrans.Status := SurePESATrans.Status::Completed;
                            SurePESATrans.Posted := true;
                            SurePESATrans."Posting Date" := Today;
                            SurePESATrans.Comments := 'Success';
                            SurePESATrans.Modify;
                            response := '{' +
                                         ' "StatusCode": 41,' +
                                         ' "StatusDescription": "Success"' +
                                        '}';
                            msg := 'You have withdrawn KES ' + Format(TransactionAmount) + ' from Account ' + Vendor.Name +
                            ' .Thank you for using Jamii Yetu Sacco M-Banking.';
                            SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
                        end
                        else begin
                            response := '{' +
                                            ' "StatusCode": 42,' +
                                            ' "StatusDescription": "Failed - Insufficient Funds"' +
                                           '}';
                            msg := 'You have insufficient funds in your savings Account to use this service.' +
                            ' .Thank you for using Jamii Yetu Sacco M-Banking.';
                            SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
                            SurePESATrans.Status := SurePESATrans.Status::Failed;
                            SurePESATrans.Posted := false;
                            SurePESATrans."Posting Date" := Today;
                            SurePESATrans.Comments := 'Failed,Insufficient Funds';
                            SurePESATrans.Modify;
                        end;
                    end else begin
                        response := '{' +
                                           ' "StatusCode": 42,' +
                                           ' "StatusDescription": "Failed - Account Not Found"' +
                                          '}';
                        msg := 'Your request has failed because account does not exist.' +
                         ' .Thank you for using Jamii Yetu Sacco M-Banking.';
                        SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
                        SurePESATrans.Status := SurePESATrans.Status::Failed;
                        SurePESATrans.Posted := false;
                        SurePESATrans."Posting Date" := Today;
                        SurePESATrans.Comments := 'Failed,Invalid Account';
                        SurePESATrans.Modify;
                    end
                end
            end
        end
        else begin

            GenLedgerSetup.Reset;
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
            GenLedgerSetup.TestField(GenLedgerSetup."MPESA Recon Acc");
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

            SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
            MobileChargesACC := GenLedgerSetup."M-banking Charges Acc";
            MPESARecon := GenLedgerSetup."MPESA Recon Acc";

            MobileCharges := GetCharge(TransactionAmount, 'SACCOWD');
            MPESACharge := GetCharge(TransactionAmount, 'MPESA');
            SurePESACharge := 10;//GenLedgerSetup."CloudPESA Charge";

            ExcDuty := (20 / 100) * (MobileCharges);
            TotalCharges := SurePESACharge + MobileCharges + ExcDuty;

            Vendor.Reset;
            Vendor.SetRange(Vendor."Phone No.", AccNumber);
            Vendor.SetFilter(Vendor."Account Type", '%1|%2|%3|%4', 'ORDINARY', 'JUNIOR', 'CURRENT', 'GROUP');

            if Vendor.Find('-') then begin
                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                if AccountTypes.Find('-') then begin
                    miniBalance := AccountTypes."Minimum Balance";
                end;
                Vendor.CalcFields(Vendor."Balance (LCY)");
                Vendor.CalcFields(Vendor."ATM Transactions");
                Vendor.CalcFields(Vendor."Uncleared Cheques");
                Vendor.CalcFields(Vendor."EFT Transactions");
                BalanceAcc := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance);


                GenLedgerSetup.Reset;
                GenLedgerSetup.Get;
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
                GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

                SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
                MobileChargesACC := GenLedgerSetup."M-banking Charges Acc";

                MobileCharges := GetCharge(TransactionAmount, 'SACCOGEN');
                SurePESACharge := GenLedgerSetup."CloudPESA Charge";

                ExcDuty := (20 / 100) * (MobileCharges);
                TotalCharges := SurePESACharge + MobileCharges;

                MPESACharge := GetCharge(TransactionAmount, 'MPESA');
                SurePESACharge := GetCharge(TransactionAmount, 'VENDWD');
                MobileCharges := GetCharge(TransactionAmount, 'SACCOWD');

                ExcDuty := (20 / 100) * (MobileCharges + SurePESACharge);
                TotalCharges := SurePESACharge + MobileCharges + ExcDuty;
                //BalanceAcc:=BalanceAcc-TotalCharges;

                TariffDetails.Reset;
                TariffDetails.SetRange(TariffDetails.Code, 'MPESA');
                TariffDetails.SetRange(TariffDetails."Lower Limit");
                TariffDetails.SetRange(TariffDetails."Upper Limit");
                if TariffDetails.Find('-') then begin
                    //IAN ADDED CODE
                    if Vendor."Balance (LCY)" < (miniBalance + TransactionAmount + TotalCharges) then begin
                        response := '{' +
                                  ' "StatusCode": 42,' +
                                  ' "StatusDescription": "Failed - Insufficient Funds"' +
                                  '}';
                        exit;
                    end else begin
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                        GenJournalLine.DeleteAll;
                        //end of deletion

                        GenBatches.Reset;
                        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                        GenBatches.SetRange(GenBatches.Name, 'MPESAWITHD');

                        if GenBatches.Find('-') = false then begin
                            GenBatches.Init;
                            GenBatches."Journal Template Name" := 'GENERAL';
                            GenBatches.Name := 'MPESAWITHD';
                            GenBatches.Description := Narration;
                            GenBatches.Validate(GenBatches."Journal Template Name");
                            GenBatches.Validate(GenBatches.Name);
                            GenBatches.Insert;
                        end;

                        //DR Customer Acc
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                        GenJournalLine."Account No." := Vendor."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                        GenJournalLine."Bal. Account No." := MPESARecon;
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Document No." := TransactionCode;
                        GenJournalLine."External Document No." := Vendor."No.";
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := Narration;
                        GenJournalLine.Amount := TransactionAmount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //Dr Withdrawal Charges
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                        GenJournalLine."Account No." := Vendor."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := TransactionCode;
                        GenJournalLine."External Document No." := Vendor."No.";
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Mobile Withdrawal Charges';
                        GenJournalLine.Amount := TotalCharges;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //Dr MPESA Charges
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                        GenJournalLine."Account No." := Vendor."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                        GenJournalLine."Bal. Account No." := MPESARecon;
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Document No." := TransactionCode;
                        GenJournalLine."External Document No." := Vendor."No.";
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'MPESA Withdrawal Charges';
                        GenJournalLine.Amount := MPESACharge;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //CR Excise Duty
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                        GenJournalLine."Account No." := Format(ExxcDuty);
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := TransactionCode;
                        GenJournalLine."External Document No." := MobileChargesACC;
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Excise duty-Mobile Withdrawal';
                        GenJournalLine.Amount := ExcDuty * -1;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //CR Mobile Transactions Acc
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                        GenJournalLine."Account No." := MobileChargesACC;
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := TransactionCode;
                        GenJournalLine."External Document No." := MobileChargesACC;
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Mobile Withdrawal Charges';
                        GenJournalLine.Amount := MobileCharges * -1;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //CR Surestep Acc
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                        GenJournalLine."Account No." := SurePESACommACC;
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := TransactionCode;
                        GenJournalLine."External Document No." := MobileChargesACC;
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Mobile Withdrawal Charges';
                        GenJournalLine.Amount := -SurePESACharge;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //START POSTING
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                        if GenJournalLine.Find('-') then begin
                            repeat
                                GLPosting.Run(GenJournalLine);
                            until GenJournalLine.Next = 0;
                        end;
                        //END POSTING

                        // DELETION OF JOURNAL
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                        GenJournalLine.DeleteAll;
                        //END OF DELETION

                        //START OF INSERTION OF  SUCCESSFUL SUREPESA TRANSACTIONS

                        SurePESATrans.Init;
                        SurePESATrans."Document No" := TransactionCode;
                        SurePESATrans.Description := Narration;
                        SurePESATrans."Document Date" := Today;
                        SurePESATrans."Account No" := Vendor."No.";
                        SurePESATrans."Account No2" := MPESARecon;
                        SurePESATrans.Amount := TransactionAmount;
                        SurePESATrans.Status := SurePESATrans.Status::Completed;
                        SurePESATrans.Posted := true;
                        SurePESATrans."Telephone Number" := Vendor."Phone No.";
                        SurePESATrans."Posting Date" := Today;
                        SurePESATrans.Comments := 'Success';
                        SurePESATrans.Client := Vendor."BOSA Account No";
                        SurePESATrans."Transaction Type" := SurePESATrans."transaction type"::Withdrawal;
                        SurePESATrans."Transaction Time" := Time;
                        SurePESATrans.Insert;
                        response := '{' +
                                     ' "StatusCode": 41,' +
                                     ' "StatusDescription": "Success"' +
                                    '}';
                        msg := 'You have withdrawn KES ' + Format(TransactionAmount) + ' from Account ' + Vendor.Name +
                        ' .Thank you for using Jamii Yetu Sacco M-Banking.';
                        SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
                    end;
                    //END OF INSERTION OF  SUCCESSFUL SUREPESA TRANSACTIONS

                    //START OF INSERTION OF INSUFFICIENT FUNDS SUREPESA TRANSACTIONS
                end
                else begin
                    response := '{' +
                                    ' "StatusCode": 42,' +
                                    ' "StatusDescription": "Failed - Isufficient Funds"' +
                                   '}';
                    msg := 'You have insufficient funds in your savings Account to use this service.' +
                    ' .Thank you for using Jamii Yetu Sacco M-Banking.';
                    SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
                    SurePESATrans.Init;
                    SurePESATrans."Document No" := TransactionCode;
                    SurePESATrans.Description := Narration;
                    SurePESATrans."Document Date" := Today;
                    SurePESATrans."Account No" := Vendor."No.";
                    SurePESATrans."Account No2" := MPESARecon;
                    SurePESATrans.Amount := TransactionAmount;
                    SurePESATrans.Status := SurePESATrans.Status::Failed;
                    SurePESATrans.Posted := false;
                    SurePESATrans."Posting Date" := Today;
                    SurePESATrans.Comments := 'Failed,Insufficient Funds';
                    SurePESATrans.Client := Vendor."BOSA Account No";
                    SurePESATrans."Transaction Type" := SurePESATrans."transaction type"::Withdrawal;
                    SurePESATrans."Transaction Time" := Time;
                    SurePESATrans.Insert;
                end

                //END OF INSERTION OF INSUFFICIENT FUNDS SUREPESA TRANSACTIONS
            end
            //START OF INSERTION OF FAILED ACCOUNT SUREPESA TRANSACTIONS
            //        /
            //END OF INSERTION OF FAILED ACCOUNT SUREPESA TRANSACTIONS
            //END;
            //END
        end
    end;


    procedure BalanceEnquiry(AccNumber: Text; TransactionType: Integer; TransactionCode: Text; Narration: Text) Bal: Text
    begin
        begin
            CloudPESATrans.Reset;
            CloudPESATrans.SetRange(CloudPESATrans."Document No", TransactionCode);
            if CloudPESATrans.Find('-') then begin
                Bal := 'REFEXISTS';
            end
            else begin
                Bal := '';
                GenLedgerSetup.Reset;
                GenLedgerSetup.Get;
                GenLedgerSetup.TestField(GenLedgerSetup."Mobile Charge");
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

                Charges.Reset;
                Charges.SetRange(Charges.Code, GenLedgerSetup."Mobile Charge");
                if Charges.Find('-') then begin
                    Charges.TestField(Charges."GL Account");
                    MobileCharges := GetCharge(0, 'ACCOUNTBALANCE');
                    MobileChargesACC := Charges."GL Account";
                end;

                CloudPESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
                CloudPESACharge := GenLedgerSetup."CloudPESA Charge";

                ExcDuty := (20 / 100) * (MobileCharges);

                Vendor.Reset;
                Vendor.SetRange(Vendor."No.", AccNumber);
                if Vendor.Find('-') then begin
                    AccountTypes.Reset;
                    AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");

                    if AccountTypes.Find('-') then begin
                        miniBalance := AccountTypes."Minimum Balance";
                    end;
                    Vendor.CalcFields(Vendor."Balance (LCY)");
                    TempBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions") - miniBalance;
                    Vendor.SetRange(Vendor."Account Type");

                    if Vendor.Find('-') then begin
                        if (TempBalance > MobileCharges + CloudPESACharge) then begin

                            //Start of Journal Deletion
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange("Journal Batch Name", 'MOBILETRAN');
                            GenJournalLine.DeleteAll;
                            //End of Journal Deletion

                            GenBatches.Reset;
                            GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                            GenBatches.SetRange(GenBatches.Name, 'MOBILETRAN');

                            if GenBatches.Find('-') = false then begin
                                GenBatches.Init;
                                GenBatches."Journal Template Name" := 'GENERAL';
                                GenBatches.Name := 'MOBILETRAN';
                                GenBatches.Description := 'Balance Enquiry';
                                GenBatches.Validate(GenBatches."Journal Template Name");
                                GenBatches.Validate(GenBatches.Name);
                                GenBatches.Insert;
                            end;

                            //Debit Mobile Transfer Charges from Acc
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := AccNumber;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := TransactionCode;
                            GenJournalLine."External Document No." := AccNumber;
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Balance Enquiry';
                            GenJournalLine.Amount := 10;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            //Debit Excise Duty from Acc
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := AccNumber;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := TransactionCode;
                            GenJournalLine."External Document No." := AccNumber;
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Excise duty-Balance Enquiry';
                            GenJournalLine.Amount := 2;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            //Credit Excise Duty to Ex-Duty GL
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                            GenJournalLine."Account No." := ExxcDuty;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := TransactionCode;
                            GenJournalLine."External Document No." := MobileChargesACC;
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Excise duty-Balance Enquiry';
                            GenJournalLine.Amount := -2;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            //Credit  Commission
                            User.Reset;
                            User.SetRange(User."User ID", UserId);
                            if User.Find('-') then begin
                                branchcode := User.Branch;

                                LineNo := LineNo + 10000;
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                GenJournalLine."Account No." := CloudPESACommACC;
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Document No." := TransactionCode;
                                GenJournalLine."External Document No." := MobileChargesACC;
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := 'Balance Enquiry Charges';
                                GenJournalLine.Amount := -CloudPESACharge;
                                GenJournalLine."Shortcut Dimension 2 Code" := branchcode;
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;


                                //Credit Mobile Transactions Acc
                                LineNo := LineNo + 10000;
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                GenJournalLine."Account No." := GenLedgerSetup."CloudPESA Comm Acc";
                                ;
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Document No." := TransactionCode;
                                GenJournalLine."External Document No." := MobileChargesACC;
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := 'Balance Enquiry Charges';
                                GenJournalLine.Amount := -MobileCharges;
                                GenJournalLine."Shortcut Dimension 2 Code" := branchcode;
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;
                            end;

                            //Start of Posting

                            GenJournalLine.Reset;

                            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange("Journal Batch Name", 'MOBILETRAN');
                            if GenJournalLine.Find('-') then begin
                                repeat
                                    GLPosting.Run(GenJournalLine);
                                until GenJournalLine.Next = 0;
                            end;
                            //End of Posting

                            // Start of Journal Deletion
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange("Journal Batch Name", 'MOBILETRAN');
                            GenJournalLine.DeleteAll;
                            // End of Journal Deletion

                            //Start of Insertion

                            CloudPESATrans.Init;
                            CloudPESATrans."Document No" := TransactionCode;
                            CloudPESATrans.Description := 'Balance Enquiry';
                            CloudPESATrans."Document Date" := Today;
                            CloudPESATrans."Account No" := Vendor."No.";
                            TotalCharges := ExcDuty + MobileCharges + CloudPESACharge;
                            CloudPESATrans.Charge := TotalCharges;
                            CloudPESATrans."Account Name" := Vendor.Name;
                            CloudPESATrans."Telephone Number" := Vendor."Phone No.";
                            CloudPESATrans."Account No2" := '';
                            CloudPESATrans.Amount := amount;
                            CloudPESATrans.Posted := true;
                            CloudPESATrans."Posting Date" := Today;
                            CloudPESATrans.Status := CloudPESATrans.Status::Completed;
                            CloudPESATrans.Comments := 'Success';
                            CloudPESATrans.Client := Vendor."BOSA Account No";
                            CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::Balance;
                            CloudPESATrans."Transaction Time" := Time;
                            CloudPESATrans.Insert;
                            // End of Insertion

                            AccountTypes.Reset;
                            AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                            if AccountTypes.Find('-') then begin
                                miniBalance := AccountTypes."Minimum Balance";
                            end;
                            Vendor.CalcFields(Vendor."Balance (LCY)");
                            Vendor.CalcFields(Vendor.Balance);
                            Vendor.CalcFields(Vendor."ATM Transactions");
                            Vendor.CalcFields(Vendor."Uncleared Cheques");
                            Vendor.CalcFields(Vendor."EFT Transactions");
                            accBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance);

                            msg := 'Account Name: ' + Vendor.Name + ', ' + 'A/c Balance Ksh. ' + Format(accBalance) + ' as at ' + Format(CurrentDatetime) + '. '
                           + 'Thank you for using Jamii Yetu Sacco M-Banking';
                            SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);

                            Bal := '{"AvailableBalance":' + '"' + Format(Vendor.Balance - 1000) + '"' + ',"BookBalance":' + '"' + Format(Vendor.Balance) + '"' + '}';

                        end
                        else begin

                            Bal := '{ "Status":"Insufficient" ' + '}';
                        end;
                    end
                    else begin
                        AccountTypes.Reset;
                        AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                        if AccountTypes.Find('-') then begin
                            miniBalance := AccountTypes."Minimum Balance";
                        end;
                    end;
                end
                else begin
                    Bal := '{ "Status" : "ACCNOTFOUND" }';
                end;
            end;
        end;
    end;


    procedure MiniStatement(AccNumber: Text; TransactionType: Integer; TransactionCode: Text; Narration: Text) response: Text
    begin
        begin
            SurePESATrans.Reset;
            SurePESATrans.SetRange(SurePESATrans."Document No", TransactionCode);
            /*
            IF SurePESATrans.FIND('-') THEN BEGIN
              response:='REFEXISTS';
            END
            ELSE BEGIN
            */
            //response :='';
            GenLedgerSetup.Reset;
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
            GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

            SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
            MobileChargesACC := GenLedgerSetup."M-banking Charges Acc";

            MobileCharges := GetCharge(amount, 'SACCOGEN');
            SurePESACharge := GenLedgerSetup."CloudPESA Charge";

            ExcDuty := (20 / 100) * (MobileCharges);
            TotalCharges := SurePESACharge + MobileCharges;

            Vendor.Reset;
            Vendor.SetRange(Vendor."Phone No.", AccNumber);
            if Vendor.Find('-') then begin
                Vendor.CalcFields(Vendor."Balance (LCY)");
                TempBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions");
                fosaAcc := Vendor."No.";

                if (TempBalance > (TotalCharges + ExcDuty + miniBalance)) then begin
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MOBILETRAN');
                    GenJournalLine.DeleteAll;
                    //end of deletion

                    GenBatches.Reset;
                    GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                    GenBatches.SetRange(GenBatches.Name, 'MOBILETRAN');

                    if GenBatches.Find('-') = false then begin
                        GenBatches.Init;
                        GenBatches."Journal Template Name" := 'GENERAL';
                        GenBatches.Name := 'MOBILETRAN';
                        GenBatches.Description := 'Mini Statement';
                        GenBatches.Validate(GenBatches."Journal Template Name");
                        GenBatches.Validate(GenBatches.Name);
                        GenBatches.Insert;
                    end;

                    //Dr Mobile Charges
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := fosaAcc;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := fosaAcc;
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Ministatement Charges';
                    GenJournalLine.Amount := TotalCharges;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //DR Excise Duty
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := fosaAcc;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := fosaAcc;
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Excise duty-Balance Enquiry';
                    GenJournalLine.Amount := ExcDuty;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := ExxcDuty;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := MobileChargesACC;
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Excise duty-Balance Enquiry';
                    GenJournalLine.Amount := ExcDuty * -1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //CR Surestep Commission
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := SurePESACommACC;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := SurePESACommACC;
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Mini Statement Charges';
                    GenJournalLine.Amount := -SurePESACharge;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //CR Sacco Acc
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MOBILETRAN';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := MobileChargesACC;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := MobileChargesACC;
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Balance Enquiry Charges';
                    GenJournalLine.Amount := MobileCharges * -1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //Post
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MOBILETRAN');
                    if GenJournalLine.Find('-') then begin
                        repeat
                            GLPosting.Run(GenJournalLine);
                        until GenJournalLine.Next = 0;
                    end;
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MOBILETRAN');
                    GenJournalLine.DeleteAll;

                    SurePESATrans.Init;
                    SurePESATrans."Document No" := TransactionCode;
                    SurePESATrans.Description := 'Mini Statement';
                    SurePESATrans."Document Date" := Today;
                    SurePESATrans."Account No" := Vendor."No.";
                    SurePESATrans."Account No2" := '';
                    SurePESATrans.Amount := amount;
                    SurePESATrans.Posted := true;
                    SurePESATrans."Posting Date" := Today;
                    SurePESATrans.Status := SurePESATrans.Status::Completed;
                    SurePESATrans.Comments := 'Success';
                    SurePESATrans.Client := Vendor."BOSA Account No";
                    SurePESATrans."Transaction Type" := SurePESATrans."transaction type"::Ministatement;
                    SurePESATrans."Transaction Time" := Time;
                    SurePESATrans.Insert;

                    minimunCount := 1;
                    Vendor.CalcFields(Vendor.Balance);
                    VendorLedgEntry.Reset;
                    VendorLedgEntry.SetCurrentkey(VendorLedgEntry."Entry No.");
                    VendorLedgEntry.Ascending(false);
                    VendorLedgEntry.SetFilter(VendorLedgEntry.Description, '<>%1', 'Charges');
                    VendorLedgEntry.SetFilter(VendorLedgEntry.Description, '<>%1', 'Excise duty-Balance Enquiry');
                    VendorLedgEntry.SetRange(VendorLedgEntry."Vendor No.", Vendor."No.");
                    VendorLedgEntry.SetRange(VendorLedgEntry.Reversed, false);
                    //VendorLedgEntry.ASCENDING(TRUE);

                    if VendorLedgEntry.FindFirst then begin
                        response := '[';
                        repeat
                            VendorLedgEntry.CalcFields(VendorLedgEntry.Amount);
                            amount := VendorLedgEntry.Amount;
                            if amount < 1 then
                                if VendorLedgEntry.Find('-') then begin
                                    repeat
                                        //amount:= amount*-1;
                                        VendorLedgEntry.CalcFields(VendorLedgEntry.Amount);
                                        amount := VendorLedgEntry.Amount;

                                        response += '{"TransactionDate":' + '"' + Format(VendorLedgEntry."Posting Date") + '"' + ',"Amount":' + '"' + Format(-VendorLedgEntry.Amount) + '"' +
                                  ',"Narration":' + '"' + CopyStr(VendorLedgEntry.Description, 1, 30) + '"' + ',"RunningBalance":' + '"' + Format(Vendor.Balance) + '"';
                                        minimunCount := minimunCount + 1;
                                        if minimunCount > 5 then begin
                                            response += '}';
                                            response += ']';
                                            exit
                                        end;
                                        if VendorLedgEntry.Next = 1 then begin
                                            response += '},';
                                        end else
                                            if VendorLedgEntry.Next = 0 then
                                                response += '}';
                                    until VendorLedgEntry.Next = 0;
                                end
                        until VendorLedgEntry.Next = 0;
                        response += ']';
                    end;
                end
                else begin
                    response := '{ "Failed":"Insufficient funds" }';
                end;
            end
            else begin
                response := '{ "Failed":"Account Not Found" }';
            end;
            // END;

        end;

    end;


    procedure AirtimePurchase(AccNumber: Text; TransactionType: Integer; TransactionAmount: Decimal; TransactionCode: Text; Narration: Text) response: Text
    begin
        CloudPESATrans.Reset;
        CloudPESATrans.SetRange(CloudPESATrans."Document No", TransactionCode);
        if CloudPESATrans.Find('-') then begin
            response := ' REFEXISTS';
        end
        else begin
            GenLedgerSetup.Reset;
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup.AirTimeSettlAcc);
            airtimeAcc := GenLedgerSetup.AirTimeSettlAcc;
        end;

        Vendor.Reset;
        Vendor.SetRange(Vendor."Phone No.", AccNumber);
        // Vendor.SetRange(Vendor."Account Type", 'ORDINARY');
        Vendor.SetFilter(Vendor."Account Type", '%1|%2', 'ORDINARY', 'GROUP');
        if Vendor.Find('-') then begin
            AccountTypes.Reset;
            AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
            if AccountTypes.Find('-') then begin
                miniBalance := AccountTypes."Minimum Balance";
            end;
            Vendor.CalcFields(Vendor."Balance (LCY)");
            Vendor.CalcFields(Vendor."ATM Transactions");
            Vendor.CalcFields(Vendor."Uncleared Cheques");
            Vendor.CalcFields(Vendor."EFT Transactions");

            ///Vendor.CALCFIELDS(Vendor."Mobile Transactions");
            TempBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + Vendor."Mobile Transactions") - miniBalance;

            if (TempBalance > TransactionAmount) then begin
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'AIRTIME');
                GenJournalLine.DeleteAll;
                //end of deletion
                GenBatches.Reset;
                GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                GenBatches.SetRange(GenBatches.Name, 'AIRTIME');

                if GenBatches.Find('-') = false then begin
                    GenBatches.Init;
                    GenBatches."Journal Template Name" := 'GENERAL';
                    GenBatches.Name := 'AIRTIME';
                    GenBatches.Description := 'AIRTIME Purchase';
                    GenBatches.Validate(GenBatches."Journal Template Name");
                    GenBatches.Validate(GenBatches.Name);
                    GenBatches.Insert;
                end;

                //DR Customer Acc
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'AIRTIME';
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                GenJournalLine."Account No." := Vendor."No.";
                GenJournalLine."Bal. Account No." := airtimeAcc;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                GenJournalLine."Document No." := TransactionCode;
                GenJournalLine."External Document No." := Vendor."No.";
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := 'AIRTIME Purchase';
                GenJournalLine.Amount := TransactionAmount;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;



                //Post
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'AIRTIME');
                if GenJournalLine.Find('-') then begin
                    repeat
                        GLPosting.Run(GenJournalLine);
                    until GenJournalLine.Next = 0;
                end;
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'AIRTIME');
                GenJournalLine.DeleteAll;
                msg := 'You have purchased airtime worth KES ' + Format(TransactionAmount) + ' from Account ' + Vendor.Name +
             ' thank you for using Jamii Yetu Sacco Mobile.';

                CloudPESATrans.Init;
                CloudPESATrans."Document No" := TransactionCode;
                CloudPESATrans.Description := 'AIRTIME Purchase';
                CloudPESATrans."Document Date" := Today;
                CloudPESATrans."Account No" := Vendor."No.";
                CloudPESATrans."Account No2" := '';
                CloudPESATrans.Charge := TotalCharges;
                CloudPESATrans."Account Name" := Vendor.Name;
                CloudPESATrans."Telephone Number" := Vendor."Phone No.";
                CloudPESATrans."SMS Message" := msg;
                CloudPESATrans.Amount := TransactionAmount;
                CloudPESATrans.Status := CloudPESATrans.Status::Completed;
                CloudPESATrans.Posted := true;
                CloudPESATrans."Posting Date" := Today;
                CloudPESATrans.Comments := 'Success';
                CloudPESATrans.Client := Vendor."BOSA Account No";
                CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::Airtime;
                CloudPESATrans."Transaction Time" := Time;
                CloudPESATrans.Insert;
                response := '{"StatusCode":"41","StatusDescription":"Success"}';

                SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
            end
            else begin
                response := '{"StatusCode":"42","StatusDescription":"Failed - Insufficient Funds"}';
                /* msg:='You have insufficient funds in your savings Account to use this service.'+
                ' .Thank you for using Jamii Yetu Sacco Mobile.';
                SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);*/
                CloudPESATrans.Init;
                CloudPESATrans."Document No" := TransactionCode;
                CloudPESATrans.Description := 'AIRTIME Purchase';
                CloudPESATrans."Document Date" := Today;
                CloudPESATrans."Account No" := Vendor."No.";
                CloudPESATrans."Account No2" := AccNumber;
                CloudPESATrans.Charge := TotalCharges;
                CloudPESATrans."Account Name" := Vendor.Name;
                CloudPESATrans."Telephone Number" := Vendor."Phone No.";
                CloudPESATrans.Amount := amount;
                CloudPESATrans.Status := CloudPESATrans.Status::Failed;
                CloudPESATrans.Posted := false;
                CloudPESATrans."Posting Date" := Today;
                CloudPESATrans.Comments := 'Failed,Insufficient Funds';
                CloudPESATrans.Client := Vendor."BOSA Account No";
                CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::Airtime;
                CloudPESATrans."Transaction Time" := Time;
                CloudPESATrans.Insert;
            end;
        end
        else begin
            response := '{"StatusCode":"42","StatusDescription":"Failed - Account Inexistent"}';
            CloudPESATrans.Init;
            CloudPESATrans."Document No" := TransactionCode;
            CloudPESATrans.Description := 'AIRTIME Purchase';
            CloudPESATrans."Document Date" := Today;
            CloudPESATrans."Account No" := '';
            CloudPESATrans."Account No2" := AccNumber;
            CloudPESATrans.Charge := TotalCharges;
            CloudPESATrans."Account Name" := Vendor.Name;
            CloudPESATrans."Telephone Number" := Vendor."Phone No.";
            CloudPESATrans.Amount := amount;
            CloudPESATrans.Posted := false;
            CloudPESATrans."Posting Date" := Today;
            CloudPESATrans.Comments := 'Failed,Invalid Account';
            CloudPESATrans.Client := '';
            CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::Airtime;
            CloudPESATrans."Transaction Time" := Time;
            CloudPESATrans.Insert;
        end;

    end;


    procedure SavingsAccount(AccNumber: Text; TransactionType: Integer; TransactionCode: Text) response: Text
    begin
        begin
            Vendor.Reset;
            Vendor.SetRange(Vendor.Status, Vendor.Status::Active);
            //Vendor.SetFilter(Vendor."Account Type", '%1', 'ORDINARY');
            Vendor.SetFilter(Vendor."Account Type", '%1|%2', 'ORDINARY', 'GROUP');
            Vendor.SetRange(Vendor."Phone No.", AccNumber);

            if Vendor.Find('-') then begin

                count := 1;

                Vendor.CalcFields(Vendor.Balance);
                response += '[' + '{"TargetProductCode":' + '"' + Vendor."Account Type" + '"' + ',"TargetProductDescription":' + '"' + Vendor."Account Type" + '"' +
              ',"FullAccountNumber":' + '"' + Vendor."No." + '"' + ',"SequenceNumber":' + Format(count) + ',"BookBalance":' + '"' + Format(Vendor.Balance) + '"' + ' }' + ']';
            end
            else begin
                response := 'Null';
            end
        end;

    end;


    procedure LoanAccounts(AccNumber: Text; TransactionType: Integer; TransactionCode: Text) response: Text
    begin
        begin
            Vendor.SetRange(Vendor."Phone No.", AccNumber);
            if Vendor.Find('-') then begin
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister."Account No", Vendor."No.");
                if LoansRegister.Find('-') then begin
                    count := 1;
                    response := '[';

                    repeat
                        //LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Interest Due",LoansRegister."Interest to be paid",LoansRegister."Interest Paid");
                        //LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance");
                        if (LoansRegister."Outstanding Balance" > 0) then begin
                            repeat
                                response += '{"TargetProductCode":' + '"' + LoansRegister."Loan  No." + '"' + ',"TargetProductDescription":' + '"' + LoansRegister."Loan Product Type Name" + '"' +
                                ',"FullAccountNumber":' + '"' + Vendor."No." + '"' + ',"SequenceNumber":' + Format(count) + ',"BookBalance": ' + '"' + Format(LoansRegister."Outstanding Balance" + LoansRegister."Interest Due") + '"';

                                count := count + 1;

                                if LoansRegister.Next = 1 then begin
                                    response += '},';

                                end else
                                    if LoansRegister.Next = 0 then
                                        response += '}';
                            until LoansRegister.Next = 0;
                        end
                    until LoansRegister.Next = 0;
                    response += ']';
                end;
            end;
        end;
        //END;
    end;


    procedure InvestmentAccounts(AccNumber: Text; TransactionType: Integer; TransactionCode: Text) response: Text
    begin
        begin
            Members.Reset;
            Members.SetRange(Members."Phone No.", AccNumber);
            Members.SetRange(Members.Status, Members.Status::Active);
            Members.SetRange(Members.Blocked, Members.Blocked::" ");
            if Members.Find('-') then begin
                Members.CalcFields(Members."Shares Retained");
                Members.CalcFields(Members."Current Shares");
                response := '[';

                response += '{' +
           '"TargetProductCode": ' + '"' + '1' + '"' + ',"TargetProductDescription": ' + '"' + 'Shares' + '"' +
           ',"FullAccountNumber": ' + '"' + Members."No." + '"' + ',"SequenceNumber": ' + Format(1) + ',"BookBalance": ' + '"' + Format(Members."Shares Retained") + '"' + '},';

                response += '{' +
          '"TargetProductCode": ' + '"' + '2' + '"' + ',"TargetProductDescription": ' + '"' + 'Deposits' + '"' +
          ',"FullAccountNumber": ' + '"' + Members."No." + '"' + ',"SequenceNumber": ' + Format(2) + ',"BookBalance": ' + '"' + Format(Members."Current Shares") + '"' + '}';

                response += ']';
            end
            else begin
                response := '';
            end
        end;
    end;


    procedure LoanLimit(TransationType: Integer; AccNumber: Text; LoanProductCode: Text; UniqueTransactionID: Text) Res: Text
    var
        StoDedAmount: Decimal;
        STO: Record "Standing Orders";
        FOSALoanRepayAmount: Decimal;
        CumulativeNet: Decimal;
        LastSalaryDate: Date;
        FirstSalaryDate: Date;
        AvarageNetPay: Decimal;
        AdvQualificationAmount: Decimal;
        CumulativeNet2: Decimal;
        finalAmount: Decimal;
        interestAMT: Decimal;
        MaxLoanAmt: Decimal;
        LastPaydate: Date;
        MPayDate: Decimal;
        MToday: Decimal;
        DateRegistered: Date;
        MtodayYear: Decimal;
        RegYear: Decimal;
        MtodayDiff: Decimal;
        MRegdate: Decimal;
        ComittedShares: Decimal;
        LoanGuarantors: Record "Loans Guarantee Details";
        FreeShares: Decimal;
        TotalAmount: Decimal;
        TransactionLoanAmt: Decimal;
        TransactionLoanDiff: Decimal;
        RepayedLoanAmt: Decimal;
        LoanRepaymentS: Record "Loan Repayment Schedule";
        Fulldate: Date;
        LastRepayDate: Date;
        PrincipalAmount: Decimal;
        employeeCode: Code[100];
        countTrans: Integer;
        MemberLedgerEntry2: Record "Cust. Ledger Entry";
        memberNO: Code[50];
    begin
        memberNO := FnGetMemberNo(AccNumber);
        amount := 0;
        //=================================================must be member for 6 months
        Members.Reset;
        Members.SetRange(Members."No.", memberNO);
        if Members.Find('-') then begin
            DateRegistered := Members."Registration Date";
        end;


        if Members.Status <> Members.Status::Active then begin
            Res := 'Your account is not active';
            exit;
        end;

        if DateRegistered <> 0D then begin
            MtodayYear := Date2dmy(Today, 3);
            RegYear := Date2dmy(DateRegistered, 3);
            MRegdate := Date2dmy(DateRegistered, 2);

            MToday := Date2dmy(Today, 2) + MRegdate;

            if CalcDate('6M', DateRegistered) > Today then begin
                amount := 1;
                Res := 'You do not qualify for this loan because you should have been a member for last 6 Months';
                exit;
            end;
        end;



        if amount <> 1 then begin
            LoansRegister.Reset;
            LoansRegister.SetRange(LoansRegister."Client Code", Members."No.");
            LoansRegister.SetRange(LoansRegister.Posted, true);
            if LoansRegister.Find('-') then begin
                repeat
                    LoansRegister.CalcFields(LoansRegister."Outstanding Balance");
                    if (LoansRegister."Outstanding Balance" > 0) then begin

                        // =================================== Check if member has an outstanding ELOAN

                        if (LoansRegister."Loan Product Type" = 'MOBILE LOAN') then begin
                            amount := 2;
                            Res := 'Your do not Qualify for this loan because You have an outstanding MOBILE LOAN';
                            exit
                        end;
                        /*
                        IF (LoansRegister."Loans Category-SASRA"<>LoansRegister."Loans Category-SASRA"::Perfoming) THEN BEGIN
                           amount:=3;
                           Res:='3::::Your do not Qualify for this loan because You have loans that are under performing::::False';
                        EXIT
                        END;
                        */

                    end;

                until LoansRegister.Next = 0;
            end;

            //=============================================Get penalty
            MpesaDisbus.Reset;
            MpesaDisbus.SetCurrentkey(MpesaDisbus."Entry No");
            MpesaDisbus.Ascending(false);
            MpesaDisbus.SetRange(MpesaDisbus."Member No", memberNO);
            if MpesaDisbus.Find('-') then begin
                if MpesaDisbus."Penalty Date" <> 0D then begin
                    if (Today <= CalcDate('1Y', MpesaDisbus."Penalty Date")) then begin
                        amount := 4;
                        Res := 'You do not qualify for this loan because you have an been penalized for late repayment';
                        exit;
                    end;
                end;
            end;


            //=========================================== last 3 months deposit contribution

            countTrans := 0;
            MemberLedgerEntry.Reset;
            MemberLedgerEntry.SetRange(MemberLedgerEntry."Customer No.", Members."No.");
            MemberLedgerEntry.SetRange(MemberLedgerEntry."Transaction Type", MemberLedgerEntry."transaction type"::"Deposit Contribution");
            MemberLedgerEntry.SetFilter(MemberLedgerEntry."Posting Date", Format(CalcDate('CM+1D-3M', Today)) + '..' + Format(CalcDate('CM', Today)));
            MemberLedgerEntry.SetFilter(MemberLedgerEntry.Description, '<>%1', 'Opening Balance');
            MemberLedgerEntry.SetCurrentkey(MemberLedgerEntry."Posting Date");
            MemberLedgerEntry.Ascending(false);
            MemberLedgerEntry.SetFilter(MemberLedgerEntry."Credit Amount", '>%1', 0);
            if MemberLedgerEntry.Find('-') then begin

                repeat
                    //    IF ABS(MemberLedgerEntry."Credit Amount")>0 THEN BEGIN

                    MemberLedgerEntry2.Reset;
                    MemberLedgerEntry2.SetRange(MemberLedgerEntry2."Customer No.", Members."No.");
                    MemberLedgerEntry2.SetRange(MemberLedgerEntry2."Transaction Type", MemberLedgerEntry."transaction type"::"Deposit Contribution");
                    MemberLedgerEntry2.SetRange(MemberLedgerEntry2."Posting Date", MemberLedgerEntry."Posting Date");
                    MemberLedgerEntry2.SetFilter(MemberLedgerEntry2.Description, '<>%1', 'Opening Balance');
                    MemberLedgerEntry2.SetFilter(MemberLedgerEntry2."Credit Amount", '>%1', 0);
                    if MemberLedgerEntry2.FindLast then begin
                        countTrans := countTrans + 1;
                    end;
                // MemberLedgerEntry."Customer No."
                //   END;

                until MemberLedgerEntry.Next = 0;

            end;


            if countTrans <> 0 then begin
                if countTrans < 2 then
                    amount := 6;
            end else begin
                amount := 6;

            end;

            if amount = 6 then begin
                Res := 'You do not qualify for this loan because you have NOT consistently saved your contribution for last 6 Months';
                exit;
            end;
            if amount <> 2 then begin
                if amount <> 3 then begin

                    SaccoSet.Reset;
                    SaccoSet.Get;

                    Members.CalcFields(Members."Current Shares");
                    TempBalance := Members."Current Shares";


                    if TempBalance < SaccoSet."Min. Contribution" then begin
                        Res := 'You do not qualify for this loan because you reached minimum contribution of Ksh ' + Format(SaccoSet."Min. Contribution");
                        exit;
                    end;
                    Members.CalcFields(Members."Outstanding Balance", Members."Outstanding Interest");
                    //MESSAGE('Balance %1  bosa balance %2',Members."Outstanding Balance"+Members."Outstanding Interest",TempBalance);
                    FreeShares := TempBalance * 10 - ((Members."Outstanding Balance" + Members."Outstanding Interest"));


                    amount := FreeShares;

                    //==================================================Get maximum loan amount
                    LoanProductsSetup.Reset;
                    LoanProductsSetup.SetRange(LoanProductsSetup.Code, 'MOBILE LOAN');
                    if LoanProductsSetup.Find('-') then begin
                        interestAMT := LoanProductsSetup."Interest rate";
                        MaxLoanAmt := LoanProductsSetup."Max. Loan Amount";
                    end;


                    if amount > MaxLoanAmt then
                        amount := MaxLoanAmt;
                end;
                if amount > TempBalance then
                    amount := TempBalance;

                if amount > 0 then begin
                    Res := '{"BookBalance":0' + ',"InterestBalance" :0' + ',"PrincipalBalance": 0' + ',"LoanLimit": ' + '"' + Format(amount) + '"' + ',"Narration": "Qualfied" }';
                end else begin
                    Res := '{"BookBalance": ' + '"' + Format(LoansRegister."Outstanding Balance") + '"' + ',"InterestBalance": ' + '"' + Format(LoansRegister."Oustanding Interest") + '"' + ',"PrincipalBalance": ' + Format(LoansRegister."Principal Paid") + ',"LoanLimit": ' + Format(amount) +
                    ',"Narration": "Do Not Qualify" }';
                end;
            end;
        end;

    end;


    procedure BillsPayment(AccNumber: Text; TransactionType: Integer; TransactionAmount: Decimal; TransactionCode: Text; Narration: Text; BillServiceCode: Text) response: Text
    var
        utilityAcc: Code[30];
    begin
        CloudPESATrans.Reset;
        CloudPESATrans.SetRange(CloudPESATrans."Document No", TransactionCode);
        if CloudPESATrans.Find('-') then begin
            response := 'REFEXISTS';
        end
        else begin

            GenLedgerSetup.Reset;
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
            utilityAcc := GenLedgerSetup.PaybillAcc;
        end;

        Vendor.Reset;
        Vendor.SetRange(Vendor."Phone No.", AccNumber);
        Vendor.SetRange(Vendor."Account Type");
        if Vendor.Find('-') then begin
            Vendor.CalcFields(Vendor."Balance (LCY)");
            Vendor.CalcFields(Vendor."ATM Transactions");
            Vendor.CalcFields(Vendor."Uncleared Cheques");
            Vendor.CalcFields(Vendor."EFT Transactions");
            //Vendor.CALCFIELDS(Vendor."Mobile Transactions");
            TempBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + Vendor."Mobile Transactions");

            if (TempBalance > amount) then begin
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'UTILITY');
                GenJournalLine.DeleteAll;
                //end of deletion
                GenBatches.Reset;
                GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                GenBatches.SetRange(GenBatches.Name, 'UTILITY');

                if GenBatches.Find('-') = false then begin
                    GenBatches.Init;
                    GenBatches."Journal Template Name" := 'GENERAL';
                    GenBatches.Name := 'UTILITY';
                    GenBatches.Description := Format(TransactionType);
                    GenBatches.Validate(GenBatches."Journal Template Name");
                    GenBatches.Validate(GenBatches.Name);
                    GenBatches.Insert;
                end;

                //DR Customer Acc
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'UTILITY';
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"G/L Account";
                GenJournalLine."Account No." := Vendor."No.";
                GenJournalLine."Bal. Account No." := utilityAcc;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                GenJournalLine."Document No." := TransactionCode;
                GenJournalLine."External Document No." := Vendor."No.";
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := Format(TransactionType);
                GenJournalLine.Amount := amount;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;



                //Post
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'UTILITY');
                if GenJournalLine.Find('-') then begin
                    repeat
                        GLPosting.Run(GenJournalLine);
                    until GenJournalLine.Next = 0;
                end;
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'UTILITY');
                GenJournalLine.DeleteAll;

                CloudPESATrans.Init;
                CloudPESATrans."Document No" := TransactionCode;
                CloudPESATrans.Description := Format(TransactionType);
                CloudPESATrans."Document Date" := Today;
                CloudPESATrans."Account No" := Vendor."No.";
                CloudPESATrans."Account No2" := '';
                CloudPESATrans.Charge := TotalCharges;
                CloudPESATrans."Account Name" := Vendor.Name;
                CloudPESATrans."Telephone Number" := Vendor."Phone No.";
                CloudPESATrans."SMS Message" := response;
                CloudPESATrans.Amount := amount;
                CloudPESATrans.Status := CloudPESATrans.Status::Completed;
                CloudPESATrans.Posted := true;
                CloudPESATrans."Posting Date" := Today;
                CloudPESATrans.Comments := 'Success';
                CloudPESATrans.Client := Vendor."BOSA Account No";
                CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::"Utility Payment";
                CloudPESATrans."Transaction Time" := Time;
                CloudPESATrans.Insert;
                response := '{' +
                             ' "StatusCode": 41,' +
                             ' "StatusDescription": "Success"' +
                            '}';

                SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
            end
            else begin
                response := '{' +
                                ' "StatusCode": 42,' +
                                ' "StatusDescription": "Failed - Insufficient Funds"' +
                               '}';
                CloudPESATrans.Init;
                CloudPESATrans."Document No" := TransactionCode;
                CloudPESATrans.Description := Format(TransactionType);
                CloudPESATrans."Document Date" := Today;
                CloudPESATrans."Account No" := Vendor."No.";
                CloudPESATrans."Account No2" := '';
                CloudPESATrans.Charge := TotalCharges;
                CloudPESATrans."Account Name" := Vendor.Name;
                CloudPESATrans."Telephone Number" := Vendor."Phone No.";
                CloudPESATrans.Amount := amount;
                CloudPESATrans.Status := CloudPESATrans.Status::Failed;
                CloudPESATrans.Posted := false;
                CloudPESATrans."Posting Date" := Today;
                CloudPESATrans.Comments := 'Failed,Insufficient Funds';
                CloudPESATrans.Client := Vendor."BOSA Account No";
                CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::Airtime;
                CloudPESATrans."Transaction Time" := Time;
                CloudPESATrans.Insert;
            end;
        end
        else begin
            response := '{' +
                               ' "StatusCode": 42,' +
                               ' "StatusDescription": "Failed - Account Inexistent"' +
                              '}';
            CloudPESATrans.Init;
            CloudPESATrans."Document No" := TransactionCode;
            CloudPESATrans.Description := Format(TransactionType);
            CloudPESATrans."Document Date" := Today;
            CloudPESATrans."Account No" := '';
            CloudPESATrans."Account No2" := '';
            CloudPESATrans.Charge := TotalCharges;
            CloudPESATrans."Account Name" := Vendor.Name;
            CloudPESATrans."Telephone Number" := Vendor."Phone No.";
            CloudPESATrans.Amount := amount;
            CloudPESATrans.Posted := false;
            CloudPESATrans."Posting Date" := Today;
            CloudPESATrans.Comments := 'Failed,Invalid Account';
            CloudPESATrans.Client := '';
            CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::Airtime;
            CloudPESATrans."Transaction Time" := Time;
            CloudPESATrans.Insert;
        end;
    end;


    procedure MemberChannels(AccNumber: Text; TransactionType: Integer; TransactionCode: Text; UniqueTransactionID: Text) response: Text
    begin
        Vendor.Reset;
        Vendor.SetRange(Vendor."Phone No.", AccNumber);
        Vendor.SetRange(Vendor."ATM No.");
        if Vendor.Find('-') then begin
            response := '[';

            response += '{ "Id":' + '"' + Vendor."No." + '",' + '"Type":"ATM",' + '"Description":"Sacco link ATM",' +
            '"CardNumber":' + '"' + Vendor."ATM No." + '"';
            if Vendor.Next = 1 then begin
                response += ' },';
            end else begin
                response += ' }';
            end;
            SurePESAApplications.Reset;
            SurePESAApplications.SetRange(SurePESAApplications.Telephone, AccNumber);
            SurePESAApplications.SetRange(SurePESAApplications.Sent, true);
            if SurePESAApplications.Find('-') then begin
                response += '{ "Id":' + '"' + Vendor."No." + '",' + '"Type":"Mobile Banking",' + '"Description":"Pesa Pepe",' +
                  '"CardNumber":' + '"' + SurePESAApplications."Account No" + '"' + '}';
            end;
            AgentAccounts.Reset;
            AgentAccounts.SetRange(AgentAccounts."Comm Account", AccNumber);
            if AgentAccounts.Find('-') then begin
                response += '{ "Id":' + '"' + Vendor."No." + '",' + '"Type":"Agency",' + '"Description":"Sacco Agent",' +
                '"CardNumber":' + '"' + AgentAccounts."Agent Code" + '"' + '}';
            end;
            response += ' ]';
        end;
    end;


    procedure Reversals(AccNumber: Text; TransactionType: Integer; TransactionAmount: Decimal; TransactionCode: Text; Narration: Text) response: Text
    begin
        SurePESATrans.Reset;
        SurePESATrans.SetRange(SurePESATrans."Document No", TransactionCode);
        SurePESATrans.SetRange(SurePESATrans.Posted, true);
        if SurePESATrans.Find('-') then begin

            GenLedgerSetup.Reset;
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
            GenLedgerSetup.TestField(GenLedgerSetup."MPESA Recon Acc");
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

            SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
            MobileChargesACC := GenLedgerSetup."M-banking Charges Acc";
            MPESARecon := GenLedgerSetup."MPESA Recon Acc";

            MobileCharges := GetCharge(TransactionAmount, 'SACCOWD');
            MPESACharge := GetCharge(TransactionAmount, 'MPESA');
            SurePESACharge := 10;//GenLedgerSetup."CloudPESA Charge";

            ExcDuty := (20 / 100) * (MobileCharges);
            TotalCharges := SurePESACharge + MobileCharges + ExcDuty;

            Vendor.Reset;
            Vendor.SetRange(Vendor."Phone No.", AccNumber);
            Vendor.SetFilter(Vendor."Account Type", '%1|%2|%3|%4', 'ORDINARY', 'JUNIOR', 'CURRENT', 'GROUP');
            if Vendor.Find('-') then begin
                Vendor.CalcFields(Vendor."Balance (LCY)");
                TempBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions");

                if (TempBalance > 0) then begin
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                    GenJournalLine.DeleteAll;
                    //end of deletion

                    GenBatches.Reset;
                    GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                    GenBatches.SetRange(GenBatches.Name, 'MPESAWITHD');

                    if GenBatches.Find('-') = false then begin
                        GenBatches."Journal Template Name" := 'GENERAL';
                        GenBatches.Name := 'MPESAWITHD';
                        GenBatches.Description := Narration;
                        GenBatches.Validate(GenBatches."Journal Template Name");
                        GenBatches.Validate(GenBatches.Name);
                        GenBatches.Modify;
                    end;

                    //CR Customer Acc
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := Vendor."No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");

                    GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Bal. Account No." := MPESARecon;
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := Vendor."No.";
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := Narration;
                    GenJournalLine.Amount := -1 * TransactionAmount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //Cr Withdrawal Charges
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := Vendor."No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := Vendor."No.";
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := Narration + 'Charges';
                    GenJournalLine.Amount := TotalCharges * -1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //Cr MPESA Charges
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := Vendor."No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");

                    GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Bal. Account No." := MPESARecon;
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := Vendor."No.";
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := Narration + 'Charges';
                    GenJournalLine.Amount := MPESACharge * -1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //DR Excise Duty
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := Format(ExxcDuty);
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := MobileChargesACC;
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := 'Excise duty-' + Narration;
                    GenJournalLine.Amount := ExcDuty;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //DR Mobile Transactions Acc
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := MobileChargesACC;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := MobileChargesACC;
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := Narration + 'Charges';
                    GenJournalLine.Amount := MobileCharges;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //DR Surestep Acc
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := SurePESACommACC;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := MobileChargesACC;
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := Narration + 'Charges';
                    GenJournalLine.Amount := SurePESACharge;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //Post
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                    if GenJournalLine.Find('-') then begin
                        repeat
                            GLPosting.Run(GenJournalLine);
                        until GenJournalLine.Next = 0;
                    end;
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                    GenJournalLine.DeleteAll;

                    SurePESATrans.Status := SurePESATrans.Status::Completed;
                    SurePESATrans.Posted := true;
                    SurePESATrans."Posting Date" := Today;
                    SurePESATrans.Comments := 'Reversal Successful';
                    SurePESATrans.Modify;
                    response := '{' +
                                 ' "StatusCode": 41,' +
                                 ' "StatusDescription": "Success"' +
                                '}';
                    msg := 'We have reversed a withdrawal transaction of KES ' + Format(TransactionAmount) + ' to Account ' + Vendor.Name +
                    ' .Thank you for using Jamii Yetu Sacco M-Banking. #Stay_Safe';
                    SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
                end
                else begin
                    response := '{' +
                                    ' "StatusCode": 42,' +
                                    ' "StatusDescription": "Failed"' +
                                   '}';
                    SurePESATrans.Status := SurePESATrans.Status::Failed;
                    SurePESATrans.Posted := false;
                    SurePESATrans."Posting Date" := Today;
                    SurePESATrans.Comments := 'Failed,Insufficient Funds';
                    SurePESATrans.Modify;
                end;
            end else begin
                response := '{' +
                                   ' "StatusCode": 42,' +
                                   ' "StatusDescription": "Failed - Account Not Found"' +
                                  '}';
                msg := 'Your request has failed because account does not exist.' +
                 ' .Thank you for using Jamii Yetu Sacco M-Banking.';
                SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
                SurePESATrans.Status := SurePESATrans.Status::Failed;
                SurePESATrans.Posted := false;
                SurePESATrans."Posting Date" := Today;
                SurePESATrans.Comments := 'Failed,Invalid Account';
                SurePESATrans.Modify;
            end
        end

        else begin

            GenLedgerSetup.Reset;
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
            GenLedgerSetup.TestField(GenLedgerSetup."MPESA Recon Acc");
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

            SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
            MobileChargesACC := GenLedgerSetup."M-banking Charges Acc";
            MPESARecon := GenLedgerSetup."MPESA Recon Acc";

            MobileCharges := GetCharge(TransactionAmount, 'SACCOWD');
            MPESACharge := GetCharge(TransactionAmount, 'MPESA');
            SurePESACharge := 10;//GenLedgerSetup."CloudPESA Charge";

            ExcDuty := (20 / 100) * (MobileCharges);
            TotalCharges := SurePESACharge + MobileCharges + ExcDuty;

            Vendor.Reset;
            Vendor.SetRange(Vendor."Phone No.", AccNumber);
            Vendor.SetFilter(Vendor."Account Type", '%1|%2|%3|%4', 'ORDINARY', 'JUNIOR', 'CURRENT', 'GROUP');
            //Vendor.SETRANGE(Vendor."Account Type", 'CURRENT');
            if Vendor.Find('-') then begin
                Vendor.CalcFields(Vendor."Balance (LCY)");
                TempBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions");

                if (TempBalance > 0) then begin
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                    GenJournalLine.DeleteAll;
                    //end of deletion

                    GenBatches.Reset;
                    GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                    GenBatches.SetRange(GenBatches.Name, 'MPESAWITHD');

                    if GenBatches.Find('-') = false then begin
                        GenBatches.Init;
                        GenBatches."Journal Template Name" := 'GENERAL';
                        GenBatches.Name := 'MPESAWITHD';
                        GenBatches.Description := 'MPESA Withdrawal Reversal';
                        GenBatches.Validate(GenBatches."Journal Template Name");
                        GenBatches.Validate(GenBatches.Name);
                        GenBatches.Insert;
                    end;

                    //CR Customer Acc
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := Vendor."No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");

                    GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Bal. Account No." := MPESARecon;
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := Vendor."No.";
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := 'MPESA Withdrawal Reversal';
                    GenJournalLine.Amount := TransactionAmount * -1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //Cr Withdrawal Charges
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := Vendor."No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := Vendor."No.";
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := 'Mobile Withdrawal Charges';
                    GenJournalLine.Amount := TotalCharges * -1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //Cr MPESA Charges
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := Vendor."No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");

                    GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Bal. Account No." := MPESARecon;
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := Vendor."No.";
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := 'MPESA Withdrawal Charges';
                    GenJournalLine.Amount := MPESACharge * -1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //DR Excise Duty
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := Format(ExxcDuty);
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := MobileChargesACC;
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := 'Excise duty-Mobile Withdrawal';
                    GenJournalLine.Amount := ExcDuty;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //DR Mobile Transactions Acc
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := MobileChargesACC;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := MobileChargesACC;
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := 'Mobile Withdrawal Charges';
                    GenJournalLine.Amount := MobileCharges;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //DR Surestep Acc
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'MPESAWITHD';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := SurePESACommACC;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := TransactionCode;
                    GenJournalLine."External Document No." := MobileChargesACC;
                    GenJournalLine."Posting Date" := Today;
                    //GenJournalLine."Posting Date":=SurePESATrans."Document Date";
                    GenJournalLine.Description := 'Mobile Withdrawal Charges';
                    GenJournalLine.Amount := SurePESACharge;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //Post
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                    if GenJournalLine.Find('-') then begin
                        repeat
                            GLPosting.Run(GenJournalLine);
                        until GenJournalLine.Next = 0;
                    end;
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MPESAWITHD');
                    GenJournalLine.DeleteAll;

                    SurePESATrans.Init;
                    SurePESATrans."Document No" := TransactionCode;
                    SurePESATrans.Description := 'MPESA Withdrawal Reversal';
                    SurePESATrans."Document Date" := Today;
                    SurePESATrans."Account No" := Vendor."No.";
                    SurePESATrans."Account No2" := MPESARecon;
                    SurePESATrans.Amount := -1 * TransactionAmount;
                    SurePESATrans.Status := SurePESATrans.Status::Completed;
                    SurePESATrans.Posted := true;
                    SurePESATrans."Telephone Number" := Vendor."Phone No.";
                    SurePESATrans."Posting Date" := Today;
                    SurePESATrans.Comments := 'Success';
                    SurePESATrans.Client := Vendor."BOSA Account No";
                    SurePESATrans."Transaction Type" := SurePESATrans."transaction type"::Withdrawal;
                    SurePESATrans."Transaction Time" := Time;
                    SurePESATrans.Insert;
                    response := '{' +
                                 ' "StatusCode": 41,' +
                                 ' "StatusDescription": "Success"' +
                                '}';
                    msg := 'You have reversed a withdrawal transaction of KES ' + Format(amount) + ' to Account ' + Vendor.Name +
                    ' .Thank you for using Jamii Yetu Sacco M-Banking. #Stay_Safe';
                    SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
                end
                else begin
                    response := '{' +
                                    ' "StatusCode": 42,' +
                                    ' "StatusDescription": "Failed - Isufficient Funds"' +
                                   '}';
                    SurePESATrans.Init;
                    SurePESATrans."Document No" := TransactionCode;
                    SurePESATrans.Description := 'MPESA Withdrawal Reversal';
                    SurePESATrans."Document Date" := Today;
                    SurePESATrans."Account No" := Vendor."No.";
                    SurePESATrans."Account No2" := MPESARecon;
                    SurePESATrans.Amount := TransactionAmount;
                    SurePESATrans.Status := SurePESATrans.Status::Failed;
                    SurePESATrans.Posted := false;
                    SurePESATrans."Posting Date" := Today;
                    SurePESATrans.Comments := 'Reversal Failed';
                    SurePESATrans.Client := Vendor."BOSA Account No";
                    SurePESATrans."Transaction Type" := SurePESATrans."transaction type"::Withdrawal;
                    SurePESATrans."Transaction Time" := Time;
                    SurePESATrans.Insert;
                end;
            end else begin
                response := '{' +
                                   ' "StatusCode": 42,' +
                                   ' "StatusDescription": "Failed - Account Not Found"' +
                                  '}';
                msg := 'Your request has failed because account does not exist.' +
                 ' .Thank you for using Jamii Yetu Sacco M-Banking.';
                SMSMessage(TransactionCode, Vendor."No.", Vendor."Phone No.", msg);
                SurePESATrans.Init;
                SurePESATrans."Document No" := TransactionCode;
                SurePESATrans.Description := 'MPESA Withdrawal';
                SurePESATrans."Document Date" := Today;
                SurePESATrans."Account No" := '';
                SurePESATrans."Account No2" := MPESARecon;
                SurePESATrans.Amount := TransactionAmount;
                SurePESATrans.Posted := false;
                SurePESATrans."Posting Date" := Today;
                SurePESATrans.Comments := 'Reversal Failed,Invalid Account';
                SurePESATrans.Client := '';
                SurePESATrans."Transaction Type" := SurePESATrans."transaction type"::Withdrawal;
                SurePESATrans."Transaction Time" := Time;
                SurePESATrans.Insert;
            end;
        end;
    end;


    procedure Callback()
    begin
    end;


    procedure AccountBalance(Acc: Code[30]; DocNumber: Code[20]) Bal: Text[500]
    begin

    end;


    procedure LoanProducts() LoanTypes: Text[1000]
    begin

        begin
            LoanProductsSetup.Reset;
            LoanProductsSetup.SetRange(LoanProductsSetup.Source, LoanProductsSetup.Source::FOSA);
            if LoanProductsSetup.Find('-') then begin
                repeat
                    LoanTypes := LoanTypes + ':::' + LoanProductsSetup."Product Description";
                until LoanProductsSetup.Next = 0;
            end
        end
    end;


    procedure BOSAAccount(Phone: Text[20]) bosaAcc: Text[20]
    begin


    end;


    procedure MemberAccountNumbers(phone: Text[20]) accounts: Text[250]
    begin
        /*
        BEGIN
          Vendor.RESET;
          Vendor.SETRANGE(Vendor."Phone No.",fnGetphoneNumber(phone));
          Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
          Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
          IF Vendor.FIND('-') THEN
            BEGIN
               accounts:='';
               REPEAT
                 accounts:=accounts+'::::'+Vendor."No.";
               UNTIL Vendor.NEXT =0;
            END
          ELSE
          BEGIN
             accounts:='';
          END
          END;
          */

    end;


    procedure RegisteredMemberDetails(Phone: Text[20]) reginfo: Text[250]
    begin
        /*
         BEGIN
         Vendor.RESET;
         Vendor.SETRANGE(Vendor."Phone No.", fnGetphoneNumber(Phone));
         IF Vendor.FIND('-') THEN
          BEGIN
             Members.RESET;
             Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
             IF Members.FIND('-') THEN
             BEGIN
             reginfo:=Members."No."+':::'+Members.Name+':::'+FORMAT(Members."ID No.")+':::'+Members."Payroll/Staff No"+':::'+ Members."E-Mail";
             END;
         END
         ELSE
         BEGIN
         reginfo:='';
         END
         END;
         */

    end;


    procedure DetailedStatement(Phone: Text[20]; lastEntry: Integer) detailedstatement: Text[1023]
    begin

        begin
            dateExpression := '<CD-1M>'; // Current date less 3 months
            dashboardDataFilter := CalcDate(dateExpression, Today);

            Vendor.Reset;
            Vendor.SetRange(Vendor."Phone No.", Phone);
            //Vendor.SETRANGE(Vendor."Phone No.",AccNumber);
            detailedstatement := '';
            if Vendor.FindSet then
                repeat
                    minimunCount := 1;
                    AccountTypes.Reset;
                    AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");

                    if AccountTypes.FindSet then
                        repeat

                            DetailedVendorLedgerEntry.Reset;
                            DetailedVendorLedgerEntry.SetRange(DetailedVendorLedgerEntry."Vendor No.", Vendor."No.");
                            DetailedVendorLedgerEntry.SetFilter(DetailedVendorLedgerEntry."Entry No.", '>%1', lastEntry);
                            DetailedVendorLedgerEntry.SetFilter(DetailedVendorLedgerEntry."Posting Date", '>%1', dashboardDataFilter);

                            if DetailedVendorLedgerEntry.FindSet then
                                repeat

                                    VendorLedgerEntry.Reset;
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Entry No.", DetailedVendorLedgerEntry."Vendor Ledger Entry No.");

                                    if VendorLedgerEntry.FindSet then begin
                                        if detailedstatement = ''
                                        then begin
                                            detailedstatement := Format(DetailedVendorLedgerEntry."Entry No.") + ':::' +
                                            Format(AccountTypes.Description) + ':::' +
                                            Format(DetailedVendorLedgerEntry."Posting Date") + ':::' +
                                            Format((DetailedVendorLedgerEntry."Posting Date"), 0, '<Month Text>') + ':::' +
                                            Format(Date2dmy((DetailedVendorLedgerEntry."Posting Date"), 3)) + ':::' +
                                            Format((DetailedVendorLedgerEntry."Credit Amount"), 0, '<Precision,2:2><Integer><Decimals>') + ':::' +
                                            Format((DetailedVendorLedgerEntry."Debit Amount"), 0, '<Precision,2:2><Integer><Decimals>') + ':::' +
                                            Format((DetailedVendorLedgerEntry.Amount), 0, '<Precision,2:2><Integer><Decimals>') + ':::' +
                                            Format(DetailedVendorLedgerEntry."Journal Batch Name") + ':::' +
                                            Format(DetailedVendorLedgerEntry."Initial Entry Global Dim. 1") + ':::' +
                                            Format(VendorLedgerEntry.Description);
                                        end
                                        else
                                            repeat
                                                detailedstatement := detailedstatement + '::::' +
                                                Format(DetailedVendorLedgerEntry."Entry No.") + ':::' +
                                                Format(AccountTypes.Description) + ':::' +
                                                Format(DetailedVendorLedgerEntry."Posting Date") + ':::' +
                                                Format((DetailedVendorLedgerEntry."Posting Date"), 0, '<Month Text>') + ':::' +
                                                Format(Date2dmy((DetailedVendorLedgerEntry."Posting Date"), 3)) + ':::' +
                                                Format((DetailedVendorLedgerEntry."Credit Amount"), 0, '<Precision,2:2><Integer><Decimals>') + ':::' +
                                                Format((DetailedVendorLedgerEntry."Debit Amount"), 0, '<Precision,2:2><Integer><Decimals>') + ':::' +
                                                Format((DetailedVendorLedgerEntry.Amount), 0, '<Precision,2:2><Integer><Decimals>') + ':::' +
                                                Format(DetailedVendorLedgerEntry."Journal Batch Name") + ':::' +
                                                Format(DetailedVendorLedgerEntry."Initial Entry Global Dim. 1") + ':::' +
                                                Format(VendorLedgerEntry.Description);

                                                if minimunCount > 20 then
                                                    exit
                                            until VendorLedgerEntry.Next = 0;
                                    end;
                                until DetailedVendorLedgerEntry.Next = 0;
                        until AccountTypes.Next = 0;
                until Vendor.Next = 0;
        end;
    end;


    procedure MemberAccountNames(phone: Text[20]) accounts: Text[250]
    begin

    end;


    procedure SharesRetained(phone: Text[20]) shares: Text[1000]
    begin


    end;


    procedure LoanBalances(phone: Text[20]) loanbalances: Text[250]
    begin


    end;


    procedure MemberAccounts(phone: Text[20]) accounts: Text
    begin
        begin
            bosaNo := BOSAAccount(phone);
            Vendor.Reset;
            Vendor.SetRange(Vendor."BOSA Account No", bosaNo);
            Vendor.SetRange(Vendor.Status, Vendor.Status::Active);
            Vendor.SetRange(Vendor.Blocked, Vendor.Blocked::" ");
            Vendor.SetRange(Vendor."Account Type");
            if Vendor.Find('-') then begin
                accounts := '';
                repeat
                    accounts := accounts + '::::' + Vendor."No." + ':::' + AccountDescription(Vendor."Account Type");
                until Vendor.Next = 0;
            end
            else begin
                accounts := '';
            end
        end;
    end;


    procedure SurePESARegistration() memberdetails: Text
    begin


    end;


    procedure CurrentShares(phone: Text[20]) shares: Text[1000]
    begin


    end;


    procedure BenevolentFund(phone: Text[20]) shares: Text[50]
    begin

    end;


    procedure FundsTransferFOSA(accFrom: Text[20]; accTo: Text[20]; DocNumber: Text[30]; amount: Decimal) result: Text[30]
    begin

    end;


    procedure FundsTransferBOSA(accFrom: Text[20]; accTo: Text[20]; DocNumber: Text[30]; amount: Decimal) result: Text[30]
    begin

    end;


    procedure WSSAccount(phone: Text[20]) accounts: Text[250]
    begin
        begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."Phone No.", fnGetphoneNumber(phone));
            Vendor.SetRange(Vendor.Status, Vendor.Status::Active);
            Vendor.SetFilter(Vendor."Account Type", '%1|%2|%3|%4', 'ORDINARY', 'JUNIOR', 'CURRENT', 'GROUP');
            Vendor.SetRange(Vendor.Blocked, Vendor.Blocked::" ");
            if Vendor.Find('-') then begin
                accounts := Vendor."No." + ':::' + AccountDescription(Vendor."Account Type");
            end
            else begin
                accounts := '';
            end
        end;
    end;


    procedure SMSMessage(documentNo: Text[30]; accfrom: Text[30]; phone: Text[20]; message: Text[250])
    begin
        iEntryNo := 0;
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else begin
            iEntryNo := 1;
        end;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Batch No" := documentNo;
        SMSMessages."Document No" := documentNo;
        SMSMessages."Account No" := accfrom;
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'MOBILETRAN';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        SMSMessages."SMS Message" := message;
        //  SMSMessages."Additional sms":=addition;
        SMSMessages."Telephone No" := phone;
        // SMSMessages.ScheduleTime:=CREATEDATETIME(TODAY,070000T);
        if SMSMessages."Telephone No" <> '' then
            SMSMessages.Insert;
    end;


    procedure LoanRepayment(accFrom: Text[20]; loanNo: Text[20]; DocNumber: Text[30]; amount: Decimal) result: Text[30]
    var
        loanName: Text[50];
    begin

    end;


    procedure OutstandingLoans(phone: Text[20]) loannos: Text[200]
    begin


    end;


    procedure LoanGuarantors(loanNo: Text[20]) guarantors: Text[1000]
    begin

    end;


    procedure LoansGuaranteed(phone: Text[20]) guarantors: Text[1000]
    begin


    end;


    procedure LoanCalculator() calcdetails: Code[1024]
    var
        varLoan: Text[1024];
        LoanProducttype: Record "Loan Products Setup";
    begin

    end;


    procedure ClientCodes(loanNo: Text[20]) codes: Text[20]
    begin
        begin
            LoansRegister.Reset;
            LoansRegister.SetRange(LoansRegister."Loan  No.", loanNo);
            if LoansRegister.Find('-') then begin
                codes := LoansRegister."Client Code";
            end;
        end
    end;


    procedure ClientNames(ccode: Text[20]) names: Text[100]
    begin
        begin
            LoansRegister.Reset;
            LoansRegister.SetRange(LoansRegister."Client Code", ccode);
            if LoansRegister.Find('-') then begin
                Vendor.Reset;
                Vendor.SetRange(Vendor."BOSA Account No", ccode);
                if Vendor.Find('-') then begin
                    names := Vendor.Name;
                end;
            end;
        end
    end;


    procedure ChargesGuarantorInfo(Phone: Text[20]; DocNumber: Text[20]) result: Text[250]
    begin

    end;


    procedure AccountBalanceNew(Acc: Code[30]; DocNumber: Code[20]) Bal: Text[50]
    begin


    end;


    procedure AccountBalanceDec(Acc: Code[30]; amt: Decimal) Bal: Decimal
    begin
        begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."No.", Acc);
            Vendor.SetFilter(Vendor."Account Type", '%1|%2|%3|%4', 'ORDINARY', 'CURRENT', 'JUNIOR', 'GROUP');
            if Vendor.Find('-') then begin
                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                if AccountTypes.Find('-') then begin
                    miniBalance := AccountTypes."Minimum Balance";
                end;
                Vendor.CalcFields(Vendor."Balance (LCY)");
                Vendor.CalcFields(Vendor."ATM Transactions");
                Vendor.CalcFields(Vendor."Uncleared Cheques");
                Vendor.CalcFields(Vendor."EFT Transactions");
                Bal := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance);

                GenLedgerSetup.Reset;
                GenLedgerSetup.Get;
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
                GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

                SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
                MobileChargesACC := GenLedgerSetup."M-banking Charges Acc";

                MobileCharges := GetCharge(amount, 'SACCOGEN');
                SurePESACharge := GenLedgerSetup."CloudPESA Charge";

                ExcDuty := (20 / 100) * (MobileCharges);
                TotalCharges := SurePESACharge + MobileCharges;

                MPESACharge := GetCharge(amt, 'MPESA');
                SurePESACharge := GetCharge(amt, 'VENDWD');
                MobileCharges := GetCharge(amt, 'SACCOWD');

                ExcDuty := (20 / 100) * (MobileCharges + SurePESACharge);
                TotalCharges := SurePESACharge + MobileCharges + ExcDuty + MPESACharge;
                Bal := Bal - TotalCharges;
            end
        end;
    end;

    local procedure GetCharge(amount: Decimal; "code": Text[20]) charge: Decimal
    begin

        TariffDetails.Reset;
        TariffDetails.SetRange(TariffDetails.Code, code);
        TariffDetails.SetFilter(TariffDetails."Lower Limit", '<=%1', amount);
        TariffDetails.SetFilter(TariffDetails."Upper Limit", '>=%1', amount);
        if TariffDetails.Find('-') then begin
            charge := TariffDetails."Charge Amount";
        end
    end;


    procedure PostMPESATrans(docNo: Text[20]; telephoneNo: Text[20]; amount: Decimal) result: Text
    begin


    end;


    procedure AccountDescription("code": Text[20]) description: Text[100]
    begin


    end;


    procedure InsertTransaction(MSISDN: Code[30]; BusinessShortCode: Code[10]; TransID: Code[30]; TransAmount: Decimal; TransTime: DateTime; BillRefNumber: Code[10]; OrgAccountBalance: Decimal; KYCInfo: Text) Result: Code[20]
    var
        keyword: Text;

    begin




        PaybillTrans.Init;
        PaybillTrans."Document No" := TransID;
        keyword := CopyStr(BillRefNumber, 1, 3);
        GetKeyword(keyword, BillRefNumber);
        //PaybillTrans."Account No" := BillRefNumber;
        PaybillTrans."Account Name" := KYCInfo;

        if StrLen(KYCInfo) > 34 then begin
            PaybillTrans."Date Posted" := Today;
            PaybillTrans."Needs Manual Posting" := true;
            PaybillTrans.Description := 'Failed';
        end else begin
            PaybillTrans.Description := 'PayBill Deposit';
        end;

        PaybillTrans.Posted := false;
        PaybillTrans."Transaction Date" := Today;
        PaybillTrans."Transaction Time" := Time;
        PaybillTrans."Trans Date" := TransTime;
        PaybillTrans.Telephone := MSISDN;
        PaybillTrans.Amount := TransAmount;
        PaybillTrans.Insert;
        //..........................................................................
        PaybillTrans.Reset;
        PaybillTrans.SetRange(PaybillTrans."Document No", TransID);
        if PaybillTrans.Find('-') then begin
            Result := 'TRUE';
        end else begin
            Result := 'FALSE';
        end;
    end;


    procedure PaybillSwitch() Result: Code[20]
    begin

        PaybillTrans.Reset;
        PaybillTrans.SetRange(PaybillTrans.Posted, false);
        PaybillTrans.SetRange(PaybillTrans."Needs Manual Posting", false);
        if PaybillTrans.Find('-') then begin

            Vendor.Reset;
            Vendor.SetRange(Vendor."No.", PaybillTrans."Key Word" + PaybillTrans."Account No");
            if Vendor.Find('-') then begin
                Result := PayBillToAccapi('PAYBILL', PaybillTrans."Document No", PaybillTrans."Key Word" + PaybillTrans."Account No", PaybillTrans."Account No", PaybillTrans.Amount, 'ORDINARY');

            end else begin

                Vendor.Reset;
                Vendor.SetRange(Vendor."BOSA Account No", PaybillTrans."Key Word" + PaybillTrans."Account No");
                //Vendor.SetRange(Vendor."Account Type", 'ORDINARY');
                Vendor.SetFilter(Vendor."Account Type", '%1|%2', 'ORDINARY', 'GROUP');
                if Vendor.Find('-') then begin
                    Result := PayBillToAccapi('PAYBILL', PaybillTrans."Document No", Vendor."No.", Vendor."No.", PaybillTrans.Amount, 'ORDINARY');
                end else begin
                    case PaybillTrans."Key Word" of
                        'C':
                            if FnAccountIsGroupType(CopyStr(PaybillTrans."Account No", 1, 19)) = true then begin
                                Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'GROUP');
                            end else
                                if FnAccountIsGroupType(CopyStr(PaybillTrans."Account No", 1, 19)) = false then begin
                                    Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'ORDINARY');
                                end;
                        'L19':
                            Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'HOLIDAY');
                        'L01':
                            Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'ORDINARY');
                        'L02':
                            Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'CURRENT');
                        'L05':
                            Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'CHRISTMAS');
                        'L03':
                            Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'JUNIOR');
                        'L11':
                            Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'JAZA');
                        'L20':
                            Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'AGENTFL');
                        'L12':
                            Result := PayBillToBOSA('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, PaybillTrans."Key Word", 'PayBill to Deposit');
                        'S03':
                            Result := PayBillToBOSA('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, PaybillTrans."Key Word", 'Unwithdrawable Shares');
                        'A03':
                            Result := PayBillToFosaLoan('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'NORM ADV', 'FOSA');
                        'A22':
                            Result := PayBillToMicroLoan('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'CEEP NEW', 'MICRO');
                        'A11':
                            Result := PayBillToBosaLoan('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'DEVELOPMENT', 'BOSA');
                        'A10':
                            Result := PayBillToBosaLoan('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'HOUSING', 'BOSA');
                        'A09':
                            Result := PayBillToBosaLoan('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'EXECUTIVE', 'BOSA');
                        'A08':
                            Result := PayBillToBosaLoan('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'DEVTVIA_SAVINGS', 'BOSA');
                        'A14':
                            Result := PayBillToBosaLoan('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'HOUSING', 'BOSA');
                        'A':
                            Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, 'ORDINARY');
                        'G':
                            Result := PayBillToAcc('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, '110');
                        'S':
                            Result := PayBillToBOSA('PAYBILL', PaybillTrans."Document No", CopyStr(PaybillTrans."Account No", 1, 19), CopyStr(PaybillTrans."Account No", 1, 19), PaybillTrans.Amount, PaybillTrans."Key Word", 'PayBill to Deposit');
                        else
                            PaybillTrans."Date Posted" := Today;
                            PaybillTrans."Needs Manual Posting" := true;
                            PaybillTrans.Description := 'Failed';
                            PaybillTrans.Modify;
                    end;

                    if Result = '' then begin
                        PaybillTrans."Date Posted" := Today;
                        PaybillTrans."Needs Manual Posting" := true;
                        PaybillTrans.Description := 'Failed';
                        PaybillTrans.Modify;
                        //msg:='Dear '+PaybillTrans."Account Name"+'. Your deposit of Ksh. '+ FORMAT(PaybillTrans.Amount)+' will be credited to your account. Thank You For Choosing to Bank With Us';
                        // SMSMessage('PAYBILLTRANS',PaybillTrans."Account No",PaybillTrans.Telephone,msg);
                    end;

                end;
            end;
        end;
    end;

    local procedure PayBillToAcc(batch: Code[20]; docNo: Code[20]; accNo: Code[20]; memberNo: Code[20]; Amount: Decimal; accountType: Code[30]) res: Code[10]
    begin
        GenLedgerSetup.Reset;
        GenLedgerSetup.Get;
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
        PaybillRecon := GenLedgerSetup.PaybillAcc;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        GenJournalLine.DeleteAll;
        //end of deletion

        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
        GenBatches.SetRange(GenBatches.Name, batch);

        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := 'GENERAL';
            GenBatches.Name := batch;
            GenBatches.Description := 'Paybill Deposit';
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;//General Jnr Batches
            // IF accountType='ORDINARY' THEN BEGIN
        Vendor.Reset;
        Vendor.SetRange(Vendor."BOSA Account No", accNo);
        Vendor.SetRange(Vendor."Account Type", accountType);

        if Vendor.FindFirst then begin

            //Cr Customer
            LineNo := LineNo + 10000;
            GenJournalLine.Init;
            GenJournalLine."Journal Template Name" := 'GENERAL';
            GenJournalLine."Journal Batch Name" := batch;
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
            GenJournalLine."Account No." := Vendor."No.";
            GenJournalLine.Validate(GenJournalLine."Account No.");

            GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
            GenJournalLine.Validate(GenJournalLine."Account No.");
            GenJournalLine."Bal. Account No." := PaybillRecon;
            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");


            GenJournalLine."Document No." := docNo;
            GenJournalLine."External Document No." := docNo;
            GenJournalLine."Posting Date" := PaybillTrans."Transaction Date";
            GenJournalLine.Description := 'Paybill Deposit by ' + Format(CopyStr(PaybillTrans."Account Name", 1, 30));
            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
            GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranchUsingFosaAccount(Vendor."No.");
            GenJournalLine.Amount := -1 * Amount;
            GenJournalLine.Validate(GenJournalLine.Amount);
            if GenJournalLine.Amount <> 0 then
                GenJournalLine.Insert;
        end;
        //Post
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        if GenJournalLine.Find('-') then begin
            repeat
                GLPosting.Run(GenJournalLine);
            until GenJournalLine.Next = 0;
            PaybillTrans.Posted := true;
            PaybillTrans."Date Posted" := Today;
            PaybillTrans.Description := 'Posted';
            PaybillTrans.Modify;
            res := 'TRUE';

            msg := 'Dear  ' + SplitString(Vendor.Name, ' ') + ', ' + PaybillTrans."Account Name" + ' has credited your acc: ' + Vendor."No." + ' with Ksh. ' + Format(Amount) + ' . Thank you for Choosing to Bank With Us."Your Financial Health Our Concern"';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Vendor."Phone No.", msg);
        end
        else begin
            PaybillTrans."Date Posted" := Today;
            PaybillTrans."Needs Manual Posting" := true;
            PaybillTrans.Description := 'Failed';
            PaybillTrans.Modify;
            res := 'FALSE';
            msg := 'Dear ' + PaybillTrans."Account Name" + ', we have received Ksh. ' + Format(Amount) + 'but has not been credited to your account, Thank you for choosing to bank with Us."Your Financial Health Our Concern"';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Vendor."Phone No.", msg);
        end;

    end;

    local procedure PayBillToBOSA(batch: Code[20]; docNo: Code[20]; accNo: Code[20]; memberNo: Code[20]; amount: Decimal; type: Code[30]; descr: Text[100]) res: Code[10]
    var
        Memb: Record Customer;
    begin

        GenLedgerSetup.Reset;
        GenLedgerSetup.Get;
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

        SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
        MobileChargesACC := GenLedgerSetup."M-banking Charges Acc";

        MobileCharges := GetCharge(amount, 'SACCOSHC');
        SurePESACharge := GenLedgerSetup."CloudPESA Charge";

        ExcDuty := (20 / 100) * (MobileCharges);
        TotalCharges := SurePESACharge + MobileCharges + ExcDuty;

        PaybillRecon := GenLedgerSetup.PaybillAcc;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        GenJournalLine.DeleteAll;
        //end of deletion

        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
        GenBatches.SetRange(GenBatches.Name, batch);

        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := 'GENERAL';
            GenBatches.Name := batch;
            GenBatches.Description := descr;
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;//General Jnr Batches
        Members.Reset;
        if (PaybillTrans."Key Word" = 'L12') or (PaybillTrans."Key Word" = 'S03') then begin
            Memb.SetRange(Memb."BOSA Account No.", accNo);
            Memb.SetRange(Memb."Customer Posting Group", 'MICRO');
            if Memb.Find('-') then begin
                if PaybillTrans."Key Word" = 'L12' then
                    Members.SetRange(Members."No.", Memb."No.")
                else
                    Members.SetRange(Members."No.", accNo);
            end;
        end else begin
            Members.SetRange(Members."No.", accNo);
        end;


        if Members.Find('-') then begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."BOSA Account No", accNo);
            // Vendor.SETRANGE(Vendor."Account Type", fosaConst);
            if Vendor.FindFirst then begin

                //Cr Customer
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := batch;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                GenJournalLine."Account No." := Members."No.";
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Document No." := docNo;
                GenJournalLine."External Document No." := docNo;
                GenJournalLine."Posting Date" := Today;
                case PaybillTrans."Key Word" of
                    'S':
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                end;
                case PaybillTrans."Key Word" of
                    'S03':
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                end;
                case PaybillTrans."Key Word" of
                    'L12':
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                end;
                /*CASE PaybillTrans."Key Word" OF 'SHA':
                  GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Shares Capital";
                END;
                CASE PaybillTrans."Key Word" OF 'BVF':
                  GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Benevolent Fund";
                END;*/

                GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Bal. Account No." := PaybillRecon;
                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Description := descr + ' ' + PaybillTrans."Account Name";
                GenJournalLine.Amount := (amount) * -1;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //Dr Deposit Charges
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := batch;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Account No." := Vendor."No.";
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Document No." := docNo;
                GenJournalLine."External Document No." := Vendor."No.";
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := descr + ' Charges';
                GenJournalLine.Amount := TotalCharges;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //CR Excise Duty
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := batch;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                GenJournalLine."Account No." := Format(ExxcDuty);
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Document No." := docNo;
                GenJournalLine."External Document No." := docNo;
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := 'Excise duty-' + descr;
                GenJournalLine.Amount := ExcDuty * -1;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //CR Mobile Transactions Acc
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := batch;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                GenJournalLine."Account No." := MobileChargesACC;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Document No." := docNo;
                GenJournalLine."External Document No." := MobileChargesACC;
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := descr + ' Charges';
                GenJournalLine.Amount := MobileCharges * -1;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //CR Surestep Acc
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := batch;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                GenJournalLine."Account No." := SurePESACommACC;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Document No." := docNo;
                GenJournalLine."External Document No." := docNo;
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := descr + ' Charges';
                GenJournalLine.Amount := -SurePESACharge;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;
            end;//Vendor
        end;//Member

        //Post
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        if GenJournalLine.Find('-') then begin
            repeat
                GLPosting.Run(GenJournalLine);
            until GenJournalLine.Next = 0;
            PaybillTrans.Posted := true;
            PaybillTrans."Date Posted" := Today;
            PaybillTrans.Description := 'Posted';
            PaybillTrans.Modify;
            res := 'TRUE';

            msg := 'Dear ' + Members.Name + ', your acc: ' + PaybillTrans."Account No" + ' has been credited with Ksh ' + Format(amount) + ' Thank you for using Jamii Yetu Sacco';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Members."Phone No.", msg);
        end
        else begin
            PaybillTrans."Date Posted" := Today;
            PaybillTrans."Needs Manual Posting" := true;
            PaybillTrans.Description := 'Failed';
            PaybillTrans.Modify;
            res := 'FALSE';
            msg := 'Dear ' + Members.Name + ', we have received Ksh. ' + Format(amount) + 'but has not been credited to your account, Thank you for using Jamii Yetu Sacco';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Members."Phone No.", msg);
        end;

    end;

    local procedure PayBillToLoan(batch: Code[20]; docNo: Code[20]; accNo: Code[20]; memberNo: Code[20]; amount: Decimal; type: Code[30]) res: Code[10]
    begin
        GenLedgerSetup.Reset;
        GenLedgerSetup.Get;
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

        SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
        SurePESACharge := GenLedgerSetup."CloudPESA Charge";
        PaybillRecon := GenLedgerSetup.PaybillAcc;

        ExcDuty := (20 / 100) * SurePESACharge;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        GenJournalLine.DeleteAll;
        //end of deletion

        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
        GenBatches.SetRange(GenBatches.Name, batch);

        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := 'GENERAL';
            GenBatches.Name := batch;
            GenBatches.Description := 'Paybill Loan Repayment';
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;//General Jnr Batches

        Members.Reset;
        Members.SetRange(Members."No.", accNo);
        if Members.Find('-') then begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."BOSA Account No", accNo);
            // Vendor.SETRANGE(Vendor."Account Type", fosaConst);
            if Vendor.FindFirst then begin

                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister."Loan Product Type", type);
                LoansRegister.SetRange(LoansRegister."Client Code", Members."No.");

                if LoansRegister.Find('+') then begin
                    LoansRegister.CalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
                    if LoansRegister."Outstanding Balance" > 0 then begin

                        //Dr MPESA PAybill ACC
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := batch;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                        GenJournalLine."Account No." := PaybillRecon;
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := docNo;
                        GenJournalLine."External Document No." := docNo;
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Paybill Loan Repayment';
                        GenJournalLine.Amount := amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        if LoansRegister."Oustanding Interest" > 0 then begin
                            LineNo := LineNo + 10000;

                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := batch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                            GenJournalLine."Account No." := LoansRegister."Client Code";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := docNo;
                            GenJournalLine."External Document No." := docNo;
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Loan Interest Payment';


                            if amount > LoansRegister."Oustanding Interest" then
                                GenJournalLine.Amount := -LoansRegister."Oustanding Interest"
                            else
                                GenJournalLine.Amount := -amount;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";

                            if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                                GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            end;
                            GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            amount := amount + GenJournalLine.Amount;
                        end;

                        if amount > 0 then begin
                            LineNo := LineNo + 10000;

                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := batch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                            GenJournalLine."Account No." := LoansRegister."Client Code";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := docNo;
                            GenJournalLine."External Document No." := '';
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Paybill Loan Repayment';
                            GenJournalLine.Amount := -amount;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                            if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                                GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            end;
                            GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;
                        end;




                    end//Outstanding Balance
                end//Loan Register
            end;//Vendor
        end;//Member

        //Post
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        if GenJournalLine.Find('-') then begin
            repeat
                GLPosting.Run(GenJournalLine);
            until GenJournalLine.Next = 0;
            PaybillTrans.Posted := true;
            PaybillTrans."Date Posted" := Today;
            PaybillTrans.Description := 'Posted';
            PaybillTrans.Modify;
            res := 'TRUE';
        end
        else begin
            PaybillTrans."Date Posted" := Today;
            PaybillTrans."Needs Manual Posting" := true;
            PaybillTrans.Description := 'Failed';
            PaybillTrans.Modify;
            res := 'FALSE';
        end;

    end;

    local procedure PayBillToBosaLoan(batch: Code[20]; docNo: Code[20]; accNo: Code[20]; memberNo: Code[20]; amount: Decimal; productType: Code[30]; productSource: Code[30]) res: Code[10]
    var
        prodType: Option;
    begin
        GenLedgerSetup.Reset;
        GenLedgerSetup.Get;
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

        SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
        SurePESACharge := GenLedgerSetup."CloudPESA Charge";
        PaybillRecon := GenLedgerSetup.PaybillAcc;

        ExcDuty := SaccoSet."Excise Duty(%)" * SurePESACharge;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        GenJournalLine.DeleteAll;
        //end of deletion

        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
        GenBatches.SetRange(GenBatches.Name, batch);

        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := 'GENERAL';
            GenBatches.Name := batch;
            GenBatches.Description := 'Paybill Loan Repayment';
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;//General Jnr Batches

        if productSource = 'BOSA' then begin
            prodType := LoanProductsSetup.Source::BOSA;
        end;

        Members.Reset;
        Members.SetRange(Members."No.", accNo);
        if Members.Find('-') then begin
            LoansRegister.Reset;
            LoansRegister.SetRange(LoansRegister.Source, prodType);
            LoansRegister.SetRange(LoansRegister."Client Code", Members."No.");
            if LoansRegister.Find('+') then begin
                LoansRegister.CalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
                if LoansRegister."Outstanding Balance" > 0 then begin

                    //Dr MPESA PAybill ACC
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := batch;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Account No." := PaybillRecon;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := docNo;
                    GenJournalLine."External Document No." := docNo;
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Paybill Loan Repayment';
                    GenJournalLine.Amount := amount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    if LoansRegister."Oustanding Interest" > 0 then begin
                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := batch;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."Account No." := LoansRegister."Client Code";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := docNo;
                        GenJournalLine."External Document No." := docNo;
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Loan Interest Payment';


                        if amount > LoansRegister."Oustanding Interest" then
                            GenJournalLine.Amount := -LoansRegister."Oustanding Interest"
                        else
                            GenJournalLine.Amount := -amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";

                        if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                            GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        end;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        amount := amount + GenJournalLine.Amount;
                    end;

                    if amount > 0 then begin
                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := batch;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                        GenJournalLine."Account No." := LoansRegister."Client Code";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := docNo;
                        GenJournalLine."External Document No." := '';
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Paybill Loan Repayment';
                        GenJournalLine.Amount := -amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                        if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                            GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        end;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;
                    end;
                end//Outstanding Balance
            end//Loan Register
        end;//Member

        //Post
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        if GenJournalLine.Find('-') then begin
            repeat
                GLPosting.Run(GenJournalLine);
            until GenJournalLine.Next = 0;
            PaybillTrans.Posted := true;
            PaybillTrans."Date Posted" := Today;
            PaybillTrans.Description := 'Posted';
            PaybillTrans.Modify;
            res := 'TRUE';

            msg := 'Dear ' + Members.Name + ', your loan associated with acc: ' + PaybillTrans."Account No" + ' has been credited with Ksh ' + Format(amount) + ' on the date of ' + Format(PaybillTrans."Transaction Date") + '. Thank you for using Jamii Yetu Sacco';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Members."Phone No.", msg);
        end
        else begin
            PaybillTrans."Date Posted" := Today;
            PaybillTrans."Needs Manual Posting" := true;
            PaybillTrans.Description := 'Failed';
            PaybillTrans.Modify;
            res := 'FALSE';

            msg := 'Dear ' + Members.Name + ', we have received Ksh. ' + Format(amount) + 'but has not been credited to your account, Thank you for using Jamii Yetu Sacco';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Members."Phone No.", msg);
        end;

    end;

    local procedure PayBillToFosaLoan(batch: Code[20]; docNo: Code[20]; accNo: Code[20]; memberNo: Code[20]; amount: Decimal; productType: Code[30]; productSource: Code[30]) res: Code[10]
    var
        prodType: Option;
    begin
        GenLedgerSetup.Reset;
        GenLedgerSetup.Get;
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

        SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
        SurePESACharge := GenLedgerSetup."CloudPESA Charge";
        PaybillRecon := GenLedgerSetup.PaybillAcc;

        ExcDuty := SaccoSet."Excise Duty(%)" * SurePESACharge;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        GenJournalLine.DeleteAll;
        //end of deletion

        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
        GenBatches.SetRange(GenBatches.Name, batch);

        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := 'GENERAL';
            GenBatches.Name := batch;
            GenBatches.Description := 'Paybill Loan Repayment';
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;//General Jnr Batches

        if productSource = 'FOSA' then begin
            prodType := LoanProductsSetup.Source::FOSA;
        end;

        Members.Reset;
        Members.SetRange(Members."No.", accNo);
        if Members.Find('-') then begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."BOSA Account No", Members."No.");
            if Vendor.FindFirst then begin
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister."Client Code", Vendor."No.");
                if LoansRegister.Find('+') then begin
                    LoansRegister.CalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
                    if LoansRegister."Outstanding Balance" > 0 then begin

                        //Dr MPESA PAybill ACC
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := batch;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                        GenJournalLine."Account No." := PaybillRecon;
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := docNo;
                        GenJournalLine."External Document No." := docNo;
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Paybill Loan Repayment';
                        GenJournalLine.Amount := amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        if LoansRegister."Oustanding Interest" > 0 then begin
                            LineNo := LineNo + 10000;

                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := batch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := LoansRegister."Client Code";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := docNo;
                            GenJournalLine."External Document No." := docNo;
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Loan Interest Payment';


                            if amount > LoansRegister."Oustanding Interest" then
                                GenJournalLine.Amount := -LoansRegister."Oustanding Interest"
                            else
                                GenJournalLine.Amount := -amount;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";

                            if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                                GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            end;
                            GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            amount := amount + GenJournalLine.Amount;
                        end;

                        if amount > 0 then begin
                            LineNo := LineNo + 10000;

                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := batch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := LoansRegister."Client Code";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := docNo;
                            GenJournalLine."External Document No." := '';
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Description := 'Paybill Loan Repayment';
                            GenJournalLine.Amount := -amount;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                            if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                                GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            end;
                            GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;
                        end;
                    end//Outstanding Balance
                end//Loan Register
            end;//Vendor
        end;//Member

        //Post
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        if GenJournalLine.Find('-') then begin
            repeat
                GLPosting.Run(GenJournalLine);
            until GenJournalLine.Next = 0;
            PaybillTrans.Posted := true;
            PaybillTrans."Date Posted" := Today;
            PaybillTrans.Description := 'Posted';
            PaybillTrans.Modify;
            res := 'TRUE';

            msg := 'Dear ' + Members.Name + ', your loan associated with acc: ' + PaybillTrans."Account No" + ' has been credited with Ksh ' + Format(amount) + ' on the date of ' + Format(PaybillTrans."Transaction Date") + '. Thank you for using Jamii Yetu Sacco';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Members."Phone No.", msg);
        end
        else begin
            PaybillTrans."Date Posted" := Today;
            PaybillTrans."Needs Manual Posting" := true;
            PaybillTrans.Description := 'Failed';
            PaybillTrans.Modify;
            res := 'FALSE';

            msg := 'Dear ' + Members.Name + ', we have received Ksh. ' + Format(amount) + 'but has not been credited to your account, Thank you for using Jamii Yetu Sacco';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Members."Phone No.", msg);
        end;

    end;

    local procedure PayBillToMicroLoan(batch: Code[20]; docNo: Code[20]; accNo: Code[20]; memberNo: Code[20]; amount: Decimal; productType: Code[30]; productSource: Code[30]) res: Code[10]
    var
        prodType: Option;
        newAccountNo: Code[30];
    begin
        GenLedgerSetup.Reset;
        GenLedgerSetup.Get;
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

        SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
        SurePESACharge := GenLedgerSetup."CloudPESA Charge";
        PaybillRecon := GenLedgerSetup.PaybillAcc;

        ExcDuty := SaccoSet."Excise Duty(%)" * SurePESACharge;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        GenJournalLine.DeleteAll;
        //end of deletion

        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
        GenBatches.SetRange(GenBatches.Name, batch);

        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := 'GENERAL';
            GenBatches.Name := batch;
            GenBatches.Description := 'Paybill Loan Repayment';
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;//General Jnr Batches

        if productSource = 'MICRO' then begin
            prodType := LoanProductsSetup.Source::MICRO;
            newAccountNo := GetMicroAccNumber(accNo);
        end;

        Members.Reset;
        Members.SetRange(Members."No.", newAccountNo);
        if Members.Find('-') then begin
            LoansRegister.Reset;
            //LoansRegister.SETRANGE(LoansRegister.Source, prodType);
            LoansRegister.SetRange(LoansRegister."Client Code", Members."No.");
            if LoansRegister.Find('+') then begin
                LoansRegister.CalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
                if LoansRegister."Outstanding Balance" > 0 then begin

                    //Dr MPESA PAybill ACC
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := batch;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Account No." := PaybillRecon;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := docNo;
                    GenJournalLine."External Document No." := docNo;
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Paybill Loan Repayment';
                    GenJournalLine.Amount := amount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    if LoansRegister."Oustanding Interest" > 0 then begin
                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := batch;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."Account No." := LoansRegister."Client Code";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := docNo;
                        GenJournalLine."External Document No." := docNo;
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Loan Interest Payment';


                        if amount > LoansRegister."Oustanding Interest" then
                            GenJournalLine.Amount := -LoansRegister."Oustanding Interest"
                        else
                            GenJournalLine.Amount := -amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";

                        if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                            GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        end;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        amount := amount + GenJournalLine.Amount;
                    end;

                    if amount > 0 then begin
                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := batch;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."Account No." := LoansRegister."Client Code";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := docNo;
                        GenJournalLine."External Document No." := '';
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Paybill Loan Repayment';
                        GenJournalLine.Amount := -amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                        if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                            GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        end;
                        if GenJournalLine."Shortcut Dimension 2 Code" = '' then begin
                            GenJournalLine."Shortcut Dimension 2 Code" := Members."Global Dimension 2 Code";
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        end;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;
                    end;
                end//Outstanding Balance
            end//Loan Register
        end;//Member

        //Post
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        if GenJournalLine.Find('-') then begin
            repeat
                GLPosting.Run(GenJournalLine);
            until GenJournalLine.Next = 0;
            PaybillTrans.Posted := true;
            PaybillTrans."Date Posted" := Today;
            PaybillTrans.Description := 'Posted';
            PaybillTrans.Modify;
            res := 'TRUE';

            msg := 'Dear ' + Members.Name + ', your loan associated with acc: ' + PaybillTrans."Account No" + ' has been credited with Ksh ' + Format(amount) + ' on the date of ' + Format(PaybillTrans."Transaction Date") + '. Thank you for using Jamii Yetu Sacco';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Members."Phone No.", msg);
        end
        else begin
            PaybillTrans."Date Posted" := Today;
            PaybillTrans."Needs Manual Posting" := true;
            PaybillTrans.Description := 'Failed';
            PaybillTrans.Modify;
            res := 'FALSE';

            msg := 'Dear ' + Members.Name + ', we have received Ksh. ' + Format(amount) + 'but has not been credited to your account, Thank you for using Jamii Yetu Sacco';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Members."Phone No.", msg);
        end;

    end;

    procedure LoanBalancesUSSD(phone: Text[50]; loanNo: Text[50]; DocNumber: Text[50]) loanbalances: Text[250]
    var
        chargeres: Text[30];
    begin

    end;


    procedure SharesUSSD(phone: Text[20]; DocNumber: Text[50]) shares: Text[1000]
    var
        normalshares: Text;
        sharecapital: Text;
        chargeres: Text[30];
    begin

    end;


    procedure PostAirtime(phone: Code[50]; "Doc No": Code[100]; amount: Decimal) result: Text[50]
    begin

        CloudPESATrans.Reset;
        CloudPESATrans.SetRange(CloudPESATrans."Document No", "Doc No");
        if CloudPESATrans.Find('-') then begin
            result := ' REFEXISTS';
        end
        else begin
            GenLedgerSetup.Reset;
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup.AirTimeSettlAcc);
            airtimeAcc := GenLedgerSetup.AirTimeSettlAcc;
            miniBalance := AccountTypes."Minimum Balance";
        end;

        Vendor.Reset;
        Vendor.SetRange(Vendor."No.", phone);
        //Vendor.SetRange(Vendor."Account Type", 'ORDINARY');
        Vendor.SetFilter(Vendor."Account Type", '%1|%2', 'ORDINARY', 'GROUP');
        if Vendor.Find('-') then begin
            Vendor.CalcFields(Vendor."Balance (LCY)");
            Vendor.CalcFields(Vendor."ATM Transactions");
            Vendor.CalcFields(Vendor."Uncleared Cheques");
            Vendor.CalcFields(Vendor."EFT Transactions");
            Vendor.CalcFields(Vendor."Mobile Transactions");
            TempBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + Vendor."Mobile Transactions" + miniBalance);

            if (TempBalance > amount) then begin
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'AIRTIME');
                GenJournalLine.DeleteAll;
                //end of deletion
                GenBatches.Reset;
                GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                GenBatches.SetRange(GenBatches.Name, 'AIRTIME');

                if GenBatches.Find('-') = false then begin
                    GenBatches.Init;
                    GenBatches."Journal Template Name" := 'GENERAL';
                    GenBatches.Name := 'AIRTIME';
                    GenBatches.Description := 'AIRTIME Purchase';
                    GenBatches.Validate(GenBatches."Journal Template Name");
                    GenBatches.Validate(GenBatches.Name);
                    GenBatches.Insert;
                end;

                //DR Customer Acc
                LineNo := LineNo + 10000;
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'AIRTIME';
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"G/L Account";
                GenJournalLine."Account No." := Vendor."No.";
                GenJournalLine."Bal. Account No." := airtimeAcc;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                GenJournalLine."Document No." := "Doc No";
                GenJournalLine."External Document No." := Vendor."No.";
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := 'AIRTIME Purchase';
                GenJournalLine.Amount := amount;
                GenJournalLine.Validate(GenJournalLine.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;



                //Post
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'AIRTIME');
                if GenJournalLine.Find('-') then begin
                    repeat
                        GLPosting.Run(GenJournalLine);
                    until GenJournalLine.Next = 0;
                end;
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'AIRTIME');
                GenJournalLine.DeleteAll;
                msg := 'You have purchased airtime worth KES ' + Format(amount) + ' from Account ' + Vendor.Name +
             ' thank you for using Jamii Yetu Sacco Mobile.';

                CloudPESATrans.Init;
                CloudPESATrans."Document No" := "Doc No";
                CloudPESATrans.Description := 'AIRTIME Purchase';
                CloudPESATrans."Document Date" := Today;
                CloudPESATrans."Account No" := Vendor."No.";
                CloudPESATrans."Account No2" := phone;
                CloudPESATrans.Charge := TotalCharges;
                CloudPESATrans."Account Name" := Vendor.Name;
                //CloudPESATrans."Payroll Number":=Vendor."Payroll/Staff No2";
                // CloudPESATrans."Payroll Number":=Vendor."Account Special Instructions";
                CloudPESATrans."Telephone Number" := Vendor."Phone No.";
                CloudPESATrans."SMS Message" := msg;
                CloudPESATrans.Amount := amount;
                CloudPESATrans.Status := CloudPESATrans.Status::Completed;
                CloudPESATrans.Posted := true;
                CloudPESATrans."Posting Date" := Today;
                CloudPESATrans.Comments := 'Success';
                CloudPESATrans.Client := Vendor."BOSA Account No";
                CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::Airtime;
                CloudPESATrans."Transaction Time" := Time;
                CloudPESATrans.Insert;
                result := 'TRUE';

                SMSMessage("Doc No", Vendor."No.", Vendor."Phone No.", msg);
            end
            else begin
                result := 'INSUFFICIENT';
                msg := 'You have insufficient funds in your savings Account to use this service.' +
               ' .Thank you for using Jamii Yetu Sacco Mobile.';
                SMSMessage(docNo, Vendor."No.", Vendor."Phone No.", msg);
                CloudPESATrans.Init;
                CloudPESATrans."Document No" := "Doc No";
                CloudPESATrans.Description := 'AIRTIME Purchase';
                CloudPESATrans."Document Date" := Today;
                CloudPESATrans."Account No" := Vendor."No.";
                CloudPESATrans."Account No2" := phone;
                CloudPESATrans.Charge := TotalCharges;
                CloudPESATrans."Account Name" := Vendor.Name;
                //CloudPESATrans."Payroll Number":=Vendor."Payroll/Staff No2";
                //CloudPESATrans."Payroll Number":=Vendor."Account Special Instructions";
                CloudPESATrans."Telephone Number" := Vendor."Phone No.";
                CloudPESATrans.Amount := amount;
                CloudPESATrans.Status := CloudPESATrans.Status::Failed;
                CloudPESATrans.Posted := false;
                CloudPESATrans."Posting Date" := Today;
                CloudPESATrans.Comments := 'Failed,Insufficient Funds';
                CloudPESATrans.Client := Vendor."BOSA Account No";
                CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::Airtime;
                CloudPESATrans."Transaction Time" := Time;
                CloudPESATrans.Insert;
            end;
        end
        else begin
            result := 'ACCINEXISTENT';
            CloudPESATrans.Init;
            CloudPESATrans."Document No" := "Doc No";
            CloudPESATrans.Description := 'AIRTIME Purchase';
            CloudPESATrans."Document Date" := Today;
            CloudPESATrans."Account No" := '';
            CloudPESATrans."Account No2" := phone;
            CloudPESATrans.Charge := TotalCharges;
            CloudPESATrans."Account Name" := Vendor.Name;
            // CloudPESATrans."Payroll Number":=Vendor."Payroll/Staff No2";
            //CloudPESATrans."Payroll Number":=Vendor."Account Special Instructions";
            CloudPESATrans."Telephone Number" := Vendor."Phone No.";
            CloudPESATrans.Amount := amount;
            CloudPESATrans.Posted := false;
            CloudPESATrans."Posting Date" := Today;
            CloudPESATrans.Comments := 'Failed,Invalid Account';
            CloudPESATrans.Client := '';
            CloudPESATrans."Transaction Type" := CloudPESATrans."transaction type"::Airtime;
            CloudPESATrans."Transaction Time" := Time;
            CloudPESATrans.Insert;
        end;
    end;


    procedure AccountBalanceAirtime(Acc: Code[30]; amt: Decimal) Bal: Decimal
    begin

        begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."No.", Acc);
            if Vendor.Find('-') then begin
                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                if AccountTypes.Find('-') then begin
                    miniBalance := AccountTypes."Minimum Balance";
                end;
                Vendor.CalcFields(Vendor."Balance (LCY)");
                Vendor.CalcFields(Vendor."ATM Transactions");
                Vendor.CalcFields(Vendor."Uncleared Cheques");
                Vendor.CalcFields(Vendor."EFT Transactions");
                Bal := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance);

                GenLedgerSetup.Reset;
                GenLedgerSetup.Get;
                GenLedgerSetup.TestField(GenLedgerSetup."Mobile Charge");
                //GenLedgerSetup.TESTFIELD(GenLedgerSetup."MPESA Reconciliation acc");
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
                GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

                Charges.Reset;
                //Charges.SETRANGE(Charges.Code,GenLedgerSetup."equity bank acc");
                if Charges.Find('-') then begin
                    Charges.TestField(Charges."GL Account");

                    MPESACharge := GetCharge(amt, 'MPESA');
                    CloudPESACharge := GetCharge(amt, 'VENDWD');
                    MobileCharges := GetCharge(amt, 'SACCOWD');

                    // ExcDuty:=(10/100)*(MobileCharges+CloudPESACharge);
                    TotalCharges := 0;//CloudPESACharge+MobileCharges+ExcDuty+MPESACharge;
                end;
                Bal := Bal - TotalCharges;
            end

        end;

    end;


    procedure AdvanceEligibility(account: Text[50]) Res: Text
    var
        StoDedAmount: Decimal;
        STO: Record "Standing Orders";
        FOSALoanRepayAmount: Decimal;
        CumulativeNet: Decimal;
        LastSalaryDate: Date;
        FirstSalaryDate: Date;
        AvarageNetPay: Decimal;
        AdvQualificationAmount: Decimal;
        CumulativeNet2: Decimal;
        finalAmount: Decimal;
        interestAMT: Decimal;
        MaxLoanAmt: Decimal;
        LastPaydate: Date;
        MPayDate: Decimal;
        MToday: Decimal;
        DateRegistered: Date;
        MtodayYear: Decimal;
        RegYear: Decimal;
        MtodayDiff: Decimal;
        MRegdate: Decimal;
        ComittedShares: Decimal;
        LoanGuarantors: Record "Loans Guarantee Details";
        FreeShares: Decimal;
        TotalAmount: Decimal;
        TransactionLoanAmt: Decimal;
        TransactionLoanDiff: Decimal;
        RepayedLoanAmt: Decimal;
        LoanRepaymentS: Record "Loan Repayment Schedule";
        Fulldate: Date;
        LastRepayDate: Date;
        PrincipalAmount: Decimal;
        employeeCode: Code[100];
        countTrans: Integer;
        MemberLedgerEntry2: Record "Cust. Ledger Entry";
        memberNO: Code[50];
    begin

    end;


    procedure PostAdvance(docNo: Code[20]; telephoneNo: Code[20]; amount: Decimal) result: Code[50]
    var
        LoanAcc: Code[30];
        InterestAcc: Code[30];
        InterestAmount: Decimal;
        AmountToCredit: Decimal;
        loanNo: Text;
        advSMS: Decimal;
        advFee: Decimal;
        advApp: Decimal;
        advSMSAcc: Code[20];
        advFEEAcc: Code[20];
        advAppAcc: Code[20];
        advSMSDesc: Text[100];
        advFeeDesc: Text[100];
        advAppDesc: Text[100];
        SurePESATrans: Record "SurePESA Transactions";
        LoanProdCharges: Record "Loan Product Charges";
        SurePESACharge: Decimal;
        SurePESACommACC: Code[100];
        SaccoNoSeries: Record "Sacco No. Series";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        LoanRepSchedule: Record "Loan Repayment Schedule";
    begin

        SurePESATrans.Reset;
        SurePESATrans.SetRange(SurePESATrans."Document No", docNo);
        if SurePESATrans.Find('-') then begin
            result := 'REFEXISTS';
        end
        else begin

            GenLedgerSetup.Reset;
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
            GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Charge");

            LoanProductsSetup.Reset;
            LoanProductsSetup.SetRange(LoanProductsSetup.Code, 'MOBILE LOAN');
            if LoanProductsSetup.FindFirst() then begin
                LoanAcc := LoanProductsSetup."Loan Account";
                InterestAcc := LoanProductsSetup."Loan Interest Account";
            end;

            LoanProdCharges.Reset;
            LoanProdCharges.SetRange(LoanProdCharges."Product Code", 'MOBILE LOAN');
            LoanProdCharges.SetRange(LoanProdCharges.Code, 'LAPPLICATION');
            if LoanProdCharges.FindFirst() then begin
                advApp := LoanProdCharges.Amount;
                advAppAcc := LoanProdCharges."G/L Account";
                advAppDesc := LoanProdCharges.Description;
            end;

            LoanProdCharges.Reset;
            LoanProdCharges.SetRange(LoanProdCharges."Product Code", 'MOBILE LOAN');
            LoanProdCharges.SetRange(LoanProdCharges.Code, 'LOAN DISB SMS');
            if LoanProdCharges.FindFirst() then begin
                advSMS := LoanProdCharges.Amount;
                advSMSAcc := LoanProdCharges."G/L Account";
                advSMSDesc := LoanProdCharges.Description;
            end;

            LoanProdCharges.Reset;
            LoanProdCharges.SetRange(LoanProdCharges."Product Code", 'MOBILE LOAN');
            LoanProdCharges.SetRange(LoanProdCharges.Code, 'LAPPRAISAL');
            if LoanProdCharges.FindFirst() then begin
                advFee := LoanProdCharges.Amount;
                advFEEAcc := LoanProdCharges."G/L Account";
                advFeeDesc := LoanProdCharges.Description;
            end;

            SurePESACharge := GenLedgerSetup."CloudPESA Charge";
            SurePESACommACC := GenLedgerSetup."CloudPESA Comm Acc";
            InterestAmount := (20 / 100) * amount;
            AmountToCredit := amount - (SurePESACharge + advApp + advFee + advSMS + InterestAmount);
            //ExcDuty:=(10/100)*(MobileCharges+SurePESACharge);

            Vendor.Reset;
            Vendor.SetRange(Vendor."Phone No.", telephoneNo);
            // Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
            if Vendor.Find('-') then begin

                Members.Reset;
                Members.SetRange(Members."No.", Vendor."BOSA Account No");
                if Members.Find('-') then begin

                    //*******Create Loan *********//
                    SaccoNoSeries.Get;
                    SaccoNoSeries.TestField(SaccoNoSeries."FOSA Loans Nos");
                    // loanNo := NoSeriesMgt.GetNextNo(SaccoNoSeries."FOSA Loans Nos", 0D, true);

                    //END;
                    LoansRegister.Init;
                    LoansRegister."Approved Amount" := amount;
                    LoansRegister.Interest := LoanProductsSetup."Interest rate";
                    LoansRegister."Instalment Period" := LoanProductsSetup."Instalment Period";
                    LoansRegister.Repayment := amount + InterestAmount;
                    LoansRegister."Expected Date of Completion" := CalcDate('1M', Today);
                    LoansRegister.Posted := true;
                    // LoansRegister."Shares Balance":=
                    Members.CalcFields(Members."Current Shares", Members."Outstanding Balance",
                    Members."Current Loan");
                    LoansRegister."Shares Balance" := Members."Current Shares";
                    LoansRegister."Net Payment to FOSA" := AmountToCredit;
                    LoansRegister.Savings := Members."Current Shares";
                    LoansRegister."Interest Paid" := InterestAmount;
                    LoansRegister."Issued Date" := Today;
                    LoansRegister."Repayment Start Date" := Today;
                    LoansRegister.Source := LoansRegister.Source::FOSA;
                    LoansRegister."Loan Disbursed Amount" := AmountToCredit;
                    LoansRegister."Current Interest Paid" := InterestAmount;
                    LoansRegister."Loan Disbursement Date" := Today;
                    LoansRegister."Client Code" := Members."No.";
                    LoansRegister."Client Name" := Members.Name;
                    LoansRegister."Existing Loan" := Members."Outstanding Balance";
                    LoansRegister.Gender := Members.Gender;
                    LoansRegister."BOSA No" := Vendor."BOSA Account No";
                    LoansRegister."Branch Code" := Vendor."Global Dimension 2 Code";
                    LoansRegister."Requested Amount" := amount;
                    LoansRegister."ID NO" := Vendor."ID No.";
                    if LoansRegister."Branch Code" = '' then
                        LoansRegister."Branch Code" := Members."Global Dimension 2 Code";
                    LoansRegister."Loan  No." := loanNo;
                    LoansRegister."No. Series" := SaccoNoSeries."FOSA Loans Nos";
                    LoansRegister."Doc No Used" := docNo;
                    LoansRegister."BOSA No" := Vendor."BOSA Account No";
                    LoansRegister."Loan Interest Repayment" := InterestAmount;
                    LoansRegister."Loan Principle Repayment" := amount;
                    LoansRegister."Loan Repayment" := amount + InterestAmount;
                    LoansRegister."ID NO" := Vendor."ID No.";
                    LoansRegister."Employer Code" := Vendor."Employer P/F";
                    //LoansRegister."Appraised By":=USERID;
                    //LoansRegister."Posted By":=USERID;
                    //LoansRegister."Discount Amount":=0;
                    LoansRegister."Interest Upfront Amount" := InterestAmount;
                    LoansRegister."Approval Status" := LoansRegister."approval status"::Approved;
                    LoansRegister."Account No" := Vendor."No.";
                    LoansRegister."Application Date" := Today;
                    LoansRegister."Loan Product Type" := LoanProductsSetup.Code;
                    LoansRegister."Loan Product Type Name" := LoanProductsSetup."Product Description";
                    LoansRegister.Installments := 1;
                    LoansRegister."Loan Amount" := amount;
                    LoansRegister.Posted := true;
                    LoansRegister."Issued Date" := Today;
                    LoansRegister."Outstanding Balance" := 0;//Update
                    LoansRegister."Repayment Frequency" := LoansRegister."repayment frequency"::Monthly;
                    LoansRegister."Recovery Mode" := LoansRegister."recovery mode"::Salary;
                    LoansRegister."Mode of Disbursement" := LoansRegister."mode of disbursement"::"Cheque";
                    LoansRegister.Insert(true);



                    //**********Process Loan*******************//
                    Vendor.CalcFields(Vendor."Balance (LCY)");
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'MOBILELOAN');
                    GenJournalLine.DeleteAll;
                    //end of deletion

                    GenBatches.Reset;
                    GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                    GenBatches.SetRange(GenBatches.Name, 'MOBILELOAN');

                    if GenBatches.Find('-') = false then begin
                        GenBatches.Init;
                        GenBatches."Journal Template Name" := 'GENERAL';
                        GenBatches.Name := 'MOBILELOAN';
                        GenBatches.Description := 'Mobile Loan';
                        GenBatches.Validate(GenBatches."Journal Template Name");
                        GenBatches.Validate(GenBatches.Name);
                        GenBatches.Insert;
                    end;

                    //Post Loan
                    LoansRegister.Reset;
                    LoansRegister.SetRange(LoansRegister."Doc No Used", docNo);
                    if LoansRegister.Find('-') then begin

                        //Dr Loan Acc
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MOBILELOAN';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Loan;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Account No." := Members."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := LoansRegister."Loan  No.";
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Mobile Loan Disbursment';
                        GenJournalLine.Amount := amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //Cr Fosa Acc
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MOBILELOAN';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Account No." := Vendor."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := LoansRegister."Loan  No.";
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Mobile Loan Disbursment';
                        GenJournalLine.Amount := -amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //Dr Fosa Acc with charges
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MOBILELOAN';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine."Account No." := Vendor."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := LoansRegister."Loan  No.";
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Mobile Loan Charge';
                        GenJournalLine.Amount := TotalCharges;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;



                        //Interest charge
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'MOBILELOAN';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                        GenJournalLine."Account No." := LoansRegister."Client Code";
                        GenJournalLine.Validate(GenJournalLine."Account No.");

                        GenJournalLine."Document No." := LoansRegister."Loan  No.";
                        ;
                        GenJournalLine."External Document No." := '';
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        GenJournalLine.Description := 'Loan ' + Format(GenJournalLine."transaction type"::"Insurance Charge");
                        GenJournalLine.Amount := InterestAmount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Insurance Charge";
                        if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                            GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        end;
                        GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := InterestAcc;
                        GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;




                        //Post
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'MOBILELOAN');
                        if GenJournalLine.Find('-') then begin
                            repeat
                                GLPosting.Run(GenJournalLine);
                            until GenJournalLine.Next = 0;
                        end;


                        msg := 'Dear ' + Vendor.Name + ' your loan of KES ' + Format(amount) + ' has been processed. KES ' + Format(amount) + ' has been credited to ACC ' + Vendor."Account Type" +
                      '. Your monthly repayment of KES ' + Format(amount + InterestAmount) + ' is due on ' + Format(CalcDate('+1M', Today));

                        //***************Update Loan Status************//
                        LoansRegister."Loan Status" := LoansRegister."loan status"::Issued;
                        LoansRegister."Amount Disbursed" := amount;
                        LoansRegister.Posted := true;
                        // LoansRegister."Discount Amount":=amount;
                        LoansRegister."Outstanding Balance" := amount;
                        LoansRegister.Modify;

                        //Insert to Schedule***********//
                        //LoanRepSchedule
                        LoanRepSchedule.Init;
                        LoanRepSchedule."Loan No." := loanNo;
                        LoanRepSchedule."Member No." := Vendor."BOSA Account No";
                        LoanRepSchedule."Loan Category" := 'MOBILE LOAN';
                        LoanRepSchedule."Loan Amount" := AmountToCredit;
                        LoanRepSchedule."Monthly Repayment" := AmountToCredit;
                        LoanRepSchedule."Monthly Interest" := 0;
                        LoanRepSchedule."Repayment Date" := Today;
                        LoanRepSchedule."Principal Repayment" := amount;
                        LoanRepSchedule."Instalment No" := 1;
                        LoanRepSchedule."Loan Balance" := AmountToCredit;
                        LoanRepSchedule.Insert();

                        SurePESATrans.Init;
                        SurePESATrans."Document No" := docNo;
                        SurePESATrans.Description := 'Mobile Advance';
                        SurePESATrans."Document Date" := Today;
                        SurePESATrans."Account No" := Vendor."No.";
                        SurePESATrans."SMS Message" := msg;
                        SurePESATrans.Charge := TotalCharges;
                        SurePESATrans."Account Name" := Vendor.Name;
                        SurePESATrans."Telephone Number" := Vendor."Phone No.";

                        SurePESATrans."Account No2" := '';
                        SurePESATrans.Amount := amount;
                        SurePESATrans.Status := SurePESATrans.Status::Completed;
                        SurePESATrans.Posted := true;
                        SurePESATrans."Posting Date" := Today;
                        SurePESATrans.Comments := 'Success';
                        SurePESATrans.Client := Vendor."BOSA Account No";
                        SurePESATrans."Transaction Type" := SurePESATrans."transaction type"::"Loan Application";
                        SurePESATrans."Transaction Time" := Time;
                        SurePESATrans.Insert;
                        result := 'TRUE';

                        SMSMessage(docNo, Vendor."No.", Vendor."Phone No.", msg);
                    end;//Loans Register
                end
            end
            else begin
                result := 'ACCINEXISTENT';
                SurePESATrans.Init;
                SurePESATrans."Document No" := docNo;
                SurePESATrans.Description := 'Mobile Advance';
                SurePESATrans."Document Date" := Today;
                SurePESATrans."Account No" := Vendor."No.";
                SurePESATrans."Account No2" := '';
                SurePESATrans.Amount := amount;
                SurePESATrans.Status := SurePESATrans.Status::Completed;
                SurePESATrans.Posted := true;
                SurePESATrans."Posting Date" := Today;
                SurePESATrans.Comments := 'Failed.Invalid Account';
                SurePESATrans.Client := Vendor."BOSA Account No";
                SurePESATrans."Transaction Type" := SurePESATrans."transaction type"::"Loan Application";
                SurePESATrans."Transaction Time" := Time;
                SurePESATrans.Insert;
            end;
        end;
    end;


    procedure GenericCharges(Phone: Text[20]; DocNumber: Text[50]; Description: Text[50]) result: Text[250]
    begin

    end;


    procedure OutstandingLoansUSSD(phone: Text[20]) loannos: Text[200]
    begin
        /*
        BEGIN
          Vendor.RESET;
          Vendor.SETRANGE(Vendor."Phone No.",phone);
              IF Vendor.FIND('-') THEN BEGIN
                LoansRegister.RESET;
                LoansRegister.SETRANGE(LoansRegister."Account No",Vendor."No.");
                IF LoansRegister.FIND('-') THEN BEGIN
                REPEAT
                  LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Interest Due",LoansRegister."Interest to be paid",LoansRegister."Interest Paid");
                  IF (LoansRegister."Outstanding Balance">0) THEN
                        loannos:= loannos + LoansRegister."Loan  No."+':::'+LoanProdName(LoansRegister."Loan Product Type")+'::::';
                UNTIL LoansRegister.NEXT = 0;
                loannos:= COPYSTR(loannos,1,STRLEN(loannos)-3);
                END;
          END
        END;
        */

    end;


    procedure LoanProdName(Cod: Text[20]) name: Text[200]
    begin
        /*
         LoanProductsSetup.RESET;
         LoanProductsSetup.SETRANGE(LoanProductsSetup.Code,LoansRegister."Loan Product Type");
         IF LoanProductsSetup.FINDFIRST THEN BEGIN
             name:= LoanProductsSetup."Product Description";
         END;
         */

    end;


    procedure AccountTypeName(Cod: Text[20]) name: Text[200]
    begin
        /*
        AccountTypes.RESET;
        AccountTypes.SETRANGE(AccountTypes.Code,AccountTypes.Description);
        IF AccountTypes.FINDFIRST THEN BEGIN
            name:= AccountTypes.Description;
        END;
        */

    end;


    procedure CommisionEarned() AccBal: Text[1024]
    begin
        /*
        GLEntries.RESET;
        GLEntries.SETRANGE("G/L Account No.",'3430');
        
        amount:=0;
        IF GLEntries.FIND('-') THEN BEGIN
        REPEAT
        amount:=amount+GLEntries."Credit Amount";
        UNTIL GLEntries.NEXT=0;
        AccBal:='::::'+FORMAT(amount)+':::';
        END;
        */

    end;


    procedure fnProcessNotification()
    var
        PrincipalAmount: Decimal;
        TransactionLoanDiff: Decimal;
        LoanSMSNotice: Record "Loan SMS Notice";
        loanNotificationDate: Date;
        LoanRepay: Record "Loan Repayment Schedule";
        loanamt: Decimal;
        amtsecondnotice: Decimal;
        repayamt: Decimal;
        Loanbal: Decimal;
        memb: Record Customer;
    begin
        //=============================================================== Initialize Loans Register ====================================================================//
        LoansRegister.Reset;
        LoansRegister.SetRange(LoansRegister.Posted, true);
        LoansRegister.CalcFields(LoansRegister."Oustanding Interest", LoansRegister."Outstanding Balance");
        LoansRegister.SetFilter(LoansRegister."Employer Code", '<>%1', LoansRegister."Employer Code", 'MMH');
        LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
        if LoansRegister.Find('-') then begin
            repeat
                PrincipalAmount := 0;
                TransactionLoanDiff := 0;
                LoansRegister.CalcFields(LoansRegister."Oustanding Interest", LoansRegister."Outstanding Balance");

                LoanSMSNotice.Reset;
                LoanSMSNotice.SetRange(LoanSMSNotice."Loan No", LoansRegister."Loan  No.");
                if LoanSMSNotice.Find('-') = false then begin
                    LoanSMSNotice.Reset;
                    if LoanSMSNotice.Find('+') then begin
                        iEntryNo := LoanSMSNotice."Entry No";
                        iEntryNo := iEntryNo + 1;
                    end
                    else begin
                        iEntryNo := 1;
                    end;

                    LoanSMSNotice.Init;
                    LoanSMSNotice."Entry No" := iEntryNo;
                    LoanSMSNotice."Loan No" := LoansRegister."Loan  No.";
                    LoanSMSNotice.Insert;
                end;

                LoanSMSNotice.Reset;
                LoanSMSNotice.SetRange(LoanSMSNotice."Loan No", LoansRegister."Loan  No.");
                if LoanSMSNotice.Find('-') then begin

                    // =============================================== if Not has arreas =========================================================================================================//
                    loanNotificationDate := Today;
                    TransactionLoanDiff := LoansRegister."Outstanding Balance" + LoansRegister."Oustanding Interest";

                    Members.Reset;
                    Members.Get(LoansRegister."Client Code");
                    if TransactionLoanDiff > 0 then begin
                        //==================================================== send if due date is today =====================================================================================//
                        LoanRepay.Reset;
                        LoanRepay.SetRange(LoanRepay."Loan No.", LoansRegister."Loan  No.");
                        if LoanRepay.Find('-') then begin
                            msg := 'Habari ' + SplitString(Members.Name, ' ') + '. Je, umelipa mkopo wako wa mwezi wa ' + LoansRegister."Loan Product Type Name" + ' ya kiasi Ksh. '
                            + Format(LoansRegister."Loan Principle Repayment" + LoansRegister."Oustanding Interest", 0, '<Precision,2><sign><Integer Thousand><Decimals,3>')
                            + '? Kama bado,' + ' Lipa kupitia LIPA na MPESA Paybill 587649. Ikiwa Umelipa,Mapema ndio best, Anza kulipa mdogo mdogo malipo ya mwezi wa Nne';
                            SMSMessage(LoansRegister."Doc No Used", LoansRegister."Client Code", Members."Phone No.", msg);
                        end;


                        // =========================================== End of send if due date is today ========================================================================================================//


                        // =========================================== Start of send if due date is  7 Day  =============================================================================================================//

                        LoanRepay.Reset;
                        LoanRepay.SetRange(LoanRepay."Loan No.", LoansRegister."Loan  No.");
                        LoanRepay.CalcSums(LoanRepay."Monthly Repayment");
                        loanamt := LoanRepay."Monthly Repayment";
                        //    LoanRepay.SETRANGE(LoanRepay."Repayment Date",CALCDATE('7D',TODAY));
                        if LoanRepay.Find('-') then begin

                            //      IF LoansRegister."Outstanding Balance">=LoansRegister."Loan Principle Repayment" THEN

                            //        IF (LoanSMSNotice."SMS 7 Day"=0D) OR (LoanSMSNotice."SMS 7 Day"=CALCDATE('7D',TODAY)) THEN BEGIN
                            //         LoanSMSNotice."SMS 7 Day":=CALCDATE('1M',CALCDATE('7D',TODAY));
                            //          LoanSMSNotice.MODIFY;
                            msg := 'Dear ' + SplitString(Members.Name, ' ') + ', Your Monthly Loan Repayment for ' + LoansRegister."Loan Product Type Name" + ' of  Kshs. '
                            + Format(LoansRegister."Loan Principle Repayment" + LoansRegister."Oustanding Interest", 0, '<Precision,2><sign><Integer Thousand><Decimals,3>')
                            + ' will fall due in the next 7 days.' + ' Kindly make arrangements to pay via Bank A/C or  Via LIPA na MPESA Paybill 587649';
                            //    SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg);
                            //     END
                            //        ELSE

                            //        IF  LoansRegister."Outstanding Balance"<LoansRegister."Loan Principle Repayment" THEN BEGIN
                            /*
                                      msg:='Dear '+SplitString(Members.Name,' ')+', Your Monthly Loan Repayment for '+LoansRegister."Loan Product Type Name"+' of  Kshs. '
                                       +FORMAT(LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest",0,'<Precision,2><sign><Integer Thousand><Decimals,3>')
                                       +' will fall due in the next 7 days.'+' Kindly make arrangements to pay via Bank A/C or  Via LIPA na MPESA Paybill 587649';
                                      SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg);
                            */

                        end;

                    end;

                    // =========================================== Start of send if due date is  7 Day  =============================================================================================================//



                    //MESSAGE(LoansRegister."Loan  No.");
                    LoanRepay.Reset;
                    LoanRepay.SetRange(LoanRepay."Loan No.", LoansRegister."Loan  No.");
                    LoanRepay.SetFilter(LoanRepay."Repayment Date", '..' + Format(CalcDate('CM+1D-2M', Today)));
                    LoanRepay.CalcSums(LoanRepay."Monthly Repayment");
                    loanamt := LoanRepay."Monthly Repayment" / 2;
                    //    amtsecondnotice:=FnGetOutstandingBal(LoansRegister."Loan  No.")/2;
                    repayamt := LoansRegister.Repayment * 2;
                    Loanbal := loanamt - amtsecondnotice;
                    if (Loanbal > repayamt) then begin

                        if (LoanSMSNotice."Notice SMS 1" = 0D) or (LoanSMSNotice."Notice SMS 1" <= Today) then begin
                            LoanSMSNotice."Notice SMS 1" := CalcDate('1M', Today);
                            LoanSMSNotice.Modify;
                            msg := 'Dear ' + SplitString(Members.Name, ' ') + ', Your loan repayment for ' + LoansRegister."Loan Product Type Name" + ' of amount Ksh. ' + Format(TransactionLoanDiff, 0, '<Precision,2><sign><Integer Thousand><Decimals,3>')
                            + ' is in Arreas for 1 Month' + 'Please pay via Bank A/C or  Via LIPA na MPESA Paybill 587649';
                            // SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg);

                            LoanGuaranteeDetails.Reset;
                            LoanGuaranteeDetails.SetRange(LoanGuaranteeDetails."Loan No", LoanSMSNotice."Loan No");
                            LoanGuaranteeDetails.SetRange(LoanGuaranteeDetails."Self Guarantee", false);
                            if LoanGuaranteeDetails.Find('-') then begin
                                repeat
                                    memb.Reset;
                                    memb.SetRange(memb."No.", LoanGuaranteeDetails."Member No");
                                    if memb.Find('-') then begin
                                        msg := 'Dear ' + SplitString(memb.Name, ' ') + ',Your Guarantee ' + Members.Name + ' has defaulted loan amount Ksh. ' + Format(TransactionLoanDiff, 0, '<Precision,2><sign><Integer Thousand><Decimals,3>')
                                   + ' for one Month';
                                        //   SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",memb."Phone No.",msg);
                                    end;
                                until LoanGuaranteeDetails.Next = 0;

                            end;
                        end;

                    end;

                    // Second Notice
                    LoanRepay.Reset;
                    LoanRepay.SetRange(LoanRepay."Loan No.", LoansRegister."Loan  No.");
                    LoanRepay.SetFilter(LoanRepay."Repayment Date", '..' + Format(CalcDate('CM+1D-2M', Today)));//FORMAT(CALCDATE('CM+1D-3M', TODAY))+'..'+FORMAT(CALCDATE('CM',TODAY)));
                    LoanRepay.CalcSums(LoanRepay."Monthly Repayment");
                    loanamt := LoanRepay."Monthly Repayment" / 3;
                    //  amtsecondnotice:=FnGetOutstandingBal(LoansRegister."Loan  No.")/3;
                    repayamt := LoansRegister.Repayment * 3;
                    Loanbal := loanamt - amtsecondnotice;
                    if (Loanbal > repayamt) then begin

                        if (LoanSMSNotice."Notice SMS 2" = 0D) or (LoanSMSNotice."Notice SMS 2" <= Today) then begin
                            LoanSMSNotice."Notice SMS 2" := CalcDate('1M', Today);
                            LoanSMSNotice.Modify;
                            msg := 'Dear ' + SplitString(Members.Name, ' ') + ', Your loan repayment for ' + LoansRegister."Loan Product Type Name" + ' of amount Ksh. ' + Format(TransactionLoanDiff, 0, '<Precision,2><sign><Integer Thousand><Decimals,3>')
                            + ' is in Arreas for 2 Months' + 'Please pay via Bank A/C or  Via LIPA na MPESA Paybill 587649';
                            // SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg);

                            LoanGuaranteeDetails.Reset;
                            LoanGuaranteeDetails.SetRange(LoanGuaranteeDetails."Loan No", LoanSMSNotice."Loan No");
                            LoanGuaranteeDetails.SetRange(LoanGuaranteeDetails."Self Guarantee", false);
                            if LoanGuaranteeDetails.Find('-') then begin
                                repeat
                                    memb.Reset;
                                    memb.SetRange(memb."No.", LoanGuaranteeDetails."Member No");
                                    if memb.Find('-') then begin
                                        msg := 'Dear ' + SplitString(memb.Name, ' ') + ', Your Guarantee ' + Members.Name + ' has defaulted loan amount Ksh. ' + Format(TransactionLoanDiff, 0, '<Precision,2><sign><Integer Thousand><Decimals,3>')
                                   + ' for period of 2 Months';
                                        //    SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",memb."Mobile Phone No",msg);
                                    end;
                                until LoanGuaranteeDetails.Next = 0;

                            end;
                        end;

                    end;

                    // Third Notice
                    LoanRepay.Reset;
                    LoanRepay.SetRange(LoanRepay."Loan No.", LoansRegister."Loan  No.");
                    LoanRepay.SetFilter(LoanRepay."Repayment Date", '..' + Format(CalcDate('CM+1D-2M', Today)));
                    LoanRepay.CalcSums(LoanRepay."Monthly Repayment", LoanRepay."Monthly Interest");
                    loanamt := LoanRepay."Monthly Repayment" / 4;
                    //  amtsecondnotice:=FnGetOutstandingBal(LoansRegister."Loan  No.")/4;

                    repayamt := LoansRegister.Repayment * 4;
                    Loanbal := loanamt - amtsecondnotice;
                    if (Loanbal > repayamt) then begin

                        if (LoanSMSNotice."Notice SMS 3" = 0D) or (LoanSMSNotice."Notice SMS 3" <= Today) then begin
                            LoanSMSNotice."Notice SMS 3" := CalcDate('1M', Today);
                            LoanSMSNotice.Modify;
                            msg := 'Dear ' + SplitString(Members.Name, ' ') + ', Your loan repayment for ' + LoansRegister."Loan Product Type Name" + ' of amount Ksh. ' + Format(TransactionLoanDiff, 0, '<Precision,2><sign><Integer Thousand><Decimals,3>')
                            + ' is in Arreas for 3 Months' + 'Please pay via Bank A/C or  Via LIPA na MPESA Paybill 587649 or risk being blacklisted with CRB';
                            //    SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Mobile Phone No",msg);

                            LoanGuaranteeDetails.Reset;
                            LoanGuaranteeDetails.SetRange(LoanGuaranteeDetails."Loan No", LoanSMSNotice."Loan No");
                            LoanGuaranteeDetails.SetRange(LoanGuaranteeDetails."Self Guarantee", false);
                            if LoanGuaranteeDetails.Find('-') then begin
                                repeat
                                    memb.Reset;
                                    memb.SetRange(memb."No.", LoanGuaranteeDetails."Member No");
                                    if memb.Find('-') then begin
                                        msg := 'Dear ' + SplitString(memb.Name, ' ') + ', Your Guarantee ' + Members.Name + ' has defaulted loan amount Ksh. ' + Format(TransactionLoanDiff, 0, '<Precision,2><sign><Integer Thousand><Decimals,3>')
                                   + ' for period of 3 Months';
                                        //      SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",memb."Phone No.",msg);
                                    end;
                                until LoanGuaranteeDetails.Next = 0;

                            end;
                        end;

                    end;


                end else begin

                end;

            until LoansRegister.Next = 0;
        end;
        //  END;

    end;

    procedure SplitString(sText: Text; separator: Text) Token: Text
    var
        Pos: Integer;
    begin
        begin
            Pos := StrPos(sText, separator);
            if Pos > 0 then begin
                Token := CopyStr(sText, 1, Pos - 1);
                if Pos + 1 <= StrLen(sText) then
                    sText := CopyStr(sText, Pos + 1)
                else
                    sText := '';
            end else begin
                Token := sText;
                sText := '';
            end;
        end;
    end;

    local procedure PayBillToAccapi(batch: Code[20]; docNo: Code[20]; accNo: Code[20]; memberNo: Code[20]; Amount: Decimal; accountType: Code[30]) res: Code[10]
    begin
        GenLedgerSetup.Reset;
        GenLedgerSetup.Get;
        GenLedgerSetup.TestField(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TestField(GenLedgerSetup.PaybillAcc);
        PaybillRecon := GenLedgerSetup.PaybillAcc;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        GenJournalLine.DeleteAll;
        //end of deletion

        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
        GenBatches.SetRange(GenBatches.Name, batch);

        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := 'GENERAL';
            GenBatches.Name := batch;
            GenBatches.Description := 'Paybill Deposit';
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;//General Jnr Batches

        Vendor.Reset;
        Vendor.SetRange(Vendor."No.", accNo);
        if Vendor.FindFirst then begin

            //Cr Customer
            LineNo := LineNo + 10000;
            GenJournalLine.Init;
            GenJournalLine."Journal Template Name" := 'GENERAL';
            GenJournalLine."Journal Batch Name" := batch;
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
            GenJournalLine."Account No." := Vendor."No.";
            GenJournalLine.Validate(GenJournalLine."Account No.");

            GenJournalLine."Bal. Account Type" := GenJournalLine."account type"::"Bank Account";
            GenJournalLine.Validate(GenJournalLine."Account No.");
            GenJournalLine."Bal. Account No." := PaybillRecon;
            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
            GenJournalLine."Document No." := docNo;
            GenJournalLine."External Document No." := docNo;
            GenJournalLine."Posting Date" := PaybillTrans."Transaction Date";
            GenJournalLine.Description := 'Paybill Deposit by ' + Format(CopyStr(PaybillTrans."Account Name", 1, 30));
            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
            GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranchUsingFosaAccount(Vendor."No.");
            GenJournalLine.Amount := -1 * Amount;
            GenJournalLine.Validate(GenJournalLine.Amount);
            if GenJournalLine.Amount <> 0 then
                GenJournalLine.Insert;
        end;//Vendor
            // END;//Member


        //Post
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", batch);
        if GenJournalLine.Find('-') then begin
            repeat
                GLPosting.Run(GenJournalLine);
            until GenJournalLine.Next = 0;
            PaybillTrans.Posted := true;
            PaybillTrans."Date Posted" := Today;
            PaybillTrans.Description := 'Posted';
            PaybillTrans.Modify;
            res := 'TRUE';

            msg := 'Dear ' + Vendor.Name + ' your acc: ' + Vendor."No." + ' has been credited with Ksh. ' + Format(Amount) + ' . Thank you for Choosing to Bank With Us';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Vendor."Phone No.", msg);
        end
        else begin
            PaybillTrans."Date Posted" := Today;
            PaybillTrans."Needs Manual Posting" := true;
            PaybillTrans.Description := 'Failed';
            PaybillTrans.Modify;
            res := 'FALSE';
            msg := 'Dear ' + Vendor.Name + ', we have received Ksh. ' + Format(Amount) + 'and will been credited to your account, Thank you for Choosing to Banking With Us';
            SMSMessage('PAYBILLTRANS', Vendor."No.", Vendor."Phone No.", msg);
        end;
    end;

    local procedure fnGetphoneNumber(phoneNo: Code[20]) Res: Code[40]
    begin
        Res := phoneNo;
        Vendor.Reset;
        Vendor.SetRange(Vendor."Phone No.", phoneNo);
        if Vendor.Find('-') then begin
            Res := Vendor."Phone No.";
            exit;
        end;

        Vendor.Reset;
        Vendor.SetRange(Vendor."Phone No.", '0' + CopyStr(phoneNo, 5, 15));
        if Vendor.Find('-') then begin
            Res := Vendor."Phone No.";
            exit;
        end;
    end;

    local procedure FnGetMemberNo(phoneNo: Code[100]) Acount: Code[100]
    begin
        Members.Reset;
        Members.SetRange(Members."Mobile Phone No", phoneNo);
        if Members.Find('-') then begin
            Acount := Members."No.";
            exit;
        end;
        Vendor.Reset;
        Vendor.SetRange(Vendor."Phone No.", phoneNo);
        if Vendor.Find('-') then begin
            Acount := Vendor."BOSA Account No";
            exit;
        end;

        Vendor.Reset;
        Vendor.SetRange(Vendor."Mobile Phone No", '0' + CopyStr(phoneNo, 4, 15));
        if Vendor.Find('-') then begin
            Acount := Vendor."BOSA Account No";
            exit;
        end;
        Vendor.Reset;
        Vendor.SetRange(Vendor."Phone No.", '0' + CopyStr(phoneNo, 4, 15));
        if Vendor.Find('-') then begin
            Acount := Vendor."BOSA Account No";
            exit;
        end;

        Vendor.Reset;
        Vendor.SetRange(Vendor."No.", phoneNo);
        if Vendor.Find('-') then begin
            Acount := Vendor."BOSA Account No";
            exit;
        end;

        Members.Reset;
        Members.SetRange(Members."No.", phoneNo);
        if Members.Find('-') then begin
            Acount := Members."No.";
            exit;
        end;
    end;

    local procedure FnGetAccountNumber(phoneNo: Text) Account: Text
    begin
        Vendor.Reset;
        Vendor.SetRange(Vendor."Phone No.", phoneNo);
        if Vendor.Find('-') then begin
            Account := Vendor."No.";
            exit;
        end;

        Vendor.Reset;
        Vendor.SetRange(Vendor."Mobile Phone No", '0' + CopyStr(phoneNo, 4, 15));
        if Vendor.Find('-') then begin
            Account := Vendor."No.";
            exit;
        end;
        Vendor.Reset;
        Vendor.SetRange(Vendor."Phone No.", '0' + CopyStr(phoneNo, 4, 15));
        if Vendor.Find('-') then begin
            Account := Vendor."No.";
            exit;
        end;
    end;

    local procedure ExcDutyAccount(ExcDutyAccount: Text)
    var
        SaccoGenSetup: Record "Sacco General Set-Up";
    begin
        SaccoGenSetup.Reset;
        SaccoGenSetup.SetRange(SaccoGenSetup."Excise Duty Account");
        ExcDutyAccount := SaccoGenSetup."Excise Duty Account";
    end;

    local procedure ExcDutyRate(ExcDutyRate: Decimal)
    var
        SaccoGenSetup: Record "Sacco General Set-Up";
    begin
        SaccoGenSetup.Reset;
        SaccoGenSetup.SetRange(SaccoGenSetup."Excise Duty(%)");
        ExcDutyRate := SaccoGenSetup."Excise Duty(%)";
    end;

    local procedure GetKeyword(keyword: Text; BillRefNumber: Text) res: Text
    begin
        if keyword = 'L01' then begin
            PaybillTrans."Key Word" := COPYSTR(BillRefNumber, 1, 3);
            PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
        end else begin
            if keyword = 'L02' then begin
                PaybillTrans."Key Word" := keyword;
                PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
            end else begin
                if keyword = 'L03' then begin
                    PaybillTrans."Key Word" := keyword;
                    PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                end else begin
                    if keyword = 'L19' then begin
                        PaybillTrans."Key Word" := keyword;
                        PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                    end else begin
                        if keyword = 'L05' then begin
                            PaybillTrans."Key Word" := keyword;
                            PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                        end else begin
                            if keyword = 'L11' then begin
                                PaybillTrans."Key Word" := keyword;
                                PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                            end else begin
                                if keyword = 'L12' then begin
                                    PaybillTrans."Key Word" := keyword;
                                    PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                                end else begin
                                    if keyword = 'L20' then begin
                                        PaybillTrans."Key Word" := keyword;
                                        PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                                    end else begin
                                        if keyword = 'A22' then begin
                                            PaybillTrans."Key Word" := keyword;
                                            PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                                        end else begin
                                            if keyword = 'A11' then begin
                                                PaybillTrans."Key Word" := keyword;
                                                PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                                            end else begin
                                                if keyword = 'S03' then begin
                                                    PaybillTrans."Key Word" := keyword;
                                                    PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                                                end else begin
                                                    if keyword = 'A22' then begin
                                                        PaybillTrans."Key Word" := keyword;
                                                        PaybillTrans."Account No" := COPYSTR(BillRefNumber, 4, 10);
                                                    end else
                                                        PaybillTrans."Key Word" := 'C';
                                                    PaybillTrans."Account No" := BillRefNumber;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure GetMicroAccNumber(accNo: Text) newNo: Text
    begin
        Members.Reset;
        Members.SetRange(Members."No.", accNo);
        if Members.FindSet then begin
            newNo := 'L12' + Members."Global Dimension 2 Code" + accNo;
        end;
    end;

    local procedure FnAccountIsGroupType(CopyStr: Code[50]): Boolean
    begin
        Vendor.Reset();
        Vendor.SetRange(Vendor."No.", CopyStr);
        if Vendor.find('-') then begin
            if Vendor."Account Type" = 'GROUP' then begin
                EXIT(true);
            end else
                if Vendor."Account Type" <> 'GROUP' then begin
                    EXIT(false);
                end;
        end;
        exit(false);
    end;
}

