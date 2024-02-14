#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516615 "Loan Top-Up Card"
{
    Caption = 'Loan Refinance Card';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Loan Top Up.";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = ApprovedEditable;
                field("Document No"; "Document No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Member No"; "Member No")
                {
                    ApplicationArea = Basic;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan No"; "Loan No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan To Top Up';
                }
                field("Issue Date"; "Issue Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Issue Date';
                    Editable = false;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Requested Amount';
                    Editable = false;
                }
                field("Approved Amount"; "Approved Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Approved Amount';
                    Editable = false;
                }
                field("Outstanding Loan Amount"; "Outstanding Loan Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Balance';
                    Editable = false;
                }
                field("Top Up Amount"; "Top Up Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Top Up Amount';

                    trigger OnValidate()
                    var
                    begin
                        LoansReg2.Reset();
                        LoansReg2.SetRange(LoansReg2."Loan  No.", "Document No");
                        if LoansReg2.Find('-') then begin
                            LoansReg2."Approved Amount" := "Top Up Amount";
                            LoansReg2.Modify();
                        end;
                        Modify;
                    end;
                }
                field("Original Installments"; "Original Installments")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("New Installments"; "New Installments")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Remaining Installments"; "Remaining Installments")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Repayment Start Date"; "Repayment Start Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Loan Insurance"; "Loan Insurance")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Commision; Commision)
                {
                    ApplicationArea = Basic;
                    Caption = 'Refinance Commission';
                    Editable = false;
                    Visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        if Status <> Status::Open then
                            ApprovedEditable := false
                        else
                            ApprovedEditable := true;
                    end;
                }
                field("Topped-Up"; "Topped-Up")
                {
                    ApplicationArea = Basic;
                    Caption = 'Topped-Up';
                    Editable = false;
                }
                field("Top Up Loan No"; "Top Up Loan No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Top Up Loan No';
                    Editable = false;
                }

                field("Topped-Up By"; "Topped-Up By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Topped-Up By';
                    Editable = false;
                }
                field("Refinance Application Date"; "Top Up Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Top Up Application Date';
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Partial Top-Up"; "Partial Top-Up")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                group(Control1000000025)
                {
                    Editable = ApprovedEditable;
                    Visible = "Partial Top-Up" = true;
                    field("Original Top-Up"; "Original Top-Up")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Original Refinance';
                        Editable = false;
                    }
                    field("Amount To Disburse"; "Amount To Disburse")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Disbursed Amount"; "Disbursed Amount")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                    field("Balance After"; "Balance After")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                }
            }
            group("Guarantors  Detail")
            {
                Editable = ApprovedEditable;
                part(Control1000000004; "Loans Guarantee Details")
                {
                    Caption = 'Guarantors  Detail';
                    SubPageLink = "Loan No" = field("Document No");
                }

            }
            group("Collateral Detail")
            {
                Editable = ApprovedEditable;
                part(Control1000000005; "Loan Collateral Security")
                {
                    Caption = 'Other Securities';
                    SubPageLink = "Loan No" = field("Document No");
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

                action("Post Loan Appeal")
                {
                    ApplicationArea = Basic;
                    Caption = 'POST';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "Member No");
                        if Cust.FindFirst then begin
                            DBranch := Cust."Global Dimension 2 Code";
                        end;

                        if Confirm('Are you sure you want to post this Loan Top Up ?', true) = false then
                            exit;

                        Temp.Get(UserId);
                        Jtemplate := 'PAYMENTS';//Temp."Receipt Journal Template";
                        JBatch := 'LOANS';//Temp."Receipt Journal Batch";

                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
                        GenJournalLine.SetRange("Journal Batch Name", JBatch);
                        GenJournalLine.DeleteAll;

                        GenSetUp.Get();

                        LoanApps.Reset;
                        LoanApps.SetRange(LoanApps."Loan  No.", "Loan No");
                        LoanApps.SetRange(LoanApps."System Created", false);
                        LoanApps.SetFilter(LoanApps."Approval Status", '<>Rejected');
                        if LoanApps.Find('-') then begin

                            if LoanApps."Approval Status" <> LoanApps."approval status"::Approved then
                                Error('Loan status must be Approved for you to post Loan. - ' + LoanApps."Loan  No.");

                            if LoanApps."Appeal Posted" = true then
                                //ERROR('Loan has already been posted. - ' + LoanApps."Loan  No.");
                                Message('Loan has already been posted. - ' + LoanApps."Loan  No.");

                            //Generate and post Approved Loan Amount
                            if not GenBatch.Get(Jtemplate, JBatch) then begin
                                GenBatch.Init;
                                GenBatch."Journal Template Name" := Jtemplate;
                                GenBatch.Name := JBatch;
                                GenBatch.Insert;
                            end;
                            //1)Create New Loan
                            NewLoan := '';
                            NewLoan := FnCreateNewLoan("Loan No");
                            If NewLoan = '' then begin
                                Error('Could not create Process Request,Contact System Administrator');
                            end;
                            //2)Generate Schedule For New Loan
                            RepaymentSchedule.Reset();
                            RepaymentSchedule.SetRange(RepaymentSchedule."Loan No.", "Document No");
                            if RepaymentSchedule.Find('-') = true then begin
                                RepaymentSchedule.DeleteAll();
                                SurestepFactory.FnGenerateRepaymentSchedule("Document No");
                            end else
                                if RepaymentSchedule.Find('-') = false then begin
                                    SurestepFactory.FnGenerateRepaymentSchedule("Document No");
                                end;

                            //3)Create The New Loan lines

                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := Jtemplate;
                            GenJournalLine."Journal Batch Name" := JBatch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                            GenJournalLine."Account No." := "Member No";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := "Document No";
                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Loan;
                            GenJournalLine."Posting Date" := "Posting Date";
                            GenJournalLine.Description := 'TopUp Loan Principle topping-' + Format("Loan No");
                            GenJournalLine.Amount := ("Top Up Amount");
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Loan No" := NewLoan;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;
                            //Take to FOSA Account
                            LoanApps.Reset;
                            LoanApps.SetRange(LoanApps."Loan  No.", NewLoan);
                            LoanApps.SetRange(LoanApps."System Created", false);
                            LoanApps.SetFilter(LoanApps."Approval Status", '<>Rejected');
                            if LoanApps.Find('-') then begin
                                if LoanApps."Mode of Disbursement" = LoanApps."mode of disbursement"::Cheque then begin

                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := Jtemplate;
                                    GenJournalLine."Journal Batch Name" := JBatch;
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                    GenJournalLine."Account No." := LoanApps."Account No";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Document No." := "Document No";
                                    GenJournalLine."Posting Date" := "Posting Date";
                                    GenJournalLine.Description := 'Top up Amount for Loan-' + "Loan No";
                                    GenJournalLine.Amount := "Top Up Amount" * -1;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Loan No" := NewLoan;
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                end else
                                    if LoanApps.Find('-') then begin
                                        LineNo := LineNo + 10000;
                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := Jtemplate;
                                        GenJournalLine."Journal Batch Name" := JBatch;
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                        GenJournalLine."Account No." := LoanApps."Account No";
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine."Document No." := "Document No";
                                        GenJournalLine."Posting Date" := "Posting Date";
                                        GenJournalLine.Description := 'Top Up for ' + LoanApps."Loan Product Type" + ' Loan.';
                                        GenJournalLine.Amount := "Top Up Amount" * -1;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Loan No" := NewLoan;
                                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;
                                    end;
                            end;
                            //

                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := Jtemplate;
                            GenJournalLine."Journal Batch Name" := JBatch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := LoanApps."Account No";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := "Document No";
                            GenJournalLine."Posting Date" := "Posting Date";
                            GenJournalLine.Description := 'Crediting Interest';
                            GenJournalLine.Amount := 500;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                            GenJournalLine."Bal. Account No." := '5218';
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := Jtemplate;
                            GenJournalLine."Journal Batch Name" := JBatch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := LoanApps."Account No";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := "Document No";
                            GenJournalLine."Posting Date" := "Posting Date";
                            GenJournalLine.Description := 'FOSA Shares Recovery';
                            GenJournalLine.Amount := (("Top Up Amount" * 1) / 100);
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := Jtemplate;
                            GenJournalLine."Journal Batch Name" := JBatch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                            GenJournalLine."Account No." := "Member No";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := "Document No";
                            GenJournalLine."Posting Date" := "Posting Date";
                            GenJournalLine.Description := 'FOSA Shares';
                            GenJournalLine.Amount := (("Top Up Amount" * 1) / 100) * -1;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"FOSA Shares";
                            GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;


                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := Jtemplate;
                            GenJournalLine."Journal Batch Name" := JBatch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := LoanApps."Account No";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := "Document No";
                            GenJournalLine."Posting Date" := "Posting Date";
                            GenJournalLine.Description := 'Upfront Interest';
                            GenJournalLine.Amount := ("Top Up Amount" * 4) / 100;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                            GenJournalLine."Bal. Account No." := '5218';
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;
                            //-----------------------------------------------------------------------------------

                            //)Now post loan and  Mark the loan As posted In Loans Register
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", Jtemplate);
                            GenJournalLine.SetRange("Journal Batch Name", JBatch);
                            if GenJournalLine.Find('-') then begin
                                //---------------New Code
                                "Topped-Up" := true;
                                "Topped-Up By" := UserId;
                                Status := Status::Approved;
                                Posted := true;
                                rec.Modify(true);
                                GenJournalLine.SendToPosting(Codeunit::"Gen. Jnl.-Post");
                                //Codeunit.Run(Codeunit::"Gen. Jnl.-Post Line", GenJournalLine);

                                //4)Notify Member
                                //Message('Successfully Posted');
                                CurrPage.Close();
                            end;
                            //......................................................................
                        end;

                    end;
                }
                separator(Action1000000036)
                {
                    Caption = '-';
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Text001: label 'This request is already pending approval';
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ScheduleError: label 'Please View the Loan Schedule First';
                        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
                    begin
                        if Confirm('Send Approval Request?', false) = true then begin
                            SrestepApprovalsCodeUnit.SendLoanTopUpRequestForApproval(rec."Document No", Rec);
                        end;
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Approvalmgt: Codeunit "Approvals Mgmt.";
                        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
                    begin
                        if Confirm('Cancel Approval Request?', false) = true then begin
                            SrestepApprovalsCodeUnit.CancelLoanTopUpRequestForApproval(rec."Document No", Rec);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Status <> Status::Open then
            ApprovedEditable := false
        else
            ApprovedEditable := true;
    end;

    trigger OnOpenPage()
    begin
        if Status <> Status::Open then
            ApprovedEditable := false
        else
            ApprovedEditable := true;
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        GenBatch: Record "Gen. Journal Batch";
        LoanApps: Record "Loans Register";
        Temp: Record "Funds User Setup";
        LoanSchedule: Record "Loan Repayment Schedule";
        Cust: Record Customer;
        InsuranceContribution: Decimal;
        SharesContribution: Decimal;
        Jtemplate: Code[10];
        JBatch: Code[10];
        GenSetUp: Record "Sacco General Set-Up";
        DActivity: Code[20];
        DBranch: Code[20];
        LineNo: Integer;
        ApprovedEditable: Boolean;
        DisbAmount: Decimal;
        BalanceAfter: Decimal;
        LoansOffset: Record "Loan Offset Details";
        ScheduleError: label 'Please view the loan schedule first!';
        TotalOffset: Decimal;
        RepayCode: Code[10];
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        NewLoan: Code[30];
        RepaymentSchedule: Record "Loan Repayment Schedule";
        SurestepFactory: Codeunit "SURESTEP Factory";
        LoansReg2: Record "Loans Register";


    procedure CheckRequiredFields()
    begin
        /*TESTFIELD("New Installments");
        TESTFIELD("Top Up Date");
        TESTFIELD("Paying Bank Account");
        TESTFIELD("Cheque No.");*/

    end;


    procedure ModifyMonthly()
    begin
        /*LoanRegister.RESET;
        LoanRegister.SETRANGE(LoanRegister."Loan  No.",LoanSchedule."Loan No.");
        IF LoanRegister.FINDFIRST THEN BEGIN
          LoanRegister."Loan Principle Repayment":=LoanSchedule."Principal Repayment";
          MESSAGE('%1',LoanRegister."Loan Principle Repayment");
          LoanRegister."Loan Interest Repayment":=LoanSchedule."Monthly Interest";
          MESSAGE('%1',LoanRegister."Loan Interest Repayment");
          END;
        {LoanRegister."Loan Principle Repayment":=LoanPrinciple;
        MESSAGE('Principle repayment %1',LoanPrinciple);
        LoanRegister."Loan Interest Repayment":=LoanInterest;
        MESSAGE('Interest Repayment %1',LoanInterest);}
        //LoanRegister.MODIFY;*/
        /*
    LoanApps.RESET;
    LoanApps.SETRANGE(LoanApps."Loan  No.","Loan No");
    LoanApps.SETRANGE(LoanApps."Topped-Up",TRUE);
    IF LoanApps.FINDFIRST THEN
      LoanApps.loan*/

    end;

    local procedure FnCreateNewLoan(LoanNo: Code[20]): Code[30]
    var
        LoansRegister: Record "Loans Register";
        LoanApp: Record "Loans Register";
        SalesSetup: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        LoanApp.Reset();
        LoanApp.SetRange(LoanApp."Loan  No.", LoanNo);
        LoanApp.SetAutoCalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
        if LoanApp.Find('-') then begin
            LoansRegister.Reset();
            LoansRegister.SetRange(LoansRegister."Loan  No.", "Document No");
            if LoansRegister.Find('-') then begin
                //LoansRegister."Loan  No." := "Top Up Loan No";
                LoansRegister."Approved Amount" := "Top Up Amount";
                LoansRegister.Interest := LoanApp.Interest;
                LoansRegister."Instalment Period" := LoanApp."Instalment Period";
                LoansRegister.Installments := LoanApp.Installments;
                LoansRegister."Loan Disbursement Date" := "Posting Date";
                if Date2DMY(LoansRegister."Loan Disbursement Date", 1) <= 15 then begin
                    LoansRegister."Repayment Start Date" := CalcDate('CM', LoansRegister."Loan Disbursement Date");
                end else
                    if Date2DMY(LoansRegister."Loan Disbursement Date", 1) > 15 then begin
                        LoansRegister."Repayment Start Date" := CalcDate('CM', CalcDate('CM+1M', LoansRegister."Loan Disbursement Date"));
                    end;
                LoansRegister."Expected Date of Completion" := CALCDATE('CM', CalcDate('CM+' + Format(LoansRegister.Installments) + 'M', LoansRegister."Loan Disbursement Date"));
                LoansRegister."Requested Amount" := "Top Up Amount";
                LoansRegister."Client Code" := "Member No";
                LoansRegister."BOSA No" := LoanApp."Client Code";
                LoansRegister."Client Name" := LoanApp."Client Name";
                LoansRegister."Employer Code" := LoanApp."Employer Code";
                LoansRegister."Employer Name" := LoanApp."Employer Name";
                LoansRegister."Staff No" := LoanApp."Staff No";
                LoansRegister."Main Sector" := LoanApp."Main Sector";
                LoansRegister."Sub-Sector" := LoanApp."Sub-Sector";
                LoansRegister."Specific Sector" := LoanApp."Specific Sector";
                LoansRegister."ID NO" := LoanApp."ID NO";
                LoansRegister."Group Code" := LoanApp."Group Code";
                LoansRegister."Group Name" := LoanApp."Group Name";
                LoansRegister."Loan Officer" := LoanApp."Loan Officer";
                LoansRegister."Branch Code" := LoanApp."Branch Code";
                LoansRegister."Issued Date" := TODAY;
                LoansRegister."Repayment Start Date" := TODAY;
                LoansRegister.Source := LoanApp.Source;
                LoansRegister."Loan Disbursed Amount" := "Top Up Amount";
                LoansRegister.Gender := LoanApp.Gender;
                LoansRegister."Branch Code" := LoanApp."Branch Code";
                LoansRegister."No. Series" := LoanApp."No. Series";
                LoansRegister."Doc No Used" := "Document No";
                IF LoanApp."Repayment Method" = LoanApp."Repayment Method"::"Reducing Balance" THEN BEGIN
                    LoansRegister."Loan Interest Repayment" := ROUND((LoansRegister.Interest / 12 / 100) * LoansRegister."Approved Amount", 0.05, '>');
                    LoansRegister."Loan Principle Repayment" := ROUND(LoansRegister."Approved Amount" / LoansRegister.Installments, 0.05, '>');
                END ELSE
                    IF LoanApp."Repayment Method" = LoanApp."Repayment Method"::Amortised THEN BEGIN
                        LoansRegister."Loan Interest Repayment" := ROUND((LoansRegister."Approved Amount" / 100 / 12) * LoansRegister.Interest, 0.05, '>');
                        LoansRegister."Loan Principle Repayment" := (ROUND((LoansRegister.Interest / 12 / 100) / (1 - POWER((1 + (LoansRegister.Interest / 12 / 100)), -LoansRegister.Installments)) * LoansRegister."Approved Amount", 1, '>')) - (LoansRegister."Loan Interest Repayment");
                    END;

                LoansRegister."Loan Repayment" := LoansRegister."Loan Interest Repayment" + LoansRegister."Loan Principle Repayment";
                LoansRegister."Approval Status" := LoansRegister."Approval Status"::Approved;
                LoansRegister."Account No" := LoanApp."Account No";
                LoansRegister."Application Date" := TODAY;
                LoansRegister.Repayment := LoansRegister."Loan Interest Repayment" + LoansRegister."Loan Principle Repayment";
                LoansRegister."Loan Product Type" := LoanApp."Loan Product Type";
                LoansRegister."Loan Product Type Name" := LoanApp."Loan Product Type";
                LoansRegister.Installments := LoanApp.Installments;
                LoansRegister."Loan Amount" := LoansRegister."Approved Amount";
                LoansRegister."Issued Date" := TODAY;
                LoansRegister."Outstanding Balance" := 0;
                LoansRegister.Posted := TRUE;
                LoansRegister."Advice Type" := LoansRegister."Advice Type"::"Top Up";
                LoansRegister."Loan Status" := LoansRegister."Loan Status"::Issued;
                LoansRegister."Posting Date" := Today;
                LoansRegister."Repayment Frequency" := LoanApp."Repayment Frequency";
                LoansRegister."Recovery Mode" := LoanApp."Recovery Mode";
                LoansRegister."Mode of Disbursement" := LoanApp."Mode of Disbursement";
                LoansRegister.Modify(TRUE);
            end;

        end;
        Message('The top Up Loan Number is %1', LoansRegister."Loan  No.");
        exit(LoansRegister."Loan  No.");
    end;
}

