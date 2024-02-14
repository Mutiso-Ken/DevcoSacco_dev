#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516876 "Group Performance Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Group Performance Status.rdlc';

    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            DataItemTableView = where(Source = filter(MICRO), "Loan Status" = filter(Issued), "Outstanding Balance" = filter(> 0), "Loan Product Type" = filter(<> 'CEEP OLD'));
            RequestFilterFields = "Group Account", "Date filter";
            column(PrincipalPaid; PrincipalPaid)
            {
            }
            column(InterestPaid; InterestPaid)
            {
            }
            column(Loan_Last_Pay_Date; "Loan Last Pay Date")
            {
            }
            column(MonthlyPrinciple; MonthlyPrinciple)
            {
            }
            column(InterestArrears; InterestArrears)
            {
            }
            column(PrincipleArrears; PrincipleArrears)
            {
            }
            column(PrincipalBalance; PrincipalBalance)
            {
            }
            column(InterestBalance; InterestBalance)
            {
            }
            column(Loan__No_; "Loan  No.")
            {
            }
            column(Loan_Interest_Repayment; "Loan Interest Repayment")
            {
            }
            column(MonthlyInterest; MonthlyInterest)
            {
            }
            column(GroupAccount_Loan; "Group Account")
            {
            }
            column(Amount_in_Arrears; "Amount in Arrears")
            {
            }
            column(LoanOfficer_Loan; "Loan Officer")
            {
            }
            column(GroupName_Loan; "Group Name")
            {
            }
            column(ClientCode_Loan; "Client Code")
            {
            }
            column(ClientName_Loan; "Client Name")
            {
            }
            column(ApprovedAmount_Loan; "Approved Amount")
            {
            }
            column(Installments_Loan; Installments)
            {
            }
            column(LoanProductType_Loan; "Loan Product Type")
            {
            }
            column(LoanDisbursementDate_Loan; "Loan Disbursement Date")
            {
            }
            column(Repayment_Loan; Repayment)
            {
            }
            column(OutstandingBalance_Loan; "Outstanding Balance")
            {
            }
            column(LoanRepayment_Loan; "Loan Repayment")
            {
            }
            column(LastPayDate_Loan; "Loan Last Pay Date")
            {
            }
            column(TotalPaid; TotalPaid)
            {
            }
            column(TotalLoan; TotalLnBal)
            {
            }
            column(IntArrears; IntArrears)
            {
            }
            column(CompanyName; Company.Name)
            {
            }
            column(CompanyAddress; Company.Address)
            {
            }
            column(CompanyPic; Company.Picture)
            {
            }
            column(ExpectInt_loans; ExpctInt)
            {
            }
            column(Loan_in_Arrears; LoanArrears)
            {
            }
            column(LoanNo_Loan; "Loans Register"."Loan  No.")
            {
            }
            column(Total_loan_bal; Totalloanbal)
            {
            }
            column(IntPaidFinsacco_Loan; "Loans Register"."Int Paid Finsacco")
            {
            }
            column(Total_Int_Paid; TotalIntPaid)
            {
            }
            column(IntBal; IntBal)
            {
            }
            column(Totalloanbal; Totalloanbal)
            {
            }
            column(IntPaid; IntPaid)
            {
            }
            column(Total_Loan_Paid; TotalPay)
            {
            }
            column(Print_Date; AsAt)
            {
            }
            column(Interest; Loans.Interest)
            {
            }
            column(LastPayment; LastPaid)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Loans.SetFilter(Loans."Date filter", DateFilter);
                Loans.SetAutocalcFields(Loans."Oustanding Interest", Loans."Interest Paid", Loans."Principal Paid", Loans."Loan Last Pay Date", Loans."Current Shares", Loans."Outstanding Balance", loans."Scheduled Principle Payments", loans."Scheduled Interest Payments", loans."Schedule Loan Amount Issued");
                if Loans.Get("Loans Register"."Loan  No.") then begin
                    //......................Get Monthly Repayment
                    MonthlyPrinciple := 0;
                    MonthlyInterest := 0;
                    MonthlyPrinciple := FnGetMonthPrinciple(Loans."Loan  No.");
                    MonthlyInterest := FnGetMonthInterest(Loans."Loan  No.");
                    //...........................................

                    //........................Get Total Expected Pay
                    //..........................Get Payments Done
                    Interestpaid := 0;
                    Interestpaid := (Loans."Interest Paid") * -1;
                    PrincipalPaid := 0;
                    PrincipalPaid := (loans."Principal Paid") * -1;
                    //......................Loan Balances
                    InterestBalance := 0;
                    PrincipalBalance := 0;
                    InterestBalance := loans."Loan Interest Repayment" - (Loans."Interest Paid") * -1;
                    PrincipalBalance := loans."Schedule Loan Amount Issued" - (loans."Principal Paid") * -1;
                    //....................................
                    //.........................Get Loan Arrears
                    PrincipleArrears := 0;
                    PrincipleArrears := FnGetPreviousMonthsPrincipalArrears(Loans."Loan  No.", PrincipalPaid);
                    if PrincipleArrears < 0 then
                        PrincipleArrears := 0;
                    InterestArrears := 0;
                    InterestArrears := FnGetPreviousMonthsInterestArrears(Loans."Loan  No.", Interestpaid);
                    if InterestArrears < 0 then
                        InterestArrears := 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                //....................Set Filter to get the group requested
                "Loans Register".SetFilter("Loans Register"."Group Account", GroupFilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {

            }
        }

        actions
        {
        }
    }

    labels
    {
    }
    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        Company.Get;
        Company.CalcFields(Company.Picture);
        PrincipalPaid := 0;
        InterestPaid := 0;
        LoanArrears := 0;
        IntArrears := 0;
        TotalPaid := 0;
        ExpctInt := 0;
        MonthsInArrears := 0;
        Expectedpayment := 0;
        InstallementExpected := 0;
        No_ofmonths := 0;
        nofmonths := 0;
        TotalIntPaid := 0;
        IntBal := 0;
        MonthlyPrinciple := 0;
        MonthlyInterest := 0;
        Totalloanbal := 0;
        IntPaid := 0;
        PaidInt := 0;
        InterestAmt := 0;
        Intbalcon := 0;
        IssueDate := 20170101D;
        TotalPay := 0;
        Months := 0;
        Days := 0;
        InterestBalance := 0;
        PrincipalBalance := 0;
        PrinArrears := 0;
        PrincipleArrears := 0;
        InterestArrears := 0;
        PrinPay := 0;
        LoanMonths := 0;
        ExpectedRepayment := 0;
        PaidMonths := 0;
        MonthlyPrinciple := 0;
        MonthlyInterest := 0;
        //.........................Get Filters used
        GroupFilter := "Loans Register".GetFilter("Loans Register"."Group Account");
        DateFilter := "Loans Register".GetFilter("Loans Register"."Date filter");
    end;


    local procedure FnGetSchedulePrinciplePayments(LoanNo: Code[30]): Decimal
    var
        LoansReg: record "Loans Register";
    begin
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        LoansReg.SetAutoCalcFields(LoansReg."Scheduled Principle Payments");
        if LoansReg.Find('-') then begin
            exit(LoansReg."Scheduled Principle Payments");
        end;
    end;

    local procedure FnGetScheduleInterestPayments(LoanNo: Code[30]): Decimal
    var
        LoansReg: record "Loans Register";
    begin
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        LoansReg.SetAutoCalcFields(LoansReg."Scheduled Interest Payments");
        if LoansReg.Find('-') then begin
            exit(LoansReg."Scheduled Interest Payments");
        end;
    end;

    local procedure FnGetMonthPrinciple(LoanNo: Code[30]): Decimal
    var
        LoanSchedule: record "Loan Repayment Schedule";
        RepaymentDateRange: date;
    begin
        //.....................First Evaluate Date Filter
        RepaymentDateRange := 0D;
        Evaluate(RepaymentDateRange, CopyStr(DateFilter, 3, 100));
        LoanSchedule.Reset();
        LoanSchedule.SetRange(LoanSchedule."Loan No.", LoanNo);
        LoanSchedule.SetFilter(LoanSchedule."Repayment Date", '%1..%2', CalcDate('-CM', RepaymentDateRange), CalcDate('CM', RepaymentDateRange));
        if LoanSchedule.Find('-') then begin
            exit(LoanSchedule."Principal Repayment");
        end;
    end;

    local procedure FnGetMonthInterest(LoanNo: Code[30]): Decimal
    var
        LoanSchedule: record "Loan Repayment Schedule";
        RepaymentDateRange: date;
    begin
        //.....................First Evaluate Date Filter
        RepaymentDateRange := 0D;
        Evaluate(RepaymentDateRange, CopyStr(DateFilter, 3, 100));
        LoanSchedule.Reset();
        LoanSchedule.SetRange(LoanSchedule."Loan No.", LoanNo);
        LoanSchedule.SetFilter(LoanSchedule."Repayment Date", '%1..%2', CalcDate('-CM', RepaymentDateRange), CalcDate('CM', RepaymentDateRange));
        if LoanSchedule.Find('-') then begin
            exit(LoanSchedule."Monthly Interest");
        end;
    end;

    local procedure FnGetPreviousMonthsPrincipalArrears(LoanNo: Code[30]; PrincipalPaid: Decimal): Decimal
    var
        LoansRegister: record "Loans Register";
        RepaymentDateRange: date;
        NewFilter: date;
        NewFiltertext: text;
    begin
        //.....................First Evaluate Date Filter
        RepaymentDateRange := 0D;
        Evaluate(RepaymentDateRange, CopyStr(DateFilter, 3, 100));
        NewFilter := 0D;
        NewFilter := CalcDate('-1M', (CalcDate('CM', RepaymentDateRange)));
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
        LoansRegister.SetFilter(LoansRegister."Date filter", '..' + format(NewFilter));
        LoansRegister.SetAutoCalcFields(LoansRegister."Scheduled Principle Payments", LoansRegister."Principal Paid");
        IF LoansRegister.Find('-') THEN begin
            exit(LoansRegister."Scheduled Principle Payments" - (PrincipalPaid));
        end;
        exit(0);
    end;

    local procedure FnGetPreviousMonthsInterestArrears(LoanNo: Code[30]; Interestpaid: Decimal): Decimal
    var
        LoansRegister: record "Loans Register";
        RepaymentDateRange: date;
        NewFilter: date;
    begin
        //.....................First Evaluate Date Filter
        RepaymentDateRange := 0D;
        Evaluate(RepaymentDateRange, CopyStr(DateFilter, 3, 100));
        NewFilter := 0D;
        NewFilter := CalcDate('-1M', (CalcDate('CM', RepaymentDateRange)));
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
        LoansRegister.SetFilter(LoansRegister."Date filter", '..' + format(NewFilter));
        LoansRegister.SetAutoCalcFields(LoansRegister."Scheduled Interest Payments", LoansRegister."Interest Paid");
        IF LoansRegister.Find('-') THEN begin
            exit(LoansRegister."Scheduled Interest Payments" - (Interestpaid));
        end;
        exit(0);
    end;

    var
        Loans: Record "Loans Register";
        MonthlyPrinciple: Decimal;
        MonthlyInterest: Decimal;
        Company: Record "Company Information";
        LoanArrears: Decimal;
        IntArrears: Decimal;
        TotalPaid: Decimal;
        TotalLnBal: Decimal;
        ExpctInt: Decimal;
        Expectedpayment: Decimal;
        LoanInArrears: Decimal;
        MonthsInArrears: Integer;
        InstallementExpected: Decimal;
        No_ofmonths: Decimal;
        PrincipleArrears: Decimal;
        InterestBalance: Decimal;
        PrincipalBalance: Decimal;
        InterestArrears: Decimal;
        LoansRec: Record "Loans Register";
        nofmonths: Decimal;
        AsAt: Date;
        GroupFilter: Code[50];
        Totalloanbal: Decimal;
        TotalIntPaid: Decimal;
        IntBal: Decimal;
        IntPaid: Decimal;
        DateFilter: Text;
        PaidInt: Decimal;
        InterestAmt: Decimal;
        IssueDate: Date;
        Intbalcon: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPay: Decimal;
        Months: Decimal;
        Days: Decimal;
        PrinArrears: Decimal;
        PrinPay: Decimal;
        LoanMonths: Decimal;
        ExpectedRepayment: Decimal;
        PaidMonths: Decimal;
        LastPaid: Decimal;
}

