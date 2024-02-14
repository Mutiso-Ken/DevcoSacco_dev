report 51516007 "CEEP Targets & Variance Report"
{
    Caption = 'CEEP Targets & Variance Report';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CEEP Targets & Variance Report.rdlc';
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.") order(ascending) where("Global Dimension 1 Code" = filter('MICRO'), "Customer Posting Group" = filter('MICRO'), "Group Account" = filter(false));
            // RequestFilterFields = "Global Dimension 2 Code", "Group Officer", "Group Account No", "Date Filter";
            column(No; "No.")
            {
            }
            column(SharesClosingBal; SharesVariance)
            {
            }
            column(LoanClosingBal; LoanVariance)
            {
            }
            column(InterestClosingBal; InterestVariance)
            {
            }
            column(TotalAmountCollected; TotalAmountCollected)
            {
            }
            // column(Group_Account_No; "Group Account No")
            // {
            // }
            column(Name; Name)
            {
            }
            column(Mobile_Phone_No_; "Phone No.")
            {
            }
            column(ID_No_; "ID No.")
            {
            }
            column(SharesBD; ShareTarget)
            {
            }
            column(LoanBD; LoanTargets)
            {
            }
            column(InterestBD; InterestTarget)
            {
            }
            column(SharesCollected; SharesCollected)
            {
            }
            column(LoanCollected; LoanCollected)
            {
            }
            column(InterestCollected; InterestCollected)
            {
            }

            trigger OnPreDataItem()
            begin
                Customer.SetFilter(Customer."Date Filter", DateFilter);
                ShareTarget := 0;
                CollectedAmount := 0;
                LoanTargets := 0;
                InterestTarget := 0;
                SharesCollected := 0;
                LoanCollected := 0;
                InterestCollected := 0;
                TotalAmountCollected := 0;
                SharesVariance := 0;
                LoanVariance := 0;
                InterestVariance := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                //..................1)Get core member details
                //....Name,No,Phoneno,Bal B/D before datefilter,
                if CustomerTable.get(Customer."No.") then begin
                    CustomerTable.SetFilter(CustomerTable."Date Filter", DateFilter);
                    CustomerTable.SetAutoCalcFields(CustomerTable."Current Shares", CustomerTable."Outstanding Balance", CustomerTable."Outstanding Interest");
                    //...........Targets(Get the period,then multiply it by 200)
                    ShareTarget := 0;
                    ShareTarget := GetSharesTarget(CustomerTable."No.", DateFilter);
                    LoanTargets := 0;
                    LoanTargets := GetLoansTarget(CustomerTable."No.", DateFilter);
                    InterestTarget := 0;
                    InterestTarget := GetInterestTarget(CustomerTable."No.", DateFilter);
                    //..................2)Get Amount contributed
                    SharesCollected := 0;
                    SharesCollected := GetSharesCollected(CustomerTable."No.", DateFilter);
                    IF SharesCollected <= 0 THEN begin
                        SharesCollected := 0;
                    end;
                    LoanCollected := 0;
                    LoanCollected := GetLoanCollected(CustomerTable."No.", DateFilter);
                    InterestCollected := 0;
                    InterestCollected := GetInterestCollected(CustomerTable."No.", DateFilter);
                    //..................3)Get the closing balance
                    SharesVariance := 0;
                    SharesVariance := ShareTarget - SharesCollected;
                    if SharesVariance < 0 then
                        SharesVariance := 0;
                    LoanVariance := 0;
                    LoanVariance := LoanTargets - LoanCollected;
                    if LoanVariance < 0 then
                        LoanVariance := 0;
                    InterestVariance := 0;
                    InterestVariance := InterestTarget - InterestCollected;
                    if InterestVariance < 0 then
                        InterestVariance := 0;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                field(FromDate; FromDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'From Date';
                    ShowMandatory = true;
                }
                field(ToDate; ToDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'To Date';
                    ShowMandatory = true;
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        FromDate := 0D;
        FromDate := CalcDate('-CM', Today);
        ToDate := 0D;
        ToDate := CalcDate('CM', Today);
        IF ToDate > Today then begin
            ToDate := Today;
        end;
    end;

    trigger OnPreReport()
    begin
        if FromDate = 0D then
            Error('You Must Specify the start date');
        if ToDate = 0D then
            Error('You Must Specify the End date');
        DateFilter := Customer.GetFilter(Customer."Date Filter");
        if DateFilter = '' then DateFilter := Format(FromDate) + '..' + Format(ToDate);
    end;

    trigger OnPostReport()
    begin

    end;

    local procedure GetSharesTarget(No: Code[20]; DateFilter: Text): Decimal
    var
        CustomerRecord: Record Customer;
        NewFilter: Text;
        DateBD: date;
        WeekRange: Decimal;
        DateBF: date;
        CustLedgerEntry: record "Cust. Ledger Entry";
    begin
        WeekRange := 0;
        WeekRange := Round((ToDate - FromDate) / 7, 1, '<');
        exit(WeekRange * 200);
    end;

    local procedure GetLoansTarget(No: Code[20]; DateFilter: Text): Decimal
    var
        CustomerRecord: Record Customer;
        NewFilter: Text;
        DateBD: date;
        LoansRegister: record "Loans Register";
        TargetAmount: Decimal;
        NewDateFilter: Text;
    begin
        TargetAmount := 0;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Client Code", No);
        LoansRegister.SetRange(LoansRegister.Posted, true);
        LoansRegister.SetFilter(LoansRegister."Date filter", '%1..%2', 0D, ToDate);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Schedule Loan Amount Issued", LoansRegister."Scheduled Principle Payments");
        if LoansRegister.Find('-') then begin
            repeat
                TargetAmount += (LoansRegister."Outstanding Balance" - (LoansRegister."Schedule Loan Amount Issued" - LoansRegister."Scheduled Principle Payments"));
            until LoansRegister.Next = 0;
            IF TargetAmount < 0 then begin
                TargetAmount := 0;
            end;
        end;
        exit(TargetAmount);
    end;

    local procedure GetInterestTarget(No: Code[20]; DateFilter: Text): Decimal
    var
        CustomerRecord: Record Customer;
        NewFilter: Text;
        DateBD: date;
        LoansRegister: Record "Loans Register";
        TargetAmount: Decimal;
    begin
        TargetAmount := 0;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Client Code", No);
        LoansRegister.SetRange(LoansRegister.Posted, true);
        LoansRegister.SetRange(LoansRegister.Source, LoansRegister.Source::MICRO);
        LoansRegister.SetFilter(LoansRegister."Date filter", '%1..%2', 0D, ToDate);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest", LoansRegister."Scheduled Interest Payments", LoansRegister."Interest Paid");
        if LoansRegister.Find('-') then begin
            repeat
                if (LoansRegister.Source = LoansRegister.Source::MICRO) and (LoansRegister."Loan Disbursement Date" > 20230806D) then begin
                    TargetAmount += (LoansRegister."Scheduled Interest Payments" - (LoansRegister."Interest Paid" * -1));
                end else begin
                    TargetAmount += LoansRegister."Oustanding Interest";
                end;
            until LoansRegister.Next = 0;
            IF TargetAmount < 0 then begin
                TargetAmount := 0;
            end;
        end;
        exit(TargetAmount);
    end;

    local procedure GetSharesCollected(No: Code[20]; DateFilter: Text): Decimal
    var
        CustomerRecord: Record Customer;
        NewFilter: Text;
        DateBD: date;
    begin
        CustomerRecord.Reset();
        CustomerRecord.SetRange(CustomerRecord."Global Dimension 1 Code", 'MICRO');
        CustomerRecord.SetRange(CustomerRecord."No.", No);
        CustomerRecord.SetFilter(CustomerRecord."Date Filter", '%1..%2', FromDate, ToDate);
        CustomerRecord.SetAutoCalcFields(CustomerRecord."Current Shares");
        if CustomerRecord.Find('-') then begin
            exit(CustomerRecord."Current Shares");
        end;
        exit(0);
    end;

    local procedure GetLoanCollected(No: Code[20]; DateFilter: Text): Decimal
    var
        CustomerRecord: Record Customer;
        NewFilter: Text;
        DateBD: date;
    begin
        CustomerRecord.Reset();
        CustomerRecord.SetRange(CustomerRecord."Global Dimension 1 Code", 'MICRO');
        CustomerRecord.SetRange(CustomerRecord."No.", No);
        CustomerRecord.SetFilter(CustomerRecord."Date Filter", '%1..%2', FromDate, ToDate);
        CustomerRecord.SetAutoCalcFields(CustomerRecord."Principal Paid");
        if CustomerRecord.Find('-') then begin
            exit(CustomerRecord."Principal Paid");
        end;
        exit(0);
    end;

    local procedure GetInterestCollected(No: Code[20]; DateFilter: Text): Decimal
    var
        CustomerRecord: Record Customer;
        NewFilter: Text;
        DateBD: date;
    begin

        CustomerRecord.Reset();
        CustomerRecord.SetRange(CustomerRecord."Global Dimension 1 Code", 'MICRO');
        CustomerRecord.SetRange(CustomerRecord."No.", No);
        CustomerRecord.SetFilter(CustomerRecord."Date Filter", '%1..%2', FromDate, ToDate);
        CustomerRecord.SetAutoCalcFields(CustomerRecord."Interest Paid");
        if CustomerRecord.Find('-') then begin
            exit(CustomerRecord."Interest Paid");
        end;
        exit(0);
    end;

    local procedure GetSharesClosingBal(No: Code[20]; DateFilter: Text): Decimal
    var
        CustomerRecord: Record Customer;
        NewFilter: Text;
        DateBD: date;
    begin

        CustomerRecord.Reset();
        CustomerRecord.SetRange(CustomerRecord."Global Dimension 1 Code", 'MICRO');
        CustomerRecord.SetRange(CustomerRecord."No.", No);
        CustomerRecord.SetFilter(CustomerRecord."Date Filter", '%1..%2', FromDate, ToDate);
        CustomerRecord.SetAutoCalcFields(CustomerRecord."Current Shares");
        if CustomerRecord.Find('-') then begin
            exit(CustomerRecord."Current Shares");
        end;
        exit(0);
    end;

    local procedure GetLoansClosingBal(No: Code[20]; DateFilter: Text): Decimal
    var
        CustomerRecord: Record Customer;
        NewFilter: Text;
        DateBD: date;
    begin

        CustomerRecord.Reset();
        CustomerRecord.SetRange(CustomerRecord."Global Dimension 1 Code", 'MICRO');
        CustomerRecord.SetRange(CustomerRecord."No.", No);
        CustomerRecord.SetFilter(CustomerRecord."Date Filter", '%1..%2', 0D, ToDate);
        CustomerRecord.SetAutoCalcFields(CustomerRecord."Outstanding Balance");
        if CustomerRecord.Find('-') then begin
            exit(CustomerRecord."Outstanding Balance");
        end;
        exit(0);
    end;

    local procedure GetInterestClosingBal(No: Code[20]; DateFilter: Text): Decimal
    var
        CustomerRecord: Record Customer;
        NewFilter: Text;
        DateBD: date;
    begin

        CustomerRecord.Reset();
        CustomerRecord.SetRange(CustomerRecord."Global Dimension 1 Code", 'MICRO');
        CustomerRecord.SetRange(CustomerRecord."No.", No);
        CustomerRecord.SetFilter(CustomerRecord."Date Filter", '%1..%2', 0D, ToDate);
        CustomerRecord.SetAutoCalcFields(CustomerRecord."Outstanding Interest");
        if CustomerRecord.Find('-') then begin
            exit(CustomerRecord."Outstanding Interest");
        end;
        exit(0);
    end;

    var
        DateFilter: Text;
        ShareTarget: Decimal;
        CollectedAmount: Decimal;
        CustomerTable: Record Customer;
        LoanTargets: Decimal;
        InterestTarget: Decimal;
        SharesCollected: Decimal;
        LoanCollected: Decimal;
        FromDate: Date;
        ToDate: Date;
        InterestCollected: Decimal;
        TotalAmountCollected: Decimal;
        SharesVariance: Decimal;
        LoanVariance: Decimal;
        InterestVariance: Decimal;

}
