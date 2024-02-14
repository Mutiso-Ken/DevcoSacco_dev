page 51516048 "Loan Recovery Card"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Loan Recovery Header";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No"; Rec."Document No")
                {
                    Editable = false;
                }
                field("Recovery Type"; Rec."Recovery Type")
                {
                    Editable = FieldEditable;
                }
                field("Entered By"; Rec."Entered By")
                {
                    Editable = false;
                }
                field("Date Entered"; Rec."Date Entered")
                {

                    Editable = false;
                }
                field("Time Entered"; Rec."Time Entered")
                {

                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Posted By"; Rec."Posted By")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Notify Member(s)"; Rec."Notify Member(s)")
                {

                }
            }
            part("Loan Recovery Lines"; "Loan Recovery Lines")
            {
                Caption = 'Loan Recovery Lines';
                SubPageLink = "Document No" = field("Document No");
                Editable = FieldEditable;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("Send Approval")
            {
                ApplicationArea = Basic;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = SendApprovalEnabled;

                trigger OnAction()
                var
                    RecoveryLines: Record "Loan Recovery List";
                begin
                    TestField(Posted, false);
                    TestField("Posted By", '');
                    TestField("Posting Date", 0D);
                    if Status <> Status::Open then begin
                        Error('The card MUST be Open');
                    end;
                    RecoveryLines.Reset();
                    RecoveryLines.SetRange(RecoveryLines."Document No", "Document No");
                    if RecoveryLines.Find('-') then begin
                        repeat
                            if (RecoveryLines."Member No" = '') or (RecoveryLines."Loan No." = '') or (RecoveryLines."Total Amount To Recover" = 0) then begin
                                Error('You cannot send a card with incomplete recovery lines for Approvals ');
                            end;
                        until RecoveryLines.Next = 0;
                    end;
                    if Confirm('Are you sure you want to send Approval Request ?', false) = false then begin
                        exit;
                    end else begin
                        SrestepApprovalsCodeUnit.SendLoanRecoveryApplicationsRequestForApproval(rec."Document No", Rec);
                        CurrPage.Close();
                    end;
                end;
            }
            action("Cancel Approval")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = CancelApprovalEnabled;
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to Cancel Approval Request ?', false) = false then begin
                        exit;
                    end else begin
                        SrestepApprovalsCodeUnit.CancelLoanRecoveryApplicationsRequestForApproval(rec."Document No", Rec);
                    end;
                end;
            }

            action("Post Recovery")
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = PostedReceipt;
                Promoted = true;
                Enabled = PostEnabled;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RecoveryLines: Record "Loan Recovery List";
                begin
                    TestField(Posted, false);
                    TestField("Posted By", '');
                    TestField("Posting Date", 0D);
                    if Status <> Status::Approved then begin
                        Error('The card MUST be Approved');
                    end;
                    //----------------Recovery Process Begin
                    if Confirm('Are You sure you want to recover loans from ' + Format("Recovery Type") + ' ?', false) = false then begin
                        exit;
                    end else begin
                        GenJournalLine.RESET;
                        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
                        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'LOANS');
                        IF GenJournalLine.FIND('-') THEN begin
                            GenJournalLine.DELETEALL;
                        end;

                        RecoveryLines.Reset();
                        RecoveryLines.SetRange(RecoveryLines."Document No", "Document No");
                        if RecoveryLines.Find('-') then begin
                            repeat
                                //.....................Create GL Lines
                                if RecoveryLines.Source <> RecoveryLines.Source::MICRO then begin
                                    Vendor.reset;
                                    Vendor.SetRange(Vendor."BOSA Account No", RecoveryLines."BOSA Account No");
                                    Vendor.SetAutoCalcFields(Vendor."FOSA Balance");
                                    if Vendor.Find('-') then begin
                                        //----------------------------------Principal Repayment
                                        LineNo := LineNo + 10000;
                                        GenJournalLine.INIT;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'LOANS';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Document No." := 'RECOVERIES';
                                        GenJournalLine."Posting Date" := TODAY;
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                        GenJournalLine."Account No." := RecoveryLines."BOSA Account No";
                                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                        GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Principle Recovery';
                                        GenJournalLine.Amount := -RecoveryLines."Principal Amount To Recover";
                                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                                        GenJournalLine."Loan No" := RecoveryLines."Loan No.";
                                        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                                        GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                        IF GenJournalLine.Amount <> 0 THEN begin
                                            GenJournalLine.INSERT;
                                        end;
                                        //--------------------------------------Interest Repayment
                                        LineNo := LineNo + 10000;
                                        GenJournalLine.INIT;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'LOANS';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Document No." := 'RECOVERIES';
                                        GenJournalLine."Posting Date" := TODAY;
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                        GenJournalLine."Account No." := RecoveryLines."BOSA Account No";
                                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                        GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Interest Recovery';
                                        GenJournalLine.Amount := -RecoveryLines."Interest Amount To Recover";
                                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                                        GenJournalLine."Loan No" := RecoveryLines."Loan No.";
                                        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                                        GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                        IF GenJournalLine.Amount <> 0 THEN begin
                                            GenJournalLine.INSERT;
                                        end;
                                        //-------------Recover Total From Vendor Account
                                        LineNo := LineNo + 10000;
                                        GenJournalLine.INIT;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'LOANS';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Document No." := 'RECOVERIES';
                                        GenJournalLine."Posting Date" := TODAY;
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                        GenJournalLine."Account No." := Vendor."No.";
                                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                        GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Recovery';
                                        GenJournalLine.Amount := RecoveryLines."Total Amount To Recover";
                                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                        GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                        IF GenJournalLine.Amount <> 0 THEN begin
                                            GenJournalLine.INSERT;
                                        end;
                                        //-------------Recover Fee charge
                                        // LineNo := LineNo + 10000;
                                        // GenJournalLine.INIT;
                                        // GenJournalLine."Journal Template Name" := 'GENERAL';
                                        // GenJournalLine."Journal Batch Name" := 'LOANS';
                                        // GenJournalLine."Line No." := LineNo;
                                        // GenJournalLine."Document No." := 'RECOVERIES';
                                        // GenJournalLine."Posting Date" := TODAY;
                                        // GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                        // GenJournalLine."Account No." := Vendor."No.";
                                        // GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                        // GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Recovery transfer fee';
                                        // GenJournalLine.Amount := 50;
                                        // GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                        // GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                        // GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                        // GenJournalLine."Account No." := '5421';
                                        // GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                        // IF GenJournalLine.Amount <> 0 THEN begin
                                        //     GenJournalLine.INSERT;
                                        // end;
                                        // //-------------Recover Fee charge excise duty
                                        // LineNo := LineNo + 10000;
                                        // GenJournalLine.INIT;
                                        // GenJournalLine."Journal Template Name" := 'GENERAL';
                                        // GenJournalLine."Journal Batch Name" := 'LOANS';
                                        // GenJournalLine."Line No." := LineNo;
                                        // GenJournalLine."Document No." := 'RECOVERIES';
                                        // GenJournalLine."Posting Date" := TODAY;
                                        // GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                        // GenJournalLine."Account No." := Vendor."No.";
                                        // GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                        // GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Recovery excise duty';
                                        // GenJournalLine.Amount := 50 * (20 / 100);
                                        // GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                        // GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                        // GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                        // GenJournalLine."Account No." := '6322';
                                        // GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                        // IF GenJournalLine.Amount <> 0 THEN begin
                                        //     GenJournalLine.INSERT;
                                        // end;
                                    end;

                                end else
                                    if RecoveryLines.Source = RecoveryLines.Source::MICRO then begin
                                        ///
                                        Customer.Reset();
                                        Customer.SetRange(Customer."No.", RecoveryLines."BOSA Account No");
                                        if Customer.find('-') then begin
                                            Vendor.reset;
                                            Vendor.SetRange(Vendor."BOSA Account No", Customer."No.");
                                            Vendor.SetAutoCalcFields(Vendor."FOSA Balance");
                                            if Vendor.Find('-') then begin
                                                //----------------------------------Principal Repayment
                                                LineNo := LineNo + 10000;
                                                GenJournalLine.INIT;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'LOANS';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Document No." := 'RECOVERIES';
                                                GenJournalLine."Posting Date" := TODAY;
                                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                                GenJournalLine."Account No." := RecoveryLines."BOSA Account No";
                                                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                                GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Principle Recovery';
                                                GenJournalLine.Amount := -RecoveryLines."Principal Amount To Recover";
                                                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                                                GenJournalLine."Loan No" := RecoveryLines."Loan No.";
                                                GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                                                GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                                IF GenJournalLine.Amount <> 0 THEN begin
                                                    GenJournalLine.INSERT;
                                                end;
                                                //--------------------------------------Interest Repayment
                                                LineNo := LineNo + 10000;
                                                GenJournalLine.INIT;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'LOANS';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Document No." := 'RECOVERIES';
                                                GenJournalLine."Posting Date" := TODAY;
                                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                                GenJournalLine."Account No." := RecoveryLines."BOSA Account No";
                                                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                                GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Interest Recovery';
                                                GenJournalLine.Amount := -RecoveryLines."Interest Amount To Recover";
                                                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                                                GenJournalLine."Loan No" := RecoveryLines."Loan No.";
                                                GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                                                GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                                IF GenJournalLine.Amount <> 0 THEN begin
                                                    GenJournalLine.INSERT;
                                                end;
                                                //-------------Recover Total From Vendor Account
                                                LineNo := LineNo + 10000;
                                                GenJournalLine.INIT;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'LOANS';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Document No." := 'RECOVERIES';
                                                GenJournalLine."Posting Date" := TODAY;
                                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                                GenJournalLine."Account No." := Vendor."No.";
                                                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                                GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Recovery';
                                                GenJournalLine.Amount := RecoveryLines."Total Amount To Recover";
                                                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                                GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                                IF GenJournalLine.Amount <> 0 THEN begin
                                                    GenJournalLine.INSERT;
                                                end;
                                                //-------------Recover Fee charge
                                                // LineNo := LineNo + 10000;
                                                // GenJournalLine.INIT;
                                                // GenJournalLine."Journal Template Name" := 'GENERAL';
                                                // GenJournalLine."Journal Batch Name" := 'LOANS';
                                                // GenJournalLine."Line No." := LineNo;
                                                // GenJournalLine."Document No." := 'RECOVERIES';
                                                // GenJournalLine."Posting Date" := TODAY;
                                                // GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                                // GenJournalLine."Account No." := Vendor."No.";
                                                // GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                                // GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Recovery transfer fee';
                                                // GenJournalLine.Amount := 50;
                                                // GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                                // GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                                // GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                                // GenJournalLine."Account No." := '5421';
                                                // GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                                // IF GenJournalLine.Amount <> 0 THEN begin
                                                //     GenJournalLine.INSERT;
                                                // end;
                                                // //-------------Recover Fee charge excise duty
                                                // LineNo := LineNo + 10000;
                                                // GenJournalLine.INIT;
                                                // GenJournalLine."Journal Template Name" := 'GENERAL';
                                                // GenJournalLine."Journal Batch Name" := 'LOANS';
                                                // GenJournalLine."Line No." := LineNo;
                                                // GenJournalLine."Document No." := 'RECOVERIES';
                                                // GenJournalLine."Posting Date" := TODAY;
                                                // GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                                // GenJournalLine."Account No." := Vendor."No.";
                                                // GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                                // GenJournalLine.Description := RecoveryLines."Loan No." + '-Loan Recovery excise duty';
                                                // GenJournalLine.Amount := 50 * (20 / 100);
                                                // GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                                // GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                                // GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                                // GenJournalLine."Account No." := '6322';
                                                // GenJournalLine."Shortcut Dimension 2 Code" := surestepFactory.FnGetMemberBranch(RecoveryLines."BOSA Account No");
                                                // IF GenJournalLine.Amount <> 0 THEN begin
                                                //     GenJournalLine.INSERT;
                                                // end;
                                            end;

                                        end;
                                    end;
                            until RecoveryLines.Next = 0;
                        end;
                        //...................Post Lines And Mark Receipt Line As Posted
                        GenJournalLine.RESET;
                        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
                        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'LOANS');
                        IF GenJournalLine.FIND('-') THEN begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine);

                        end;
                        //------------------Mark As Posted
                        Posted := true;
                        "Posted By" := UserId;
                        "Posting Date" := Today;
                        Status := Status::Closed;
                        REC.Modify();
                        Message('Loan Recoveries Posted Successfully');
                        // IF REC."Notify Member(s)" = true THEN begin
                        //     //Send SMS Alerts
                        // end;
                    end;
                end;
            }

        }
    }
    var
        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
        SendApprovalEnabled: Boolean;
        CancelApprovalEnabled: Boolean;
        PostEnabled: Boolean;
        FieldEditable: Boolean;
        surestepFactory: Codeunit "SURESTEP Factory";
        GenJournalLine: Record "Gen. Journal Line";
        Vendor: Record vendor;
        ABC: Decimal;
        Customer: Record Customer;
        LineNo: Integer;

    trigger OnAfterGetCurrRecord()
    begin
        FnUpdateControls();
    end;

    trigger OnOpenPage()
    begin
        FnUpdateControls();
    end;

    local procedure FnUpdateControls()
    begin
        if Status = Status::Open then begin
            SendApprovalEnabled := true;
            CancelApprovalEnabled := false;
            PostEnabled := false;
            FieldEditable := true;
        end else
            if Status = Status::Pending then begin
                SendApprovalEnabled := false;
                CancelApprovalEnabled := true;
                PostEnabled := false;
                FieldEditable := false;
            end
            else
                if Status = Status::Approved then begin
                    SendApprovalEnabled := false;
                    CancelApprovalEnabled := false;
                    PostEnabled := true;
                    FieldEditable := false;
                end
                else
                    if Status = Status::Closed then begin
                        SendApprovalEnabled := false;
                        CancelApprovalEnabled := false;
                        PostEnabled := false;
                        FieldEditable := false;
                    end
                    else
                        if Status = Status::Rejected then begin
                            SendApprovalEnabled := true;
                            CancelApprovalEnabled := false;
                            PostEnabled := true;
                            FieldEditable := false;
                        end;
        CurrPage.Update();
    end;

}