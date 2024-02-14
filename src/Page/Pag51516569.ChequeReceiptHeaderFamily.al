#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516569 "Cheque Receipt Header-Family"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    Editable = true;
    PageType = Card;
    SourceTable = "Cheque Receipts-Family";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posted By"; "Posted By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unpaid By"; "Unpaid By")
                {
                    ApplicationArea = Basic;
                }
                field("Refference Document"; "Refference Document")
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Unpaid; Unpaid)
                {
                    ApplicationArea = Basic;
                }
                field(Imported; Imported)
                {
                    ApplicationArea = Basic;
                }
                field(Processed; Processed)
                {
                    ApplicationArea = Basic;
                }
                field("Document Name"; "Document Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account"; "Bank Account")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000011; "Cheque Receipt Line-Family")
            {
                SubPageLink = "Header No" = field("No.");

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Import)
            {
                ApplicationArea = Basic;
                Image = Import;
                Visible = false;

                trigger OnAction()
                var
                    DestinationFile: Text[60];
                begin

                    //  DestinationFile := FileMgt.OpenFileDialog('D:\Cheque Trunc\Raw\','*.J70',UserId+'(*.*)|(*.J70)');
                    if Confirm('Are you sure you want Import cheques', true) = true then begin
                        if FILE.Copy(DestinationFile, 'D:\Cheque Trunc\Raw\' + '.J70') then begin
                            Message(Format(DestinationFile));
                            ObjChequeFamily.Reset;
                            ObjChequeFamily.SetRange(ObjChequeFamily."No.", "No.");
                            if ObjChequeFamily.Find('-') then begin
                                ObjChequeFamily.Imported := true;
                                ObjChequeFamily."Document Name" := 'D:\Cheque Trunc\Raw\newfile' + '.J70';
                                ObjChequeFamily."Created By" := UserId;
                                ObjChequeFamily.Modify;
                                FILE.Erase(DestinationFile);
                                Message('Successfully Imported');  // continue your program
                            end;
                        end else begin
                            Message('Nothing to Import');  // else handle the error
                        end;
                    end;

                    //XMLPORT.RUN(51516038,TRUE);
                    //REPORT.RUN(51516517,TRUE);


                    /*
                    RefNoRec.RESET;
                    RefNoRec.SETRANGE(RefNoRec.CurrUserID,USERID);
                    IF RefNoRec.FIND('-') THEN BEGIN
                    RefNoRec."Reference No":="No.";
                    RefNoRec.MODIFY;
                    END
                    ELSE BEGIN
                    RefNoRec.INIT;
                    RefNoRec.CurrUserID:=USERID;
                    RefNoRec."Reference No":="No.";
                    RefNoRec.INSERT;
                    END;*/

                end;
            }
            action("Load Lines")
            {
                ApplicationArea = Basic;
                Image = Line;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                Scope = Page;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    objChequeTransactions.Reset;
                    objChequeTransactions.SetRange(objChequeTransactions."Imported to Receipt Lines", false);
                    if objChequeTransactions.Find('-') then begin
                        repeat
                            objChequeTransactions.CalcFields(objChequeTransactions.FrontBWImage, objChequeTransactions.FrontGrayScaleImage, objChequeTransactions.RearImage);
                            ChqRecLines.Init;
                            ChqRecLines."Cheque Serial No" := Format(objChequeTransactions.SerialId);
                            ChqRecLines."Chq Receipt No" := Format(objChequeTransactions.ChequeDataId);
                            ChqRecLines."Account No." := FnGetAccountNo(objChequeTransactions.MemberNo);
                            ChqRecLines.TestField(ChqRecLines."Account No.");
                            ChqRecLines."Member Branch" := CopyStr(ChqRecLines."Account No.", 4, 3);

                            ChqRecLines."Cheque No" := objChequeTransactions.SNO;
                            ChqRecLines."Header No" := "No.";
                            ChqRecLines."Account Name" := FnGetAccountName(objChequeTransactions.MemberNo);
                            ChqRecLines.Amount := objChequeTransactions.AMOUNT;
                            ChqRecLines.Currency := 'KES';
                            ChqRecLines."Family Account No." := objChequeTransactions.DESTACC;
                            ChqRecLines."Account Balance" := FnGetAccountBalance(objChequeTransactions.MemberNo);
                            ChqRecLines.Fillers := objChequeTransactions.FILLER;
                            ChqRecLines."Branch Code" := objChequeTransactions.DESTBRANCH;
                            ChqRecLines.FrontImage := objChequeTransactions.FrontBWImage;
                            ChqRecLines.FrontGrayImage := objChequeTransactions.FrontGrayScaleImage;
                            ChqRecLines.BackImages := objChequeTransactions.RearImage;
                            ChqRecLines.Insert;
                            objChequeTransactions."Imported to Receipt Lines" := true;
                            objChequeTransactions.Modify;
                        until objChequeTransactions.Next = 0;
                    end else begin
                        Error('No New Lines found');
                    end;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    BATCH_NAME := 'CHQTRANS';
                    BATCH_TEMPLATE := 'GENERAL';
                    DOCUMENT_NO := "No.";
                    TestField("Bank Account");
                    if Posted then
                        Error('Document already Posted');

                    if Confirm('Are you sure you want post cheques', true) = true then begin
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", BATCH_TEMPLATE);
                        GenJournalLine.SetRange("Journal Batch Name", BATCH_NAME);
                        GenJournalLine.DeleteAll;

                        ChqRecLines.Reset;
                        ChqRecLines.SetRange(ChqRecLines."Header No", "No.");
                        ChqRecLines.SetRange(ChqRecLines.Status, ChqRecLines.Status::Pending);
                        ChqRecLines.SetRange(ChqRecLines."Verification Status", ChqRecLines."verification status"::Verified);
                        if ChqRecLines.Find('-') then begin
                            repeat
                                if Charges.Get('CPF') then begin
                                    Charges.TestField(Charges."GL Account");
                                    Charges.TestField(Charges."Charge Amount");
                                end;

                                //----------------------------------1.DEBIT TO VENDOR----------------------------------------------
                                LineNo := LineNo + 10000;
                                SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0", GenJournalLine."account type"::Vendor,
                                ChqRecLines."Account No.", "Transaction Date", ChqRecLines.Amount, 'FOSA', ChqRecLines."Cheque No", 'Cheque Issued' + ChqRecLines."Cheque No", '', GenJournalLine."account type"::"Bank Account", "Bank Account");

                                ChargeAmount := 0;
                                objChequeCharges.Reset;
                                if objChequeCharges.Find('-') then
                                    repeat
                                        if (ChqRecLines.Amount >= objChequeCharges."Lower Limit") and (ChqRecLines.Amount <= objChequeCharges."Upper Limit") then begin
                                            ChargeAmount := objChequeCharges.Charges;
                                        end
                                    until objChequeCharges.Next = 0;


                                GenSetup.Get();
                                //----------------------------------2.DEBIT TO VENDOR WITH PROCESSING FEE----------------------------------------------
                                LineNo := LineNo + 10000;
                                SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0", GenJournalLine."account type"::Vendor,
                                ChqRecLines."Account No.", "Transaction Date", ChargeAmount, 'FOSA', ChqRecLines."Cheque No", 'Cheque Issued Commision-' + ChqRecLines."Cheque No", '', GenJournalLine."bal. account type"::"G/L Account", GenSetup."Cheque Processing Fee Account");

                                //----------------------------------3.CHARGE EXCISE DUTY----------------------------------------------
                                LineNo := LineNo + 10000;
                                SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0", GenJournalLine."account type"::Vendor,
                                ChqRecLines."Account No.", "Transaction Date", ChargeAmount * 0.2, 'FOSA', ChqRecLines."Cheque No", 'Excise Duty-' + ChqRecLines."Cheque No", '', GenJournalLine."bal. account type"::"G/L Account", GenSetup."Excise Duty Account");

                                if Vend.Get(ChqRecLines."Account No.") then begin
                                    Vend.CalcFields(Vend."Balance (LCY)");
                                    if AccountType.Get(Vend."Account Type") then begin
                                        if (Vend."Balance (LCY)") - (ChqRecLines.Amount + ROUND(Charges."Charge Amount" * 0.01, 5) + Charges."Charge Amount")
                                         < AccountType."Minimum Balance" then begin
                                            Message('TRANSACTION WILL RESULT TO ACCOUNT GOING BELOW MINIMUM BALANCE %1', ChqRecLines."Account No.");
                                        end;
                                    end;
                                end;
                                ChqRecLines.Status := ChqRecLines.Status::Approved;
                                ChqRecLines.Modify;
                            until ChqRecLines.Next = 0;
                        end;


                        //Post New

                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", BATCH_TEMPLATE);
                        GenJournalLine.SetRange("Journal Batch Name", BATCH_NAME);
                        if GenJournalLine.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco21", GenJournalLine);
                        end;

                        //Mark cheque book register
                        ChqRecLines.Reset;
                        ChqRecLines.SetRange(ChqRecLines."Header No", "No.");
                        ChqRecLines.SetRange(ChqRecLines.Status, ChqRecLines.Status::Approved);
                        if ChqRecLines.Find('-') then begin
                            repeat
                                CheqReg.Reset;
                                CheqReg.SetRange(CheqReg."Cheque No.", ChqRecLines."Cheque No");
                                if CheqReg.Find('-') then begin
                                    CheqReg.Status := CheqReg.Status::Approved;
                                    CheqReg."Approval Date" := Today;
                                    CheqReg.Modify;
                                end;
                            until ChqRecLines.Next = 0;
                        end;
                        Posted := true;
                        "Posted By" := UserId;
                        Modify;
                        Message('Transaction Charges ' + Format(ChargeAmount));
                    end;
                    /*
                    ChqRecLines.GET;
                    ChqRecLines.SETRANGE(ChqRecLines."Header No",ChqRecHeader."No.");
                    IF ChqRecLines.FIND('-') THEN BEGIN
                      REPEAT
                    
                    */

                end;
            }
            action("Post UnPaid Accounts")
            {
                ApplicationArea = Basic;
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                begin

                    if Confirm('Are you sure you want to unpay accounts', false) = true then begin

                        if UpperCase(UserId) = UpperCase("Posted By") then
                            Error('This must be done by another user');

                        if Posted = false then
                            Error('It must be posted first');

                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'CHQTRANS');
                        GenJournalLine.DeleteAll;

                        ChqRecLines.Reset;
                        ChqRecLines.SetRange(ChqRecLines."Header No", "No.");
                        ChqRecLines.SetRange(ChqRecLines.Status, ChqRecLines.Status::Approved);
                        if ChqRecLines.Find('-') then begin
                            repeat

                                if ChqRecLines."Un pay Code" <> '' then begin


                                    //Cheque Amounts

                                    LineNo := LineNo + 10000;

                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'CHQTRANS';
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                    GenJournalLine."Account No." := ChqRecLines."Account No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Posting Date" := "Transaction Date";
                                    GenJournalLine."External Document No." := ChqRecLines."Cheque Serial No";
                                    GenJournalLine.Description := 'Cheque Issued' + ChqRecLines."Cheque Serial No";
                                    GenJournalLine.Amount := ChqRecLines.Amount * -1;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"Bank Account";
                                    GenJournalLine."Bal. Account No." := "Bank Account";
                                    GenJournalLine."Shortcut Dimension 2 Code" := ChqRecLines."Member Branch";
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;



                                    //Cheque Charges

                                    LineNo := LineNo + 10000;

                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'CHQTRANS';
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                    GenJournalLine."Account No." := ChqRecLines."Account No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Posting Date" := "Transaction Date";
                                    GenJournalLine."External Document No." := ChqRecLines."Cheque Serial No";
                                    GenJournalLine.Description := 'Cheque Issued' + ChqRecLines."Cheque Serial No";
                                    GenJournalLine.Amount := GenSetup."Cheque Processing Fee" * -1;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                                    GenJournalLine."Bal. Account No." := GenSetup."Cheque Processing Fee Account";
                                    GenJournalLine."Shortcut Dimension 2 Code" := ChqRecLines."Member Branch";
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;



                                    //Excise

                                    LineNo := LineNo + 10000;

                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'CHQTRANS';
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                    GenJournalLine."Account No." := ChqRecLines."Account No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Posting Date" := "Transaction Date";
                                    GenJournalLine."External Document No." := ChqRecLines."Cheque Serial No";
                                    GenJournalLine.Description := 'Cheque Issued' + ChqRecLines."Cheque Serial No";
                                    GenJournalLine.Amount := (GenSetup."Cheque Processing Fee" * (GenSetup."Excise Duty(%)" / 100)) * -1;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                                    GenJournalLine."Bal. Account No." := GenSetup."Excise Duty Account";
                                    GenJournalLine."Shortcut Dimension 2 Code" := ChqRecLines."Member Branch";
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                    //Post cheque processing charges
                                    GenSetup.Get();
                                    LineNo := LineNo + 10000;

                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'CHQTRANS';
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                    GenJournalLine."Account No." := ChqRecLines."Account No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Posting Date" := "Transaction Date";
                                    GenJournalLine."External Document No." := ChqRecLines."Cheque Serial No";
                                    GenJournalLine.Description := 'Cheque unpay Commision';
                                    GenJournalLine.Amount := GenSetup."Unpaid Cheques Fee";
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                                    GenJournalLine."Bal. Account No." := GenSetup."Unpaid Cheques Fee Account";
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;

                                    //Excise duty
                                    GenSetup.Get;

                                    LineNo := LineNo + 10000;

                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'CHQTRANS';
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                    GenJournalLine."Account No." := ChqRecLines."Account No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Posting Date" := "Transaction Date";
                                    GenJournalLine."External Document No." := ChqRecLines."Cheque Serial No";
                                    GenJournalLine.Description := 'Excise Duty';
                                    GenJournalLine.Amount := GenSetup."Unpaid Cheques Fee" * (GenSetup."Excise Duty(%)" / 100);
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                                    GenJournalLine."Bal. Account No." := GenSetup."Excise Duty Account";
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                    //ChqRecLines.
                                end;
                            until ChqRecLines.Next = 0;
                        end;


                        //Post New
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'CHQTRANS');
                        if GenJournalLine.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco21", GenJournalLine);
                        end;



                        "Unpaid By" := UserId;
                        Unpaid := true;
                    end;
                end;
            }
            action("Export Unpaid Accounts")
            {
                ApplicationArea = Basic;
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    ChqRecLines.Reset;
                    ChqRecLines.SetRange(ChqRecLines."Chq Receipt No", "No.");
                    //DATAPORT.RUN(50003,TRUE,ChqRecLines);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Created By" := UserId;
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        AccountType: Record "Account Types-Saving Products";
        AvailableBal: Decimal;
        LineNo: Integer;
        EFTDetails: Record "EFT Details";
        STORegister: Record "Investor Posting Group";
        Accounts: Record Vendor;
        EFTHeader: Record "EFT Header Details";
        Transactions: Record "Investor Interest Amounts";
        TextGen: Text[250];
        STO: Record "Standing Orders";
        ReffNo: Code[20];
        Account: Record Vendor;
        SMSMessage: Record Vendor;
        iEntryNo: Integer;
        Vend: Record Vendor;
        ChqRecHeader: Record "Cheque Receipts-Family";
        ChqRecLines: Record "Cheque Issue Lines-Family";
        AccountTypes: Record "Account Types-Saving Products";
        CheqReg: Record "Cheques Register";
        Charges: Record "Interest Rates";
        GenSetup: Record "Sacco General Set-Up";
        objChequeTransactions: Record "Cheque Truncation Buffer";
        ObjChequeFamily: Record "Cheque Receipts-Family";
        FileMgt: Codeunit "File Management";
        objChequeCharges: Record "Cheque Processing Charges";
        ChargeAmount: Decimal;
        SFactory: Codeunit "SURESTEP Factory";
        BATCH_TEMPLATE: Code[100];
        BATCH_NAME: Code[100];
        DOCUMENT_NO: Code[100];

    local procedure FnGetAccountNo(MemberNo: Code[100]) AccountNo: Code[100]
    begin
        Account.Reset;
        Account.SetRange(Account."BOSA Account No", MemberNo);
        Account.SetRange(Account."Account Type", 'ORDINARY');
        if Account.Find('-') then begin
            AccountNo := Account."No.";
        end
    end;

    local procedure FnGetAccountName(MemberNo: Code[100]) AccountName: Text[250]
    begin
        Account.Reset;
        Account.SetRange(Account."BOSA Account No", MemberNo);
        Account.SetRange(Account."Account Type", 'ORDINARY');
        if Account.Find('-') then begin
            AccountName := Account.Name;
        end
    end;


    procedure Balance(Acc: Code[30]; Vendor: Record Vendor) Bal: Decimal
    begin
        if Vendor.Get(Acc) then begin
            Vendor.CalcFields(Vendor."Balance (LCY)", Vendor."ATM Transactions", Vendor."Uncleared Cheques");
            Bal := Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions");
        end
    end;

    local procedure FnGetAccountBalance(MemberNo: Code[100]) AccountBalance: Decimal
    begin
        Account.Reset;
        Account.SetRange(Account."BOSA Account No", MemberNo);
        Account.SetRange(Account."Account Type", 'ORDINARY');
        if Account.Find('-') then begin
            AccountBalance := Balance(Account."No.", Account);
        end
    end;
}

