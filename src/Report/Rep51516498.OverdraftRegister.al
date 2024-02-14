#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516498 "Overdraft Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Overdraft Register.rdlc';

    dataset
    {
        dataitem(ODRegister; "Loans Register")
        {
            RequestFilterFields = "Account No", "Issued Date";
            DataItemTableView = sorting("Loan  No.") where("Loan Product Type" = filter('OVERDRAFT'), Posted = const(true));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(OverDraftNo; ODRegister."Loan  No.")
            {
            }
            column(AccountNo; ODRegister."Account No")
            {
            }
            column(Applicationdate; ODRegister."Application date")
            {
            }
            column(ApprovedDate; ODRegister."Issued Date")
            {
            }
            column(CapturedBy; ODRegister."Captured by")
            {
            }
            column(AccountName; ODRegister."Client Name")
            {
            }
            column(CurrentAccountNo; ODRegister."Vendor No")
            {
            }
            column(OutstandingOverdraft; ODRegister."Outstanding Balance")
            {
            }
            column(AmountApplied; ODRegister."Requested Amount")
            {
            }
            column(Posted; ODRegister.Posted)
            {
            }
            column(Status; ODRegister."Loan Status")
            {
            }
            column(OverdraftStatus; ODRegister."Loan Status")
            {
            }
            column(ApprovedAmount; ODRegister."Approved Amount")
            {
            }
            column(DatePosted; ODRegister."Posting Date")
            {
            }
            column(PostedBy; ODRegister."Approved By")
            {
            }
            column(RemaingBalance; ODRegister."Outstanding Balance")
            {
            }
            column(RepaymentStartDate; ODRegister."Repayment Start Date")
            {
            }
            column(RepaymentCompletion; ODRegister."Expected Date of Completion")
            {
            }
            column(Installments; ODRegister.Installments)
            {
            }
            column(Oustanding_Interest; "Oustanding Interest")
            {
            }
            column(InterestRate; ODRegister.Interest)
            {
            }
            column(MonthlyOverdraftRepayment; ODRegister.Repayment)
            {
            }
            column(MonthlyInterestRepayment; ODRegister."Loan Interest Repayment")
            {
            }
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
}

