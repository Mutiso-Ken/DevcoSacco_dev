#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516003 "POST ATM Transactions"
{

    trigger OnRun()
    begin

        //MESSAGE(FORMAT(fnGetUnpostedTrans()));
        //ERROR('TUKO HAPA');
        //MESSAGE(FORMAT(PostTrans()));
        PostTrans();
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        ATMTrans: Record "ATM Transactions";
        LineNo: Integer;
        Acct: Record Vendor;
        ATMCharges: Decimal;
        BankCharges: Decimal;
        GenBatches: Record "Gen. Journal Batch";
        // GLPosting: Codeunit "Gen. Jnl.-Post Line";
        BankCode: Code[20];
        PDate: Date;
        RevFromDate: Date;
        ATMTransR: Record "ATM Transactions";
        GLAcc: Code[20];
        BankAcc: Code[20];
        ATMCharge: Record "ATM Charges";
        AtmTrans1: Record "ATM Transactions";
        BankChargecode: Code[20];
        DocNo: Code[20];
        Pos: Record "POS Commissions";
        ExciseDuty: Decimal;
        SaccoGen: Record "Sacco General Set-Up";
        ExciseAcNo: Code[30];
        SMSMessage: Record "SMS Messages";
        iEntryNo: Integer;
        TEST: Boolean;


    procedure PostTrans() success: Boolean
    begin
        //delete journal line
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", 'ATMTRANS');
        GenJournalLine.DeleteAll;
        //end of deletion
        //ERROR('tuko hapa');
        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
        GenBatches.SetRange(GenBatches.Name, 'ATMTRANS');
        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := 'GENERAL';
            GenBatches.Name := 'ATMTRANS';
            GenBatches.Description := 'ATM Transactions';
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;

        ATMTrans.LockTable;
        ATMTrans.Reset;
        ATMTrans.SetRange(ATMTrans.Posted, false);
        ATMTrans.SetRange(ATMTrans.Source, ATMTrans.Source::"ATM Bridge");
        if ATMTrans.Find('-') then begin

            repeat
                DocNo := ATMTrans."Reference No";
                ATMCharges := 0;
                BankCharges := 0;
                ExciseDuty := 0;
                GLAcc := '';
                BankAcc := '';
                BankChargecode := '';
                ExciseAcNo := '';

                if ATMCharge.Get(ATMTrans."Transaction Type Charges") then begin
                    ATMCharges := ATMCharge."Total Amount";
                    BankCharges := ATMCharge."Total Amount" - ATMCharge."Sacco Amount";
                    SaccoGen.Get;
                    ExciseDuty := (SaccoGen."Excise Duty(%)" / 100) * ATMCharges;

                    if ATMTrans."Transaction Type Charges" = ATMTrans."transaction type charges"::"POS - Cash Withdrawal" then begin
                        Pos.Reset;
                        Pos.SetFilter(Pos."Lower Limit", '<=%1', ATMTrans.Amount);
                        Pos.SetFilter(Pos."Upper Limit", '>=%1', ATMTrans.Amount);
                        if Pos.FindFirst then begin
                            ATMCharges := Pos."Charge Amount";
                            BankCharges := Pos."Bank charge";
                        end;
                    end;

                    if ATMCharge.Source = ATMCharge.Source::ATM then begin
                        GLAcc := ATMCharge."Atm Income A/c";
                        BankAcc := ATMCharge."Atm Bank Settlement A/C";
                        BankChargecode := ATMCharge."Atm Bank Settlement A/C";
                        SaccoGen.Get();
                        ExciseAcNo := SaccoGen."Excise Duty Account";
                    end else begin
                        GLAcc := ATMCharge."Atm Income A/c";
                        BankAcc := ATMCharge."Atm Bank Settlement A/C";
                        BankChargecode := ATMCharge."Atm Bank Settlement A/C";
                        SaccoGen.Get();
                        ExciseAcNo := SaccoGen."Excise Duty Account";


                    end;
                end;

                if ATMTrans.Reversed = true then begin
                    AtmTrans1.Reset;
                    AtmTrans1.SetRange(AtmTrans1."Account No", ATMTrans."Account No");
                    AtmTrans1.SetRange(AtmTrans1.Reversed, false);
                    AtmTrans1.SetRange(AtmTrans1."Trace ID", ATMTrans."Reversal Trace ID");
                    if AtmTrans1.Find('-') then begin
                        ATMCharges := 0;
                        BankCharges := 0;
                        ExciseDuty := 0;


                        if ATMCharge.Get(AtmTrans1."Transaction Type Charges") then begin

                            ATMCharges := -ATMCharge."Total Amount";
                            BankCharges := -(ATMCharge."Total Amount" - ATMCharge."Sacco Amount");
                            SaccoGen.Get;
                            ExciseDuty := (SaccoGen."Excise Duty(%)" / 100) * ATMCharges;
                            if AtmTrans1."Transaction Type Charges" = AtmTrans1."transaction type charges"::"POS - Cash Withdrawal" then begin
                                Pos.Reset;
                                Pos.SetFilter(Pos."Lower Limit", '<=%1', AtmTrans1.Amount);
                                Pos.SetFilter(Pos."Upper Limit", '>=%1', AtmTrans1.Amount);
                                if Pos.FindFirst then begin
                                    ATMCharges := -Pos."Charge Amount";
                                    BankCharges := -Pos."Bank charge";
                                end;
                            end;


                            if ATMCharge.Source = ATMCharge.Source::ATM then begin
                                GLAcc := ATMCharge."Atm Income A/c";
                                BankAcc := ATMCharge."Atm Bank Settlement A/C";
                                BankChargecode := ATMCharge."Atm Bank Settlement A/C";
                                SaccoGen.Get();
                                ExciseAcNo := SaccoGen."Excise Duty Account";
                            end else begin
                                SaccoGen.Get();
                                GLAcc := ATMCharge."Atm Income A/c";
                                BankAcc := ATMCharge."Atm Bank Settlement A/C";
                                BankChargecode := ATMCharge."Atm Bank Settlement A/C";
                                SaccoGen.Get();
                                ExciseAcNo := SaccoGen."Excise Duty Account";
                            end;
                        end;
                    end;
                end;

                if Acct.Get(ATMTrans."Account No") then begin
                    LineNo := LineNo + 10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := ATMTrans."Account No";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := DocNo;
                    GenJournalLine."Posting Date" := ATMTrans."Posting Date";
                    if ATMTrans."Transaction Description" = '' then
                        GenJournalLine.Description := 'ATM Cash W/D'
                    else
                        GenJournalLine.Description := ATMTrans."Transaction Description";
                    GenJournalLine.Amount := ATMTrans.Amount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    LineNo := LineNo + 10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Account No." := BankAcc;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := DocNo;
                    GenJournalLine."Posting Date" := ATMTrans."Posting Date";
                    GenJournalLine.Description := Acct.Name;
                    GenJournalLine.Amount := ATMTrans.Amount * -1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := Acct."Global Dimension 1 Code";
                    GenJournalLine."Shortcut Dimension 2 Code" := Acct."Global Dimension 2 Code";
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;







                    LineNo := LineNo + 10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No." := ATMTrans."Account No";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := DocNo;
                    GenJournalLine."Posting Date" := ATMTrans."Posting Date";
                    if ATMTrans."Transaction Description" = '' then
                        GenJournalLine.Description := 'ATM W/D Charges '
                    else
                        GenJournalLine.Description := 'Trans Charges';
                    GenJournalLine.Amount := ATMCharges + ExciseDuty;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    LineNo := LineNo + 10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Account No." := BankChargecode;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := DocNo;
                    GenJournalLine."External Document No." := Acct."ATM No.";
                    GenJournalLine."Posting Date" := ATMTrans."Posting Date";
                    GenJournalLine.Description := 'Trans. Charges';
                    GenJournalLine.Amount := -BankCharges;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := Acct."Global Dimension 1 Code";
                    GenJournalLine."Shortcut Dimension 2 Code" := Acct."Global Dimension 2 Code";
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;



                    LineNo := LineNo + 10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := GLAcc;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := DocNo;
                    GenJournalLine."External Document No." := ATMTrans."Account No";
                    GenJournalLine."Posting Date" := ATMTrans."Posting Date";
                    GenJournalLine.Description := Acct.Name;
                    GenJournalLine.Amount := -1 * (ATMCharges - BankCharges);
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := Acct."Global Dimension 1 Code";
                    GenJournalLine."Shortcut Dimension 2 Code" := Acct."Global Dimension 2 Code";
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;


                    //EXCISE DUTY
                    LineNo := LineNo + 10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'ATMTRANS';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No." := ExciseAcNo;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := DocNo;
                    GenJournalLine."External Document No." := ATMTrans."Account No";
                    GenJournalLine."Posting Date" := ATMTrans."Posting Date";
                    GenJournalLine.Description := 'Excise Duty';
                    GenJournalLine.Amount := -1 * ExciseDuty;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := Acct."Global Dimension 1 Code";
                    GenJournalLine."Shortcut Dimension 2 Code" := Acct."Global Dimension 2 Code";
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    //ERROR('%1',GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;




                    ATMTrans.Posted := true;
                    ATMTrans.Modify;
                    success := true;
                    ///sms

                    //SMS MESSAGE
                    SMSMessage.Reset;
                    if SMSMessage.Find('+') then begin
                        iEntryNo := SMSMessage."Entry No";
                        iEntryNo := iEntryNo + 1;
                    end
                    else begin
                        iEntryNo := 1;
                    end;

                    SMSMessage.Reset;
                    SMSMessage.Init;
                    SMSMessage."Entry No" := iEntryNo;
                    SMSMessage."Account No" := ATMTrans."Account No";
                    SMSMessage."Date Entered" := Today;
                    SMSMessage."Time Entered" := Time;
                    SMSMessage.Source := 'ATM TRANS';
                    SMSMessage."Entered By" := UserId;
                    SMSMessage."Sent To Server" := SMSMessage."sent to server"::No;
                    if ATMTrans.Amount > 0 then begin
                        SMSMessage."SMS Message" := 'You have withdrawn KES.' + Format(ATMTrans.Amount) +
                                                  ' from ATM Location ' + ATMTrans."Withdrawal Location" +
                                                  ' on ' + Format(Today) + ' ' + Format(Time) + '  From MMH Sacco';

                        SMSMessage."Telephone No" := Acct."Phone No.";
                        SMSMessage.Insert;
                    end;

                    if ATMTrans.Amount < 0 then begin
                        SMSMessage."SMS Message" := 'Your withdrawal of KES.' + Format(ATMTrans.Amount) +
                                                  ' from ATM Location ' + ATMTrans."Withdrawal Location" +
                                                  ' has been reversed on ' + Format(Today) + ' ' + Format(Time) + ' From MMH Sacco';

                        SMSMessage."Telephone No" := Acct."Phone No.";
                        SMSMessage.Insert;
                    end;


                    //////////////////////////////

                    ///end sms

                end else begin
                    Error('%1', 'Account No. %1 not found.', ATMTrans."Account No");
                end;



            until ATMTrans.Next = 0;


            //Post
            GenJournalLine.Reset;
            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
            GenJournalLine.SetRange("Journal Batch Name", 'ATMTRANS');
            if GenJournalLine.Find('-') then begin
                // repeat
                // GLPosting.Run(GenJournalLine);
                // until GenJournalLine.Next = 0;
                Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine);
            end;


            GenJournalLine.Reset;
            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
            GenJournalLine.SetRange("Journal Batch Name", 'ATMTRANS');
            GenJournalLine.DeleteAll;
            //Post
        end;
        exit(success);
    end;


    procedure fnGetUnpostedTrans() TotalUnposted: Integer
    begin

        ATMTrans.Reset;
        ATMTrans.SetRange(ATMTrans.Posted, false);
        if ATMTrans.Find('-') then begin

            TotalUnposted := TotalUnposted;
            //ERROR('%1',  ATMTrans.Posted);
        end;
        exit(TotalUnposted);
        //MESSAGE('%1',ATMTrans.Posted);
    end;
}

