#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516272 "Process Standing Orders"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            DataItemTableView = where("Creditor Type"=const(Account),Status=const(Active),Blocked=filter(<>All));
            RequestFilterFields = "Account Type","Company Code","No.";
            RequestFilterHeading = 'Account';
            column(ReportForNavId_3182; 3182)
            {
            }
            dataitem("Standing Orders";"Standing Orders")
            {
                DataItemLink = "Source Account No."=field("No.");
                DataItemTableView = sorting("No.") where(Status=const(Approved),"Income Type"=filter(" "));
                RequestFilterFields = "Next Run Date";
                column(ReportForNavId_8337; 8337)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    AmountDed:=0;

                    //IF "Standing Orders"."Next Run Date"<= TODAY THEN BEGIN

                    if "Standing Orders"."Next Run Date"<= Today then begin

                    DocNo:="Standing Orders"."No.";

                    if AccountS.Get("Standing Orders"."Source Account No.") then begin
                    DActivity3:=AccountS."Global Dimension 1 Code";
                    DBranch3:=AccountS."Global Dimension 2 Code";

                    AccountS.CalcFields(AccountS.Balance,AccountS."Uncleared Cheques");
                    if AccountTypeS.Get(AccountS."Account Type") then begin

                    Charges.Get('STO');
                    Charges.Reset;
                    if "Destination Account Type" = "destination account type"::External then
                    Charges.SetRange(Charges."Charge Type",Charges."charge type"::"External Standing Order Fee")
                    else if ("Destination Account Type" = "destination account type"::Internal) or
                    ("Destination Account Type" = "destination account type"::BOSA) then
                    Charges.SetRange(Charges."Charge Type",Charges."charge type"::"Standing Order Fee");
                    if Charges.Find('-') then begin
                    AvailableBal:=AvailableBal-Charges."Charge Amount";
                    end;
                    //MESSAGE('%1',Charges."Charge Type");
                    //MESSAGE('%1',Charges."Charge Amount");


                    if "Standing Orders"."Next Run Date" = 0D then
                    "Standing Orders"."Next Run Date":="Standing Orders"."Effective/Start Date";

                    if AvailableBal >= "Standing Orders".Amount then begin
                    //IF AvailableBal >= "Standing Orders".Amount AND >60 THEN BEGIN
                    AmountDed:="Standing Orders".Amount;
                    DedStatus:=Dedstatus::Successfull;
                    if "Standing Orders".Amount >= "Standing Orders".Balance then begin
                    "Standing Orders".Balance:=0;
                    "Standing Orders".Unsuccessfull:=false;
                    end else begin
                    "Standing Orders".Balance:="Standing Orders".Balance-"Standing Orders".Amount;

                    "Standing Orders".Unsuccessfull:=true;
                    end;


                    end else begin
                    if "Standing Orders"."Don't Allow Partial Deduction" = true then begin
                    AmountDed:=0;
                    DedStatus:=Dedstatus::Failed;
                    "Standing Orders".Balance:="Standing Orders".Amount;
                    "Standing Orders".Unsuccessfull:=true;


                    end else begin
                    AmountDed:=AvailableBal;
                    DedStatus:=Dedstatus::"Partial Deduction";
                    "Standing Orders".Balance:="Standing Orders".Amount-AmountDed;
                    "Standing Orders".Unsuccessfull:=true;

                    end;
                    end;

                    if AmountDed < 0 then begin
                    AmountDed:=0;
                    DedStatus:=Dedstatus::Failed;

                    "Standing Orders".Balance:="Standing Orders".Amount;
                    "Standing Orders"."Uneffected STO":=true;
                    "Standing Orders".Unsuccessfull:=true;

                    end;

                    if AmountDed > 0 then begin
                    ActualSTO:=0;
                    if "Standing Orders"."Destination Account Type" = "Standing Orders"."destination account type"::BOSA then begin
                    PostBOSAEntries();
                    AmountDed:=ActualSTO;


                    end;
                    LineNo:=LineNo+10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='STO';
                    GenJournalLine."Document No.":=DocNo;
                    GenJournalLine."External Document No.":="Standing Orders"."Destination Account No.";
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":="Standing Orders"."Source Account No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":="Standing Orders"."Next Run Date";
                    GenJournalLine.Description:='Standing Order ' + DocNo;
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=AmountDed;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
                    GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;

                    //Reduce Available
                    AvailableBal:=AvailableBal-GenJournalLine.Amount;


                    if "Standing Orders"."Destination Account Type" <> "Standing Orders"."destination account type"::BOSA then begin//STIMA

                    LineNo:=LineNo+10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='STO';
                    GenJournalLine."Document No.":=DocNo;
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."External Document No.":="Standing Orders"."Source Account No.";
                    if "Standing Orders"."Destination Account Type" = "Standing Orders"."destination account type"::Internal then begin
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":="Standing Orders"."Destination Account No.";
                    end else begin
                    GenJournalLine."Account Type":=GenJournalLine."account type"::"G/L Account";
                    GenJournalLine."Account No.":=AccountTypeS."Standing Orders Suspense";
                    end;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":="Standing Orders"."Next Run Date";
                    GenJournalLine.Description:='Standing Order ' + DocNo;
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=-AmountDed;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
                    GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;

                    end;

                    end;

                    //Standing Order Charges
                    if AmountDed > 0 then begin
                    //IF ("Standing Orders"."Destination Account Type"="Standing Orders"."Destination Account Type"::Internal) OR
                    //("Standing Orders"."Destination Account Type"="Standing Orders"."Destination Account Type"::BOSA)THEN BEGIN
                    ChargeAmount:=0;
                    Charges.Get('STO');
                    Charges.Reset;
                    if "Destination Account Type" = "destination account type"::External then
                    Charges.SetRange(Charges."Charge Type",Charges."charge type"::"External Standing Order Fee")
                    else if ("Destination Account Type" = "destination account type"::Internal) or
                    ("Destination Account Type" = "destination account type"::BOSA) then
                    Charges.SetRange(Charges."Charge Type",Charges."charge type"::"Standing Order Fee");
                    if Charges.Find('-') then begin
                    ChargeAmount:=Charges."Charge Amount";
                    end;

                    LineNo:=LineNo+10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='STO';
                    GenJournalLine."Document No.":=DocNo;
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":="Standing Orders"."Source Account No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":="Standing Orders"."Next Run Date";
                    GenJournalLine.Description:=Charges.Description;
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=ChargeAmount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Bal. Account No.":=Charges."GL Account";
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
                    GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;

                    //Reduce Available
                    AvailableBal:=AvailableBal-GenJournalLine.Amount;
                    //END;

                    GenSetup.Get;
                    //Excise Duty
                    //Charges.RESET;
                    //Charges.SETRANGE(Charges.Code,'ED');
                    if Charges.Find('-') then begin
                    LineNo:=LineNo+10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='STO';
                    GenJournalLine."Document No.":=DocNo;
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":="Standing Orders"."Source Account No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":="Standing Orders"."Next Run Date";
                    GenJournalLine.Description:='Excise Duty';
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=ChargeAmount*(GenSetup."Excise Duty(%)"/100);
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Bal. Account No.":=GenSetup."Excise Duty Account";
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
                    GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;

                    //Reduce Available
                    AvailableBal:=AvailableBal-GenJournalLine.Amount;

                    //Excise Duty
                    //END;
                    end;
                    end else begin
                    Charges.Reset;
                    Charges.SetRange(Charges."Charge Type",Charges."charge type"::"Failed Standing Order Fee");
                    if Charges.Find('-') then begin
                    LineNo:=LineNo+10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name":='PURCHASES';
                    GenJournalLine."Journal Batch Name":='STO';
                    GenJournalLine."Document No.":=DocNo;
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                    GenJournalLine."Account No.":="Standing Orders"."Source Account No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date":="Standing Orders"."Next Run Date";
                    GenJournalLine.Description:=Charges.Description;
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount:=Charges."Charge Amount";
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                    GenJournalLine."Bal. Account No.":=Charges."GL Account";
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
                    GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;

                    //Reduce Available
                    AvailableBal:=AvailableBal-GenJournalLine.Amount;
                    end;
                    end;

                    //Standing Order Charges

                    "Standing Orders".Effected:=true;
                    "Standing Orders"."Auto Process":=true;
                    "Standing Orders"."Next Run Date":=CalcDate("Standing Orders".Frequency,"Standing Orders"."Next Run Date");
                    "Standing Orders".Modify;


                    STORegister.Init;
                    STORegister."Register No.":='';
                    STORegister.Validate(STORegister."Register No.");
                    STORegister."Standing Order No.":="Standing Orders"."No.";
                    STORegister."Source Account No.":="Standing Orders"."Source Account No.";
                    STORegister."Staff/Payroll No.":="Standing Orders"."Staff/Payroll No.";
                    STORegister.Date:=Today;
                    STORegister."Account Name":="Standing Orders"."Account Name";
                    STORegister."Destination Account Type":="Standing Orders"."Destination Account Type";
                    STORegister."Destination Account No.":="Standing Orders"."Destination Account No.";
                    STORegister."Destination Account Name":="Standing Orders"."Destination Account Name";
                    STORegister."BOSA Account No.":="Standing Orders"."BOSA Account No.";
                    STORegister."Effective/Start Date":="Standing Orders"."Effective/Start Date";
                    STORegister."End Date":="Standing Orders"."End Date";
                    STORegister.Duration:="Standing Orders".Duration;
                    STORegister.Frequency:="Standing Orders".Frequency;
                    STORegister."Don't Allow Partial Deduction":="Standing Orders"."Don't Allow Partial Deduction";
                    STORegister."Deduction Status":=DedStatus;
                    STORegister.Remarks:="Standing Orders".Remarks;
                    STORegister.Amount:="Standing Orders".Amount;
                    STORegister."Amount Deducted":=AmountDed;
                    if "Standing Orders"."Destination Account Type" = "Standing Orders"."destination account type"::External then
                    STORegister.EFT:=true;
                    STORegister.Insert(true);

                    end;
                    end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields(Balance,"Uncleared Cheques");
                AvailableBal:=(Balance-"Uncleared Cheques");
                if AccountTypeS.Get("Account Type") then
                AvailableBal:=AvailableBal-AccountTypeS."Minimum Balance";
                 //MESSAGE('processin ni leo %1',AvailableBal);
            end;

            trigger OnPostDataItem()
            begin

                //Post New
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name",'PURCHASES');
                GenJournalLine.SetRange("Journal Batch Name",'STO');
                if GenJournalLine.Find('-') then begin
                Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch",GenJournalLine);
                end;
                //Post New
            end;

            trigger OnPreDataItem()
            begin
                GenJournalLine.Reset;
                GenJournalLine.SetRange(GenJournalLine."Journal Template Name",'PURCHASES');
                GenJournalLine.SetRange(GenJournalLine."Journal Batch Name",'STO');
                if GenJournalLine.Find('-') then
                GenJournalLine.DeleteAll;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        GenJournalLine: Record "Gen. Journal Line";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Account: Record Vendor;
        AccountType: Record "Account Types-Saving Products";
        AvailableBal: Decimal;
        STORegister: Record "Standing Order Register";
        AmountDed: Decimal;
        DedStatus: Option Successfull,"Partial Deduction",Failed;
        Charges: Record Charges;
        LineNo: Integer;
        DActivity: Code[20];
        DBranch: Code[20];
        STOAmount: Decimal;
        ReceiptAllocations: Record "Receipt Allocation";
        BOSABank: Code[20];
        STORunBal: Decimal;
        ReceiptAmount: Decimal;
        Loans: Record "Loans Register";
        DocNo: Code[20];
        InsCont: Decimal;
        ActualSTO: Decimal;
        AccountS: Record Vendor;
        DActivity3: Code[20];
        DBranch3: Code[20];
        RunBal: Decimal;
        AccountTypeS: Record "Account Types-Saving Products";
        AccountBal: Record Vendor;
        GenSetup: Record "Sacco General Set-Up";
        ChargeAmount: Decimal;


    procedure PostBOSAEntries()
    begin

        if AmountDed > 0 then begin
        STORunBal:=AmountDed;


        ReceiptAllocations.Reset;
        ReceiptAllocations.SetRange(ReceiptAllocations."Document No","Standing Orders"."No.");
        ReceiptAllocations.SetRange(ReceiptAllocations."Member No","Standing Orders"."BOSA Account No.");
        if ReceiptAllocations.Find('-') then begin
        repeat
        ReceiptAllocations."Amount Balance":=0;
        ReceiptAllocations."Interest Balance":=0;

        ReceiptAmount:=ReceiptAllocations.Amount;

        //Check Loan Balances
        if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Registration Fee" then begin
        Loans.Reset;
        Loans.SetRange(Loans."Loan  No.",ReceiptAllocations."Loan No.");
        if Loans.Find('-') then begin
        Loans.CalcFields(Loans."Outstanding Balance",Loans."Oustanding Interest");
        if ReceiptAmount > Loans."Outstanding Balance" then
        ReceiptAmount := Loans."Outstanding Balance";

        if Loans."Oustanding Interest">0 then
        ReceiptAmount:=ReceiptAmount-Loans."Oustanding Interest";

        end else
        Error('Loan No. %1 not Found. :- %2',ReceiptAllocations."Loan No.",ReceiptAllocations."Document No");
        end;

        if ReceiptAmount < 0 then
        ReceiptAmount:=0;

        if STORunBal < 0 then
        STORunBal:=0;

        LineNo:=LineNo+10000;

        GenJournalLine.Init;
        GenJournalLine."Journal Template Name":='PURCHASES';
        GenJournalLine."Journal Batch Name":='STO';
        GenJournalLine."Line No.":=LineNo;
        GenJournalLine."Document No.":=DocNo;
        GenJournalLine."External Document No.":="Standing Orders"."No.";
        GenJournalLine."Posting Date":="Standing Orders"."Next Run Date";
        GenJournalLine."Account Type":=GenJournalLine."bal. account type"::Customer;
        GenJournalLine."Account No.":=ReceiptAllocations."Member No";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine.Description:=Format(ReceiptAllocations."Transaction Type")+'-'+DocNo;
        if STORunBal > ReceiptAmount then
        GenJournalLine.Amount:=-ReceiptAmount
        else
        GenJournalLine.Amount:=-STORunBal;
        GenJournalLine.Validate(GenJournalLine.Amount);
        if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Deposit Contribution" then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Deposit Contribution"
        else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Benevolent Fund" then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Benevolent Fund"
        else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Insurance Contribution" then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Insurance Contribution"

        else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Shares Capital" then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Shares Capital"
        else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"FOSA Shares" then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"FOSA Shares"
        else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Pepea Shares" then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Pepea Shares"

        // else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Tambaa Shares" then
        // GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Tamba Shares"
        //.................... Added Changamka Shares .......................................................//

        else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Changamka Shares" then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Changamka Shares"

        //....................................................................................................//
        else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Lift Shares" then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Lift Shares"

        else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::Repayment then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::Repayment
        else if ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::"Registration Fee" then
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Registration Fee";
        GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
        GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
        GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
        if GenJournalLine.Amount<>0 then
        GenJournalLine.Insert;

        ReceiptAllocations."Amount Balance":=ReceiptAllocations."Amount Balance" + (GenJournalLine.Amount * -1);

        STORunBal:=STORunBal+GenJournalLine.Amount;
        ActualSTO:=ActualSTO+(GenJournalLine.Amount*-1);


        if STORunBal < 0 then
        STORunBal:=0;


        if (ReceiptAllocations."Transaction Type" = ReceiptAllocations."transaction type"::Repayment) then begin

        LineNo:=LineNo+10000;

        //Check Outstanding Interestcode
        Loans.Reset;
        Loans.SetRange(Loans."Loan  No.",ReceiptAllocations."Loan No.");

        if Loans.Find('-') then begin
        Loans.CalcFields(Loans."Oustanding Interest");
        ReceiptAmount := Loans."Oustanding Interest";
        //MESSAGE('%1',Loans."Oustanding Interest");          // Loans."Oustanding Interest";
          //MESSAGE('Loan number is %1',ReceiptAllocations."Loan No.");
        end else

        Error('Loan No. %1 not Found. :- %2',ReceiptAllocations."Loan No.",ReceiptAllocations."Document No");


        if ReceiptAmount < 0 then
        ReceiptAmount:=0;

        if ReceiptAmount > 0 then begin

        GenJournalLine.Init;
        GenJournalLine."Journal Template Name":='PURCHASES';
        GenJournalLine."Journal Batch Name":='STO';
        GenJournalLine."Line No.":=LineNo;
        GenJournalLine."Document No.":=DocNo;
        GenJournalLine."External Document No.":="Standing Orders"."No.";
        GenJournalLine."Posting Date":="Standing Orders"."Next Run Date";
        GenJournalLine."Account Type":=GenJournalLine."bal. account type"::Customer;
        GenJournalLine."Account No.":=ReceiptAllocations."Member No";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine.Description:='Interest Paid '+DocNo;
        if STORunBal > ReceiptAmount then
        GenJournalLine.Amount:=-ReceiptAmount
        else
        GenJournalLine.Amount:=-STORunBal;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Transaction Type":=GenJournalLine."transaction type"::"Interest Paid";
        GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
        GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
        GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
        if GenJournalLine.Amount<>0 then
        GenJournalLine.Insert;

        ReceiptAllocations."Interest Balance":=ReceiptAllocations."Interest Balance" + (GenJournalLine.Amount * -1);

        STORunBal:=STORunBal+GenJournalLine.Amount;
        ActualSTO:=ActualSTO+(GenJournalLine.Amount*-1);
        end;
        end;

        ReceiptAllocations.Modify;

        until ReceiptAllocations.Next = 0;
        end;
        end;
    end;
}

