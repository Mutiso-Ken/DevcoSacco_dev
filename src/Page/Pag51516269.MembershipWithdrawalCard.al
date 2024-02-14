#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516269 "Membership Withdrawal Card"
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
                field("BBF Amount"; "BBF Amount")
                {
                    ApplicationArea = Basic;
                    Editable = true;
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
                field("With Notice"; "With Notice")
                {
                    ApplicationArea = Basic;
                    Caption = 'With Notice?';
                }
                field(Charges; Charges)
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                        DocumentType := Documenttype::"Member Withdrawal";
                        ApprovalEntries.SetRecordFilters(Database::"Membership Withdrawals", DocumentType, "No.");
                        ApprovalEntries.Run;
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
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        if Status <> Status::Open then
                            Error(text001);


                        // if ApprovalMgt.CheckMemberWithdrawalWorkflowEnabled(Rec) then
                        //   ApprovalMgt.OnSendMemberWithdrawalForApproval(Rec);

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
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        if Status <> Status::Open then
                            Error(text001);
                        //ApprovalMgt.OnCancelMemberWithdrawalApprovalRequest(Rec);


                    end;
                }
                action("Account closure Slip")
                {
                    ApplicationArea = Basic;
                    Image = Print;
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
                    Visible = false;

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
                            if ("Closure Type" = "closure type"::"Withdrawal - Normal") or ("Closure Type" = "closure type"::"Withdrawal - Death(Defaulter)") or ("Closure Type" = "closure type"::"Withdrawal - Death")
                               then begin
                                //cust."Withdrawal Fee":=1000;

                                //Delete journal line
                                Gnljnline.Reset;
                                Gnljnline.SetRange("Journal Template Name", 'GENERAL');
                                Gnljnline.SetRange("Journal Batch Name", 'Closure');
                                Gnljnline.DeleteAll;
                                //End of deletion


                                Totalrecovered := 0;
                                TotalInsuarance := 0;
                                RunBal := 0;
                                runbal1 := 0;
                                NetBal := RunBal + ("BBF Amount" + Vend.Balance - runbal1);// net deposits

                                DActivity := cust."Global Dimension 1 Code";
                                DBranch := cust."Global Dimension 2 Code";
                                cust.CalcFields(cust."Outstanding Balance", "Accrued Interest", "Current Shares");

                                cust.CalcFields(cust."Outstanding Balance", cust."Outstanding Interest", "FOSA Outstanding Balance", "Accrued Interest", "Insurance Fund", cust."Current Shares");
                                TotalOustanding := cust."Outstanding Balance" + cust."Outstanding Interest";
                                RunBal := "Member Deposits";
                                //GETTING WITHDRWAL FEE
                                Generalsetup.Get();
                                //cust."Withdrawal Fee":= ClosureR.Charges;
                                //Charges:=0;
                                //ClosureR.Charges:=0;
                                //Charges:=ClosureR.Charges;
                                //Generalsetup."Withdrawal Fee";
                                // END OF GETTING WITHDRWAL FEE

                                //MESSAGE('%1',Charges);
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
                                //GenJournalLine.Amount:=Charges*-1; //Generalsetup."Withdrawal Fee";
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Withdrawal;
                                //GenJournalLine."Bal. Account No." :=Generalsetup."Withdrawal Fee Account";
                                //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;
                                TotalAdd += GenJournalLine.Amount;
                                runbal1 := runbal1 + (GenJournalLine.Amount * -1);
                                //Totalrecovered:=Totalrecovered+GenJournalLine.Amount;
                                //cust."Closing Deposit Balance":=(cust."Current Shares"-cust."Withdrawal Fee");


                                if RunBal > 0 then begin
                                    //withdrawal commision
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Closure';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."External Document No." := "No.";
                                    GenJournalLine."Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                                    GenJournalLine."Account No." := Generalsetup."Withdrawal Fee Account";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine.Description := 'Withdrawal commision';
                                    GenJournalLine.Amount := -Charges;//Generalsetup."Withdrawal Commision";
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                    //GenJournalLine."Bal. Account No." :=Generalsetup."Withdrawal Fee Account";
                                    //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                    TotalAdd += GenJournalLine.Amount;
                                    runbal1 := runbal1 + (GenJournalLine.Amount * -1);
                                end;

                                if RunBal > 0 then begin
                                    //excise duty on withdrawal
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Closure';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."External Document No." := "No.";
                                    GenJournalLine."Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                                    GenJournalLine."Account No." := Generalsetup."Excise Duty Account";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine.Description := 'excise Duty';
                                    GenJournalLine.Amount := -(Charges * (Generalsetup."Excise Duty(%)" / 100));
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                    //GenJournalLine."Bal. Account No." :=Generalsetup."Withdrawal Fee Account";
                                    //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                    TotalAdd += GenJournalLine.Amount;
                                    runbal1 := runbal1 + (GenJournalLine.Amount * -1);
                                end;

                                //BBF
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
                                GenJournalLine.Description := 'BBF amount';
                                GenJournalLine.Amount := "BBF Amount";
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Benevolent Fund";
                                //GenJournalLine."Bal. Account No." :=Generalsetup."Withdrawal Fee Account";
                                //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;
                                TotalAdd += GenJournalLine.Amount;
                                //RunBal:=RunBal+(GenJournalLine.Amount*-1);

                                //Totalrecovered:=Totalrecovered+GenJournalLine.Amount;
                                //cust."Closing Deposit Balance":=(cust."Current Shares"-cust."Withdrawal Fee");
                                if Vend.Get("FOSA Account No.") then begin
                                    Vend.CalcFields(Vend.Balance);
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Closure';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."External Document No." := "No.";
                                    GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Vendor;
                                    GenJournalLine."Account No." := Vend."No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine.Description := 'ORDINARY withdrawal';
                                    GenJournalLine.Amount := Vend.Balance;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Benevolent Fund";
                                    //GenJournalLine."Bal. Account No." :=Generalsetup."Withdrawal Fee Account";
                                    //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                    TotalAdd += GenJournalLine.Amount;
                                end;

                                if RunBal > 0 then begin
                                    //"Remaining Amount":=cust."Closing Deposit Balance";

                                    LoansR.Reset;
                                    LoansR.SetRange(LoansR."Client Code", "Member No.");
                                    LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                                    if LoansR.Find('-') then begin

                                        repeat
                                            LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest");
                                            TotalInsuarance := TotalInsuarance + LoansR."Loans Insurance";
                                        until LoansR.Next = 0;
                                    end;


                                    LoansR.Reset;
                                    LoansR.SetRange(LoansR."Client Code", "Member No.");
                                    LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                                    if LoansR.Find('-') then begin
                                        repeat
                                            "AMOUNTTO BE RECOVERED" := 0;
                                            LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest");

                                            Linterest := "Total Interest";

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
                                        //RunBal:=RunBal-(GenJournalLine.Amount*-1);
                                        until LoansR.Next = 0;
                                    end;
                                end;
                                cust."Closing Deposit Balance" := (cust."Closing Deposit Balance" - LoansR."Loans Insurance");

                                TotalLoansOut := 0;
                                //Capitalize Interest to Loans
                                if RunBal > 0 then begin
                                    "Remaining Amount" := cust."Closing Deposit Balance";

                                    LoansR.Reset;
                                    LoansR.SetRange(LoansR."Client Code", "Member No.");
                                    LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                                    if LoansR.Find('-') then begin
                                        repeat
                                            "AMOUNTTO BE RECOVERED" := 0;

                                            LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest");
                                            Linterest := LoansR."Oustanding Interest";

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
                                            GenJournalLine.Description := 'Interest Offset: ' + "No.";
                                            if RunBal < Linterest then
                                                GenJournalLine.Amount := -1 * RunBal
                                            else
                                                GenJournalLine.Amount := -1 * Linterest;
                                            //GenJournalLine.Amount:=-ROUND(LoansR."Oustanding Interest");
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";
                                            GenJournalLine."Loan No" := LoansR."Loan  No.";
                                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                            //RunBal:=RunBal-(GenJournalLine.Amount*-1);
                                            TotalLoansOut := TotalLoansOut + (GenJournalLine.Amount * -1)
                                        /*
                                        LineNo:=LineNo+10000;
                                        GenJournalLine.INIT;
                                        GenJournalLine."Journal Template Name":='GENERAL';
                                        GenJournalLine."Journal Batch Name":='Closure';
                                        GenJournalLine."Line No.":=LineNo;
                                        GenJournalLine."Document No.":="No.";
                                        GenJournalLine."Posting Date":=TODAY;
                                        GenJournalLine."External Document No.":="No.";
                                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                        GenJournalLine."Account No.":="Member No.";
                                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                        GenJournalLine.Description:='Interest Capitalized: ' + "No.";
                                        GenJournalLine.Amount:=ROUND(LoansR."Oustanding Interest");
                                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                        GenJournalLine."Loan No":=LoansR."Loan  No.";
                                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                        IF GenJournalLine.Amount<>0 THEN
                                        GenJournalLine.INSERT;

                                        */
                                        until LoansR.Next = 0;
                                    end;
                                end;
                                ////End of Capitalize Interest to Loans

                                Lprinciple := 0;

                                if RunBal > 0 then begin
                                    //GET LOANS TO RECOVER

                                    LoansR.Reset;
                                    LoansR.SetRange(LoansR."Client Code", "Member No.");
                                    LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                                    if LoansR.Find('-') then begin
                                        repeat
                                            LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest");
                                            Lprinciple := LoansR."Outstanding Balance";
                                            //IF Lprinciple >0 THEN BEGIN
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
                                            GenJournalLine.Description := 'Loan Cleared by deposits: ' + "No.";
                                            if RunBal < Lprinciple then
                                                GenJournalLine.Amount := -1 * RunBal
                                            else
                                                GenJournalLine.Amount := -1 * Lprinciple;
                                            //GenJournalLine.Amount:=-ROUND(LoansR."Outstanding Balance"+LoansR."Oustanding Interest");
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                                            GenJournalLine."Loan No" := LoansR."Loan  No.";
                                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                            TotalLoansOut := TotalLoansOut + (GenJournalLine.Amount * -1);
                                        //RunBal:=RunBal-(GenJournalLine.Amount*1);
                                        //TotalLoansOut:="Total Loan"+"Total Interest";
                                        //END;
                                        until LoansR.Next = 0;
                                    end;
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
                                RunBal := RunBal - (GenJournalLine.Amount);
                                cust."Closing Deposit Balance" := (cust."Closing Deposit Balance" - TotalLoansOut);


                                //AMOUNT PAYABLE TO THE MEMBER
                                if RunBal > 0 then begin

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
                                    GenJournalLine.Amount := RunBal;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;


                                    //***CREDIT PAYING BANK
                                    //transfer to FOSA
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Closure';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."External Document No." := "Cheque No.";
                                    GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Vendor;
                                    GenJournalLine."Account No." := "FOSA Account No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine.Description := 'Account Closure No: ' + "No.";
                                    GenJournalLine.Amount := -(RunBal + "BBF Amount" + Vend.Balance - runbal1);
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



                        /*
                        //ACCOUNT CLOSURE-DEATH
                        
                        IF "Closure Type"="Closure Type"::"Withdrawal - Death" THEN BEGIN
                        //Transfer Deposits
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Closure';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        IF "Mode Of Disbursement"="Mode Of Disbursement"::"FOSA Transfer" THEN
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                        GenJournalLine."Account No.":=cust."FOSA Account";
                        
                        IF "Mode Of Disbursement"="Mode Of Disbursement"::Cheque THEN
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                        GenJournalLine."Account No.":="Paying Bank";
                        
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Member Withdrawal'+' '+"Member No.";
                        GenJournalLine.Amount:=-("Member Deposits");
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        
                        
                        
                        //Deposit
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Closure';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                        GenJournalLine."Account No.":="Member No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Membership Closure';
                        GenJournalLine.Amount:="Member Deposits";
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        
                        
                        
                        //Funeral Expense
                        Generalsetup.GET();
                        
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Closure';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                        GenJournalLine."Account No.":="Paying Bank";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Member Withdrawal(Death)'+' '+"Member No.";
                        GenJournalLine.Amount:=-Generalsetup."Funeral Expense Amount";
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                        GenJournalLine."Bal. Account No.":=Generalsetup."Funeral Expenses Account";
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        END;
                        */




                        //Post New
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'Closure');
                        if GenJournalLine.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);
                        end;


                        //Posted:=TRUE;
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
                action("RE-OPEN")
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
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","FOSA Opening","Loan Batching",Leave,"Imprest Requisition","Imprest Surrender","Stores Requisition","Funds Transfer","Change Request","Staff Claims","BOSA Transfer","Loan Tranche","Loan TopUp","Memb Opening","Member Withdrawal";
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
        Table_id: Integer;
        Doc_No: Code[20];
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","FOSA Opening","Loan Batching",Leave,"Imprest Requisition","Imprest Surrender","Stores Requisition","Funds Transfer","Change Request","Staff Claims","BOSA Transfer","Loan Tranche","Loan TopUp","Memb Opening","Member Withdrawal";
        TotalAdd: Decimal;
        RunBal: Decimal;
        Linterest: Decimal;
        Lprinciple: Decimal;
        runbal1: Decimal;
        memberwithdrawal: Integer;
        NetBal: Decimal;


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

