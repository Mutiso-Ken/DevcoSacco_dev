#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516000 "Funds Management"
{

    trigger OnRun()
    begin
    end;

    var
        TaxCodes: Record "Funds Tax Codes";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        DocPrint: Codeunit "Document-Print";
        DActivity: Code[10];
        DBranch: Code[50];


    procedure PostPayment("Payment Header": Record "Payment Header"; "Journal Template": Code[20]; "Journal Batch": Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        PaymentLine: Record "Payment Line";
        PaymentHeader: Record "Payment Header";
        SourceCode: Code[20];
        BankLedgers: Record "Bank Account Ledger Entry";
        PaymentLine2: Record "Payment Line";
        PaymentHeader2: Record "Payment Header";
    begin
        //Check if Document Already Posted
        BankLedgers.Reset;
        BankLedgers.SetRange(BankLedgers."Document No.", "Payment Header"."No.");
        if BankLedgers.FindFirst then
            Error('Document No:' + Format("Payment Header"."No.") + ' already exists in Bank No:' + Format("Payment Header"."Bank Account"));
        //end check

        PaymentHeader.TransferFields("Payment Header", true);
        SourceCode := 'PAYMENTJNL';

        //Delete Journal Lines if Exist
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", "Journal Batch");
        if GenJnlLine.FindSet then begin
            GenJnlLine.DeleteAll;
        end;
        //End Delete

        LineNo := 1000;
        //********************************************Add to Bank(Payment Header)*******************************************************//
        PaymentHeader.CalcFields(PaymentHeader."Net Amount");
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
       
        // if CustomerLinesExist(PaymentHeader) then
        //     GenJnlLine."Document Type" := GenJnlLine."document type"::" "
        // else
        //     GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine."Document No." := PaymentHeader."No.";
        GenJnlLine."External Document No." := PaymentHeader."Cheque No";
        GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";
        GenJnlLine."Account No." := PaymentHeader."Bank Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
        GenJnlLine.Validate(GenJnlLine."Currency Code");
        // GenJnlLine."Transaction Type":=
        GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        GenJnlLine.Amount := -(PaymentHeader."Net Amount");  //Credit Amount
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
        GenJnlLine.ValidateShortcutDimCode(7, PaymentHeader."Shortcut Dimension 7 Code");
        GenJnlLine.ValidateShortcutDimCode(8, PaymentHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := CopyStr(PaymentHeader."Payment Description", 1, 50);
        GenJnlLine.Validate(GenJnlLine.Description);
        // if PaymentHeader."Payment Mode" <> PaymentHeader."payment mode"::Cheque then begin
        //     GenJnlLine."Bank Payment Type" := GenJnlLine."bank payment type"::" "
        // end else begin
        //     if PaymentHeader."Cheque Type" = PaymentHeader."cheque type"::"Computer Cheque" then
        //         GenJnlLine."Bank Payment Type" := GenJnlLine."bank payment type"::"Computer Check"
        //     else
        //         GenJnlLine."Bank Payment Type" := GenJnlLine."bank payment type"::" "
        // end;
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;
        //************************************************End Add to Bank***************************************************************//

        //***********************************************Add Payment Lines**************************************************************//
        PaymentLine.Reset;
        PaymentLine.SetRange(PaymentLine."Document No", PaymentHeader."No.");
        PaymentLine.SetFilter(PaymentLine.Amount, '<>%1', 0);
        if PaymentLine.FindSet then begin
            repeat
                //****************************************Add Line NetAmounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                GenJnlLine."Document No." := PaymentLine."Document No";
                     
                GenJnlLine."Posting Group" := PaymentLine."Default Grouping";    //Posting Group
                // if CustomerLinesExist(PaymentHeader) then
                //     GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                // else
                //     GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                GenJnlLine."Account Type" := PaymentLine."Account Type";
                GenJnlLine."Account No." := PaymentLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := PaymentHeader."Cheque No";
                GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                GenJnlLine.Validate("Currency Code");
                GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";
                GenJnlLine.Validate("Currency Factor");
                GenJnlLine.Amount := PaymentLine."Net Amount";  //Debit Amount
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Transaction Type" := PaymentLine."Transaction Type";
                GenJnlLine."Loan No" := PaymentLine."Loan No.";
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Gen. Bus. Posting Group" := PaymentLine."Gen. Bus. Posting Group";
                GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group" := PaymentLine."Gen. Prod. Posting Group";
                GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group" := PaymentLine."VAT Bus. Posting Group";
                GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group" := PaymentLine."VAT Prod. Posting Group";
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine."Shortcut Dimension 1 Code" := PaymentLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Global Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                GenJnlLine.ValidateShortcutDimCode(7, PaymentHeader."Shortcut Dimension 7 Code");
                GenJnlLine.ValidateShortcutDimCode(8, PaymentHeader."Shortcut Dimension 8 Code");
                GenJnlLine.Description := PaymentLine."Payment Description";//COPYSTR(PaymentHeader."Payment Description",1,50);
                                                                            //GenJnlLine.VALIDATE(GenJnlLine.Description);
                // GenJnlLine."Applies-to Doc. Type" := GenJnlLine."applies-to doc. type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";

                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert;
                //*************************************End add Line NetAmounts**********************************************************//

                //****************************************Add VAT Amounts***************************************************************//
                if PaymentLine."VAT Code" <> '' then begin
                    TaxCodes.Reset;
                    TaxCodes.SetRange(TaxCodes."Tax Code", PaymentLine."VAT Code");
                    if TaxCodes.FindFirst then begin
                        TaxCodes.TestField(TaxCodes."Account No");
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        // if CustomerLinesExist(PaymentHeader) then
                        //     GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                        // else
                        //     GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                        GenJnlLine."Document No." := PaymentLine."Document No";
                        //GenJnlLine."Posting Group":=PaymentLine."Default Grouping";    //Posting Group
                        GenJnlLine."External Document No." := PaymentHeader."Cheque No";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine."Loan No" := PaymentLine."Loan No.";
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount := -(PaymentLine."VAT Amount");   //Credit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Transaction Type" := PaymentLine."Transaction Type";
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentLine."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, PaymentHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('VAT:' + Format(PaymentLine."Account Type") + '::' + Format(PaymentLine."Account Name"), 1, 50);
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                        //VAT Balancing goes to Vendor
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        // if CustomerLinesExist(PaymentHeader) then
                        //     GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                        // else
                        //     GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                        GenJnlLine."Document No." := PaymentLine."Document No";
                        GenJnlLine."Posting Group" := PaymentLine."Default Grouping";    //Posting Group
                        GenJnlLine."External Document No." := PaymentHeader."Cheque No";
                        GenJnlLine."Account Type" := PaymentLine."Account Type";
                        GenJnlLine."Account No." := PaymentLine."Account No.";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Transaction Type" := PaymentLine."Transaction Type";
                        GenJnlLine."Loan No" := PaymentLine."Loan No.";
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine.Amount := PaymentLine."VAT Amount";   //Debit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentLine."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, PaymentHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('VAT:' + Format(PaymentLine."Account Type") + '::' + Format(PaymentLine."Account Name"), 1, 50);
                        // GenJnlLine."Applies-to Doc. Type" := GenJnlLine."applies-to doc. type"::Invoice;
                        GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                    end;
                end;
                //*************************************End Add VAT Amounts**************************************************************//

                //****************************************Add W/TAX Amounts*************************************************************//
                if PaymentLine."W/TAX Code" <> '' then begin
                    TaxCodes.Reset;
                    TaxCodes.SetRange(TaxCodes."Tax Code", PaymentLine."W/TAX Code");
                    if TaxCodes.FindFirst then begin
                        TaxCodes.TestField(TaxCodes."Account No");
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        // if CustomerLinesExist(PaymentHeader) then
                        //     GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                        // else
                        //     GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                        GenJnlLine."Document No." := PaymentLine."Document No";
                        //GenJnlLine."Posting Group":=PaymentLine."Default Grouping";    //Posting Group
                        GenJnlLine."External Document No." := PaymentHeader."Cheque No";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Loan No" := PaymentLine."Loan No.";
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount := -(PaymentLine."W/TAX Amount");   //Credit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentLine."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, PaymentHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('W/TAX:' + Format(PaymentLine."Account Type") + '::' + Format(PaymentLine."Account Name"), 1, 50);
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                        //W/TAX Balancing goes to Vendor
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        // if CustomerLinesExist(PaymentHeader) then
                        //     GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                        // else
                        //     GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                        GenJnlLine."Document No." := PaymentLine."Document No";
                        GenJnlLine."Posting Group" := PaymentLine."Default Grouping";    //Posting Group
                        GenJnlLine."External Document No." := PaymentHeader."Cheque No";
                        GenJnlLine."Account Type" := PaymentLine."Account Type";
                        GenJnlLine."Loan No" := PaymentLine."Loan No.";
                        GenJnlLine."Account No." := PaymentLine."Account No.";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine.Amount := PaymentLine."W/TAX Amount";   //Debit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Transaction Type" := PaymentLine."Transaction Type";
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentLine."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, PaymentHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('W/TAX:' + Format(PaymentLine."Account Type") + '::' + Format(PaymentLine."Account Name"), 1, 50);
                        // GenJnlLine."Applies-to Doc. Type" := GenJnlLine."applies-to doc. type"::Invoice;
                        // GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                        // GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                        // GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                    end;
                end;

            //*************************************End Add W/TAX Amounts************************************************************//

            //*************************************Add Retention Amounts************************************************************//
            //***********************************End Add Retention Amounts**********************************************************//
            until PaymentLine.Next = 0;
        end;

        //*********************************************End Add Payment Lines************************************************************//
        Commit;
        //********************************************Post the Journal Lines************************************************************//
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", "Journal Batch");
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        AdjustGenJnl.Run(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances


        //Before posting if its computer cheque,print the cheque
        // if (PaymentHeader."Payment Mode" = PaymentHeader."payment mode"::Cheque) and
        // (PaymentHeader."Cheque Type" = PaymentHeader."cheque type"::"Computer Cheque") then begin
            // DocPrint.PrintCheck(GenJnlLine);
            // Codeunit.Run(Codeunit::"Adjust Gen. Journal Balance", GenJnlLine);
        // end;
        //Now Post the Journal Lines
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
        //***************************************************End Posting****************************************************************//
        Commit;
        //*************************************************Update Document**************************************************************//
        BankLedgers.Reset;
        BankLedgers.SetRange(BankLedgers."Document No.", PaymentHeader."No.");
        if BankLedgers.FindFirst then begin
            PaymentHeader2.Reset;
            PaymentHeader2.SetRange(PaymentHeader2."No.", PaymentHeader."No.");
            if PaymentHeader2.FindFirst then begin
                PaymentHeader2.Status := PaymentHeader2.Status::Posted;
                PaymentHeader2.Posted := true;
                PaymentHeader2."Posted By" := UserId;
                PaymentHeader2."Date Posted" := Today;
                PaymentHeader2."Time Posted" := Time;
                PaymentHeader2.Modify;
                PaymentLine2.Reset;
                PaymentLine2.SetRange(PaymentLine2."Document No", PaymentHeader2."No.");
                if PaymentLine2.FindSet then begin
                    repeat
                        PaymentLine2.Status := PaymentLine2.Status::Posted;
                        PaymentLine2.Posted := true;
                        PaymentLine2."Posted By" := UserId;
                        PaymentLine2."Date Posted" := Today;
                        PaymentLine2."Time Posted" := Time;
                        PaymentLine2.Modify;
                    until PaymentLine2.Next = 0;
                end;
            end;
        end;

        //***********************************************End Update Document************************************************************//

    end;


    procedure PostReceipt("Receipt Header": Record "Receipt Header"; "Journal Template": Code[20]; "Journal Batch": Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        ReceiptLine: Record "Receipt Line";
        ReceiptHeader: Record "Receipt Header";
        SourceCode: Code[20];
        BankLedgers: Record "Bank Account Ledger Entry";
        ReceiptLine2: Record "Receipt Line";
        ReceiptHeader2: Record "Receipt Header";
    begin
        ReceiptHeader.TransferFields("Receipt Header", true);
        SourceCode := 'RECEIPTJNL';

        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", "Journal Batch");
        if GenJnlLine.FindSet then begin
            GenJnlLine.DeleteAll;
        end;
        //End Delete

        LineNo := 1000;
        //********************************************Add to Bank(Payment Header)*******************************************************//
        ReceiptHeader.CalcFields(ReceiptHeader."Total Amount");
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
        //IF CustomerLinesExist(ReceiptHeader) THEN
        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
        //ELSE
        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := ReceiptHeader."No.";
        GenJnlLine."Document Type" := GenJnlLine."document type"::" ";
        GenJnlLine."External Document No." := ReceiptHeader."Cheque No";
        GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";
        GenJnlLine."Account No." := ReceiptHeader."Bank Code";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
        GenJnlLine.Validate(GenJnlLine."Currency Code");
        GenJnlLine."Currency Factor" := ReceiptHeader."Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        GenJnlLine.Amount := ReceiptHeader."Total Amount";  //Debit Amount
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
        GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
        GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := CopyStr(ReceiptHeader.Description, 1, 50);
        GenJnlLine.Validate(GenJnlLine.Description);
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;
        //************************************************End Add to Bank***************************************************************//

        //***********************************************Add Receipt Lines**************************************************************//
        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine."Document No", ReceiptHeader."No.");
        ReceiptLine.SetFilter(ReceiptLine.Amount, '<>%1', 0);
        if ReceiptLine.FindSet then begin
            repeat
                //****************************************Add Line NetAmounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                GenJnlLine."Document No." := ReceiptLine."Document No";
                GenJnlLine."Document Type" := GenJnlLine."document type"::" ";
                GenJnlLine."Account Type" := ReceiptLine."Account Type";
                GenJnlLine."Account No." := ReceiptLine."Account Code";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := ReceiptHeader."Cheque No";
                GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                GenJnlLine.Validate("Currency Code");
                GenJnlLine."Currency Factor" := ReceiptHeader."Currency Factor";
                GenJnlLine.Validate("Currency Factor");
                GenJnlLine.Amount := -(ReceiptLine.Amount);  //Credit Amount
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Gen. Bus. Posting Group" := ReceiptLine."Gen. Bus. Posting Group";
                GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group" := ReceiptLine."Gen. Prod. Posting Group";
                GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group" := ReceiptLine."VAT Bus. Posting Group";
                GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group" := ReceiptLine."VAT Prod. Posting Group";
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                GenJnlLine.Description := ReceiptLine.Description;//COPYSTR(ReceiptHeader.Description,1,50);
                GenJnlLine.Validate(GenJnlLine.Description);
                // GenJnlLine."Interest Code" := ReceiptHeader."Interest Code";
                /*GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID"; */

                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert;
                //*************************************End add Line NetAmounts**********************************************************//

                //****************************************Add VAT Amounts***************************************************************//
                if ReceiptLine."VAT Code" <> '' then begin
                    TaxCodes.Reset;
                    TaxCodes.SetRange(TaxCodes."Tax Code", ReceiptLine."VAT Code");
                    if TaxCodes.FindFirst then begin
                        TaxCodes.TestField(TaxCodes."Account No");
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        GenJnlLine."Document No." := ReceiptLine."Document No";
                        // GenJnlLine."Document Type":=GenJnlLine."document type"::"7";
                        GenJnlLine."External Document No." := ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := ReceiptHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount := -(ReceiptLine."VAT Amount");   //Credit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('VAT:' + Format(ReceiptLine."Account Type") + '::' + Format(ReceiptLine."Account Name"), 1, 50);
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                        //VAT Balancing goes to Vendor
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        GenJnlLine."Document No." := ReceiptLine."Document No";
                        // GenJnlLine."Document Type":=GenJnlLine."document type"::"7";
                        GenJnlLine."External Document No." := ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type" := ReceiptLine."Account Type";
                        GenJnlLine."Account No." := ReceiptLine."Account Code";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := ReceiptHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine.Amount := ReceiptLine."VAT Amount";   //Debit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('VAT:' + Format(ReceiptLine."Account Type") + '::' + Format(ReceiptLine."Account Name"), 1, 50);
                        GenJnlLine."Interest Code" := ReceiptHeader."Interest Code";
                        /*GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID";*/
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                    end;
                end;
                //*************************************End Add VAT Amounts**************************************************************//

                //****************************************Add W/TAX Amounts*************************************************************//
                if ReceiptLine."W/TAX Code" <> '' then begin
                    TaxCodes.Reset;
                    TaxCodes.SetRange(TaxCodes."Tax Code", ReceiptLine."W/TAX Code");
                    if TaxCodes.FindFirst then begin
                        TaxCodes.TestField(TaxCodes."Account No");
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        GenJnlLine."Document No." := ReceiptLine."Document No";
                        //GenJnlLine."Document Type":=GenJnlLine."document type"::"7";
                        GenJnlLine."External Document No." := ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := ReceiptHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount := -(ReceiptLine."W/TAX Amount");   //Credit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('W/TAX:' + Format(ReceiptLine."Account Type") + '::' + Format(ReceiptLine."Account Name"), 1, 50);
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                        //W/TAX Balancing goes to Vendor
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        GenJnlLine."Document No." := ReceiptLine."Document No";
                        // GenJnlLine."Document Type":=GenJnlLine."document type"::"7";
                        GenJnlLine."External Document No." := ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type" := ReceiptLine."Account Type";
                        GenJnlLine."Account No." := ReceiptLine."Account Code";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := ReceiptHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine.Amount := ReceiptLine."W/TAX Amount";   //Debit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('W/TAX:' + Format(ReceiptLine."Account Type") + '::' + Format(ReceiptLine."Account Name"), 1, 50);
                        GenJnlLine."Interest Code" := ReceiptHeader."Interest Code";
                        /*GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID";*/
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                    end;
                end;

                //*************************************End Add W/TAX Amounts************************************************************//

                //*************************************Add Retention Amounts************************************************************//
                //***********************************End Add Retention Amounts**********************************************************//

                //****************************************Add Legal Amounts***************************************************************//
                if ReceiptLine."Legal Fee Code" <> '' then begin
                    ReceiptLine.TestField(ReceiptLine."Account Type", ReceiptLine."account type"::Investor);//Applies to investor Accounts only
                    TaxCodes.Reset;
                    TaxCodes.SetRange(TaxCodes."Tax Code", ReceiptLine."Legal Fee Code");
                    if TaxCodes.FindFirst then begin
                        TaxCodes.TestField(TaxCodes."Account No");
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        //IF CustomerLinesExist(ReceiptHeader) THEN
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        //ELSE
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No." := ReceiptLine."Document No";
                        GenJnlLine."External Document No." := ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := ReceiptHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        ReceiptLine.TestField(ReceiptLine."Legal Fee Amount");
                        GenJnlLine.Amount := -(ReceiptLine."Legal Fee Amount");   //Credit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('LEGAL FEE:' + Format(ReceiptLine."Account Type") + '::' + Format(ReceiptLine."Account Name"), 1, 50);
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                        //Legal Balancing goes to Investor
                        LineNo := LineNo + 1;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        //IF CustomerLinesExist(ReceiptHeader) THEN
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        //ELSE
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No." := ReceiptLine."Document No";
                        GenJnlLine."External Document No." := ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type" := ReceiptLine."Account Type";
                        GenJnlLine."Account No." := ReceiptLine."Account Code";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := ReceiptHeader."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");
                        GenJnlLine.Amount := ReceiptLine."Legal Fee Amount";   //Debit Amount
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := CopyStr('LEGAL FEE:' + Format(ReceiptLine."Account Type") + '::' + Format(ReceiptLine."Account Name"), 1, 50);
                        GenJnlLine."Interest Code" := ReceiptHeader."Interest Code";
                        /*GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID";*/
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;

                    end;
                end;
            //*************************************End Add Legal Amounts**************************************************************//

            until ReceiptLine.Next = 0;
        end;

        //*********************************************End Add Payment Lines************************************************************//
        Commit;
        //********************************************Post the Journal Lines************************************************************//
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", "Journal Batch");
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        AdjustGenJnl.Run(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances

        //Now Post the Journal Lines
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
        //***************************************************End Posting****************************************************************//
        Commit;
        //*************************************************Update Document**************************************************************//
        BankLedgers.Reset;
        BankLedgers.SetRange(BankLedgers."Document No.", ReceiptHeader."No.");
        if BankLedgers.FindFirst then begin
            ReceiptHeader2.Reset;
            ReceiptHeader2.SetRange(ReceiptHeader2."No.", ReceiptHeader."No.");
            if ReceiptHeader2.FindFirst then begin
                ReceiptHeader2.Status := ReceiptHeader2.Status::Posted;
                ReceiptHeader2.Posted := true;
                ReceiptHeader2."Posted By" := UserId;
                ReceiptHeader2."Date Posted" := Today;
                ReceiptHeader2."Time Posted" := Time;
                ReceiptHeader2.Modify;
                ReceiptLine2.Reset;
                ReceiptLine2.SetRange(ReceiptLine2."Document No", ReceiptHeader2."No.");
                if ReceiptLine2.FindSet then begin
                    repeat
                        ReceiptLine2.Status := ReceiptLine2.Status::Posted;
                        ReceiptLine2.Posted := true;
                        ReceiptLine2."Posted By" := UserId;
                        ReceiptLine2."User ID" := UserId;
                        ReceiptLine2."Date Posted" := Today;
                        ReceiptLine2."Time Posted" := Time;
                        ReceiptLine2.Modify;
                    until ReceiptLine2.Next = 0;
                end;
            end;
        end;

        //***********************************************End Update Document************************************************************//

    end;


    procedure PostInvestorReceipt("Receipt Header": Record "Receipt Header"; "Journal Template": Code[20]; "Journal Batch": Code[20]): Boolean
    var
        ReceiptLine: Record "Receipt Line";
        ReceiptHeader: Record "Receipt Header";
        ReceiptLine2: Record "Receipt Line";
        ReceiptHeader2: Record "Receipt Header";
    begin
        //Post the Receipt
        PostReceipt("Receipt Header", "Journal Template", "Journal Batch");
        Commit;
        //Update investor Amounts
        ReceiptHeader.Reset;
        ReceiptHeader.SetRange(ReceiptHeader."No.", "Receipt Header"."No.");
        ReceiptHeader.SetRange(ReceiptHeader.Posted, true);
        if ReceiptHeader.FindFirst then begin
            ReceiptHeader.CalcFields(ReceiptHeader."Investor Net Amount", ReceiptHeader."Investor Net Amount(LCY)");
            InsertInvestorLedger(ReceiptHeader."Investor No.", ReceiptHeader."Interest Code",
            ReceiptHeader."Investor Net Amount", ReceiptHeader."Investor Net Amount(LCY)", ReceiptHeader."No.", ReceiptHeader."Posting Date");
            ReceiptLine.Reset;
            ReceiptLine.SetRange(ReceiptLine."Document No", ReceiptHeader."No.");
            if ReceiptLine.FindSet then begin
                repeat
                    if (ReceiptLine."Account Type" = ReceiptLine."account type"::Investor) and (ReceiptLine."Account Code" <> '') then
                        UpdateInvestorAmounts(ReceiptLine."Account Code", ReceiptHeader."Interest Code", ReceiptHeader."Posting Date",
                                              ReceiptHeader."Investor Net Amount", ReceiptHeader."Investor Net Amount(LCY)");
                until ReceiptLine.Next = 0;
            end;
            exit(true);
        end else begin
            exit(false);
        end;
    end;


    procedure PostPropertyReceipt("Receipt Header": Record "Receipt Header"; "Journal Template": Code[20]; "Journal Batch": Code[20]; "Property No": Code[20]; Receipt: Code[20]; Cust: Code[20]; CustName: Text[50]; Amount: Decimal): Boolean
    var
        ReceiptLine: Record "Receipt Line";
        ReceiptHeader: Record "Receipt Header";
        ReceiptLine2: Record "Receipt Line";
        ReceiptHeader2: Record "Receipt Header";
    begin
        //Post the Receipt
        PostReceipt("Receipt Header", "Journal Template", "Journal Batch");
        Commit;
        //Update Property
        if UpdateProperty("Property No", Receipt, Cust, CustName, Amount) then begin
            exit(true);
        end else begin
            exit(false);
        end;
    end;


    procedure PostFundsTransfer()
    begin
    end;


    procedure PostImprest()
    begin
    end;


    procedure PostImprestAccounting()
    begin
    end;


    procedure PostFundsClaim()
    begin
    end;

    local procedure CustomerLinesExist("Payment Header": Record "Payment Header"): Boolean
    var
        "Payment Line": Record "Payment Line";
        "Payment Line2": Record "Payment Line";
    begin
        "Payment Line".Reset;
        "Payment Line".SetRange("Payment Line"."Document No", "Payment Header"."No.");
        if "Payment Line".FindFirst then begin
            if "Payment Line"."Account Type" = "Payment Line"."account type"::Customer then begin
                exit(true);
            end else begin
                "Payment Line2".Reset;
                "Payment Line2".SetRange("Payment Line2"."Document No", "Payment Header"."No.");
                "Payment Line2".SetFilter("Payment Line2"."Net Amount", '<%1', 0);
                if "Payment Line2".FindFirst then
                    exit(true)
                else
                    exit(false)
            end;
        end;
    end;

    local procedure UpdateInvestorAmounts("Investor No": Code[20]; "Interest Code": Code[50]; "Posting Date": Date; Amount: Decimal; "Amount(LCY)": Decimal)
    var
        InvestorAmounts: Record "Investor Amounts";
        InvestorAmounts2: Record "Investor Amounts";
    begin
        InvestorAmounts.Reset;
        InvestorAmounts.SetRange(InvestorAmounts."Investor No", "Investor No");
        InvestorAmounts.SetRange(InvestorAmounts."Interest Code", "Interest Code");
        InvestorAmounts.SetRange(InvestorAmounts."Investment Date", "Posting Date");
        if InvestorAmounts.FindFirst = false then begin
            InvestorAmounts2.Reset;
            InvestorAmounts2."Investor No" := "Investor No";
            InvestorAmounts2."Interest Code" := "Interest Code";
            InvestorAmounts2."Investment Date" := "Posting Date";
            InvestorAmounts2.Amount := Amount;
            InvestorAmounts2."Amount(LCY)" := "Amount(LCY)";
            InvestorAmounts2.Description := 'Investor Topup,Interest Rate:' + Format("Interest Code");
            InvestorAmounts2."Last Update Date" := Today;
            InvestorAmounts2."Last Update Time" := Time;
            InvestorAmounts2."Last Update User" := UserId;
            InvestorAmounts2.Insert;
        end else begin
            InvestorAmounts.Amount := InvestorAmounts.Amount + Amount;
            InvestorAmounts."Amount(LCY)" := InvestorAmounts."Amount(LCY)" + "Amount(LCY)";
            InvestorAmounts."Last Update Date" := Today;
            InvestorAmounts."Last Update Time" := Time;
            InvestorAmounts."Last Update User" := UserId;
            InvestorAmounts.Modify;
        end;
    end;

    local procedure InsertInvestorLedger(InvestorNo: Code[20]; InterestCode: Code[20]; Amount: Decimal; "Amount(LCY)": Decimal; ReceiptNo: Code[20]; PostingDate: Date)
    var
        InvestorLedger: Record "Investor Amounts Ledger";
    begin
        InvestorLedger.Reset;
        InvestorLedger."Investor No" := InvestorNo;
        InvestorLedger."Principle Amount" := Amount;
        InvestorLedger."Principle Amount(LCY)" := "Amount(LCY)";
        InvestorLedger.Date := PostingDate;
        InvestorLedger.Day := Date2dmy(PostingDate, 1);
        InvestorLedger.Month := Date2dmy(PostingDate, 2);
        InvestorLedger.Year := Date2dmy(PostingDate, 3);
        InvestorLedger."Receipt No" := ReceiptNo;
        InvestorLedger."Interest Rate" := InterestCode;
        InvestorLedger.Insert;
    end;

    local procedure UpdateProperty(PropertyCode: Code[20]; "Receipt No": Code[20]; "Customer No": Code[20]; "Customer Name": Text[50]; Amount: Decimal): Boolean
    var
        FA: Record "Fixed Asset";
    begin
        FA.Reset;
        FA.SetRange(FA."No.", PropertyCode);
        if FA.FindFirst then begin
            FA.Receipted := true;
            FA."Receipt No" := "Receipt No";
            FA."Customer No" := "Customer No";
            FA."Customer Name" := "Customer Name";
            FA."Customer Balance" := FA."Customer Balance" - Amount;
            if FA.Modify then begin
                Message('Property Payment Successfull. Customer:' + Format("Customer Name"));
                exit(true);
            end else begin
                exit(false);
            end;
        end;
    end;


    procedure CommitPurchase(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        Commitments: Record "Budget Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "G/L Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        dimSetEntry: Record "Dimension Set Entry";
    begin
        //First Update Analysis View
        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        /*BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (PurchHeader."Document Date"< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (PurchHeader."Document Date">BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
            //Get Commitment Lines
                 IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PurchLine.RESET;
              PurchLine.SETRANGE(PurchLine."Document Type",PurchHeader."Document Type");
              PurchLine.SETRANGE(PurchLine."Document No.",PurchHeader."No.");
              IF PurchLine.FINDFIRST THEN
                BEGIN
                  REPEAT
        
                 //Get the Dimension Here
                   IF PurchLine."Line No." <> 0 THEN
                        DimMgt.ShowDocDim(
                          DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Dimension Set ID",
                          PurchLine."Line No.",ShortcutDimCode)
                      ELSE
                       DimMgt.ShowTempDim(ShortcutDimCode);
                 //Had to be put here for the sake of Calculating Individual Line Entries
        
                    //check the type of account in the payments line
                    //Item
                      IF PurchLine.Type=PurchLine.Type::Item THEN BEGIN
                          Item.RESET;
                          IF NOT Item.GET(PurchLine."No.") THEN
                             ERROR('Item Does not Exist');
        
                          Item.TESTFIELD("Item G/L Budget Account");
                          BudgetGL:=Item."Item G/L Budget Account";
                       END;
                      //  MESSAGE('FOUND');
                       IF PurchLine.Type=PurchLine.Type::"Fixed Asset" THEN BEGIN
                               FixedAssetsDet.RESET;
                               FixedAssetsDet.SETRANGE(FixedAssetsDet."No.",PurchLine."No.");
                                 IF FixedAssetsDet.FIND('-') THEN BEGIN
                                 FixedAssetsDet.CALCFIELDS(FixedAssetsDet."FA Posting Group");
                                     FAPostingGRP.RESET;
                                     FAPostingGRP.SETRANGE(FAPostingGRP.Code,FixedAssetsDet."FA Posting Group");
                                     IF FAPostingGRP.FIND('-') THEN
                                       IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::Maintenance THEN
                                        BEGIN
                                           BudgetGL:=FAPostingGRP."Maintenance Expense Account";
                                             IF BudgetGL ='' THEN
                                               ERROR('Ensure Fixed Asset No %1 has the Maintenance G/L Account',PurchLine."No.");
                                       END ELSE BEGIN
                                           BudgetGL:=FAPostingGRP."Acquisition Cost Account";
                                              IF BudgetGL ='' THEN
                                                 ERROR('Ensure Fixed Asset No %1 has the Acquisition G/L Account',PurchLine."No.");
                                        END;
                                 END;
                       END;
        
                       IF PurchLine.Type=PurchLine.Type::"G/L Account" THEN BEGIN
                          BudgetGL:=PurchLine."No.";
                          IF GLAcc.GET(PurchLine."No.") THEN
                             GLAcc.TESTFIELD(GLAcc."Budget Controlled",TRUE);
                       END;
        
                    //End Checking Account in Payment Line
        
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(PurchHeader."Document Date",2),DATE2DMY(PurchHeader."Document Date",3));
                               CurrMonth:=DATE2DMY(PurchHeader."Document Date",2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(PurchHeader."Document Date",3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PurchHeader."Document Date",3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETFILTER(Budget.Date,'%1..%2',BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Global Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                              // IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                               Budget.SETRANGE(Budget."Global Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Budget Dimension 1 Code",ShortcutDimCode[3]);
                               Budget.SETRANGE(Budget."Budget Dimension 2 Code",ShortcutDimCode[4]);
                                 IF Budget.FIND('-') THEN BEGIN
                                 REPEAT
                                  BudgetAmount:=BudgetAmount+Budget.Amount;
                                 UNTIL Budget.NEXT=0;
                                 END;
        
                                   {
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            "G/L Entry".RESET;
                            "G/L Entry".SETRANGE("G/L Entry"."G/L Account No.",BudgetGL);
                            "G/L Entry".SETRANGE("G/L Entry"."Posting Date",BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                            "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                            IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                            "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                            IF "G/L Entry".FIND('-') THEN BEGIN
                            REPEAT
                            ActualsAmount:=ActualsAmount+"G/L Entry".Amount;
                            UNTIL "G/L Entry".NEXT=0;
                            END;
                           // error(format(ActualsAmount));
                                  }
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                           // IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::Global THEN
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",ShortcutDimCode[3]);
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",ShortcutDimCode[4]);
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
        //                    IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
                           //check if there is any budget
                           IF (BudgetAmount<=0) THEN
                            BEGIN
                              ERROR('No Budget To Check Against');
                            END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")>BudgetAmount) AND
                           (BCSetup."Allow OverExpenditure"=FALSE) THEN
                            BEGIN
                              ERROR('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                              PurchLine."Document No.",PurchLine.Type ,PurchLine."No.",
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)"))));
                            END ELSE BEGIN
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=PurchHeader."Document Date";
                                IF PurchHeader.DocApprovalType=PurchHeader.DocApprovalType::Purchase THEN
                                    Commitments."Document Type":=Commitments."Document Type"::LPO
                                ELSE
                                    Commitments."Document Type":=Commitments."Document Type"::Requisition;
        
                                IF PurchHeader."Document Type"=PurchHeader."Document Type"::Invoice THEN
                                    Commitments."Document Type":=Commitments."Document Type"::PurchInvoice;
        
                                Commitments."Document No.":=PurchHeader."No.";
                                Commitments.Amount:=PurchLine."Outstanding Amount (LCY)";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=PurchHeader."Document Date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
                                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PurchLine."Shortcut Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PurchLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=ShortcutDimCode[3];
                                Commitments."Shortcut Dimension 4 Code":=ShortcutDimCode[4];
                                Commitments.Committed:=TRUE;
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=Commitments.Type::Vendor;
                                Commitments."Vendor/Cust No.":=PurchHeader."Buy-from Vendor No.";
                                Commitments.INSERT;
                                //Tag the Purchase Line as Committed
                                  PurchLine.Committed:=TRUE;
                                  PurchLine.MODIFY;
                                //End Tagging PurchLines as Committed
                            END;
        
                  UNTIL PurchLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
          {****III
        //  error(format(BudgetAmount));
        PurchHeader.RESET;
        PurchHeader.SETRANGE(PurchHeader."No.",PurchLine."Document No.");
        IF PurchHeader.FIND('-') THEN BEGIN
        PurchHeader."Budgeted Amount":=BudgetAmount;
        PurchHeader."Actual Expenditure":=ActualsAmount;
        PurchHeader."Committed Amount":=CommitmentAmount;
        PurchHeader."Budget Balance":=BudgetAmount-(ActualsAmount+CommitmentAmount+PurchHeader."Order Amount");
        PurchHeader.MODIFY;
        END;
                  ********III}
        
        
        {****************************************************************
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (PurchHeader."Document Date"< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (PurchHeader."Document Date">BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
            //Get Commitment Lines
                 IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PurchLine.RESET;
              PurchLine.SETRANGE(PurchLine."Document Type",PurchHeader."Document Type");
              PurchLine.SETRANGE(PurchLine."Document No.",PurchHeader."No.");
              IF PurchLine.FINDFIRST THEN
                BEGIN
                  REPEAT
        
                 //Get the Dimension Here
                   IF PurchLine."Line No." <> 0 THEN
                       DimMgt.GetShortcutDimensions(PurchLine."Dimension Set ID",ShortcutDimCode);
        
                    //    DimMgt.ShowDocDim(
                     //     DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",
                    //      PurchLine."Line No.",ShortcutDimCode)
                    //  ELSE
                    //    DimMgt.ClearDimSetFilter(ShortcutDimCode);
                 //Had to be put here for the sake of Calculating Individual Line Entries
        
                    //check the type of account in the payments line
                  //Item
                      IF PurchLine.Type=PurchLine.Type::Item THEN BEGIN
                          Item.RESET;
                          IF NOT Item.GET(PurchLine."No.") THEN
                             ERROR('Item Does not Exist');
        
                          Item.TESTFIELD("Item G/L Budget Account");
                          BudgetGL:=Item."Item G/L Budget Account";
                       END;
        
                       IF PurchLine.Type=PurchLine.Type::"Fixed Asset" THEN BEGIN
                               FixedAssetsDet.RESET;
                               FixedAssetsDet.SETRANGE(FixedAssetsDet."No.",PurchLine."No.");
                                 IF FixedAssetsDet.FIND('-') THEN BEGIN
                                     FAPostingGRP.RESET;
                                     FAPostingGRP.SETRANGE(FAPostingGRP.Code,FixedAssetsDet."FA Posting Group");
                                     IF FAPostingGRP.FIND('-') THEN
                                       IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::Maintenance THEN
                                        BEGIN
                                           BudgetGL:=FAPostingGRP."Maintenance Expense Account";
                                             IF BudgetGL ='' THEN
                                               ERROR('Ensure Fixed Asset No %1 has the Maintenance G/L Account',PurchLine."No.");
                                       END ELSE BEGIN
                                         IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"Acquisition Cost" THEN BEGIN
                                           BudgetGL:=FAPostingGRP."Acquisition Cost Account";
                                              IF BudgetGL ='' THEN
                                                 ERROR('Ensure Fixed Asset No %1 has the Acquisition G/L Account',PurchLine."No.");
                                         END;
                                         //To Accomodate any Additional Item under Custom 1 and Custom 2
                                         IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"Custom 1" THEN BEGIN
                                           BudgetGL:=FAPostingGRP."Custom 2 Account";
                                              IF BudgetGL ='' THEN
                                                 ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account',PurchLine."No.",
                                                 FAPostingGRP."Custom 1 Account");
                                         END;
        
                                         IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"Custom 2" THEN BEGIN
                                           BudgetGL:=FAPostingGRP."Custom 2 Account";
                                              IF BudgetGL ='' THEN
                                                 ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account',PurchLine."No.",
                                                 FAPostingGRP."Custom 1 Account");
                                         END;
                                         //To Accomodate any Additional Item under Custom 1 and Custom 2
        
                                        END;
                                 END;
                       END;
        
                       IF PurchLine.Type=PurchLine.Type::"G/L Account" THEN BEGIN
                          BudgetGL:=PurchLine."No.";
                          IF GLAcc.GET(PurchLine."No.") THEN
                             GLAcc.TESTFIELD("Budget Controlled",TRUE);
                       END;
        
                    //End Checking Account in Payment Line
        
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(PurchHeader."Document Date",2),DATE2DMY(PurchHeader."Document Date",3));
                               CurrMonth:=DATE2DMY(PurchHeader."Document Date",2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(PurchHeader."Document Date",3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PurchHeader."Document Date",3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                              //--ADDED Denno for AMPATH Projects obligated---------------------------------
                              objJobs.RESET;
                              objJobs.SETRANGE(objJobs."No.",PurchHeader."Shortcut Dimension 2 Code");
                              IF objJobs.FIND('-') THEN BEGIN
                               BudgetAmount:=0;
                               IF objJobs."Obligated Amount">0 THEN BudgetAmount:=objJobs."Obligated Amount";
        
                              END ELSE BEGIN
                               //---------------------------------------------------------------------------
        
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",ShortcutDimCode[3]);
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",ShortcutDimCode[4]);
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                            END; // Denno  Added--------------------------------
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."G/L Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",ShortcutDimCode[3]);
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",ShortcutDimCode[4]);
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."G/L Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")+ ActualsAmount>BudgetAmount)
                           AND NOT (BCSetup."Allow OverExpenditure") THEN
                            BEGIN
                              ERROR('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                              PurchLine."Document No.",PurchLine.Type ,PurchLine."No.",
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)"))));
                            END ELSE BEGIN
                                //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")+ ActualsAmount>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
                                //END ADDING CONFIRMATION
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=PurchHeader."Document Date";
                                IF PurchHeader.DocApprovalType=PurchHeader.DocApprovalType::Purchase THEN
                                    Commitments."Document Type":=Commitments."Document Type"::LPO
                                ELSE
                                    Commitments."Document Type":=Commitments."Document Type"::Requisition;
        
                                IF PurchHeader."Document Type"=PurchHeader."Document Type"::Invoice THEN
                                    Commitments."Document Type":=Commitments."Document Type"::PurchInvoice;
        
                                Commitments."Document No.":=PurchHeader."No.";
                                Commitments.Amount:=PurchLine."Outstanding Amount (LCY)";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=PurchHeader."Document Date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
        //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PurchLine."Shortcut Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PurchLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=ShortcutDimCode[3];
                                Commitments."Shortcut Dimension 4 Code":=ShortcutDimCode[4];
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=Commitments.Type::Vendor;
                                Commitments."Vendor/Cust No.":=PurchHeader."Buy-from Vendor No.";
                                Commitments.INSERT;
                                //Tag the Purchase Line as Committed
                                  PurchLine.Committed:=TRUE;
                                  PurchLine.MODIFY;
                                //End Tagging PurchLines as Committed
                            END;
                  UNTIL PurchLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        *******************************************************************}
          */

    end;


    procedure CommitPayments(var PaymentHeader: Record "Payment Header")
    var
        PayLine: Record "Payment Line";
        Commitments: Record "Budget Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
    begin

        //First Update Analysis View
        /*UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (PaymentHeader.Date< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3',PaymentHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (PaymentHeader.Date>BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3',PaymentHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.RESET;
              PayLine.SETRANGE(PayLine.No,PaymentHeader."No.");
              PayLine.SETRANGE(PayLine."Account Type",PayLine."Account Type"::"G/L Account");
              //PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
              IF PayLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(PaymentHeader.Date,2),DATE2DMY(PaymentHeader.Date,3));
                               CurrMonth:=DATE2DMY(PaymentHeader.Date,2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(PaymentHeader.Date,3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PaymentHeader.Date,3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               BudgetGL:=PayLine."Account No.";
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                              { Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code"); }
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
                               MESSAGE(FORMAT(BudgetAmount));
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PayLine."NetAmount LCY"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,PayLine.Type ,PayLine.No,
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."NetAmount LCY"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PayLine."NetAmount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."NetAmount LCY")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=PaymentHeader.Date;
                                IF PaymentHeader."Payment Type"=PaymentHeader."Payment Type"::Normal THEN
                                 Commitments."Document Type":=Commitments."Document Type"::"Payment Voucher"
                                ELSE
                                  Commitments."Document Type":=Commitments."Document Type"::PettyCash;
                                Commitments."Document No.":=PaymentHeader."No.";
                                Commitments.Amount:=PayLine."NetAmount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=PaymentHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
        //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.INSERT;
                               // MESSAGE('Done');
                                //Tag the Payment Line as Committed
                                  PayLine.Committed:=TRUE;
                                  PayLine.MODIFY;
                                //End Tagging Payment Lines as Committed
                            END;
        
                  UNTIL PayLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
         */

    end;


    procedure CommitImprest(var ImprestHeader: Record "Imprest Header")
    var
        PayLine: Record "Imprest Line";
        Commitments: Record "Budget Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
    begin
        //First Update Analysis View
        /*UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.RESET;
              PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
              PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
              IF PayLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                               CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //The GL Account
                                BudgetGL:=PayLine."Account No:";
        
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                               IF Budget.FIND('-') THEN BEGIN
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
                               END;
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,'Staff Imprest' ,PayLine.No,
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=ImprestHeader.Date;
                                Commitments."Document Type":=Commitments."Document Type"::Imprest;
                                Commitments."Document No.":=ImprestHeader."No.";
                                Commitments.Amount:=PayLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=ImprestHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
        //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                                Commitments.INSERT;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=TRUE;
                                  PayLine.MODIFY;
                                //End Tagging Imprest Lines as Committed
                            END;
        
                  UNTIL PayLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
          */

    end;


    procedure ReverseEntries(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance; DocNo: Code[20])
    var
        Commitments: Record "Budget Committment";
        EntryNo: Integer;
        CommittedLines: Record "Budget Committment";
    begin
        //Get Commitment Lines
        /*Commitments.RESET;
         IF Commitments.FIND('+') THEN
            EntryNo:=Commitments."Line No.";
        
        CommittedLines.RESET;
        CommittedLines.SETRANGE(CommittedLines."Document Type",DocumentType);
        CommittedLines.SETRANGE(CommittedLines."Document No.",DocNo);
        CommittedLines.SETRANGE(CommittedLines.Committed,TRUE);
        IF CommittedLines.FIND('-') THEN BEGIN
           REPEAT
             Commitments.RESET;
             Commitments.INIT;
             EntryNo+=1;
             Commitments."Line No.":=EntryNo;
             Commitments.Date:=TODAY;
             Commitments."Posting Date":=CommittedLines."Posting Date";
             Commitments."Document Type":=CommittedLines."Document Type";
             Commitments."Document No.":=CommittedLines."Document No.";
             Commitments.Amount:=-CommittedLines.Amount;
             Commitments."Month Budget":=CommittedLines."Month Budget";
             Commitments."Month Actual":=CommittedLines."Month Actual";
             Commitments.Committed:=FALSE;
             Commitments."Committed By":=USERID;
             Commitments."Committed Date":=CommittedLines."Committed Date";
             Commitments."G/L Account No.":=CommittedLines."G/L Account No.";
             Commitments."Committed Time":=TIME;
        //     Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
             Commitments."Shortcut Dimension 1 Code":= CommittedLines."Shortcut Dimension 1 Code";
             Commitments."Shortcut Dimension 2 Code":=CommittedLines."Shortcut Dimension 2 Code";
             Commitments."Shortcut Dimension 3 Code":=CommittedLines."Shortcut Dimension 3 Code";
             Commitments."Shortcut Dimension 4 Code":=CommittedLines."Shortcut Dimension 4 Code";
             Commitments.Budget:=CommittedLines.Budget;
             Commitments.INSERT;
        
           UNTIL CommittedLines.NEXT=0;
        END;
        */

    end;


    procedure CommitFundsAvailability(Payments: Record "Payment Header")
    var
        BankAcc: Record "Bank Account";
        "Current Source A/C Bal.": Decimal;
    begin
        //get the source account balance from the database table
        /*Payments.CALCFIELDS(Payments."Total Net Amount");
        BankAcc.RESET;
        BankAcc.SETRANGE(BankAcc."No.",Payments."Paying Bank Account");
        BankAcc.SETRANGE(BankAcc."Bank Type",BankAcc."Bank Type"::Cash);
        IF BankAcc.FINDFIRST THEN
          BEGIN
            BankAcc.CALCFIELDS(BankAcc.Balance);
            "Current Source A/C Bal.":=BankAcc.Balance;
            IF ("Current Source A/C Bal."-Payments."Total Net Amount")<0 THEN
              BEGIN
                ERROR('The transaction will result in a negative balance in the BANK ACCOUNT. %1:%2',BankAcc."No.",
                BankAcc.Name);
              END;
          END;
        */

    end;


    procedure UpdateAnalysisView()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        BudgetaryControl: Record "Budgeting Setup";
        AnalysisView: Record "Analysis View";
    begin
        /*//Update Budget Lines
        IF BudgetaryControl.GET THEN BEGIN
          IF BudgetaryControl."Analysis View Code"<>'' THEN BEGIN
           AnalysisView.RESET;
           AnalysisView.SETRANGE(AnalysisView.Code,BudgetaryControl."Analysis View Code");
           IF AnalysisView.FIND('-') THEN
             UpdateAnalysisView.UpdateAnalysisView_Budget(AnalysisView);
          END;
        END;  */

        //Update Budget Lines
        /*IF BudgetaryControl.GET THEN BEGIN
          IF BudgetaryControl."Actual Source"=BudgetaryControl."Actual Source"::"Analysis View Entry" THEN BEGIN
             IF BudgetaryControl."Analysis View Code"='' THEN
                ERROR('The Analysis view code can not be blank in the budgetary control setup');
          END;
          IF BudgetaryControl."Analysis View Code"<>''  THEN BEGIN
           AnalysisView.RESET;
           AnalysisView.SETRANGE(AnalysisView.Code,BudgetaryControl."Analysis View Code");
           IF AnalysisView.FIND('-') THEN
             UpdateAnalysisView.UpdateAnalysisView_Budget(AnalysisView);
          END;
        END; */

    end;


    procedure UpdateDim(DimCode: Code[20]; DimValueCode: Code[20])
    var
        GLBudgetDim: Integer;
    begin
        //In 2013 this is not applicable table 361 not supported
        /*IF DimCode = '' THEN
          EXIT;
        WITH GLBudgetDim DO BEGIN
          IF GET(Rec."Entry No.",DimCode) THEN
            DELETE;
          IF DimValueCode <> '' THEN BEGIN
            INIT;
            "Entry No." := Rec."Entry No.";
            "Dimension Code" := DimCode;
            "Dimension Value Code" := DimValueCode;
            INSERT;
          END;
        END; */

    end;


    procedure CheckIfBlocked(BudgetName: Code[20])
    var
        GLBudgetName: Record "G/L Budget Name";
    begin
        GLBudgetName.Get(BudgetName);
        GLBudgetName.TestField(Blocked, false);
    end;


    procedure CommitStaffClaim(var ImprestHeader: Record "Imprest Header")
    var
        PayLine: Record "Imprest Line";
        Commitments: Record "Budget Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        /*
       UpdateAnalysisView();

       //get the budget control setup first to determine if it mandatory or not
       BCSetup.RESET;
       BCSetup.GET();
       IF BCSetup.Mandatory THEN//budgetary control is mandatory
         BEGIN
           //check if the dates are within the specified range in relation to the payment header table
           IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
             BEGIN
               ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
               BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
             END
           ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
             BEGIN
               ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
               BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

             END;
           //Is budget Available
           CheckIfBlocked(BCSetup."Current Budget Code");

           //Get Commitment Lines
            IF Commitments.FIND('+') THEN
               EntryNo:=Commitments."Line No.";

           //get the lines related to the payment header
             PayLine.RESET;
             PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
             PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
             IF PayLine.FINDFIRST THEN
               BEGIN
                 REPEAT
                              //check the votebook now
                              FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                              CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                              IF CurrMonth=12 THEN
                               BEGIN
                                 LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                 LastDay:=CALCDATE('-1D',LastDay);
                               END
                              ELSE
                               BEGIN
                                 CurrMonth:=CurrMonth +1;
                                 LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                 LastDay:=CALCDATE('-1D',LastDay);
                               END;

                              //If Budget is annual then change the Last day
                              IF BCSetup."Budget Check Criteria"=BCSetup."Budget Check Criteria"::"Whole Year" THEN
                                  LastDay:=BCSetup."Current Budget End Date";

                              //The GL Account
                               BudgetGL:=PayLine."Account No:";

                              //check the summation of the budget in the database
                              BudgetAmount:=0;
                              Budget.RESET;
                              Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                              Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                              Budget."Dimension 4 Value Code");
                              Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                              Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                              Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                              Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                              Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                              Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                              Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                  Budget.CALCSUMS(Budget.Amount);
                                  BudgetAmount:= Budget.Amount;

                         //get the summation on the actuals
                         //Separate Analysis View and G/L Entry
                           IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                           ActualsAmount:=0;
                           Actuals.RESET;
                           Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                           Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                           Actuals."Posting Date",Actuals."Account No.");
                           Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                           Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                           Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                           Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                           Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                           Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                           Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                              Actuals.CALCSUMS(Actuals.Amount);
                              ActualsAmount:= Actuals.Amount;
                           END ELSE BEGIN
                               GLAccount.RESET;
                               GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                               GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                               IF PayLine."Global Dimension 1 Code" <> '' THEN
                                 GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                               IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                                 GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                               IF GLAccount.FIND('-') THEN BEGIN
                                GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                ActualsAmount:=GLAccount."Net Change";
                               END;
                           END;
                         //get the committments
                           CommitmentAmount:=0;
                           Commitments.RESET;
                           Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                           Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                           Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                           Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                           Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                           Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                           Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                           Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                           Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                           Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                              Commitments.CALCSUMS(Commitments.Amount);
                              CommitmentAmount:= Commitments.Amount;

                          //check if there is any budget
                          IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                             ERROR('No Budget To Check Against');
                          END ELSE BEGIN
                           IF (BudgetAmount<=0) THEN BEGIN
                            IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                               ERROR('Budgetary Checking Process Aborted');
                            END;
                           END;
                          END;

                          //check if the actuals plus the amount is greater then the budget amount
                          IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                          AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                             ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                             PayLine.No,'Staff Imprest' ,PayLine.No,
                               FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                           END ELSE BEGIN
                           //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                               IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                   IF NOT CONFIRM(Text0001+
                                   FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                   +Text0002,TRUE) THEN BEGIN
                                      ERROR('Budgetary Checking Process Aborted');
                                   END;
                               END;

                               Commitments.RESET;
                               Commitments.INIT;
                               EntryNo+=1;
                               Commitments."Line No.":=EntryNo;
                               Commitments.Date:=TODAY;
                               Commitments."Posting Date":=ImprestHeader.Date;
                               Commitments."Document Type":=Commitments."Document Type"::StaffAdvance;
                               Commitments."Document No.":=ImprestHeader."No.";
                               Commitments.Amount:=PayLine."Amount LCY";
                               Commitments."Month Budget":=BudgetAmount;
                               Commitments."Month Actual":=ActualsAmount;
                               Commitments.Committed:=TRUE;
                               Commitments."Committed By":=USERID;
                               Commitments."Committed Date":=ImprestHeader.Date;
                               Commitments."G/L Account No.":=BudgetGL;
                               Commitments."Committed Time":=TIME;
                              // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                               Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                               Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                               Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                               Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                               Commitments.Budget:=BCSetup."Current Budget Code";
                               Commitments.Type:=ImprestHeader."Account Type";
                               Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
       //                        Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
       //                        Commitments."Actual Source":=BCSetup."Actual Source";
                               Commitments.INSERT;
                               //Tag the Imprest Line as Committed
                                 PayLine.Committed:=TRUE;
                                 PayLine.MODIFY;
                               //End Tagging Imprest Lines as Committed
                           END;

                 UNTIL PayLine.NEXT=0;
               END;
         END
       ELSE//budget control not mandatory
         BEGIN

         END;
       MESSAGE('Budgetary Checking Completed Successfully');






       {*********************************************************
       //First Update Analysis View
       UpdateAnalysisView();

       //get the budget control setup first to determine if it mandatory or not
       BCSetup.RESET;
       BCSetup.GET();
       IF BCSetup.Mandatory THEN//budgetary control is mandatory
         BEGIN
           //check if the dates are within the specified range in relation to the payment header table
           IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
             BEGIN
               ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
               BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
             END
           ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
             BEGIN
               ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
               BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

             END;
           //Is budget Available
           CheckIfBlocked(BCSetup."Current Budget Code");

           //Get Commitment Lines
            IF Commitments.FIND('+') THEN
               EntryNo:=Commitments."Line No.";

           //get the lines related to the payment header
             PayLine.RESET;
             PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
             PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
             IF PayLine.FINDFIRST THEN
               BEGIN
                 REPEAT
                              //check the votebook now
                              FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                              CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                              IF CurrMonth=12 THEN
                               BEGIN
                                 LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                 LastDay:=CALCDATE('-1D',LastDay);
                               END
                              ELSE
                               BEGIN
                                 CurrMonth:=CurrMonth +1;
                                 LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                 LastDay:=CALCDATE('-1D',LastDay);
                               END;

                              //The GL Account
                               BudgetGL:=PayLine."Account No:";

                              //check the summation of the budget in the database
                              BudgetAmount:=0;
                              Budget.RESET;
                              Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                              Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                              Budget."Dimension 4 Value Code");
                              Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                              Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                              Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                              Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                              Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                              Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                              Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                  Budget.CALCSUMS(Budget.Amount);
                                  BudgetAmount:= Budget.Amount;

                         //get the summation on the actuals
                           ActualsAmount:=0;
                           Actuals.RESET;
                           Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                           Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                           Actuals."Posting Date",Actuals."G/L Account No.");
                           Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                           Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                           Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                           Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                           Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                           Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                           Actuals.SETRANGE(Actuals."G/L Account No.",BudgetGL);
                              Actuals.CALCSUMS(Actuals.Amount);
                              ActualsAmount:= Actuals.Amount;

                         //get the committments
                           CommitmentAmount:=0;
                           Commitments.RESET;
                           Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                           Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                           Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                           Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                           Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                           Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                           Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                           Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                           Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                           Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                              Commitments.CALCSUMS(Commitments.Amount);
                              CommitmentAmount:= Commitments.Amount;

                          //check if there is any budget
                          IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                             ERROR('No Budget To Check Against');
                          END ELSE BEGIN
                           IF (BudgetAmount<=0) THEN BEGIN
                            IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                               ERROR('Budgetary Checking Process Aborted');
                            END;
                           END;
                          END;

                          //check if the actuals plus the amount is greater then the budget amount
                          IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                          AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                             ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                             PayLine.No,'Staff Imprest' ,PayLine.No,
                               FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                           END ELSE BEGIN
                           //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                               IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                   IF NOT CONFIRM(Text0001+
                                   FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                   +Text0002,TRUE) THEN BEGIN
                                      ERROR('Budgetary Checking Process Aborted');
                                   END;
                               END;

                               Commitments.RESET;
                               Commitments.INIT;
                               EntryNo+=1;
                               Commitments."Line No.":=EntryNo;
                               Commitments.Date:=TODAY;
                               Commitments."Posting Date":=ImprestHeader.Date;
                               Commitments."Document Type":=Commitments."Document Type"::StaffClaim;
                               Commitments."Document No.":=ImprestHeader."No.";
                               Commitments.Amount:=PayLine."Amount LCY";
                               Commitments."Month Budget":=BudgetAmount;
                               Commitments."Month Actual":=ActualsAmount;
                               Commitments.Committed:=TRUE;
                               Commitments."Committed By":=USERID;
                               Commitments."Committed Date":=ImprestHeader.Date;
                               Commitments."G/L Account No.":=BudgetGL;
                               Commitments."Committed Time":=TIME;
       //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                               Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                               Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                               Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                               Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                               Commitments.Budget:=BCSetup."Current Budget Code";
                               Commitments.Type:=ImprestHeader."Account Type";
                               Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                               Commitments.INSERT;
                               //Tag the Imprest Line as Committed
                                 PayLine.Committed:=TRUE;
                                 PayLine.MODIFY;
                               //End Tagging Imprest Lines as Committed
                           END;

                 UNTIL PayLine.NEXT=0;
               END;
         END
       ELSE//budget control not mandatory
         BEGIN

         END;
       MESSAGE('Budgetary Checking Completed Successfully');
       ***************************************}
        */

    end;


    procedure CommitStaffAdvance(var ImprestHeader: Record "Imprest Header")
    var
        PayLine: Record "Imprest Line";
        Commitments: Record "Budget Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin

        //First Update Analysis View
        /*UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.RESET;
              PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
              PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
              IF PayLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                               CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //If Budget is annual then change the Last day
                               IF BCSetup."Budget Check Criteria"=BCSetup."Budget Check Criteria"::"Whole Year" THEN
                                   LastDay:=BCSetup."Current Budget End Date";
        
                               //The GL Account
                                BudgetGL:=PayLine."Account No:";
        
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                            IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            END ELSE BEGIN
                                GLAccount.RESET;
                                GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                                GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                IF PayLine."Global Dimension 1 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                                IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                                IF GLAccount.FIND('-') THEN BEGIN
                                 GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                END;
                            END;
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,'Staff Imprest' ,PayLine.No,
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=ImprestHeader.Date;
                                Commitments."Document Type":=Commitments."Document Type"::StaffAdvance;
                                Commitments."Document No.":=ImprestHeader."No.";
                                Commitments.Amount:=PayLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=ImprestHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
                             //   Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
        //                        Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
        //                        Commitments."Actual Source":=BCSetup."Actual Source";
                                Commitments.INSERT;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=TRUE;
                                  PayLine.MODIFY;
                                //End Tagging Imprest Lines as Committed
                            END;
        
                  UNTIL PayLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
        
        
        
        {********************
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.RESET;
              PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
              PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
              IF PayLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                               CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //The GL Account
                                BudgetGL:=PayLine."Account No:";
        
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."G/L Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."G/L Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,'Staff Imprest' ,PayLine.No,
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=ImprestHeader.Date;
                                Commitments."Document Type":=Commitments."Document Type"::StaffAdvance;
                                Commitments."Document No.":=ImprestHeader."No.";
                                Commitments.Amount:=PayLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=ImprestHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
        //                       // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                                Commitments.INSERT;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=TRUE;
                                  PayLine.MODIFY;
                                //End Tagging Imprest Lines as Committed
                            END;
        
                  UNTIL PayLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
        ******************************}
         */

    end;


    procedure CommitStaffAdvSurr(var ImprestHeader: Record "Imprest Header")
    var
        PayLine: Record "Imprest Line";
        Commitments: Record "Budget Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
    begin
        //First Update Analysis View
        /*UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader."Surrender Date"< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader."Surrender Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (ImprestHeader."Surrender Date">BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader."Surrender Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.RESET;
              PayLine.SETRANGE(PayLine."Surrender Doc No.",ImprestHeader.No);
              PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
              IF PayLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader."Surrender Date",2),DATE2DMY(ImprestHeader."Surrender Date",3));
                               CurrMonth:=DATE2DMY(ImprestHeader."Surrender Date",2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader."Surrender Date",3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader."Surrender Date",3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //The GL Account
                                BudgetGL:=PayLine."Account No:";
        
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Shortcut Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Shortcut Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Shortcut Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine."Surrender Doc No.",'Staff Imprest' ,PayLine."Surrender Doc No.",
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=ImprestHeader."Surrender Date";
                                Commitments."Document Type":=Commitments."Document Type"::StaffSurrender;
                                Commitments."Document No.":=ImprestHeader.No;
                                Commitments.Amount:=PayLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=ImprestHeader."Surrender Date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
        //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Shortcut Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                                Commitments.INSERT;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=TRUE;
                                  PayLine.MODIFY;
                                //End Tagging Imprest Lines as Committed
                            END;
        
                  UNTIL PayLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
         */

    end;
}

