#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516287 "Posted Member Withdrawal Card"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption';
    SourceTable = "Membership Withdrawals";
    SourceTableView = where(Posted = filter(false));

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
                field("Member No."; "Member No.")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Closing Date"; "Closing Date")
                {
                    ApplicationArea = Basic;
                    Editable = ClosingDateEditable;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Closure Type"; "Closure Type")
                {
                    ApplicationArea = Basic;
                    Editable = ClosureTypeEditable;
                }
                field("Total Loan"; "Total Loan")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Interest"; "Total Interest")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Member Deposits"; "Member Deposits")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Mode Of Disbursement"; "Mode Of Disbursement")
                {
                    ApplicationArea = Basic;
                }
                field("Paying Bank"; "Paying Bank")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No."; "Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field("FOSA Account No."; "FOSA Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Payee; Payee)
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
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        // DocumentType := Documenttype::"Member Closure";
                        // ApprovalEntries.SetRecordFilters(Database::"Payroll Employer Deductions", DocumentType, "No.");
                        // ApprovalEntries.Run;
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                    //ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Status <> Status::Open then
                            Error(text001);

                        //End allocate batch number
                        //IF ApprovalMgt.SendClosurelRequest(Rec) THEN;
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel A&pproval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                    //ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Status <> Status::Open then
                            Error(text001);

                        //End allocate batch number
                        //ApprovalMgt.CancelClosureApprovalRequest(Rec);
                    end;
                }
                action("Account closure Slip")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        cust.Reset;
                        cust.SetRange(cust."No.", "Member No.");
                        if cust.Find('-') then
                            Report.Run(51516250, true, false, cust);
                    end;
                }
                action("Print Cheque")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        /*
                        ClosureR.RESET;
                        ClosureR.SETRANGE(ClosureR."Member No.","Member No.");
                        IF ClosureR.FIND('-') THEN
                        REPORT.RUN(,TRUE,FALSE,ClosureR);
                        */

                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Are you absolutely sure you want to recover the loans from member deposit') = false then
                            exit;

                        if cust.Get("Member No.") then begin
                            if ("Closure Type" = "closure type"::"Withdrawal - Normal") or ("Closure Type" = "closure type"::"Withdrawal - Death(Defaulter)") then begin
                                cust."Withdrawal Fee" := 1000;

                                //Delete journal line
                                Gnljnline.Reset;
                                Gnljnline.SetRange("Journal Template Name", 'GENERAL');
                                Gnljnline.SetRange("Journal Batch Name", 'Closure');
                                Gnljnline.DeleteAll;
                                //End of deletion


                                Totalrecovered := 0;
                                TotalInsuarance := 0;

                                DActivity := cust."Global Dimension 1 Code";
                                DBranch := cust."Global Dimension 2 Code";
                                cust.CalcFields(cust."Outstanding Balance", "Accrued Interest", "Current Shares");

                                cust.CalcFields(cust."Outstanding Balance", cust."Outstanding Interest", "FOSA Outstanding Balance", "Accrued Interest", "Insurance Fund", "Current Shares");
                                TotalOustanding := cust."Outstanding Balance" + cust."Outstanding Interest";

                                //GETTING WITHDRWAL FEE
                                Generalsetup.Get();
                                cust."Withdrawal Fee" := Generalsetup."Withdrawal Fee";
                                // END OF GETTING WITHDRWAL FEE

                                LineNo := LineNo + 10000;
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                GenJournalLine."Journal Batch Name" := 'Closure';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Document No." := "No.";
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine."External Document No." := "No.";
                                GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                GenJournalLine."Account No." := "Member No.";
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine.Description := 'Withdrawal Fee';
                                GenJournalLine.Amount := Generalsetup."Withdrawal Fee";
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                                GenJournalLine."Bal. Account No." := Generalsetup."Withdrawal Fee Account";
                                GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                                GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;
                                Totalrecovered := Totalrecovered + GenJournalLine.Amount;
                                cust."Closing Deposit Balance" := (cust."Current Shares" - cust."Withdrawal Fee");



                                if cust."Closing Deposit Balance" > 0 then begin
                                    "Remaining Amount" := cust."Closing Deposit Balance";

                                    LoansR.Reset;
                                    LoansR.SetRange(LoansR."Client Code", "Member No.");
                                    LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                                    if LoansR.Find('-') then begin
                                        repeat
                                            LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest", LoansR."Loans Insurance");
                                            TotalInsuarance := TotalInsuarance + LoansR."Loans Insurance";
                                        until LoansR.Next = 0;
                                    end;
                                end;

                                LoansR.Reset;
                                LoansR.SetRange(LoansR."Client Code", "Member No.");
                                LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                                if LoansR.Find('-') then begin
                                    repeat
                                        "AMOUNTTO BE RECOVERED" := 0;
                                        LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest", LoansR."Loans Insurance");



                                        //Loan Insurance
                                        LineNo := LineNo + 10000;
                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'Closure';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Document No." := "No.";
                                        GenJournalLine."Posting Date" := Today;
                                        GenJournalLine."External Document No." := "No.";
                                        GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                        GenJournalLine."Account No." := "Member No.";
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine.Description := 'Cleared by deposits: ' + "No.";
                                        GenJournalLine.Amount := -ROUND(LoansR."Loans Insurance");
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Insurance Paid";
                                        GenJournalLine."Loan No" := LoansR."Loan  No.";
                                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;
                                    until LoansR.Next = 0;
                                end;

                                cust."Closing Deposit Balance" := (cust."Closing Deposit Balance" - LoansR."Loans Insurance");


                                //Capitalize Interest to Loans
                                if cust."Closing Deposit Balance" > 0 then begin
                                    "Remaining Amount" := cust."Closing Deposit Balance";

                                    LoansR.Reset;
                                    LoansR.SetRange(LoansR."Client Code", "Member No.");
                                    LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                                    if LoansR.Find('-') then begin
                                        repeat
                                            "AMOUNTTO BE RECOVERED" := 0;

                                            LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest");
                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := 'GENERAL';
                                            GenJournalLine."Journal Batch Name" := 'Closure';
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Document No." := "No.";
                                            GenJournalLine."Posting Date" := Today;
                                            GenJournalLine."External Document No." := "No.";
                                            GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                            GenJournalLine."Account No." := "Member No.";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine.Description := 'Interest Capitalized: ' + "No.";
                                            GenJournalLine.Amount := -ROUND(LoansR."Oustanding Interest");
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";
                                            GenJournalLine."Loan No" := LoansR."Loan  No.";
                                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;


                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := 'GENERAL';
                                            GenJournalLine."Journal Batch Name" := 'Closure';
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Document No." := "No.";
                                            GenJournalLine."Posting Date" := Today;
                                            GenJournalLine."External Document No." := "No.";
                                            GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                            GenJournalLine."Account No." := "Member No.";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine.Description := 'Interest Capitalized: ' + "No.";
                                            GenJournalLine.Amount := ROUND(LoansR."Oustanding Interest");
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Loan;
                                            GenJournalLine."Loan No" := LoansR."Loan  No.";
                                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                        until LoansR.Next = 0;
                                    end;
                                end;
                                ////End of Capitalize Interest to Loans




                                //GET LOANS TO RECOVER

                                LoansR.Reset;
                                LoansR.SetRange(LoansR."Client Code", "Member No.");
                                LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                                if LoansR.Find('-') then begin
                                    repeat
                                        LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest", LoansR."Loans Insurance");
                                        if LoansR."Outstanding Balance" > 0 then begin
                                            //Loans Outstanding
                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := 'GENERAL';
                                            GenJournalLine."Journal Batch Name" := 'Closure';
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Document No." := "No.";
                                            GenJournalLine."Posting Date" := Today;
                                            GenJournalLine."External Document No." := "No.";
                                            GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                            GenJournalLine."Account No." := "Member No.";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine.Description := 'Cleared by deposits: ' + "No.";
                                            GenJournalLine.Amount := -ROUND(LoansR."Outstanding Balance" + LoansR."Oustanding Interest");
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                                            GenJournalLine."Loan No" := LoansR."Loan  No.";
                                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                            TotalLoansOut := "Total Loan" + "Total Interest";
                                        end;
                                    until LoansR.Next = 0;
                                end;

                                //RECOVER LOANS FROM DEPOIST
                                LineNo := LineNo + 10000;
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                GenJournalLine."Journal Batch Name" := 'Closure';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Document No." := "No.";
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine."External Document No." := "No.";
                                GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                GenJournalLine."Account No." := "Member No.";
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine.Description := 'Loans Recovered From Shares: ' + "No.";
                                GenJournalLine.Amount := ROUND(TotalLoansOut);
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                                GenJournalLine."Loan No" := LoansR."Loan  No.";
                                GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;
                                cust."Closing Deposit Balance" := (cust."Closing Deposit Balance" - TotalLoansOut);


                                //AMOUNT PAYABLE TO THE MEMBER
                                if cust."Closing Deposit Balance" > 0 then begin

                                    //***DEBIT MEMBER DEPOSITS
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Closure';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."External Document No." := "No.";
                                    GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                    GenJournalLine."Account No." := "Member No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine.Description := 'Account Closure No: ' + "No.";
                                    GenJournalLine.Amount := cust."Closing Deposit Balance";
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;

                                    //***CREDIT PAYING BANK
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Closure';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."External Document No." := "Cheque No.";
                                    GenJournalLine."Account Type" := GenJournalLine."bal. account type"::"Bank Account";
                                    GenJournalLine."Account No." := "Paying Bank";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine.Description := 'Account Closure No: ' + "No.";
                                    GenJournalLine.Amount := -cust."Closing Deposit Balance";
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                end;
                            end;
                        end;




                        //ACCOUNT CLOSURE-DEATH

                        if "Closure Type" = "closure type"::"Withdrawal - Death" then begin
                            //Transfer Deposits
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'Closure';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Document No." := "No.";
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine."External Document No." := "No.";
                            if "Mode Of Disbursement" = "mode of disbursement"::"FOSA Transfer" then
                                GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Vendor;
                            GenJournalLine."Account No." := cust."FOSA Account";

                            if "Mode Of Disbursement" = "mode of disbursement"::Cheque then
                                GenJournalLine."Account Type" := GenJournalLine."bal. account type"::"Bank Account";
                            GenJournalLine."Account No." := "Paying Bank";

                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine.Description := 'Member Withdrawal' + ' ' + "Member No.";
                            GenJournalLine.Amount := -("Member Deposits");
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;



                            //Deposit
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'Closure';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Document No." := "No.";
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine."External Document No." := "No.";
                            GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                            GenJournalLine."Account No." := "Member No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine.Description := 'Membership Closure';
                            GenJournalLine.Amount := "Member Deposits";
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;



                            //Funeral Expense
                            Generalsetup.Get();

                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'Closure';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Document No." := "No.";
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine."External Document No." := "No.";
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                            GenJournalLine."Account No." := "Paying Bank";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine.Description := 'Member Withdrawal(Death)' + ' ' + "Member No.";
                            //GenJournalLine.Amount := -Generalsetup."Funeral Expense Amount";
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                            GenJournalLine."Bal. Account No." := Generalsetup."Funeral Expenses Account";
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;
                        end;





                        //Post New
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'Closure');
                        if GenJournalLine.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);
                        end;



                        Message('Closure posted successfully.');


                        //CHANGE ACCOUNT STATUS
                        cust.Reset;
                        cust.SetRange(cust."No.", "Member No.");
                        if cust.Find('-') then begin
                            cust.Status := cust.Status::Withdrawal;
                            cust.Blocked := cust.Blocked::All;
                            cust.Modify;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
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
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff;
        MNoEditable: Boolean;
        ClosingDateEditable: Boolean;
        ClosureTypeEditable: Boolean;
        TotalFOSALoan: Decimal;
        TotalInsuarance: Decimal;
        DActivity: Code[30];
        DBranch: Code[30];
        LineNo: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        "Remaining Amount": Decimal;
        LoansR: Record "Loans Register";
        "AMOUNTTO BE RECOVERED": Decimal;
        PrincipInt: Decimal;
        TotalLoansOut: Decimal;
        ClosureR: Record "Membership Withdrawals";


    procedure UpdateControl()
    begin
        if Status = Status::Open then begin
            MNoEditable := true;
            ClosingDateEditable := false;
            ClosureTypeEditable := true;
        end;

        if Status = Status::Pending then begin
            MNoEditable := false;
            ClosingDateEditable := false;
            ClosureTypeEditable := false
        end;

        if Status = Status::Rejected then begin
            MNoEditable := false;
            ClosingDateEditable := false;
            ClosureTypeEditable := false;
        end;

        if Status = Status::Approved then begin
            MNoEditable := false;
            ClosingDateEditable := true;
            ClosureTypeEditable := false;
        end;
    end;
}

