#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516880 "MICRO report Officer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MICROreportOfficer.rdlc';

    dataset
    {
        dataitem(Loan; "Loans Register")
        {
            DataItemTableView = where(Source = filter(MICRO), "Loan Status" = filter(Issued), Posted = filter(true));
            RequestFilterFields = "Group Account";
            column(ReportForNavId_1000000019; 1000000019)
            {
            }
            column(GroupAccount_Loan; Loan."Group Account")
            {
            }
            column(LoanOfficer_Loan; Loan."Loan Officer")
            {
            }
            column(GroupName_Loan; Loan."Group Name")
            {
            }
            column(ClientCode_Loan; Loan."Client Code")
            {
            }
            column(ClientName_Loan; Loan."Client Name")
            {
            }
            column(ApprovedAmount_Loan; Loan."Approved Amount")
            {
            }
            column(Installments_Loan; Loan.Installments)
            {
            }
            column(LoanProductType_Loan; Loan."Loan Product Type")
            {
            }
            column(LoanDisbursementDate_Loan; Loan."Loan Disbursement Date")
            {
            }
            column(Repayment_Loan; Loan.Repayment)
            {
            }
            column(OutstandingBalance_Loan; Loan."Outstanding Balance")
            {
            }
            column(CurrentShares_Loan; Loan."Current Shares")
            {
            }
            column(LoanRepayment_Loan; Loan."Loan Repayment")
            {
            }
            column(LastPayDate_Loan; Loan."Last Pay Date")
            {
            }
            column(InterestDue_Loan; Loan."Interest Due")
            {
            }
            column(InterestPaid_Loan; Loan."Interest Paid")
            {
            }
            column(RepaymentStartDate_Loan; Loan."Repayment Start Date")
            {
            }
            column(OustandingInterest_Loan; Loan."Oustanding Interest")
            {
            }
            column(CurrentInterestPaid_Loan; Loan."Current Interest Paid")
            {
            }
            column(OutstandingLoan_Loan; Loan."Outstanding Loan")
            {
            }
            column(MonthlyRepayment_Loan; Loan."Monthly Repayment")
            {
            }
            column(LoanNextPayDate_Loan; Loan."Loan Next Pay Date")
            {
            }
            column(LoanPrincipleRepayment_Loan; Loan."Loan Principle Repayment")
            {
            }
            column(LoanInterestRepayment_Loan; Loan."Loan Interest Repayment")
            {
            }
            column(LastInterestPayDate_Loan; Loan."Last Interest Pay Date")
            {
            }
            column(TotalLoansOutstanding_Loan; Loan."Total Loans Outstanding")
            {
            }
            column(ApplicationDate_Loan; Loans."Issued Date")
            {
            }
            column(IssuedDate_Loan; Loan."Issued Date")
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
            column(LoanNo_Loan; Loan."Loan  No.")
            {
            }
            column(Total_loan_bal; Totalloanbal)
            {
            }
            column(IntPaidFinsacco_Loan; Loan."Int Paid Finsacco")
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

                Loan.CalcFields(Loan."Interest Due");
                Loan.CalcFields(Loan."Interest Paid");
                Loan.CalcFields(Loan."Current Shares");
                Loan.CalcFields(Loan."Last Pay Date");
                Loan.CalcFields(Loan."Outstanding Balance");
                Loan.CalcFields(Loan."Oustanding Interest");


                //MESSAGE('%1 %2 %3 %4',Loan."Client Code",Loan."Client Name",Loan."Outstanding Balance",nofmonths);
                Loan."Interest Paid" := (Loan."Interest Paid" * -1);
                nofmonths := ROUND(InstallementExpected / 30, 1, '=');
                TotalPaid := Loan."Approved Amount" - Loan."Outstanding Balance";
                IntArrears := Loan."Interest Due" - Loan."Interest Paid";
                ExpctInt := ROUND(Loan."Approved Amount" * (Loan.Interest / 100) * (Loan.Installments / 12), 0.01, '>');
                IntPaid := Loan."Interest Paid" + Loan."Int Paid Finsacco";
                TotalPay := TotalPaid + IntPaid;
                Intbalcon := ExpctInt - IntPaid;
                if Intbalcon > 0 then
                    IntBal := Intbalcon
                else
                    IntBal := 0;


                // Code for New loan Balance  Waweru
                Days := (AsAt - Loan."Issued Date");
                Months := ROUND(Days / 30);


                if Months >= Loan.Installments then
                    Totalloanbal := Loan."Outstanding Balance" + Loan."Oustanding Interest"
                else
                    Totalloanbal := Loan."Outstanding Balance" + IntBal;
                LoansRec.Reset;
                LoansRec.SetRange(LoansRec."Loan  No.", Loan."Loan  No.");
                LoansRec.SetRange(LoansRec.Posted, true);

                if LoansRec.Find('-') then begin
                    //IF (LoansRec."Issued Date"<>0D) AND (LoansRec.Installments>0)  THEN BEGIN
                    if LoansRec.Installments > 0 then begin
                        Loan.CalcFields(Loan."Outstanding Balance");
                        InstallementExpected := AsAt - LoansRec."Issued Date";

                        if (nofmonths >= 1) then
                            No_ofmonths := nofmonths;

                        Expectedpayment := ROUND((LoansRec."Approved Amount" - ((LoansRec."Approved Amount" / LoansRec.Installments) * No_ofmonths)), 0.01, '>');
                        LoanArrears := Loan."Outstanding Balance" - Expectedpayment;

                    end;

                end;
                TotalIntPaid := ((Loan."Interest Paid") + Loan."Int Paid Finsacco");
            end;

            trigger OnPreDataItem()
            begin
                if (AsAt = 0D) then
                    Error('Please Enter as at Date');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(AsAt; AsAt)
                {
                    ApplicationArea = Basic;
                    Caption = 'As At';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Company.Get;
        Company.CalcFields(Company.Picture);

        LoanArrears := 0;
        IntArrears := 0;
        TotalPaid := 0;
        ExpctInt := 0;
        Expectedpayment := 0;
        InstallementExpected := 0;
        No_ofmonths := 0;
        nofmonths := 0;
        TotalIntPaid := 0;
        IntBal := 0;
        Totalloanbal := 0;
        IntPaid := 0;
        PaidInt := 0;
        InterestAmt := 0;
        Intbalcon := 0;
        IssueDate := 20170101D;
        TotalPay := 0;
        Months := 0;
        Days := 0;
        PrinArrears := 0;
        PrinPay := 0;
        LoanMonths := 0;
        ExpectedRepayment := 0;
        PaidMonths := 0;
    end;

    var
        Loans: Record "Loans Register";
        Company: Record "Company Information";
        LoanArrears: Decimal;
        IntArrears: Decimal;
        TotalPaid: Decimal;
        TotalLnBal: Decimal;
        ExpctInt: Decimal;
        Expectedpayment: Decimal;
        LoanInArrears: Decimal;
        InstallementExpected: Decimal;
        No_ofmonths: Decimal;
        LoansRec: Record "Loans Register";
        nofmonths: Decimal;
        AsAt: Date;
        Totalloanbal: Decimal;
        TotalIntPaid: Decimal;
        IntBal: Decimal;
        IntPaid: Decimal;
        PaidInt: Decimal;
        InterestAmt: Decimal;
        IssueDate: Date;
        Intbalcon: Decimal;
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

