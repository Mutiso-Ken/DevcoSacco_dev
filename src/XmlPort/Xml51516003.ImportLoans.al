xmlport 51516003 "Import Loans"
{
    Caption = 'Import Loans';
    Format = VariableText;
    schema
    {
        textelement(Salaries_Processing)
        {
            tableelement("Loan Imported"; "Loan Imported")
            {
                XmlName = 'LoanImport';
                fieldelement(LoanNo; "Loan Imported"."Loan No")
                {
                }
                fieldelement(Source; "Loan Imported".Source)
                {
                }
                fieldelement(LoanProductType; "Loan Imported"."Loan Product Type")
                {
                }
                fieldelement(RepaymentMethod; "Loan Imported"."Repayment Method")
                {
                }
                fieldelement(AppliedAmount; "Loan Imported"."Applied Amount")
                {
                }
                fieldelement(LoanBalance; "Loan Imported"."Loan Balance")
                {
                }
                fieldelement(ApplicationDate; "Loan Imported"."Application Date")
                {
                }
                fieldelement(CapturedBy; "Loan Imported"."Captured By")
                {
                }
                fieldelement(OverdraftPeriod; "Loan Imported"."Overdraft Period")
                {
                }
                fieldelement(LoanDisbursementDate; "Loan Imported"."Loan Disbursement Date")
                {
                }
                fieldelement(VendorNo; "Loan Imported"."Vendor No")
                {
                }
            }
        }
    }
}
