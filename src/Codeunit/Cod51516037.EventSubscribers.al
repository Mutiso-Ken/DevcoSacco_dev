codeunit 51516037 "EventSubscribers"
{

    trigger OnRun()
    begin

    end;
    //1)----------------------------------Update Loans Status Once Loan Payment Has Been Posted
    [EventSubscriber(ObjectType::Table, 21, 'OnAfterInsertEvent', '', false, false)]
    procedure UpdateLoanCategorySASRA()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        LoansCategorization: Codeunit UpdateLoanClassification;
    begin
        // CustLedgerEntry.Reset();
        // CustLedgerEntry.SetRange(CustLedgerEntry.Reversed, false);
        // CustLedgerEntry.SetFilter(CustLedgerEntry."Transaction Type", '%1|%2', CustLedgerEntry."Transaction Type"::Repayment, CustLedgerEntry."Transaction Type"::"Interest Paid");
        // if CustLedgerEntry.FindLast then begin
        //     LoansCategorization.FnUpdateLoanStatus(CustLedgerEntry."Loan No");
        // end;
    end;
    //2)------------------------------------Prevent One Not Allowed To Reverse From Reversing
    [EventSubscriber(ObjectType::Table, 179, 'OnBeforeInsertReversalEntry', '', false, false)]
    procedure CheckIfAllowedToReverse()
    var
        StatusChangePermission: Record "Status Change Permision";
    begin
        StatusChangePermission.Reset();
        StatusChangePermission.SetRange(StatusChangePermission."User Id", UserId);
        StatusChangePermission.SetFilter(StatusChangePermission.Function, '%1', StatusChangePermission.Function::Reverse);
        if StatusChangePermission.Find('-') = false then begin
            Error('Denied!,you do have have permission to reverse. Contact system administrator');
        end;
    end;
    //4)---------------------------------Update Allowed Posting Date to & from for user currently logging in
    [EventSubscriber(ObjectType::Codeunit, 40, OnLogInEndOnAfterGetUserSetupRegisterTime, '', false, false)]
    local procedure UpdatePostingDate()
    var
        UserSetUp: Record "User Setup";
    begin
        UserSetUp.Reset();
        UserSetUp.SetRange(UserSetUp."User ID", UserId);
        if UserSetUp.Find('-') = true then begin
            UserSetUp."Allow Posting From" := Today;
            UserSetUp."Allow Posting To" := Today;
            UserSetUp.Modify();
        end;
    end;
    //5)---------------------------------Over look the printed option when making payment vouches
    [EventSubscriber(ObjectType::Codeunit, 229, 'OnBeforePrintCheckProcedure', '', false, false)]
    local procedure BypassRule(var NewGenJnlLine: Record "Gen. Journal Line"; var GenJournalLine: Record "Gen. Journal Line"; var IsPrinted: Boolean);
    var
        UserSetUp: Record "User Setup";
    begin
        IsPrinted := true;
        exit;
    end;

    [EventSubscriber(ObjectType::Codeunit, 229, 'OnBeforePrintPostedPaymentReconciliation', '', false, false)]
    local procedure BypassRule2(var PostedPaymentReconHdr: Record "Posted Payment Recon. Hdr"; var IsPrinted: Boolean);
    var
        UserSetUp: Record "User Setup";
    begin
        IsPrinted := true;
        exit;
    end;


     [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeCheckBlockedCust', '', false, false)]
    local procedure OnBeforeCheckBlockedCust(Customer: Record Customer; Source: Option; DocType: Option; Shipment: Boolean; Transaction: Boolean; var IsHandled: Boolean);
    begin
        if ((DocType = 0) AND (Customer."No." = '50000')) then begin
            IsHandled := true;
        end;
    end;
}
