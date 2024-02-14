#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516020 AgencyCode
{

    trigger OnRun()
    begin

    end;

    var
        Vendor: Record Vendor;
        SavingsProdAccTypes: Record "Account Types-Saving Products";
        AgentApps: Record "Agent Applications";
        AgentTransactions: Record "Agent transaction";
        LoansRegister: Record "Loans Register";
        accBalance: Decimal;
        VendorLedgEntry: Record "Vendor Ledger Entry";
        amount: Decimal;
        minimunCount: Integer;
        AccountTypes: Record "Account Types-Saving Products";
        miniBalance: Decimal;
        Loans: Integer;
        LoanProductsSetup: Record "Loan Products Setup";
        Members: Record Customer;
        dateExpression: Text[20];
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        dashboardDataFilter: Date;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        MemberLedgerEntry: Record "Cust. Ledger Entry";
        GenJournalLine: Record "Gen. Journal Line";
        GenBatches: Record "Gen. Journal Batch";
        LineNo: Integer;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        GenLedgerSetup: Record "General Ledger Setup";
        TariffHeader: Record "Agency Tariff Header";
        TariffDetails: Record "Agent Tariff Details";
        commAgent: Decimal;
        commVendor: Decimal;
        commSacco: Decimal;
        TotalCommission: Decimal;
        CloudPESACommACC: Text[20];
        AgentChargesAcc: Text[20];
        GLAccount: Record "G/L Account";
        WithdrawalLimit: Record "Agent Withdrawal Limits";
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
        ExxcDuty: label '3326';
        ExcDuty: Decimal;
        BlockedStatus: Boolean;
        BankAccount: Record "Bank Account Ledger Entry";


    procedure GetAccountType(accountNo: Text[100]) accountType: Text[100]
    begin
        begin

            Vendor.Reset;
            Vendor.SetRange(Vendor."No.", accountNo);
            if Vendor.Find('-') then begin
                accountType := Vendor."Account Type";
            end
            else begin
                accountType := '';
            end
        end;
    end;


    procedure GetMinimumBal(accountType: Text[100]) minBalance: Decimal
    begin
        begin
            SavingsProdAccTypes.Reset;
            SavingsProdAccTypes.SetRange(SavingsProdAccTypes.Code, accountType);
            if SavingsProdAccTypes.Find('-') then begin
                minBalance := -SavingsProdAccTypes."Minimum Balance";
            end
            else begin
                minBalance := 0.0;
            end
        end;
    end;


    procedure GetAgentcommision("code": Text) account: Text[100]
    begin
        begin
            AgentApps.Reset;
            AgentApps.SetRange(AgentApps.DeviceID, code);
            AgentApps.SetRange(AgentApps.Status, AgentApps.Status::Approved);
            if AgentApps.Find('-') then begin
                account := AgentApps.Name + ' ::: ' + Format(1000) + ' ::: ' + Format(GetAccountBalance(AgentApps."Comm Account"));
            end
            else begin
                account := '';
            end
        end;
    end;


    procedure GetAgentAccount("code": Text) account: Text[100]
    begin

        begin
            AgentApps.Reset;
            AgentApps.SetRange(AgentApps.DeviceID, code);
            AgentApps.SetRange(AgentApps.Status, AgentApps.Status::Approved);
            if AgentApps.Find('-') then begin
                account := AgentApps.Name + ':::' + Format(1000) + ':::' + Format(GetAccountBalance(AgentApps.Account)) + ':::' + Format(AgentApps.Branch);
            end
            else begin
                account := '';
            end
        end;
    end;


    procedure GetAccounts(idNumber: Text[50]) accounts: Text
    begin
        begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."BOSA Account No", Getfosaaccount(idNumber));
            Vendor.SetRange(Vendor.Blocked, 0);
            Vendor.SetFilter(Vendor.Status, '%1|%2', 0, 4);
            if Vendor.Find('-') then begin
                accounts := '';
                repeat
                    Vendor.CalcFields(Vendor."Balance (LCY)");
                    Vendor.CalcFields(Vendor."ATM Transactions");
                    Vendor.CalcFields(Vendor."Uncleared Cheques");
                    Vendor.CalcFields(Vendor."EFT Transactions");
                    accBalance := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions") - miniBalance;
                    accounts := accounts + '-:-' + Vendor."ID No." + ':::' + Vendor."Account Type" + ':::' + Vendor.Name + ':::' + Vendor."No." + ':::' +
                    Format(accBalance);
                until Vendor.Next = 0;
            end
            else begin
                accounts := 'none';
            end
        end;
    end;


    procedure InsertAgencyTransaction(docNo: Code[20]; transDate: Date; accNo: Code[50]; description: Text[220]; amount: Decimal; posted: Boolean; transTime: DateTime; balAccNo: Code[30]; docDate: Date; datePosted: Date; timePosted: Time; accStatus: Text[30]; messages: Text[400]; needsChange: Boolean; changeTransNo: Code[20]; oldAccNo: Code[50]; changed: Boolean; dateChanged: Date; timeChanged: Time; changedBy: Code[10]; approvedBy: Code[10]; originalAccNo: Code[50]; accBal: Decimal; branchCode: Code[10]; activityCode: Code[30]; globalDim1Filter: Code[20]; globalDim2Filter: Code[20]; accNo2: Text[250]; ccode: Code[20]; transLocation: Text[30]; transBy: Text[30]; agentCode: Text; loanNo: Code[20]; accName: Text[30]; telephone: Text[20]; idNo: Code[20]; branch: Text[30]; memberNo: Code[20]; transType: Integer; DateofBirth: Date; Address: Text; PhysicallAddress: Text; PostalCode: Text; Residence: Text) result: Text[20]
    begin
        AgentTransactions.SetRange(AgentTransactions."Document No.", docNo);
        AgentTransactions.SetRange(AgentTransactions.Description, description);
        AgentTransactions.SetRange(AgentTransactions."Transaction Date", transDate);
        if AgentTransactions.Find('-') then begin
            result := 'exists';
        end
        else begin
            AgentApps.Reset;
            AgentApps.SetRange(AgentApps.DeviceID, agentCode);
            if AgentApps.Find('-') then begin
                AgentTransactions.Init;
                AgentTransactions."Document No." := docNo;
                AgentTransactions."Transaction Date" := transDate;
                AgentTransactions."Account No." := accNo;
                AgentTransactions."Transaction Type" := transType;
                AgentTransactions.Description := description;
                AgentTransactions.Amount := amount;
                AgentTransactions.Posted := posted;
                AgentTransactions."Transaction Time" := transTime;
                AgentTransactions."Bal. Account No." := balAccNo;
                AgentTransactions."Document Date" := docDate;
                AgentTransactions."Date Posted" := datePosted;
                AgentTransactions."Time Posted" := timePosted;
                AgentTransactions."Account Status" := accStatus;
                AgentTransactions.Messages := messages;
                AgentTransactions."Needs Change" := needsChange;
                AgentTransactions."Old Account No" := oldAccNo;
                AgentTransactions.Changed := changed;
                AgentTransactions."Date Changed" := dateChanged;
                AgentTransactions."Time Changed" := timeChanged;
                AgentTransactions."Changed By" := changedBy;
                AgentTransactions."Approved By" := approvedBy;
                AgentTransactions."Original Account No" := originalAccNo;
                AgentTransactions."Branch Code" := branchCode;
                AgentTransactions."Activity Code" := activityCode;
                AgentTransactions."Global Dimension 1 Filter" := globalDim1Filter;
                AgentTransactions."Global Dimension 2 Filter" := globalDim2Filter;
                AgentTransactions."Account No 2" := accNo2;
                AgentTransactions.CCODE := ccode;
                AgentTransactions."Transaction Location" := AgentApps."Place of Business";
                AgentTransactions."Transaction By" := AgentApps."Name of the Proposed Agent";
                AgentTransactions."Agent Code" := AgentApps."Agent Code";
                AgentTransactions."Loan No" := loanNo;
                AgentTransactions."Account Name" := accName;
                AgentTransactions.Telephone := telephone;
                AgentTransactions."Id No" := idNo;
                AgentTransactions.Branch := branch;
                AgentTransactions.DeviceID := agentCode;
                AgentTransactions."Member No" := '';
                AgentTransactions.Insert;
                result := 'completed';
            end;

        end
    end;


    procedure GetAccountInfo(accountNo: Code[20]) reslt: Text[200]
    begin
        begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."No.", accountNo);
            Vendor.SetRange(Vendor.Blocked, 0);
            Vendor.SetFilter(Vendor.Status, '%1|%2', 0, 4);
            if Vendor.Find('-') then begin
                reslt := Vendor."No." + ':::' + Vendor.Name + ':::' + Vendor."Account Type" + ':::' + Vendor."Phone No.";
            end
            else begin
                reslt := 'none';
            end
        end;
    end;


    procedure GetLoans(idNumber: Code[20]) loans: Text[1000]
    begin
        begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."BOSA Account No", Getfosaaccount(idNumber));
            if Vendor.Find('-') then begin
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister."Client Code", Vendor."BOSA Account No");
                if LoansRegister.Find('-') then begin
                    repeat
                        LoansRegister.CalcFields(LoansRegister."Outstanding Balance", LoansRegister."Interest Due", LoansRegister."Oustanding Interest", LoansRegister."Interest Paid");
                        if (LoansRegister."Outstanding Balance" > 0) or (LoansRegister."Oustanding Interest" > 0) then
                            loans := loans + '-:-' + LoansRegister."Loan  No." + ':::' + LoansRegister."Loan Product Type" + ':::' + LoansRegister."Loan Product Type Name" + ':::' + Format(LoansRegister.Source) +
                            ':::' + Format(LoansRegister."Outstanding Balance" + LoansRegister."Oustanding Interest");
                        ;
                    until LoansRegister.Next = 0;
                end;
            end
        end;
    end;


    procedure GetMiniStatement(account: Code[20]; NoofEntry: Integer) Statement: Text[500]
    var
        Dr: Code[10];
    begin
        begin
            VendorLedgEntry.Reset;
            VendorLedgEntry.SetCurrentkey(VendorLedgEntry."Entry No.");
            VendorLedgEntry.Ascending(false);
            VendorLedgEntry.SetRange(VendorLedgEntry."Vendor No.", account);
            VendorLedgEntry.SetRange(VendorLedgEntry.Reversed, false);
            if VendorLedgEntry.Find('-') then begin
                Statement := '';
                repeat
                    VendorLedgEntry.CalcFields(VendorLedgEntry.Amount);
                    amount := VendorLedgEntry.Amount;
                    if amount < 1 then begin
                        amount := amount * -1;
                        Dr := 'CR';
                    end else begin
                        Dr := 'DR';
                    end;
                    Statement := Statement + Format(VendorLedgEntry."Posting Date") + ':::' + VendorLedgEntry.Description + ':::' +
                    Format(amount) + ':::' + Dr + ':::' + Format(GetAccountBalance(account)) + '::::';
                    minimunCount := minimunCount + 1;
                    if minimunCount > 5 then
                        exit
                until VendorLedgEntry.Next = 0
            end
        end;
    end;


    procedure PostBranchAgentTransaction(transID: Code[30]) res: Boolean
    begin

        AgentTransactions.Reset;
        AgentTransactions.SetRange(AgentTransactions."Document No.", transID);
        AgentTransactions.SetRange(AgentTransactions.Posted, false);
        if AgentTransactions.Find('-') then begin
            BlockedStatus := Blocked(AgentTransactions."Account No.");
            if (BlockedStatus = false) or (AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::Deposit)
              or (AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::LoanRepayment)
               then begin
                TariffHeader.Reset();
                TariffHeader.SetRange(TariffHeader."Trans Type", AgentTransactions."Transaction Type");
                if TariffHeader.FindFirst then begin
                    TariffDetails.Reset();
                    TariffDetails.SetRange(TariffDetails.Code, TariffHeader.Code);
                    if TariffDetails.FindFirst then begin
                        commAgent := TariffDetails."Agent Comm";
                        commVendor := TariffDetails."Vendor Comm";
                        commSacco := TariffDetails."Sacco Comm";
                        TotalCommission := commVendor + commSacco;
                    end;//Tariff Details
                end;//Tariff Header

                ExcDuty := 20 / 100 * TotalCommission;

                if (AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::Deposit) then begin
                    AgentTransactions.Amount := -AgentTransactions.Amount;
                end;

                AgentApps.Reset;
                AgentApps.SetRange(AgentApps."Agent Code", AgentTransactions."Agent Code");
                if AgentApps.Find('-')
                  then begin
                    GenLedgerSetup.Reset;
                    GenLedgerSetup.Get;
                    //  GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
                    //CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
                    AgentChargesAcc := GenLedgerSetup."Agency Charges Acc";

                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'Agency');
                    GenJournalLine.DeleteAll;
                    //end of deletion

                    GenBatches.Reset;
                    GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                    GenBatches.SetRange(GenBatches.Name, 'Agency');

                    if GenBatches.Find('-') = false then begin
                        GenBatches.Init;
                        GenBatches."Journal Template Name" := 'GENERAL';
                        GenBatches.Name := 'Agency';
                        GenBatches.Description := 'Agency Transactions';
                        GenBatches.Validate(GenBatches."Journal Template Name");
                        GenBatches.Validate(GenBatches.Name);
                        GenBatches.Insert;
                    end;//General Jnr Batches
                    if (AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::Withdrawal) then begin
                        Vendor.Reset;
                        Vendor.SetRange(Vendor."No.", AgentTransactions."Account No.");
                        if Vendor.Find('-') then begin
                            Vendor.CalcFields(Vendor."Balance (LCY)");
                            if (Abs(AgentTransactions.Amount) > ExcDuty + TotalCommission + Vendor."Balance (LCY)") then begin
                                AgentTransactions.Posted := false;
                                AgentTransactions."Date Posted" := Today;
                                AgentTransactions.Messages := 'insufficient balance';
                                AgentTransactions."Time Posted" := Time;
                                AgentTransactions.Modify;
                                res := false;
                                exit;
                            end;
                        end;

                    end;
                    case AgentTransactions."Transaction Type" of

                        AgentTransactions."transaction type"::Withdrawal,
                        AgentTransactions."transaction type"::Deposit,
                        AgentTransactions."transaction type"::Transfer:
                            begin
                                Vendor.Reset;
                                Vendor.SetRange(Vendor."No.", AgentTransactions."Account No.");
                                if Vendor.Find('-') then begin
                                    //..........................DEPOSIT.....................................................................................//
                                    if (AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::Deposit) then begin

                                        //....Credit Member Account
                                        LineNo := LineNo + 10000;
                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'Agency';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                        GenJournalLine."Account No." := AgentTransactions."Account No.";
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine."Document No." := AgentTransactions."Document No.";
                                        GenJournalLine."External Document No." := AgentApps."Agent Code";
                                        GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                        GenJournalLine.Description := 'Cash Deposit- ' + AgentTransactions.Description;
                                        GenJournalLine.Amount := AgentTransactions.Amount;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                        GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;

                                        //.......Debit Bank Account

                                        LineNo := LineNo + 10000;
                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'Agency';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                                        GenJournalLine."Account No." := AgentApps.Account;
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine."Document No." := AgentTransactions."Document No.";
                                        GenJournalLine."External Document No." := AgentApps."Agent Code";
                                        GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                        GenJournalLine.Description := 'Cash Deposit- ' + AgentTransactions.Description;
                                        GenJournalLine.Amount := AgentTransactions.Amount * -1;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                        GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;
                                    end
                                end;//CASE Deposits, Withdrawal Transfer
                                    //...................................END OF DEPOSIT.....................................................................//


                            end;
                        AgentTransactions."transaction type"::Balance,
              AgentTransactions."transaction type"::Ministatment:
                            if Vendor.Find('-') then begin
                                begin
                                    //Cr Vendor
                                    Vendor.Reset;
                                    Vendor.SetRange(Vendor."No.", AgentTransactions."Account No.");
                                    //Dr Customer
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Agency';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                    GenJournalLine."Account No." := AgentTransactions."Account No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Document No." := AgentTransactions."Document No.";
                                    GenJournalLine."External Document No." := AgentApps."Agent Code";
                                    GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                    GenJournalLine.Description := 'Agency Banking Charges';
                                    GenJournalLine.Amount := TotalCommission + ExcDuty;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                    GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;

                                    //Cr Excise Duty
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Agency';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                    GenJournalLine."Account No." := ExxcDuty;
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Document No." := AgentTransactions."Document No.";
                                    GenJournalLine."External Document No." := AgentApps."Agent Code";
                                    GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                    GenJournalLine.Description := 'Excise Duty-Agency Charges';
                                    GenJournalLine.Amount := -1 * ExcDuty;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                    GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;

                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Agency';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                    GenJournalLine."Account No." := CloudPESACommACC;
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Document No." := AgentTransactions."Document No.";
                                    GenJournalLine."External Document No." := AgentApps."Agent Code";
                                    GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                    GenJournalLine.Description := 'Agency Banking Charges';
                                    GenJournalLine.Amount := -1 * commVendor;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                    GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;

                                    //Cr Sacco
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Agency';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                    GenJournalLine."Account No." := AgentChargesAcc;
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Document No." := AgentTransactions."Document No.";
                                    GenJournalLine."External Document No." := AgentApps."Agent Code";
                                    GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                    GenJournalLine.Description := 'Agency Banking Charges';
                                    GenJournalLine.Amount := -1 * commSacco;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                    GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                    res := true;
                                end;//Vendor
                            end;//CASE mini Statement, Balance
                        AgentTransactions."transaction type"::Sharedeposit,
                        AgentTransactions."transaction type"::Registration:

                            begin

                                Members.Reset;
                                Members.SetRange(Members."No.", AgentTransactions."Account No.");
                                if Members.Find('-') then begin
                                    Vendor.Reset;
                                    Vendor.SetRange(Vendor."ID No.", AgentTransactions."Id No");
                                    Vendor.SetFilter(Vendor."Account Type", '%1|%2|%3', 'ORDINARY', 'JUNIOR', 'CURRENT');
                                    if Vendor.FindFirst then begin
                                        AgentTransactions.Amount := -AgentTransactions.Amount;
                                        //Cr Customer

                                        /* IF AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Deposit Contribution" THEN BEGIN
                                            LineNo:=LineNo+10000;
                                            GenJournalLine.INIT;
                                            GenJournalLine."Journal Template Name":='GENERAL';
                                            GenJournalLine."Journal Batch Name":='Agency';
                                            GenJournalLine."Line No.":=LineNo;
                                            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                            GenJournalLine."Account No.":=AgentTransactions."Account No.";
                                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                            GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                            GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                            GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                            GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                            GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                            GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                            GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution";
                                            GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                            GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Description:=AgentTransactions.Description+'-'+AgentTransactions."Account Name";
                                            GenJournalLine.Amount:=AgentTransactions.Amount;
                                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                            IF GenJournalLine.Amount<>0 THEN
                                            GenJournalLine.INSERT;
                                          END;
                                          */
                                        if AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::Sharedeposit then begin
                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := 'GENERAL';
                                            GenJournalLine."Journal Batch Name" := 'Agency';
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                            GenJournalLine."Account No." := AgentTransactions."Account No.";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"Bank Account";
                                            GenJournalLine.Validate(GenJournalLine."Bal. Account Type");
                                            GenJournalLine."Bal. Account No." := AgentApps.Account;
                                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                                            GenJournalLine."Document No." := AgentTransactions."Document No.";
                                            GenJournalLine."External Document No." := AgentApps."Agent Code";
                                            GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Shares Capital";
                                            GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Description := AgentTransactions.Description + '-' + AgentTransactions."Account Name";
                                            GenJournalLine.Amount := AgentTransactions.Amount;
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                        end;
                                        /*IF AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Registration Fee" THEN BEGIN
                                          LineNo:=LineNo+10000;
                                          GenJournalLine.INIT;
                                          GenJournalLine."Journal Template Name":='GENERAL';
                                          GenJournalLine."Journal Batch Name":='Agency';
                                          GenJournalLine."Line No.":=LineNo;
                                          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                          GenJournalLine."Account No.":=AgentTransactions."Account No.";
                                          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                          GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                          GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                          GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                          GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                          GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                          GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Registration Fee";
                                          GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                          GenJournalLine.Description:=AgentTransactions.Description+'-'+AgentTransactions."Account Name";
                                          GenJournalLine.Amount:=AgentTransactions.Amount;
                                          GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                          IF GenJournalLine.Amount<>0 THEN
                                          GenJournalLine.INSERT;
                                        END;
                                        IF AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Benevolent Fund" THEN BEGIN
                                          LineNo:=LineNo+10000;
                                          GenJournalLine.INIT;
                                          GenJournalLine."Journal Template Name":='GENERAL';
                                          GenJournalLine."Journal Batch Name":='Agency';
                                          GenJournalLine."Line No.":=LineNo;
                                          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                          GenJournalLine."Account No.":=AgentTransactions."Account No.";
                                          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                          GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                          GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                          GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                          GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                          GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                          GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Benevolent Fund";
                                          GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                          GenJournalLine.Description:=AgentTransactions.Description +'-'+AgentTransactions."Account Name";
                                          GenJournalLine.Amount:=AgentTransactions.Amount;
                                          GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                          IF GenJournalLine.Amount<>0 THEN
                                          GenJournalLine.INSERT;
                                        END;
                                        */
                                        //Dr Customer charges
                                        LineNo := LineNo + 10000;
                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'Agency';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                        GenJournalLine."Account No." := Vendor."No.";
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine."Document No." := AgentTransactions."Document No.";
                                        GenJournalLine."External Document No." := AgentApps."Agent Code";
                                        GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                        GenJournalLine.Description := 'Agency Banking Charges';
                                        GenJournalLine.Amount := TotalCommission + ExcDuty;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                        GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;

                                        //Cr Excise Duty
                                        LineNo := LineNo + 10000;
                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'Agency';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                        GenJournalLine."Account No." := ExxcDuty;
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine."Document No." := AgentTransactions."Document No.";
                                        GenJournalLine."External Document No." := AgentApps."Agent Code";
                                        GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                        GenJournalLine.Description := 'Excise Duty-Agency Charges';
                                        GenJournalLine.Amount := -1 * ExcDuty;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                        GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;

                                        LineNo := LineNo + 10000;
                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'Agency';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                        GenJournalLine."Account No." := CloudPESACommACC;
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine."Document No." := AgentTransactions."Document No.";
                                        GenJournalLine."External Document No." := AgentApps."Agent Code";
                                        GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                        GenJournalLine.Description := 'Agency Banking Charges';
                                        GenJournalLine.Amount := -1 * commVendor;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                        GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;

                                        //Cr Sacco
                                        LineNo := LineNo + 10000;
                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'Agency';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                        GenJournalLine."Account No." := AgentChargesAcc;
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine."Document No." := AgentTransactions."Document No.";
                                        GenJournalLine."External Document No." := AgentApps."Agent Code";
                                        GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                        GenJournalLine.Description := 'Agency Banking Charges';
                                        GenJournalLine.Amount := -1 * commSacco;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                        GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;
                                    end;//Vendor
                                end;//Member
                            end;//CASE Shares Deposit

                        AgentTransactions."transaction type"::LoanRepayment:
                            begin
                                //  AgentTransactions.Amount :=-AgentTransactions.Amount;
                                Members.Reset;
                                Members.SetRange(Members."No.", AgentTransactions."Account No.");
                                if Members.Find('-') then begin
                                    Vendor.Reset;
                                    Vendor.SetRange(Vendor."No.", AgentTransactions."Account No.");
                                    // Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
                                    if Vendor.Find('-') then begin

                                        //Cr Customer
                                        LoansRegister.Reset;
                                        LoansRegister.SetRange(LoansRegister."Loan  No.", AgentTransactions."Loan No");
                                        LoansRegister.SetRange(LoansRegister."Client Code", Members."No.");

                                        if LoansRegister.Find('+') then begin
                                            LoansRegister.CalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
                                            if LoansRegister."Outstanding Balance" > 0 then begin

                                                LineNo := LineNo + 10000;

                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;

                                                GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                                GenJournalLine.Validate(GenJournalLine."Account Type");
                                                GenJournalLine."Account No." := LoansRegister."Client Code";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");

                                                GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"Bank Account";
                                                GenJournalLine.Validate(GenJournalLine."Bal. Account Type");
                                                GenJournalLine."Bal. Account No." := AgentApps.Account;
                                                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := '';
                                                GenJournalLine."Posting Date" := Today;
                                                GenJournalLine.Description := 'Loan Interest Payment -' + AgentTransactions."Account Name";

                                                if AgentTransactions.Amount > LoansRegister."Oustanding Interest" then
                                                    GenJournalLine.Amount := -LoansRegister."Oustanding Interest"
                                                else
                                                    GenJournalLine.Amount := -AgentTransactions.Amount;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";
                                                GenJournalLine.Validate(GenJournalLine."Transaction Type");

                                                if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                                                    GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                end;
                                                GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;
                                            end;

                                            AgentTransactions.Amount := AgentTransactions.Amount + GenJournalLine.Amount;

                                            if AgentTransactions.Amount > 0 then begin

                                                LineNo := LineNo + 10000;

                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;

                                                GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                                GenJournalLine.Validate(GenJournalLine."Account Type");
                                                GenJournalLine."Account No." := LoansRegister."Client Code";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");

                                                GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"Bank Account";
                                                GenJournalLine.Validate(GenJournalLine."Bal. Account Type");
                                                GenJournalLine."Bal. Account No." := AgentApps.Account;
                                                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := '';
                                                GenJournalLine."Posting Date" := Today;
                                                GenJournalLine.Description := 'Loan repayment -' + AgentTransactions."Account Name";
                                                GenJournalLine.Amount := -AgentTransactions.Amount;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                                                if GenJournalLine."Shortcut Dimension 1 Code" = '' then begin
                                                    GenJournalLine."Shortcut Dimension 1 Code" := Members."Global Dimension 1 Code";
                                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                end;
                                                GenJournalLine."Loan No" := LoansRegister."Loan  No.";
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //Dr Customer
                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                                GenJournalLine."Account No." := Vendor."No.";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Agency Banking Charges';
                                                GenJournalLine.Amount := TotalCommission + ExcDuty;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //Cr Excise Duty
                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                                GenJournalLine."Account No." := ExxcDuty;
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Excise Duty-Agency Charges';
                                                GenJournalLine.Amount := -1 * ExcDuty;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                                GenJournalLine."Account No." := CloudPESACommACC;
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Agency Banking Charges';
                                                GenJournalLine.Amount := -1 * commVendor;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //Cr Sacco
                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                                GenJournalLine."Account No." := AgentChargesAcc;
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Agency Banking Charges';
                                                GenJournalLine.Amount := -1 * commSacco;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;
                                            end;
                                        end;//LoansRegister
                                    end;//Vendor
                                end;//Member
                            end;//CASE Loan Repayment



                    /* AgentTransactions."Transaction Type"::"Pay Fines",AgentTransactions."Transaction Type"::Others,AgentTransactions."Transaction Type"::"Sale of Plate",
                     AgentTransactions."Transaction Type"::"Share Passbook",AgentTransactions."Transaction Type"::"Sale of Passbook":
                         BEGIN
                        AgentTransactions.Amount :=AgentTransactions.Amount*-1;
                       IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Share Passbook") THEN BEGIN
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Agency';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                        GenJournalLine."Account No.":='401130';
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Document No.":=AgentTransactions."Document No.";
                        GenJournalLine."External Document No.":=AgentApps."Agent Code";
                        GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Share Capital";
                        GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Description:=AgentTransactions.Description;
                        GenJournalLine.Amount:=AgentTransactions.Amount;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                      END;
                       IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Pay Fines") THEN BEGIN
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Agency';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                        GenJournalLine."Account No.":='401270';
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Document No.":=AgentTransactions."Document No.";
                        GenJournalLine."External Document No.":=AgentApps."Agent Code";
                        GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Share Capital";
                        GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Description:=AgentTransactions.Description;
                        GenJournalLine.Amount:=AgentTransactions.Amount;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;

                       END;//pay fine
                       IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::Others) THEN BEGIN
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Agency';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                        GenJournalLine."Account No.":='401220';
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Document No.":=AgentTransactions."Document No.";
                        GenJournalLine."External Document No.":=AgentApps."Agent Code";
                        GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Share Capital";
                        GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Description:=AgentTransactions.Description;
                        GenJournalLine.Amount:=AgentTransactions.Amount;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                       END;
                       IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Sale of Plate") THEN BEGIN
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Agency';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                        GenJournalLine."Account No.":='401120';
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Document No.":=AgentTransactions."Document No.";
                        GenJournalLine."External Document No.":=AgentApps."Agent Code";
                        GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Loan;
                        GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Description:=AgentTransactions.Description;
                        GenJournalLine.Amount:=AgentTransactions.Amount;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                       END;
                       IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Sale of Passbook") THEN BEGIN
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Agency';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                        GenJournalLine."Account No.":='401110';
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Document No.":=AgentTransactions."Document No.";
                        GenJournalLine."External Document No.":=AgentApps."Agent Code";
                        GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Share Capital";
                        GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Description:=AgentTransactions.Description;
                        GenJournalLine.Amount:=AgentTransactions.Amount;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;

                       END;

//Debit/Credit agent

                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Agency';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                        GenJournalLine."Bal. Account No.":=AgentApps.Account;
                        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Document No.":=AgentTransactions."Document No.";
                        GenJournalLine."External Document No.":=AgentApps."Agent Code";
                        GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                        GenJournalLine.Description:=AgentTransactions.Description  +'-'+AgentTransactions."Account Name";
                        GenJournalLine.Amount:=AgentTransactions.Amount;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                        GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                      END;
                        //END;
                        */

                    end;



                    //Post
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'Agency');
                    if GenJournalLine.Find('-') then begin
                        repeat
                            GLPosting.Run(GenJournalLine);
                        until GenJournalLine.Next = 0;
                        AgentTransactions.Posted := true;
                        AgentTransactions."Date Posted" := Today;
                        AgentTransactions.Messages := 'Completed';
                        AgentTransactions."Time Posted" := Time;
                        AgentTransactions.Modify;
                        res := true;
                    end
                    else begin
                        AgentTransactions.Posted := false;
                        AgentTransactions."Date Posted" := Today;
                        AgentTransactions.Messages := 'Failed';
                        AgentTransactions."Time Posted" := Time;
                        AgentTransactions.Modify;
                    end;
                    // END;
                end;//Agent Apps
            end
            else begin//Check deposit
                res := false;
            end
        end;//Agent Transactions

    end;


    procedure PostAgentTransaction(transID: Code[30]) res: Boolean
    var
        "branch?": Boolean;
    begin

        AgentTransactions.Reset;
        AgentTransactions.SetRange(AgentTransactions."Document No.", transID);
        AgentTransactions.SetRange(AgentTransactions.Posted, false);

        if AgentTransactions.Find('-') then begin

            AgentApps.Reset;
            AgentApps.SetRange(AgentApps."Agent Code", AgentTransactions.DeviceID);
            AgentApps.SetRange(AgentApps.Status, AgentApps.Status::Approved);
            if AgentApps.Find('-') then begin
                "branch?" := AgentApps.Branch;
            end;

            if "branch?" then begin
                res := PostBranchAgentTransaction(transID);
            end else begin

                BlockedStatus := Blocked(AgentTransactions."Account No.");
                if (BlockedStatus = false) or (AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::Deposit) then begin
                    TariffHeader.Reset();
                    TariffHeader.SetRange(TariffHeader."Trans Type", AgentTransactions."Transaction Type");
                    if TariffHeader.FindFirst then begin
                        TariffDetails.Reset();
                        TariffDetails.SetRange(TariffDetails.Code, TariffHeader.Code);
                        TariffDetails.SetFilter(TariffDetails."Lower Limit", '<=%1', Abs(AgentTransactions.Amount));
                        TariffDetails.SetFilter(TariffDetails."Upper Limit", '>=%1', Abs(AgentTransactions.Amount));
                        if TariffDetails.FindFirst then begin
                            commAgent := TariffDetails."Agent Comm";
                            commVendor := TariffDetails."Vendor Comm";
                            commSacco := TariffDetails."Sacco Comm";
                            TotalCommission := commAgent + commVendor + commSacco;
                            ExcDuty := 20 / 100 * TotalCommission;
                        end;//Tariff Details
                    end;//Tariff Header


                    //..................Initialize AgentApps............................................//
                    AgentApps.Reset;
                    AgentApps.SetRange(AgentApps."Agent Code", AgentTransactions."Agent Code");
                    if AgentApps.Find('-')
                      then begin
                        if (AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::Withdrawal) then begin
                            Vendor.Reset;
                            Vendor.SetRange(Vendor."No.", AgentTransactions."Account No.");
                            if Vendor.Find('-') then begin
                                Vendor.CalcFields(Vendor."Balance (LCY)");
                                if ((Abs(AgentTransactions.Amount)) > (ExcDuty + TotalCommission + Vendor."Balance (LCY)")) then begin
                                    AgentTransactions.Posted := false;
                                    AgentTransactions."Date Posted" := Today;
                                    AgentTransactions.Messages := 'insufficient balance';
                                    AgentTransactions."Time Posted" := Time;
                                    AgentTransactions.Modify;
                                    res := false;
                                    exit;
                                end;
                            end;

                        end;

                        GenLedgerSetup.Reset;
                        GenLedgerSetup.Get;
                        CloudPESACommACC := '3433'; // Centrino Commision Account
                        AgentChargesAcc := '5290';// Agent income Account
                                                  //........Start of Journal Deletion.......
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'Agency');
                        GenJournalLine.DeleteAll;
                        //.......End of Deletion................

                        //.........................Initialize General Batch.....................................//
                        GenBatches.Reset;
                        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                        GenBatches.SetRange(GenBatches.Name, 'Agency');
                        if GenBatches.Find('-') = false then begin
                            GenBatches.Init;
                            GenBatches."Journal Template Name" := 'GENERAL';
                            GenBatches.Name := 'Agency';
                            GenBatches.Description := 'Agency Transactions';
                            GenBatches.Validate(GenBatches."Journal Template Name");
                            GenBatches.Validate(GenBatches.Name);
                            GenBatches.Insert;
                        end;
                        //............................. End of General Jnr Batches.............................//
                        case AgentTransactions."Transaction Type" of
                            AgentTransactions."transaction type"::Withdrawal,
                            AgentTransactions."transaction type"::Deposit,
                            AgentTransactions."transaction type"::Transfer:
                                begin
                                    Vendor.Reset;
                                    Vendor.SetRange(Vendor."No.", AgentTransactions."Account No.");
                                    if Vendor.Find('-') then begin


                                        //..................................CASE DEPOSIT....................................................................//
                                        if (AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::Deposit) then begin
                                            /*
                                            BEGIN
                                           AgentTransactions.Amount :=AgentTransactions.Amount*-1;
                                           ExcDuty:=20/100*TotalCommission;
                                           END;
                                           */
                                            //..................Credit Member Account Transaction Amount ...............//
                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := 'GENERAL';
                                            GenJournalLine."Journal Batch Name" := 'Agency';
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                            GenJournalLine."Account No." := AgentTransactions."Account No.";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Document No." := AgentTransactions."Document No.";
                                            GenJournalLine."External Document No." := AgentApps."Agent Code";
                                            GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                            GenJournalLine.Description := 'Cash Deposit- ' + AgentTransactions.Description; //1
                                            GenJournalLine.Amount := AgentTransactions.Amount * -1;
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                            GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;

                                            //.....................Debit Agent Account Transaction Amount ........................//

                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := 'GENERAL';
                                            GenJournalLine."Journal Batch Name" := 'Agency';
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                            GenJournalLine."Account No." := AgentApps.Account;
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Document No." := AgentTransactions."Document No.";
                                            GenJournalLine."External Document No." := AgentApps."Agent Code";
                                            GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                            GenJournalLine.Description := 'Cash Deposit- ' + AgentTransactions.Description; //2
                                            GenJournalLine.Amount := AgentTransactions.Amount;
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                            GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;

                                            //...............Debit Sacco Agency Banking Charges......................///

                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := 'GENERAL';
                                            GenJournalLine."Journal Batch Name" := 'Agency';
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                            GenJournalLine."Account No." := AgentChargesAcc;
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Document No." := AgentTransactions."Document No.";
                                            GenJournalLine."External Document No." := AgentApps."Agent Code";
                                            GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                            GenJournalLine.Description := 'Agency Banking Charges';
                                            GenJournalLine.Amount := TotalCommission;
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                            GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;

                                            //.............. Credit Vendor(Centrino Technologies) Commision...................//

                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := 'GENERAL';
                                            GenJournalLine."Journal Batch Name" := 'Agency';
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                            GenJournalLine."Account No." := CloudPESACommACC;
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Document No." := AgentTransactions."Document No.";
                                            GenJournalLine."External Document No." := AgentApps."Agent Code";
                                            GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                            GenJournalLine.Description := 'Agency Banking Commision  ' + AgentTransactions."Document No.";
                                            GenJournalLine.Amount := commVendor * -1;
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                            GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;

                                            //...................... Credit Agent Commision...........................//

                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := 'GENERAL';
                                            GenJournalLine."Journal Batch Name" := 'Agency';
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                            GenJournalLine."Account No." := AgentApps."Comm Account";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Document No." := AgentTransactions."Document No.";
                                            GenJournalLine."External Document No." := AgentApps."Agent Code";
                                            GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                            GenJournalLine.Description := 'Agency Banking Commision  ' + AgentTransactions."Document No.";
                                            GenJournalLine.Amount := commAgent * -1;
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                            GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                        end;

                                        //....................................   END OF DEPOSIT ...................................................//


                                        //..................................CASE WITHDRAWAL....................................................................//

                                        //.....................................Geoffrey Code Added.........................//
                                        if (AgentTransactions."Transaction Type" = AgentTransactions."transaction type"::Withdrawal) then begin
                                            Vendor.Reset;
                                            Vendor.SetRange(Vendor."No.", AgentTransactions."Account No.");
                                            // Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY', 'CURRENT');
                                            // Vendor.SETRANGE(Vendor."Account Type", 'JUNIOR');
                                            if Vendor.Find('-') then begin


                                                //.........................................End Of Geoffrey Code.....................//


                                                //   IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::Withdrawal) THEN BEGIN


                                                //...............Debit Member Account Transaction Amount .............................//
                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                                GenJournalLine."Account No." := AgentTransactions."Account No.";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Cash Withdrawal- ' + AgentTransactions."Account No.";
                                                GenJournalLine.Amount := AgentTransactions.Amount;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //.............. Credit Agent Account Transaction Amount ............................//

                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                                GenJournalLine."Account No." := AgentApps.Account;
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Cash Withdrawal- ' + AgentTransactions."Account No.";
                                                GenJournalLine.Amount := AgentTransactions.Amount * -1;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //...........Debit Customer Agency Banking Charges..................///

                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                                GenJournalLine."Account No." := AgentTransactions."Account No.";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Agency Banking Charges';
                                                GenJournalLine.Amount := TotalCommission;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //............Credit Sacco Commision..........................//

                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                                GenJournalLine."Account No." := AgentChargesAcc;
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Agency Banking Commision   ' + AgentTransactions."Document No.";
                                                GenJournalLine.Amount := commSacco * -1;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //.............. Credit Vendor(Centrino Technologies)...............//

                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                                GenJournalLine."Account No." := CloudPESACommACC;
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Agency Banking Commision  ' + AgentTransactions."Document No.";
                                                GenJournalLine.Amount := commVendor * -1;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //............ Credit Agent Commision..................//

                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                                GenJournalLine."Account No." := AgentApps."Comm Account";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Agency Banking Commision  ' + AgentTransactions."Document No.";
                                                GenJournalLine.Amount := commAgent * -1;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //.................. Debit Member Excise Duty .......................//

                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                                GenJournalLine."Account No." := AgentTransactions."Account No.";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Excise Duty-Agency Charges';
                                                GenJournalLine.Amount := ExcDuty;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;

                                                //.....................Credit Excise Duty G/L.........................//

                                                LineNo := LineNo + 10000;
                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'Agency';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                                GenJournalLine."Account No." := ExxcDuty;
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine."Document No." := AgentTransactions."Document No.";
                                                GenJournalLine."External Document No." := AgentApps."Agent Code";
                                                GenJournalLine."Posting Date" := AgentTransactions."Transaction Date";
                                                GenJournalLine.Description := 'Excise Duty-Agency Charges  ' + Format(AgentTransactions."Document No.");
                                                GenJournalLine.Amount := ExcDuty * -1;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                                                GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;
                                            end;

                                            //....................................   END OF WITHDRAWAL ...................................................//

                                        end; //End Balance Check
                                    end;//End CASE Deposits
                                end; //End CASE Withdrawal
                                     //  END; // End CASE Ministatement
                        end; //End Vendor

                        //Post
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'Agency');
                        if GenJournalLine.Find('-') then begin
                            repeat
                                GLPosting.Run(GenJournalLine);
                            until GenJournalLine.Next = 0;
                            AgentTransactions.Posted := true;
                            AgentTransactions."Date Posted" := Today;
                            AgentTransactions.Messages := 'Completed';
                            AgentTransactions."Time Posted" := Time;
                            AgentTransactions.Modify;
                            res := true;
                        end
                        else begin
                            AgentTransactions.Posted := false;
                            AgentTransactions."Date Posted" := Today;
                            AgentTransactions.Messages := 'Failed';
                            AgentTransactions."Time Posted" := Time;
                            AgentTransactions.Modify;
                        end;
                    end;//Agent Apps
                end

                else begin//Check deposit
                    res := false;
                end
            end;
        end;//Agent Transaction

        /*
        
              AgentTransactions.RESET;
              AgentTransactions.SETRANGE(AgentTransactions."Document No.",transID);
              AgentTransactions.SETRANGE(AgentTransactions.Posted,FALSE);
         IF AgentTransactions.FIND('-') THEN BEGIN
               BlockedStatus:=Blocked(AgentTransactions."Account No.");
                 IF (BlockedStatus=FALSE) OR (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::Deposit)
                   OR (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::LoanRepayment)
                    THEN BEGIN
                  TariffHeader.RESET();
                  TariffHeader.SETRANGE(TariffHeader."Trans Type",AgentTransactions."Transaction Type");
                  IF TariffHeader.FINDFIRST THEN
                     BEGIN
                      TariffDetails.RESET();
                      TariffDetails.SETRANGE(TariffDetails.Code,TariffHeader.Code);
                      IF TariffDetails.FINDFIRST THEN
                      BEGIN
                          commAgent := TariffDetails."Agent Comm";
                          commVendor := TariffDetails."Vendor Comm";
                          commSacco := TariffDetails."Sacco Comm" ;
                          TotalCommission:=commVendor+commSacco;
                          //TotalCommission:=commAgent+commVendor+commSacco;
                        END;//Tariff Details
                     END;//Tariff Header
        
                       ExcDuty:=20/100*TotalCommission;
        
                      IF (AgentTransactions."Transaction Type" = AgentTransactions."Transaction Type"::Deposit) THEN
                        BEGIN
                          AgentTransactions.Amount :=-AgentTransactions.Amount;
                        END;
        
                      AgentApps.RESET;
                      AgentApps.SETRANGE(AgentApps."Agent Code", AgentTransactions."Agent Code");
                      IF AgentApps.FIND('-')
                        THEN BEGIN
                              GenLedgerSetup.RESET;
                              GenLedgerSetup.GET;
                            //  GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
                              //CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
                              AgentChargesAcc:= GenLedgerSetup."Agency Charges Acc";
        
                              GenJournalLine.RESET;
                              GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                              GenJournalLine.SETRANGE("Journal Batch Name",'Agency');
                              GenJournalLine.DELETEALL;
                              //end of deletion
        
                              GenBatches.RESET;
                              GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                              GenBatches.SETRANGE(GenBatches.Name,'Agency');
        
                              IF GenBatches.FIND('-') = FALSE THEN BEGIN
                                  GenBatches.INIT;
                                  GenBatches."Journal Template Name":='GENERAL';
                                  GenBatches.Name:='Agency';
                                  GenBatches.Description:='Agency Transactions';
                                  GenBatches.VALIDATE(GenBatches."Journal Template Name");
                                  GenBatches.VALIDATE(GenBatches.Name);
                                  GenBatches.INSERT;
                              END;//General Jnr Batches
                              CASE AgentTransactions."Transaction Type" OF
        
                                     AgentTransactions."Transaction Type"::Withdrawal,
                                     AgentTransactions."Transaction Type"::Deposit,
                                     AgentTransactions."Transaction Type"::Transfer:
                                BEGIN
                                Vendor.RESET;
                                Vendor.SETRANGE(Vendor."No.", AgentTransactions."Account No.");
                                IF Vendor.FIND('-') THEN BEGIN
        //..........................DEPOSIT.....................................................................................//
                              IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::Deposit) THEN BEGIN
        
                   //....Credit Member Account
                                  LineNo:=LineNo+10000;
                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='Agency';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                  GenJournalLine."Account No.":=AgentTransactions."Account No.";
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                  GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                  GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                  GenJournalLine.Description:='Cash Deposit- '+AgentTransactions.Description;
                                  GenJournalLine.Amount:=AgentTransactions.Amount;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                  GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                  GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                  GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;
        
                      //.......Debit Bank Account
        
                                  LineNo:=LineNo+10000;
                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='Agency';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                  GenJournalLine."Account No.":=AgentApps.Account;
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                  GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                  GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                  GenJournalLine.Description:='Cash Deposit- '+AgentTransactions.Description;
                                  GenJournalLine.Amount:=AgentTransactions.Amount *-1;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                  GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                  GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                  GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;
                                  END
                                  END;//CASE Deposits, Withdrawal Transfer
        //...................................END OF DEPOSIT.....................................................................//
        
        
                                  END;
                                 AgentTransactions."Transaction Type"::Balance,
                                  AgentTransactions."Transaction Type"::Ministatment:
                                  IF Vendor.FIND('-') THEN BEGIN
                                  BEGIN
                                  //Cr Vendor
                                  Vendor.RESET;
                                  Vendor.SETRANGE(Vendor."No.", AgentTransactions."Account No.");
                                      //Dr Customer
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                      GenJournalLine."Account No.":=AgentTransactions."Account No.";
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Agency Banking Charges';
                                      GenJournalLine.Amount:=TotalCommission+ExcDuty;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                      //Cr Excise Duty
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":=ExxcDuty;
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Excise Duty-Agency Charges';
                                      GenJournalLine.Amount:=-1*ExcDuty;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":=CloudPESACommACC;
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Agency Banking Charges';
                                      GenJournalLine.Amount:=-1*commVendor;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                      //Cr Sacco
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":=AgentChargesAcc;
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Agency Banking Charges';
                                      GenJournalLine.Amount:=-1*commSacco;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                       res:=TRUE;
                                      END;//Vendor
                                    END;//CASE mini Statement, Balance
                                AgentTransactions."Transaction Type"::Sharedeposit,
                                AgentTransactions."Transaction Type"::Registration:
        
                              //  AgentTransactions."Transaction Type"::,
                             //   AgentTransactions."Transaction Type"::"Benevolent Fund":
                                  BEGIN
        
                                  Members.RESET;
                                  Members.SETRANGE(Members."No.", AgentTransactions."Account No.");
                                  IF Members.FIND('-') THEN BEGIN
                                  Vendor.RESET;
                                  Vendor.SETRANGE(Vendor."ID No.", AgentTransactions."Id No");
                                 // Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
                                   IF Vendor.FINDFIRST THEN BEGIN
                                     AgentTransactions.Amount :=-AgentTransactions.Amount;
                                    //Cr Customer
        
                                  { IF AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Deposit Contribution" THEN BEGIN
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                      GenJournalLine."Account No.":=AgentTransactions."Account No.";
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                      GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution";
                                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.Description:=AgentTransactions.Description+'-'+AgentTransactions."Account Name";
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                    END;
                                    }
                                    IF AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::Sharedeposit THEN BEGIN
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                      GenJournalLine."Account No.":=AgentTransactions."Account No.";
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                      GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Shares Capital";
                                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.Description:=AgentTransactions.Description+'-'+AgentTransactions."Account Name";
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                    END;
                                    {IF AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Registration Fee" THEN BEGIN
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                      GenJournalLine."Account No.":=AgentTransactions."Account No.";
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                      GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Registration Fee";
                                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.Description:=AgentTransactions.Description+'-'+AgentTransactions."Account Name";
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                    END;
                                    IF AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Benevolent Fund" THEN BEGIN
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                      GenJournalLine."Account No.":=AgentTransactions."Account No.";
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                      GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Benevolent Fund";
                                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.Description:=AgentTransactions.Description +'-'+AgentTransactions."Account Name";
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                    END;
                                    }
               //Dr Customer charges
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                      GenJournalLine."Account No.":=Vendor."No.";
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Agency Banking Charges';
                                      GenJournalLine.Amount:=TotalCommission+ExcDuty;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                      //Cr Excise Duty
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":=ExxcDuty;
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Excise Duty-Agency Charges';
                                      GenJournalLine.Amount:=-1*ExcDuty;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":=CloudPESACommACC;
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Agency Banking Charges';
                                      GenJournalLine.Amount:=-1*commVendor;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                      //Cr Sacco
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":=AgentChargesAcc;
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Agency Banking Charges';
                                      GenJournalLine.Amount:=-1*commSacco;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                      END;//Vendor
                                      END;//Member
                                    END;//CASE Shares Deposit
        
                                   AgentTransactions."Transaction Type"::LoanRepayment:
                                    BEGIN
                                     //  AgentTransactions.Amount :=-AgentTransactions.Amount;
                                    Members.RESET;
                                    Members.SETRANGE(Members."No.", AgentTransactions."Account No.");
                                    IF Members.FIND('-') THEN BEGIN
                                    Vendor.RESET;
                                    Vendor.SETRANGE(Vendor."No.", AgentTransactions."Account No.");
                                   // Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
                                     IF Vendor.FIND('-') THEN BEGIN
        
                                          //Cr Customer
                                          LoansRegister.RESET;
                                          LoansRegister.SETRANGE(LoansRegister."Loan  No.",AgentTransactions."Loan No");
                                          LoansRegister.SETRANGE(LoansRegister."Client Code",Members."No.");
        
                                          IF LoansRegister.FIND('+') THEN BEGIN
                                          LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest");
                                          IF LoansRegister."Outstanding Balance" > 0 THEN BEGIN
        
                                          LineNo:=LineNo+10000;
        
                                          GenJournalLine.INIT;
                                          GenJournalLine."Journal Template Name":='GENERAL';
                                          GenJournalLine."Journal Batch Name":='Agency';
                                          GenJournalLine."Line No.":=LineNo;
        
                                          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                          GenJournalLine.VALIDATE(GenJournalLine."Account Type");
                                          GenJournalLine."Account No.":=LoansRegister."Client Code";
                                          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        
                                          GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                          GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
        
                                          GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                          GenJournalLine."External Document No.":='';
                                          GenJournalLine."Posting Date":=TODAY;
                                          GenJournalLine.Description:='Loan Interest Payment -'+AgentTransactions."Account Name";
        
                                          IF AgentTransactions.Amount > LoansRegister."Oustanding Interest" THEN
                                          GenJournalLine.Amount:=-LoansRegister."Oustanding Interest"
                                          ELSE
                                          GenJournalLine.Amount:=-AgentTransactions.Amount;
                                          GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                          GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                          GenJournalLine.VALIDATE(GenJournalLine."Transaction Type");
        
                                          IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                                          GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                                          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                          END;
                                          GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                                          IF GenJournalLine.Amount<>0 THEN
                                          GenJournalLine.INSERT;
                                           END;
        
                                          AgentTransactions.Amount:=AgentTransactions.Amount+GenJournalLine.Amount;
        
                                          IF AgentTransactions.Amount>0 THEN BEGIN
        
                                          LineNo:=LineNo+10000;
        
                                          GenJournalLine.INIT;
                                          GenJournalLine."Journal Template Name":='GENERAL';
                                          GenJournalLine."Journal Batch Name":='Agency';
                                          GenJournalLine."Line No.":=LineNo;
        
                                          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                          GenJournalLine.VALIDATE(GenJournalLine."Account Type");
                                          GenJournalLine."Account No.":=LoansRegister."Client Code";
                                          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        
                                          GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                          GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
        
                                          GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                          GenJournalLine."External Document No.":='';
                                          GenJournalLine."Posting Date":=TODAY;
                                          GenJournalLine.Description:='Loan repayment -'+AgentTransactions."Account Name";
                                          GenJournalLine.Amount:=-AgentTransactions.Amount;
                                          GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                          GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                          IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                                          GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                                          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                          END;
                                          GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                                          IF GenJournalLine.Amount<>0 THEN
                                          GenJournalLine.INSERT;
        
               //Dr Customer
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                      GenJournalLine."Account No.":=Vendor."No.";
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Agency Banking Charges';
                                      GenJournalLine.Amount:=TotalCommission+ExcDuty;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                      //Cr Excise Duty
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":=ExxcDuty;
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Excise Duty-Agency Charges';
                                      GenJournalLine.Amount:=-1*ExcDuty;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":=CloudPESACommACC;
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Agency Banking Charges';
                                      GenJournalLine.Amount:=-1*commVendor;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                      //Cr Sacco
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":=AgentChargesAcc;
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:='Agency Banking Charges';
                                      GenJournalLine.Amount:=-1*commSacco;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                          END;
                                          END;//LoansRegister
                                          END;//Vendor
                                          END;//Member
                                        END;//CASE Loan Repayment
        
        
        
                                  { AgentTransactions."Transaction Type"::"Pay Fines",AgentTransactions."Transaction Type"::Others,AgentTransactions."Transaction Type"::"Sale of Plate",
                                   AgentTransactions."Transaction Type"::"Share Passbook",AgentTransactions."Transaction Type"::"Sale of Passbook":
                                       BEGIN
                                      AgentTransactions.Amount :=AgentTransactions.Amount*-1;
                                     IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Share Passbook") THEN BEGIN
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":='401130';
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Share Capital";
                                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.Description:=AgentTransactions.Description;
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                    END;
                                     IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Pay Fines") THEN BEGIN
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":='401270';
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Share Capital";
                                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.Description:=AgentTransactions.Description;
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                     END;//pay fine
                                     IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::Others) THEN BEGIN
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":='401220';
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Share Capital";
                                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.Description:=AgentTransactions.Description;
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                     END;
                                     IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Sale of Plate") THEN BEGIN
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":='401120';
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Loan;
                                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.Description:=AgentTransactions.Description;
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                     END;
                                     IF (AgentTransactions."Transaction Type"=AgentTransactions."Transaction Type"::"Sale of Passbook") THEN BEGIN
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                      GenJournalLine."Account No.":='401110';
                                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Share Capital";
                                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.Description:=AgentTransactions.Description;
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
        
                                     END;
        
              //Debit/Credit agent
        
                                      LineNo:=LineNo+10000;
                                      GenJournalLine.INIT;
                                      GenJournalLine."Journal Template Name":='GENERAL';
                                      GenJournalLine."Journal Batch Name":='Agency';
                                      GenJournalLine."Line No.":=LineNo;
                                      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                                      GenJournalLine."Bal. Account No.":=AgentApps.Account;
                                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                      GenJournalLine."Document No.":=AgentTransactions."Document No.";
                                      GenJournalLine."External Document No.":=AgentApps."Agent Code";
                                      GenJournalLine."Posting Date":=AgentTransactions."Transaction Date";
                                      GenJournalLine.Description:=AgentTransactions.Description  +'-'+AgentTransactions."Account Name";
                                      GenJournalLine.Amount:=AgentTransactions.Amount;
                                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                      GenJournalLine."Shortcut Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                      GenJournalLine."Shortcut Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                      IF GenJournalLine.Amount<>0 THEN
                                      GenJournalLine.INSERT;
                                    END;
                                      //END;
                                      }
        
                                END;
        
        
        
                                        //Post
                                        GenJournalLine.RESET;
                                        GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                        GenJournalLine.SETRANGE("Journal Batch Name",'Agency');
                                        IF GenJournalLine.FIND('-') THEN BEGIN
                                            REPEAT
                                           GLPosting.RUN(GenJournalLine);
                                            UNTIL GenJournalLine.NEXT = 0;
                                        AgentTransactions.Posted:=TRUE;
                                        AgentTransactions."Date Posted":=TODAY;
                                        AgentTransactions.Messages:='Completed';
                                        AgentTransactions."Time Posted":=TIME;
                                        AgentTransactions.MODIFY;
                                        res:=TRUE;
                                        END
                                        ELSE BEGIN
                                        AgentTransactions.Posted:=FALSE;
                                        AgentTransactions."Date Posted":=TODAY;
                                        AgentTransactions.Messages:='Failed';
                                        AgentTransactions."Time Posted":=TIME;
                                        AgentTransactions.MODIFY;
                                        END;
                                   // END;
                         END;//Agent Apps
                     END
                     ELSE BEGIN//Check deposit
                           res:=FALSE;
                        END
              END;//Agent Transactions
        
        */

    end;


    procedure GetAccountBookBalance(account: Code[30]) bal: Decimal
    begin
        begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."No.", account);
            if Vendor.Find('-') then begin
                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                if AccountTypes.Find('-') then begin
                    //miniBalance:=1000;//AccountTypes."Minimum Balance";
                    miniBalance := AccountTypes."Minimum Balance";
                    Vendor.CalcFields(Vendor."Balance (LCY)");
                    Vendor.CalcFields(Vendor."ATM Transactions");
                    Vendor.CalcFields(Vendor."Uncleared Cheques");
                    Vendor.CalcFields(Vendor."EFT Transactions");
                    //bal:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);
                    bal := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions");
                end;
            end
            else begin
                //    AgentApps.RESET;
                //    AgentApps.SETRANGE(AgentApps."Agent Code",account);
                //    IF AgentApps.FIND('-') THEN BEGIN
                BankAccount.Reset;
                BankAccount.SetRange(BankAccount."Bank Account No.", account);
                if (BankAccount.Find('-')) then begin
                    repeat
                        bal := bal + BankAccount.Amount;

                    until BankAccount.Next = 0;
                end;
                //END;
            end;

        end;
    end;


    procedure GetAccountBalance(account: Code[30]) bal: Decimal
    begin
        //Available Balance
        begin
            Vendor.Reset;
            Vendor.SetRange(Vendor."No.", account);
            if Vendor.Find('-') then begin
                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                if AccountTypes.Find('-') then begin
                    miniBalance := AccountTypes."Minimum Balance";
                    Vendor.CalcFields(Vendor."Balance (LCY)");
                    Vendor.CalcFields(Vendor."ATM Transactions");
                    Vendor.CalcFields(Vendor."Uncleared Cheques");
                    Vendor.CalcFields(Vendor."EFT Transactions");
                    //Changed Here
                    bal := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance);
                end;
            end
            else begin
                BankAccount.Reset;
                BankAccount.SetRange(BankAccount."Bank Account No.", account);
                if (BankAccount.Find('-')) then begin
                    repeat
                        bal := bal + BankAccount.Amount;

                    until BankAccount.Next = 0;
                end;
            end;

        end;
    end;


    procedure GetMember(idNumber: Text[50]) accounts: Text[1000]
    var
        Dateofreg: Date;
        dateofbirth: Date;
        gender: Code[10];
    begin
        begin
            Members.Reset;
            Members.SetRange(Members."No.", Getfosaaccount(idNumber));
            Members.SetRange(Members.Blocked, 0);
            Members.SetFilter(Members.Status, '%1|%2', 0, 4);
            if Members.Find('-') then begin
                accounts := '';
                repeat
                    if Members."Registration Date" = 0D then
                        Dateofreg := CalcDate('-5Y', Today)
                    else
                        Dateofreg := Members."Registration Date";

                    if Members."Date of Birth" = 0D then
                        dateofbirth := CalcDate('-18Y', Today)
                    else
                        dateofbirth := Members."Date of Birth";


                    if Members.Gender = Members.Gender::" " then
                        gender := 'MALE'
                    else
                        gender := Format(Members.Gender);
                    accounts := accounts + '::::' + Members.Name + ':::' + Members."ID No." + ':::' + Format(dateofbirth) + ':::' + Members."Global Dimension 2 Code" + ':::' + Members."No." + ':::'
                      + gender + ':::' + Members."Phone No." + ':::' + Format(Dateofreg);
                until Members.Next = 0;
            end
            else begin
                accounts := 'none';
            end
        end;
    end;


    procedure GetTransactionMinAmount() limits: Decimal
    begin
        WithdrawalLimit.Reset;
        WithdrawalLimit.SetRange(WithdrawalLimit.Code, 'NORMAL');
        if WithdrawalLimit.Find('-') then begin
            limits := WithdrawalLimit."Trans Min Amount";
        end;
    end;


    procedure GetTransactionMaxAmount() limits: Decimal
    begin
        WithdrawalLimit.Reset;
        WithdrawalLimit.SetRange(WithdrawalLimit.Code, 'NORMAL');
        if WithdrawalLimit.Find('-') then begin
            limits := WithdrawalLimit."Trans Max Amount";
        end;
    end;


    procedure GetTransactionCharges(TransactionType: Option; TransactionAmount: Decimal) ChargeAmount: Decimal
    begin
        WithdrawalLimit.Reset;
        WithdrawalLimit.SetRange(WithdrawalLimit.Code, 'NORMAL');
        if WithdrawalLimit.Find('-') then begin
            ChargeAmount := WithdrawalLimit."Trans Max Amount";
        end;
    end;


    procedure GetWithdrawalCharges(type: Text[20]; amount: Decimal) charges: Decimal
    begin
        TariffDetails.Reset;
        TariffDetails.SetRange(TariffDetails.Code, type);
        TariffDetails.SetFilter(TariffDetails."Lower Limit", '<=%1', amount);
        TariffDetails.SetFilter(TariffDetails."Upper Limit", '>=%1', amount);
        if TariffDetails.Find('-') then begin
            charges := TariffDetails.Charge;
        end;
    end;


    procedure GetCharges(type: Text[20]) charge: Decimal
    begin
        TariffDetails.Reset;
        TariffDetails.SetRange(TariffDetails.Code, 'WITH');
        if TariffDetails.Find('-') then begin
            charge := TariffDetails.Charge;
        end;
    end;


    procedure GetTariffCode(type: Text[30]) "code": Text[10]
    begin
        TariffHeader.Reset;
        TariffHeader.SetFilter(TariffHeader."Trans Type", type);
        if TariffHeader.Find('-') then begin
            code := TariffHeader.Code;
        end;
    end;


    procedure InsertMessages(documentNo: Text[30]; phone: Text[20]; message: Text[400]) res: Boolean
    begin
        begin
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
            SMSMessages."Account No" := '';
            SMSMessages."Date Entered" := Today;
            SMSMessages."Time Entered" := Time;
            SMSMessages.Source := 'MOBILETRAN';
            SMSMessages."Entered By" := UserId;
            SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
            SMSMessages."SMS Message" := message;
            SMSMessages."Telephone No" := phone;
            if SMSMessages."Telephone No" <> '' then
                SMSMessages.Insert;
            res := true;
        end;
    end;


    procedure AgencyRegistration() memberdetails: Text[500]
    var
        Activate: Code[50];
        AgentReg: Record "Agency Members App";
    begin
        begin
            AgentReg.Reset;
            AgentReg.SetRange(AgentReg.SentToServer, false);
            if AgentReg.Find('-') then begin
                memberdetails := AgentReg."Bosa Number" + ':::NULL:::' + AgentReg."ID No" + ':::' + AgentReg."Account Name" + ':::' + AgentReg.Telephone;
            end
            else begin
                memberdetails := '';
            end
        end;
    end;


    procedure UpdateAgencyRegistration(agentCode: Code[20]) result: Text[30]
    var
        AgentReg: Record "Agency Members App";
    begin
        AgentReg.Reset;
        AgentReg.SetRange(AgentReg."Bosa Number", agentCode);
        if AgentReg.Find('-') then begin
            AgentReg.SentToServer := true;
            AgentReg.Modify;
            result := 'Modified';
        end;
    end;

    local procedure Blocked(Account: Code[30]) status: Boolean
    begin
        Vendor.Reset;
        Vendor.SetRange(Vendor."No.", Account);
        if Vendor.Find('-') then begin
            if Vendor.Blocked = Vendor.Blocked::All then begin
                status := true;
            end
            else
                if Vendor.Blocked = Vendor.Blocked::Payment then begin
                    status := true;
                end
                else begin
                    status := false;
                end
        end
    end;

    local procedure GetmobileCharges("code": Code[30]) charge: Decimal
    begin
        charge := 0;
    end;


    procedure GetMemberBalancesALL(Identifier: Code[50]; IdentifierType: Integer) StringList: Text
    begin
    end;


    procedure GetLoansInfo(Identifier: Code[50]; IdentifierType: Integer) StringList: Text
    begin
    end;


    procedure GetMemberShareDeposit(Identifier: Code[50]; IdentifierType: Integer) StringList: Text
    begin
    end;


    procedure GetPhoneNumber(Identifier: Code[50]; IdentifierType: Integer) StringList: Text
    begin
    end;


    procedure FnGetPicture(account: Code[50]) res: Text
    var
        Item: Record Customer;
        TenantMedia: Record "Tenant Permission Set";
        //TempBlob: Record TempBlob;
        PictureTex: Text;
        PictureInstream: InStream;
        PictureOutStream: OutStream;
    begin
        // Item.Reset;
        // Item.SetRange(Item."ID No.", account);
        // if Item.Find('-') then begin
        //     Clear(PictureTex);
        //     Clear(PictureInstream);
        //     Item.Image.CreateInstream(PictureInstream);

        //     TempBlob.Reset;

        //     if TempBlob.Find('+') then begin
        //         iEntryNo := TempBlob."Primary Key";
        //         iEntryNo := iEntryNo + 1;
        //     end
        //     else begin
        //         iEntryNo := 1;
        //     end;
        //     TempBlob.Init;
        //     TempBlob."Primary Key" := iEntryNo;
        //     TempBlob.Blob.CreateOutstream(PictureOutStream);
        //     CopyStream(PictureOutStream, PictureInstream);
        //     TempBlob.Insert;
        //     TempBlob.CalcFields(Blob);
        //     PictureTex := Format(TempBlob.Blob);
        //     res := Format(Item.Picture);
        // end;
    end;

    local procedure Getfosaaccount(Acountno: Code[50]) acount: Code[100]
    begin
        acount := 'NONE';
        Members.Reset;
        Members.SetRange(Members."ID No.", Acountno);
        if Members.Find('-') then begin
            acount := Members."No.";
            exit;
        end;
        Members.Reset;
        Members.SetRange(Members."No.", Acountno);
        if Members.Find('-') then begin
            acount := Members."No.";
            exit;
        end;
    end;


    procedure GetAgentBalance(account: Code[30]) bal: Decimal
    begin

        AgentApps.Reset;
        AgentApps.SetRange(AgentApps.Account, account);
        if AgentApps.Find('-') then begin

            begin
                Vendor.Reset;
                Vendor.SetRange(Vendor."No.", account);
                if Vendor.Find('-') then begin
                    AccountTypes.Reset;
                    AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                    if AccountTypes.Find('-') then begin
                        miniBalance := AccountTypes."Minimum Balance";
                        Vendor.CalcFields(Vendor."Balance (LCY)");
                        Vendor.CalcFields(Vendor."ATM Transactions");
                        Vendor.CalcFields(Vendor."Uncleared Cheques");
                        Vendor.CalcFields(Vendor."EFT Transactions");
                        bal := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance);
                    end;
                end
                else begin

                    BankAccount.Reset;
                    BankAccount.SetRange(BankAccount."Bank Account No.", account);
                    if (BankAccount.Find('-')) then begin
                        repeat
                            bal := bal + BankAccount.Amount;

                        until BankAccount.Next = 0;
                    end;




                end;
            end;
        end;
    end;
}

