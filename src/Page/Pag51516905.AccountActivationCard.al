#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516905 "Account Activation Card"
{
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption';
    SourceTable = "Account Activation";


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Type"; Type)
                {
                    ApplicationArea = Basic;
                    Editable = AType;
                    Caption = 'Account Source';
                }
                field("Client No."; "Client No.")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                }
                field("Client Name"; "Client Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Activation Date"; "Activation Date")
                {
                    ApplicationArea = Basic;
                    Editable = ClosingDateEditable;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = Rmarks;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                Caption = 'Function';

                action(Activate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Activate';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                        if Status <> Status::Approved then
                            Error('The request must be approved');

                        TestField("Activation Date");

                        if Type = Type::Member then begin

                            if cust.Get("Client No.") then begin
                                if cust.Status = cust.Status::Active then
                                    Error('This Member Account has already been Activated');


                                if Confirm('Are you sure you want to reactivate this member account?') = false then
                                    exit;



                                cust.Status := cust.Status::Active;
                                cust.Blocked := cust.Blocked::" ";
                                cust.Modify;


                            end;
                        end;

                        if Type = Type::Account then begin
                            if Vend.Get("Client No.") then begin
                                if Vend.Status = Vend.Status::Active then
                                    Error('This Account has already been Activated');


                                if Confirm('Are you sure you want to reactivate this account?') = false then
                                    exit;


                                Vend.Status := Vend.Status::Active;
                                Vend.Blocked := Vend.Blocked::" ";
                                Vend.Modify;

                            end;
                        end;


                        Activated := true;
                        Modify;

                        BATCH_TEMPLATE := 'GENERAL';
                        BATCH_NAME := 'ACTIVATE';
                        DOCUMENT_NO := "No.";
                        GenSetup.Get();
                        LineNo := 0;
                        //----------------------------------1.DEBIT TO VENDOR WITH PROCESSING FEE----------------------------------------------
                        LineNo := LineNo + 10000;
                        SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0", GenJournalLine."account type"::Vendor,
                        "Client No.", Today, 200, 'FOSA', '', 'Activation fees', '', GenJournalLine."bal. account type"::"G/L Account", '5534');

                        //-------------------------------2.CHARGE EXCISE DUTY----------------------------------------------
                        LineNo := LineNo + 10000;
                        SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0", GenJournalLine."account type"::Vendor,
                        "Client No.", Today, 20, 'FOSA', '', 'Excise Duty', '', GenJournalLine."bal. account type"::"G/L Account", GenSetup."Excise Duty Account");


                        //Post New
                        Gnljnline.Reset;
                        Gnljnline.SetRange("Journal Template Name", BATCH_TEMPLATE);
                        Gnljnline.SetRange("Journal Batch Name", BATCH_NAME);
                        if Gnljnline.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", Gnljnline);
                            Gnljnline.DeleteAll;
                        end;

                        Message('Account re-activated successfully');
                        //EXIT;




                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType := Documenttype::"Account Reactivation";
                        ApprovalEntries.SetRecordFilters(Database::"Account Activation", DocumentType, "No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Status <> Status::Open then
                            Error(text001);

                        //End allocate batch number
                        //IF ApprovalMgt.SendAccActivateApprovalRequest(Rec) THEN;
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel A&pproval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Status <> Status::Open then
                            Error(text001);

                        //End allocate batch number
                        //IF ApprovalMgt.CancelAccActivateApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                action("Account/Member Page")
                {
                    visible = false;
                    ApplicationArea = Basic;
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Member Account Card";
                    RunPageLink = "No." = field("Client No.");

                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
    end;

    trigger OnOpenPage()
    begin
        //Gnljnline.DELETEALL;
    end;

    var
        Closure: Integer;
        Text001: label 'Not Approved';
        cust: Record Customer;
        UBFRefund: Decimal;
        Generalsetup: Record "Sacco General Set-Up";
        Totalavailable: Decimal;
        UnpaidDividends: Decimal;
        TotalOustanding: Decimal;
        Vend: Record Vendor;
        value2: Decimal;
        Gnljnline: Record "Gen. Journal Line";
        Totalrecovered: Decimal;
        Advice: Boolean;
        TotalDefaulterR: Decimal;
        AvailableShares: Decimal;
        Loans: Record "Loans Register";
        Value1: Decimal;
        Interest: Decimal;
        LineN: Integer;
        LRepayment: Decimal;
        Vendno: Code[20];
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation";
        MNoEditable: Boolean;
        ClosingDateEditable: Boolean;
        ClosureTypeEditable: Boolean;
        AType: Boolean;
        Rmarks: Boolean;
        GenSetup: Record "Sacco General Set-Up";
        SFactory: Codeunit "SURESTEP Factory";
        BATCH_TEMPLATE: Code[100];
        BATCH_NAME: Code[100];
        DOCUMENT_NO: Code[100];
        LineNo: Integer;
        GenJournalLine: Record "Gen. Journal Line";


    procedure UpdateControl()
    begin
        if Status = Status::Open then begin
            MNoEditable := true;
            ClosingDateEditable := false;
            ClosureTypeEditable := true;
            AType := true;
            Rmarks := true;
        end;

        if Status = Status::Pending then begin
            MNoEditable := false;
            ClosingDateEditable := false;
            ClosureTypeEditable := false;
            AType := false;
            Rmarks := true;
        end;

        if Status = Status::Rejected then begin
            MNoEditable := false;
            ClosingDateEditable := false;
            ClosureTypeEditable := false;
            AType := false;
            Rmarks := false;
        end;

        if Status = Status::Approved then begin
            MNoEditable := false;
            ClosingDateEditable := true;
            AType := false;
            ClosureTypeEditable := false;
            Rmarks := false;
        end;


    end;
}

