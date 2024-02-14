#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516031 "DO Payment Trans. Log Mgt."
{
    Permissions = TableData "DO Payment Trans. Log Entry" = im;

    trigger OnRun()
    begin
    end;

    var
        DOPaymentMgt: Codeunit "Sales Post Invoice Events";
        Text065: label 'Credit card %1 has already been performed for this %2, but posting failed. You must complete posting of %2 %3.';
        Text066: label 'The operation cannot be performed because %1 %2 has already been authorized on %3, and authorization is not expired.';
        Text069: label '%1 %2 has already been authorized on %3, and authorization is not expired. You must void the previous authorization before you can delete this %1.';
        Text001: label '"Error Code = %1; Message = %2"';
        Text002: label 'Payment transaction has been performed successfully.';
        Text003: label 'Payment transaction has not been performed.';
        Text004: label 'Payment transaction has been initialized but has not been completed.';
        Text005: label 'A capture of %1 %2 has already been performed for Document No. %3 on %4.';


    procedure ValidateCanDeleteDocument(PaymentMethodCode: Code[10]; DocumentType: Integer; DocumentTypeName: Text[30]; DocumentNo: Code[20])
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        // if DOPaymentMgt.IsValidPaymentMethod(PaymentMethodCode) then begin
        //   if FindPostingNotFinishedEntry(DocumentType,DocumentNo,DOPaymentTransLogEntry) then
        //     Error(Text065,DOPaymentTransLogEntry."Transaction Type",DocumentTypeName,DocumentNo);

        //   if FindValidAuthorizationEntry(DocumentType,DocumentNo,DOPaymentTransLogEntry) then
        //     Error(Text069,DocumentTypeName,DocumentNo,DOPaymentTransLogEntry."Transaction Date-Time");
        // end;
    end;


    procedure ValidateHasNoValidTransactions(DocumentType: Integer; DocumentTypeName: Text[30]; DocumentNo: Code[20])
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        if FindPostingNotFinishedEntry(DocumentType, DocumentNo, DOPaymentTransLogEntry) then
            Error(Text065, DOPaymentTransLogEntry."Transaction Type", DocumentTypeName, DocumentNo);

        if FindValidAuthorizationEntry(DocumentType, DocumentNo, DOPaymentTransLogEntry) then
            Error(Text066, DocumentTypeName, DocumentNo, DOPaymentTransLogEntry."Transaction Date-Time");
    end;

    local procedure UpdateExpirationInAuthEntries(DocumentType: Integer; DocumentNo: Code[20])
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
        DOPaymentSetup: Record "DO Payment Setup";
    begin
        if DOPaymentSetup.Get then
            if DOPaymentSetup."Days Before Auth. Expiry" <> 0 then
                with DOPaymentTransLogEntry do begin
                    SetCurrentkey("Document Type", "Document No.", "Transaction Type", "Transaction Result", "Transaction Status");
                    SetRange("Document Type", DocumentType);
                    SetRange("Document No.", DocumentNo);
                    SetRange("Transaction Type", "transaction type"::Authorization);
                    SetRange("Transaction Result", "transaction result"::Success);
                    SetRange("Transaction Status", "transaction status"::" ");
                    if FindSet then
                        repeat
                            if Dt2Date(CurrentDatetime) -
                               Dt2Date("Transaction Date-Time") > DOPaymentSetup."Days Before Auth. Expiry"
                            then begin
                                "Transaction Status" := "transaction status"::Expired;
                                Modify;
                            end;
                        until Next = 0;
                end;
    end;


    procedure FindValidAuthorizationEntry(DocumentType: Integer; DocumentNo: Code[20]; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Boolean
    begin
        UpdateExpirationInAuthEntries(DocumentType, DocumentNo);
        with DOPaymentTransLogEntry do begin
            Reset;
            SetCurrentkey("Document Type", "Document No.", "Transaction Type", "Transaction Result", "Transaction Status");
            SetRange("Document Type", DocumentType);
            SetRange("Document No.", DocumentNo);
            SetRange("Transaction Type", "transaction type"::Authorization);
            SetRange("Transaction Result", "transaction result"::Success);
            SetRange("Transaction Status", "transaction status"::" ");
            exit(FindFirst);
        end;
    end;


    procedure FindPostingNotFinishedEntry(DocumentType: Integer; DocumentNo: Code[20]; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Boolean
    begin
        with DOPaymentTransLogEntry do begin
            Reset;
            SetCurrentkey("Document Type", "Document No.", "Transaction Type", "Transaction Result", "Transaction Status");
            SetRange("Document Type", DocumentType);
            SetRange("Document No.", DocumentNo);
            SetFilter("Transaction Type", '%1|%2', "transaction type"::Void, "transaction type"::Refund);
            SetRange("Transaction Result", "transaction result"::Success);
            SetRange("Transaction Status", "transaction status"::"Posting Not Finished");
            exit(FindFirst);
        end;
    end;


    procedure FindCapturedButNotFinishedEntr(CustomerNo: Code[20]; DocumentNo: Code[20]; PaidAmount: Decimal; CurrencyCode: Code[10]; CreditCardNo: Code[20]; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Boolean
    begin
        with DOPaymentTransLogEntry do begin
            //   Reset;
            //   SetCurrentkey("Document No.","Customer No.","Transaction Status");
            //   SetRange("Document No.",DocumentNo);
            //   SetRange("Customer No.",CustomerNo);
            //   SetRange("Transaction Status","transaction status"::"Posting Not Finished");
            //   SetRange("Credit Card No.",CreditCardNo);
            //   CurrencyCode := DOPaymentMgt.FindCurrencyCode(CurrencyCode);
            //   SetRange("Currency Code",CurrencyCode);
            //   SetRange("Transaction Type","transaction type"::Capture);
            //   SetRange("Transaction Result","transaction result"::Success);

            //   if not FindFirst then
            //     exit(false);

            //   if Amount <> PaidAmount then
            //     Error(Text005,Amount,CurrencyCode,DocumentNo,Format(Dt2Date("Transaction Date-Time"),0,4));

            //   exit(true);
        end;
    end;


    // procedure CompleteTransLogEntry(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; TransactionResult: dotnet ITransactionResult)
    // begin
    //     if not TransactionResult.IsSuccess then begin
    //         DOPaymentTransLogEntry."Transaction Result" := DOPaymentTransLogEntry."transaction result"::Failed;
    //         DOPaymentTransLogEntry."Transaction Description" :=
    //           CopyStr(StrSubstNo(Text001, TransactionResult.LastErrorCode, TransactionResult.
    //               LastErrorMessage), 1, MaxStrLen(DOPaymentTransLogEntry."Transaction Description"));
    //         if DOPaymentTransLogEntry."Transaction Description" = '' then
    //             DOPaymentTransLogEntry."Transaction Description" := Text003;
    //     end else begin
    //         DOPaymentTransLogEntry."Transaction Result" := DOPaymentTransLogEntry."transaction result"::Success;
    //         DOPaymentTransLogEntry."Transaction Description" := CopyStr(TransactionResult.Description, 1, MaxStrLen(DOPaymentTransLogEntry.
    //               "Transaction Description"));
    //         if DOPaymentTransLogEntry."Transaction Description" = '' then
    //             DOPaymentTransLogEntry."Transaction Description" := Text002;
    //         DOPaymentTransLogEntry.Amount := ROUND(TransactionResult.Amount, 0.01, '=');
    //         DOPaymentTransLogEntry."Transaction GUID" := TransactionResult.TransactionId;
    //         DOPaymentTransLogEntry."Transaction ID" := TransactionResult.TransactionIdentifier;
    //         DOPaymentTransLogEntry."Currency Code" := TransactionResult.CurrencyCode;
    //     end;
    //     DOPaymentTransLogEntry."Transaction Date-Time" := CurrentDatetime;
    //     DOPaymentTransLogEntry."User ID" := UserId;
    //     DOPaymentTransLogEntry.Modify;
    // end;

    local procedure CompleTransLogEntryWithError(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; ErrorMessage: Text[250])
    begin
        DOPaymentTransLogEntry."Transaction Result" := DOPaymentTransLogEntry."transaction result"::Failed;
        DOPaymentTransLogEntry."Transaction Description" := ErrorMessage;
        if DOPaymentTransLogEntry."Transaction Description" = '' then
            DOPaymentTransLogEntry."Transaction Description" := Text003;
        DOPaymentTransLogEntry."Transaction Date-Time" := CurrentDatetime;
        DOPaymentTransLogEntry."User ID" := UserId;
        DOPaymentTransLogEntry.Modify;
    end;


    procedure InitializeTransactionLogEntry(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; CreditCardNo: Code[20]; SourceType: Option " ","Order",Invoice; SourceNo: Code[20]; CustomerNo: Code[20]; TransactionType: Option; var ParentDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Integer
    var
        NewDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        NewDOPaymentTransLogEntry.Init;
        NewDOPaymentTransLogEntry."Document Type" := SourceType;
        NewDOPaymentTransLogEntry."Document No." := SourceNo;
        NewDOPaymentTransLogEntry."Customer No." := CustomerNo;
        NewDOPaymentTransLogEntry."Credit Card No." := CreditCardNo;
        NewDOPaymentTransLogEntry."Transaction Type" := TransactionType;
        NewDOPaymentTransLogEntry."Transaction Result" := NewDOPaymentTransLogEntry."transaction result"::Failed;
        NewDOPaymentTransLogEntry."Transaction Description" := Text004;
        NewDOPaymentTransLogEntry."Transaction Date-Time" := CurrentDatetime;
        NewDOPaymentTransLogEntry."User ID" := UserId;
        NewDOPaymentTransLogEntry."Reference GUID" := CreateGuid;
        if not ParentDOPaymentTransLogEntry.IsEmpty then
            NewDOPaymentTransLogEntry."Parent Entry No." := ParentDOPaymentTransLogEntry."Entry No.";
        NewDOPaymentTransLogEntry.Insert;

        DOPaymentTransLogEntry := NewDOPaymentTransLogEntry;
        exit(NewDOPaymentTransLogEntry."Entry No.");
    end;
}

