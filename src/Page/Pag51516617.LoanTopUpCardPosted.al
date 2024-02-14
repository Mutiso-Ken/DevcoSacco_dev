#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516617 "Loan Top-Up Card-Posted"
{
    Caption = 'Loan Refinance Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Loan Top Up.";
    SourceTableView = where(Posted = const(true));

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
                    begin
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
            group("Active Schedule")
            {
                Editable = ApprovedEditable;
                field("Is Active"; "Is Active")
                {
                    ApplicationArea = Basic;
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
                action(Guarantors)
                {
                    ApplicationArea = Basic;
                    Caption = 'Guarantors';
                    Image = ItemGroup;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loans Guarantee Details";
                    RunPageLink = "Loan No" = field("Loan No");
                }
                action(Securities)
                {
                    ApplicationArea = Basic;
                    Image = FixedAssets;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Collateral Security";
                    RunPageLink = "Loan No" = field("Loan No");
                }
                action("View Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Schedule';
                    Image = Holiday;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        LoanRegister: Record "Loans Register";
                        LoanSchedule: Record "Loan Repayment Schedule";
                        Installments: Integer;
                        DisbAmount: Decimal;
                        LoanTranche: Record "Loan Top Up.";
                        LoanAmount: Decimal;
                        LoanBal: Decimal;
                        InterestRate: Decimal;
                        RepayDate: Date;
                        LoanInterest: Decimal;
                        LoanPrinciple: Decimal;
                        SharesTxt: label 'Include monthly shares in the schedule?';
                        LoanDisbursed: Decimal;
                        Cust: Record Customer;
                        InstalNo: Integer;
                    begin
                        TestField("Top Up Amount");
                        TestField("New Installments");

                        LoanRegister.Reset;
                        LoanRegister.SetRange(LoanRegister."Loan  No.", "Loan No");
                        if LoanRegister.FindFirst then begin
                            LoanRegister.TestField(LoanRegister.Installments);
                            LoanRegister.TestField(LoanRegister.Interest);
                            LoanRegister.TestField(LoanRegister."Repayment Frequency");

                            //Delete Schedule:
                            LoanSchedule.Reset;
                            LoanSchedule.SetRange(LoanSchedule."Loan No.", LoanRegister."Loan  No.");
                            LoanSchedule.SetRange(LoanSchedule."Top Up Code", "Document No");
                            LoanSchedule.DeleteAll;
                            //End of Delete Schedule

                            LoanAmount := "Top Up Amount" + "Outstanding Loan Amount";
                            LoanBal := LoanAmount;
                            InterestRate := LoanRegister.Interest;
                            Installments := "New Installments";
                            RepayDate := "Top Up Date";
                            InstalNo := 0;

                            repeat
                                InstalNo := InstalNo + 1;

                                //Repayment Frequency
                                if LoanRegister."Repayment Frequency" = LoanRegister."repayment frequency"::Daily then
                                    RepayDate := CalcDate('1D', RepayDate)
                                else
                                    if LoanRegister."Repayment Frequency" = LoanRegister."repayment frequency"::Weekly then
                                        RepayDate := CalcDate('1W', RepayDate)
                                    else
                                        if LoanRegister."Repayment Frequency" = LoanRegister."repayment frequency"::Monthly then
                                            RepayDate := CalcDate('1M', RepayDate)
                                        else
                                            if LoanRegister."Repayment Frequency" = LoanRegister."repayment frequency"::Quaterly then
                                                RepayDate := CalcDate('1Q', RepayDate);
                                //Repayment Frequency

                                if LoanRegister."Repayment Method" = LoanRegister."repayment method"::"Reducing Balance" then begin
                                    LoanPrinciple := ROUND(LoanAmount / Installments, 1, '=');
                                    LoanInterest := ROUND((InterestRate / 12 / 100) * LoanBal, 1, '=');
                                end else
                                    if LoanRegister."Repayment Method" = LoanRegister."repayment method"::"Straight Line" then begin
                                        LoanPrinciple := ROUND(LoanAmount / Installments, 1, '=');
                                        LoanInterest := ROUND((InterestRate / 12 / 100) * LoanAmount, 1, '=');
                                    end;
                                Evaluate(RepayCode, Format(InstalNo));

                                LoanBal := LoanBal - LoanPrinciple;
                                LoanSchedule.Init;
                                LoanSchedule."Repayment Code" := RepayCode;
                                LoanSchedule."Top Up Code" := "Document No";
                                LoanSchedule."Loan No." := LoanRegister."Loan  No.";
                                LoanSchedule."Loan Amount" := LoanAmount;
                                LoanSchedule."Instalment No" := InstalNo;
                                LoanSchedule."Repayment Date" := RepayDate;//CALCDATE('CM',RepayDate);
                                LoanSchedule."Member No." := LoanRegister."Client Code";
                                LoanSchedule."Loan Category" := LoanRegister."Loan Product Type";
                                LoanSchedule."Monthly Repayment" := LoanInterest + LoanPrinciple;
                                LoanSchedule."Monthly Interest" := LoanInterest;
                                LoanSchedule."Principal Repayment" := LoanPrinciple;
                                /*LoanSchedule."Repayment Day":=DATE2DMY(RepayDate,1);
                                LoanSchedule."Repayment Month":=DATE2DMY(RepayDate,2);
                                LoanSchedule."Repayment Year":=DATE2DMY(RepayDate,3);
                                LoanSchedule."Loan Balance":=LoanBal;*/

                                if "Is Active" = true then begin
                                    LoanSchedule."Active Schedule" := true;
                                end;
                                LoanSchedule.Insert;
                            until LoanBal < 1;

                            LoanSchedule.Reset;
                            LoanSchedule.SetRange(LoanSchedule."Loan No.", "Loan No");
                            LoanSchedule.SetFilter(LoanSchedule."Top Up Code", '<>%1', "Document No");
                            if LoanSchedule.Find('-') then begin
                                repeat
                                    if "Is Active" = true then begin
                                        LoanSchedule."Active Schedule" := false;
                                        LoanSchedule.Modify;
                                    end;
                                until LoanSchedule.Next = 0;
                            end;
                        end;

                        LoanApps.Reset;
                        LoanApps.SetRange(LoanApps."Loan  No.", "Loan No");
                        if LoanApps.FindFirst then begin
                            LoanApps."Approved Amount" := "Outstanding Loan Amount" + "Top Up Amount";
                            LoanApps."Requested Amount" := "Outstanding Loan Amount" + "Top Up Amount";
                            LoanApps.Installments := "New Installments";
                            LoanApps."Loan Principle Repayment" := LoanPrinciple;
                            //LoanApps.Repayment:=LoanInterest+LoanPrinciple;
                            //LoanApps."Loan Interest Repayment":=LoanInterest;
                            LoanApps.Modify;
                        end;

                        Commit;

                        LoanRegister.Reset;
                        LoanRegister.SetRange(LoanRegister."Loan  No.", "Loan No");
                        if LoanRegister.Find('-') then begin
                            Report.Run(51516477, true, false, LoanRegister);
                        end;

                    end;
                }
                action("Post Loan Appeal")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Topup';
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

                        "Approved Amount" := ("Top Up Amount" + "Outstanding Loan Amount");
                        Validate("Approved Amount");
                        Modify;

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
                                Error('Loan has already been posted. - ' + LoanApps."Loan  No.");

                            //Generate and post Approved Loan Amount
                            if not GenBatch.Get(Jtemplate, JBatch) then begin
                                GenBatch.Init;
                                GenBatch."Journal Template Name" := Jtemplate;
                                GenBatch.Name := JBatch;
                                GenBatch.Insert;
                            end;

                            //principal amount
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
                            GenJournalLine.Description := 'Top Up Amount';
                            GenJournalLine.Amount := "Top Up Amount";
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Loan No" := "Loan No";
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;


                            LoanApps.Reset;
                            LoanApps.SetRange(LoanApps."Loan  No.", "Loan No");
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
                                    GenJournalLine."Loan No" := "Loan No";
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
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
                                        GenJournalLine."Loan No" := "Loan No";
                                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;
                                    end;
                            end;

                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := Jtemplate;
                            GenJournalLine."Journal Batch Name" := JBatch;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := LoanApps."Account No";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No." := "Document No";
                            //GenJournalLine."External Document No.":=LoanApps."Loan Appealed Cheque Number";
                            GenJournalLine."Posting Date" := "Posting Date";
                            GenJournalLine.Description := 'Top Up Fee';
                            //LoanApps.CALCFIELDS(LoanApps."Outstanding Balance");
                            GenJournalLine.Amount := ("Top Up Amount" * 0.01);
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                            GenJournalLine."Bal. Account No." := '5411';
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                        end;

                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := Jtemplate;
                        GenJournalLine."Journal Batch Name" := JBatch;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                        GenJournalLine."Account No." := LoanApps."Account No";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := "Document No";
                        //GenJournalLine."External Document No.":=LoanApps."Loan Appealed Cheque Number";
                        GenJournalLine."Posting Date" := "Posting Date";
                        GenJournalLine.Description := 'Loan Crediting Fee';
                        GenJournalLine.Amount := 500;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := '5410';
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
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
                        //GenJournalLine."External Document No.":=LoanApps."Loan Appealed Cheque Number";
                        GenJournalLine."Posting Date" := "Posting Date";
                        GenJournalLine.Description := 'Excise Duty on Crediting Fee';
                        GenJournalLine.Amount := 50;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := '3326';
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
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
                        //GenJournalLine."External Document No.":=LoanApps."Loan Appealed Cheque Number";
                        GenJournalLine."Posting Date" := "Posting Date";
                        GenJournalLine.Description := 'FOSA Shares Recovery';
                        GenJournalLine.Amount := (("Top Up Amount" * 0.5) / 100);
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
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
                        //GenJournalLine."External Document No.":=LoanApps."Loan Appealed Cheque Number";
                        GenJournalLine."Posting Date" := "Posting Date";
                        GenJournalLine.Description := 'FOSA Shares';
                        GenJournalLine.Amount := (("Top Up Amount" * 0.5) / 100) * -1;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"FOSA Shares";
                        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
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
                        //GenJournalLine."External Document No.":=LoanApps."Loan Appealed Cheque Number";
                        GenJournalLine."Posting Date" := "Posting Date";
                        GenJournalLine.Description := 'UnWithdrawable Deposits Recovery';
                        GenJournalLine.Amount := (("Top Up Amount" * 0.5) / 100);
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
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
                        //GenJournalLine."External Document No.":=LoanApps."Loan Appealed Cheque Number";
                        GenJournalLine."Posting Date" := "Posting Date";
                        GenJournalLine.Description := 'UnWithdrawable Deposits';
                        GenJournalLine.Amount := (("Top Up Amount" * 0.5) / 100) * -1;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                        GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
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
                        //GenJournalLine."External Document No.":=LoanApps."Loan Appealed Cheque Number";
                        GenJournalLine."Posting Date" := "Posting Date";
                        GenJournalLine.Description := 'Loan Insuarance';
                        GenJournalLine.Amount := ("Top Up Amount" * 1.75) / 100;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := '5406';
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
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
                        //GenJournalLine."External Document No.":=LoanApps."Loan Appealed Cheque Number";
                        GenJournalLine."Posting Date" := "Posting Date";
                        GenJournalLine.Description := 'Loan Form Fee';
                        GenJournalLine.Amount := ("Top Up Amount" * 0.75) / 100;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := '5408';
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //Post
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
                        GenJournalLine.SetRange("Journal Batch Name", JBatch);
                        if GenJournalLine.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);
                        end;

                        LoanApps."Appeal Posted" := true;
                        LoanApps.Modify;
                        Message('Loan Top Up Posted Successfully.');
                    end;
                }
                separator(Action1000000036)
                {
                    Caption = '-';
                }
                action(Approval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","FOSA Opening","Loan Batching",Leave,"Imprest Requisition","Imprest Surrender","Stores Requisition","Funds Transfer","Change Request","Staff Claims","BOSA Transfer","Loan Tranche","Loan TopUp","Memb Opening","Member Withdrawal";
                    begin
                        DocumentType := Documenttype::"Loan TopUp";
                        ApprovalEntries.SetRecordFilters(Database::"Loan Top Up.", DocumentType, "Document No");
                        ApprovalEntries.Run;
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Text001: label 'This request is already pending approval';
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ScheduleError: label 'Please View the Loan Schedule First';
                    begin
                        LoanSchedule.Reset;
                        LoanSchedule.SetRange(LoanSchedule."Loan No.", "Loan No");
                        LoanSchedule.SetRange(LoanSchedule."Top Up Code", "Document No");
                        if not LoanSchedule.FindFirst then begin
                            Error(ScheduleError);
                        end;

                        // if ApprovalsMgmt.CheckLoanTopUpWorkflowEnabled(Rec) then
                        //   ApprovalsMgmt.OnSendLoanTopUpForApproval(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Approvalmgt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.OnCancelLoanTopUpApprovalRequest(Rec);
                    end;
                }
                action(open)
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    begin
                        Status := Status::Open;
                        Modify;
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
}

