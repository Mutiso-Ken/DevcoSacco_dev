#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516901 "Tea Pay Out Processing"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = Transactions;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Account No";"Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Time";"Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Type";"Cheque Type")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Post Dated";"Post Dated")
                {
                    ApplicationArea = Basic;
                }
                field("Clearing Charges";"Clearing Charges")
                {
                    ApplicationArea = Basic;
                }
                field("Clearing Days";"Clearing Days")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No";"Cheque No")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Date";"Cheque Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Maturity Date";"Expected Maturity Date")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Schedule Amount";"Schedule Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account";"Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted";"Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Time Posted";"Time Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posted By";"Posted By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Deposited;Deposited)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Payout;Payout)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102755027;"Transaction Schedule")
            {
                SubPageLink = No=field(No);
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
                Promoted = true;
                PromotedCategory = Process;
                RunObject = XMLport "Import Tea Payout";
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    
                    if Deposited=true then
                    Error('The cheque has already been deposited.');
                    
                    TestField("Transaction Type");
                    TestField("Cheque Type");
                    TestField("Cheque No");
                    TestField("Bank Account");
                    
                    if "Cheque Date"=0D then
                    Error('Please select the cheque date.');
                    
                    if Amount<>"Schedule Amount" then
                    Error('Amount must be equal to scheduled amount');
                      /*
                    //GET LIMITS
                    TransactionTypes.RESET;
                    IF TransactionTypes.GET("Transaction Type") THEN BEGIN
                    TransactionLimits.RESET;
                    IF TransactionLimits.GET(TransactionTypes."Limit Code") THEN BEGIN
                    IF Amount>TransactionLimits."Upper Limit" THEN
                    ERROR('The transaction amount is above the maximum limit required by this bank.');
                    IF Amount<TransactionLimits."Lower Limit" THEN
                    ERROR('The transaction amount is below the minimum limit required by this bank.');
                    END;
                    
                    END;
                    // END OF LIMITS CHECK
                      */
                    /*
                    //GET ACCOUNT LIMITS
                    TransactionsSchedule.RESET;
                    TransactionsSchedule.SETRANGE(TransactionsSchedule.No,No);
                    IF TransactionsSchedule.FIND('-') THEN BEGIN
                    AccountTypes.RESET;
                    AccountTypes.SETRANGE(AccountTypes.Code,TransactionsSchedule."Account Type");
                    IF AccountTypes.FIND('-') THEN  BEGIN
                    IF TransactionsSchedule.Amount>AccountTypes."Maximum Allowable Deposit" THEN BEGIN
                    IF Authorised=Authorised::No THEN BEGIN
                    ERROR('The deposit amount of some account holders is higher than the maximum allowable deposit for their ' +
                    'account types and therefore must be authorised.');
                    END
                    ELSE BEGIN
                    IF Authorised=Authorised::Rejected THEN BEGIN
                    ERROR('The cheque deposit transaction has been rejected and therefore cannot be processed further.');
                    END;
                    END;
                    END;
                    END;
                    
                    END;
                    
                     */
                    
                    //GET EXTERNAL TRANSFERS ACCOUNT
                    TransactionsSchedule.Reset;
                    TransactionsSchedule.SetRange(TransactionsSchedule.No,No);
                    TransactionsSchedule.SetRange(TransactionsSchedule."Transfer By EFT",TransactionsSchedule."transfer by eft"::Yes);
                    //TransactionsSchedule.SETRANGE(TransactionsSchedule."Account No",'6864010100005');
                    if TransactionsSchedule.Find('-') then begin
                    
                    //GET ACCOUNT LIMITS
                    TransactionsSchedule.Init;
                    TransactionsSchedule.SetRange(TransactionsSchedule.No,No);
                    if TransactionsSchedule.Find('-') then begin
                    
                    
                      repeat
                      if TransactionsSchedule."External Account No"='' then
                      Error('Please enter the external account no. for' + TransactionsSchedule."Account No");
                      if TransactionsSchedule."Account Name"='' then
                      Error('Please enter the external account name for' + TransactionsSchedule."Account No");
                      until TransactionsSchedule.Next=0;
                    
                    
                    end;
                    end;
                    
                    //END OF GET ACCOUNT LIMITS
                    //MESSAGE('%1',Amount);
                    //MESSAGE('%1',"Schedule Amount");
                    //CALCFIELDS("Schedule Amount");
                    //IF Amount<>"Schedule Amount" THEN
                    //ERROR('The cheque amount should tally with the schedule amount.');
                    
                    if Confirm('Are you sure you want to deposit this cheque?',false) = true then  begin
                    
                    // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange(GenJournalLine."Journal Template Name",'PURCHASES');
                    GenJournalLine.SetRange(GenJournalLine."Journal Batch Name",'PAYOUT');
                    GenJournalLine.DeleteAll;
                    
                    if DefaultBatch.Get('PURCHASES','PAYOUT') then
                    DefaultBatch.Delete;
                    
                    DefaultBatch.Reset;
                    DefaultBatch."Journal Template Name":='PURCHASES';
                    DefaultBatch.Name:='PAYOUT';
                    DefaultBatch.Insert;
                    
                    LineNo:=LineNo+10000;
                    
                    GenLedgerSetup.Get;
                    
                    //POSTING MAIN TRANSACTION
                    
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    //GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                    //GenJournalLine."Account No.":=GenLedgerSetup."Salary Clearing Account";
                    GenJournalLine."Account Type":=GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Account No.":="Bank Account";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine."Due Date":="Expected Maturity Date";
                    GenJournalLine.Description:='Payout Processing'+' ' + "Cheque No";
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=Amount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Bal. Account No.":='';
                    GenJournalLine.Insert;
                    // END JOURNALS
                    
                    /////////////////////////////////////
                    TransactionsSchedule.Reset;
                    TransactionsSchedule.SetRange(TransactionsSchedule.No,No);
                    //TransactionsSchedule.SETRANGE(TransactionsSchedule."Account No",'6864010100005');
                    
                    if TransactionsSchedule.Find('-') then begin
                    
                    repeat
                    LineNo:=LineNo+10000;
                    BalLessDed:=0;
                    BalLessDed:=TransactionsSchedule.Amount;
                    
                    GenLedgerSetup.Get;
                    
                    //POSTING MAIN TRANSACTION
                    
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":=TransactionsSchedule."Account No";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Due Date":=Today;
                    GenJournalLine.Description:='Payout Processing'+' ' + "Cheque No";
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=-TransactionsSchedule.Amount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Bal. Account No.":='';
                    GenJournalLine.Insert;
                    // END JOURNALS
                    
                    
                    //CHARGES
                    TCharges:=0;
                    
                    TransactionCharges.Reset;
                    TransactionCharges.SetRange(TransactionCharges."Transaction Type","Transaction Type");
                    if TransactionCharges.Find('-') then begin
                    
                    repeat
                    
                    
                    
                    if (TransactionsSchedule.Amount>50) and (TransactionsSchedule.Amount<1000000) then begin
                    // CurrentCharge2:=TransactionCharges."PayOut 50-100";
                     CurrentCharge2:=80;
                    end;
                    
                    LineNo:=LineNo+10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":=TransactionsSchedule."Account No";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Due Date":=Today;
                    GenJournalLine.Description:=TransactionCharges.Description;
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=CurrentCharge2;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Bal. Account No.":=TransactionCharges."G/L Account";
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                    BalLessDed:=BalLessDed-GenJournalLine.Amount;
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
                    
                    
                    TCharges:=TCharges+CurrentCharge2;
                    until TransactionCharges.Next=0;
                    end;
                    
                    
                    //excise
                    TCharges:=0;
                    
                    TransactionCharges.Reset;
                    TransactionCharges.SetRange(TransactionCharges."Transaction Type","Transaction Type");
                    if TransactionCharges.Find('-') then begin
                    
                    repeat
                    
                    
                    
                    if (TransactionsSchedule.Amount>50) and (TransactionsSchedule.Amount<1000000) then begin
                    // CurrentCharge2:=TransactionCharges."PayOut 50-100";
                     CurrentCharge2:=80;
                    end;
                    
                    LineNo:=LineNo+10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":=TransactionsSchedule."Account No";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Due Date":=Today;
                    GenJournalLine.Description:='Excise Duty';
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=CurrentCharge2*0.1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Bal. Account No.":='2-10-000195';
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                    BalLessDed:=BalLessDed-GenJournalLine.Amount;
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
                    
                    
                    
                    TCharges:=TCharges+CurrentCharge2;
                    until TransactionCharges.Next=0;
                    end;
                    
                    //excise
                    
                    //TEA LOAN
                    
                    LOANAMNT:=0;
                    INTAMNT:=0;
                    SHAREAMNT:=0;
                    AVAILAMNT:=ROUND(TransactionsSchedule.Amount*1/3);
                    
                    
                    loans.Reset;
                    loans.SetRange(loans."Client Code",TransactionsSchedule."Bosa Account No");
                    loans.SetRange(loans."Loan Product Type",'TEA');
                    loans.SetFilter(loans."Outstanding Balance",'>0');
                    if loans.Find('-') then begin
                    repeat
                    
                    loans.CalcFields("Outstanding Balance");
                    INTAMNT:=ROUND(loans."Outstanding Balance"*0.17/12);
                    LOANAMNT:=(loans."Approved Amount"/loans.Installments);
                    
                    if INTAMNT > AVAILAMNT then
                    INTAMNT:=AVAILAMNT
                    else if INTAMNT < AVAILAMNT then
                    INTAMNT:=ROUND(loans."Outstanding Balance"*0.17/12);
                    RUNBALL:=AVAILAMNT-INTAMNT;
                    
                    if LOANAMNT > RUNBALL then
                    LOANAMNT:=RUNBALL
                    else if LOANAMNT < RUNBALL then
                    LOANAMNT:=(loans."Approved Amount"/loans.Installments);
                    RUNBALL:=RUNBALL- LOANAMNT;
                    SHAREAMNT:=RUNBALL;
                    
                    
                    
                    LineNo:=LineNo+10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":=TransactionsSchedule."Account No";;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Due Date":=Today;
                    GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Description:='Repayment ' + loans."Loan Product Type";
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=LOANAMNT;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                    //GenJournalLine."Loan No":=loans."Loan  No.";
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
                    
                    LineNo:=LineNo+10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Customer;
                    GenJournalLine."Account No.":=TransactionsSchedule."Bosa Account No";;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Due Date":=Today;
                    GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Description:='Repayment ' + loans."Loan Product Type";
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=LOANAMNT*-1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::Repayment;
                    GenJournalLine."Loan No":=loans."Loan  No.";
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
                    
                    
                    LineNo:=LineNo+10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":=TransactionsSchedule."Account No";;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Due Date":=Today;
                    GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Description:='Interest Paid ' + loans."Loan Product Type";
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=INTAMNT;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                    //GenJournalLine."Loan No":=loans."Loan  No.";
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
                    
                    
                    LineNo:=LineNo+10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Customer;
                    GenJournalLine."Account No.":=TransactionsSchedule."Bosa Account No";;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Due Date":=Today;
                    GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Description:='Interest Paid ' + loans."Loan Product Type";
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=INTAMNT*-1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Interest Paid";
                    GenJournalLine."Loan No":=loans."Loan  No.";
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
                    
                    until
                    loans.Next=0
                    
                    end;
                    
                    
                    
                    cust.Reset;
                    cust.SetRange(cust."No.",TransactionsSchedule."Bosa Account No");
                    if cust.Find('-') then begin
                    
                    loans.Reset;
                    loans.SetRange(loans."Client Code",TransactionsSchedule."Bosa Account No");
                    loans.SetRange(loans."Loan Product Type",'TEA');
                    if loans.Find('-') then begin
                    repeat
                    
                    LineNo:=LineNo+10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":=TransactionsSchedule."Account No";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Due Date":=Today;
                    GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Description:='Deposit Contribution';
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=SHAREAMNT;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                    //GenJournalLine."Loan No":=loans."Loan  No.";
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
                    
                    LineNo:=LineNo+10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='PAYOUT';
                    GenJournalLine."Document No.":=No;
                    GenJournalLine."External Document No.":="Cheque No";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Customer;
                    GenJournalLine."Account No.":=TransactionsSchedule."Bosa Account No";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":=Today;
                    GenJournalLine."Due Date":=Today;
                    GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Description:='Deposit Contribution';
                    GenJournalLine."Currency Code":="Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=SHAREAMNT*-1;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Deposit Contribution";
                    GenJournalLine."Loan No":=loans."Loan  No.";
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
                    
                    
                    until loans.Next=0;
                    end;
                    end;
                    
                    
                    //TEA LOAN CYRUS
                    
                    
                    
                    //TransactionsSchedule.CALCFIELDS(TransactionsSchedule."Loan Deductions");
                    DedAmount:=0;
                    
                    if TransactionsSchedule."Do Not Effect Deductions" = false then begin
                    if TransactionsSchedule."Loan Deductions" > (TransactionsSchedule.Amount-TCharges) then begin
                    AccBal:=0;
                    AvlBal:=0;
                    MinBal:=0;
                     if AvlBal>0 then begin
                      //DedAmount:=(TransactionsSchedule.Amount-TCharges)+AvlBal;
                       DedAmount:=TransactionsSchedule."Loan Deductions";
                      if DedAmount>TransactionsSchedule."Loan Deductions" then begin
                        DedAmount:=TransactionsSchedule."Loan Deductions";
                      end;
                    
                     end
                     else begin
                        //DedAmount:=(TransactionsSchedule.Amount-TCharges);
                       DedAmount:=TransactionsSchedule."Loan Deductions";
                     end;
                    
                    
                    end
                    else begin
                      DedAmount:=TransactionsSchedule."Loan Deductions";
                    end;
                    
                      DedAmount:=TransactionsSchedule."Loan Deductions";
                    
                    end;
                    
                    TransactionsSchedule."EFT Amount":=BalLessDed;
                    TransactionsSchedule.Modify;
                    
                    until TransactionsSchedule.Next=0;
                    
                    end;
                    
                    //Post New
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name",'PURCHASES');
                    GenJournalLine.SetRange("Journal Batch Name",'PAYOUT');
                    if GenJournalLine.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJournalLine);
                    end;
                    //Post New
                    
                    
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange(GenJournalLine."Journal Template Name",'PURCHASES');
                    GenJournalLine.SetRange(GenJournalLine."Journal Batch Name",'PAYOUT');
                    
                    if GenJournalLine.Find('-') then  begin
                    GenJournalLine.DeleteAll;
                    end;
                    
                    
                    if DefaultBatch.Get('PURCHASES','PAYOUT') then
                    DefaultBatch.Delete;
                    
                    
                    //CHECK IF POSTED
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange(GenJournalLine."Journal Template Name",'PURCHASES');
                    GenJournalLine.SetRange(GenJournalLine."Journal Batch Name",'PAYOUT');
                    
                    if GenJournalLine.Find('-') then
                    exit;
                    
                    
                    Deposited:=true;
                    "Supervisor Checked":=true;
                    "Needs Approval":="needs approval"::No;
                    "Date Deposited":=Today;
                    "Time Deposited":=Time;
                    "Deposited By":=UserId;
                    Modify;
                    
                    
                    Message('Cheque deposited successfully.');
                    
                    end;

                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Image = Print;

                trigger OnAction()
                begin

                    SetFilter(No,No);
                    Report.Run(39004081,true,false,Rec);
                    Reset;
                end;
            }
            action(Print_Schedule)
            {
                ApplicationArea = Basic;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
         Payout:=true;
    end;

    trigger OnOpenPage()
    begin
           if Deposited=true then
           CurrPage.Editable:=false;
           //Payout:=TRUE;
    end;

    var
        TransactionTypes: Record "Transaction Type";
        //wScript: Automation WshShell;
        TransactionsSchedule: Record "Transaction Schedule";
        AccountTypes: Record "Account Types-Saving Products";
        GenJournalLine: Record "Gen. Journal Line";
        GenLedgerSetup: Record "General Ledger Setup";
        LineNo: Decimal;
        window: Dialog;
        DefaultBatch: Record "Gen. Journal Batch";
        PostingCode: Codeunit "Gen. Jnl.-Post Line";
        TransactionCharges: Record "Transaction Charges";
        AccountHolders: Record Vendor;
        CompInfo: Record "Company Information";
        DedAmount: Decimal;
        Interest: Decimal;
        Princ: Decimal;
        TCharges: Decimal;
        TotalDed: Decimal;
        BalLessDed: Decimal;
        Vend: Record Vendor;
        AccBal: Decimal;
        AvlBal: Decimal;
        AccTypes: Record "Account Types-Saving Products";
        MinBal: Decimal;
        CurrentCharge2: Decimal;
        BANKS: Record Banks;
        loans: Record "Loans Register";
        LOANAMNT: Decimal;
        INTAMNT: Decimal;
        SHAREAMNT: Decimal;
        AVAILAMNT: Decimal;
        cust: Record Customer;
        LOANrep: Decimal;
        RUNBALL: Decimal;
}

