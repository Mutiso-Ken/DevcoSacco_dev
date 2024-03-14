codeunit 51516057 "Job Qeue Automations"
{
    trigger OnRun()
    begin

        //.............1)Run Loan Interest Due for loans and post
        SaccoGenSetUp.Get();
        if (SaccoGenSetUp."Last Loan Interest Run Date" <> Today) and (Today <> 20230920D) then begin
            //FOSA & BOSA Loans
            GenerateLoanInterestDue.FnInitiateGLs();
            GenerateLoanInterestDue.FnGenerateFOSALoansInterest();
            GenerateLoanInterestDue.FnGenerateBOSALoansInterest();
            GenerateLoanInterestDue.FnAutoPostGls();
            //MICRO Loans
            if Today = DMY2DATE(01, DATE2DMY(Today, 2), DATE2DMY(Today, 3)) then begin
                GenerateLoanInterestDue.FnInitiateGLs();
                GenerateLoanInterestDue.FnGenerateMICROLoansInterest();
                GenerateLoanInterestDue.FnAutoPostGls();
            end;
            SaccoGenSetUp."Last Loan Interest Run Date" := Today;
            SaccoGenSetUp.Modify();
        end;
        //.............2)Update Loan Classifications
        SASRALoanClassification.FnResetLoanStatus();//Reset Loan SASRA Status
        SASRALoanClassification.FnUpdateLoanStatus();//Update Loan Status
        //.............3)Recover Loans
        LoanAutoRecoveries.FnRecoverArrearsUsingLoansTable();
        //.............4)Update Loan Classifications
        SASRALoanClassification.FnResetLoanStatus();//Reset Loan SASRA Status
        SASRALoanClassification.FnUpdateLoanStatus();//Update Loan Status
    end;

    var
        SASRALoanClassification: Codeunit "Live SASRA Loan Classification";
        SaccoGenSetUp: record "Sacco General Set-Up";
        GenerateMonthlyFOSAInterest: Codeunit "Generate Monthly FOSA Interest";
        ChargeMonthlyAccountMaintainance: Codeunit "Charge FOSA Account Maintain";
        GenerateLoanInterestDue: Codeunit GenerateLoanInterestDue;
        UpdateCustLedgeEntryLoanType: Codeunit "Update CustLedgeEntryLoanType";
        SendLoanNotifications: Codeunit "Send Loan Notifications";
        LoanRecoverys: Codeunit "Devco Management";
        GenerateLoanSchedule: Codeunit "Regenerate loan repayment sch";
        msg: Text;
        SurestepFactory: Codeunit "SURESTEP Factory";
        LoanAutoRecoveries: Codeunit "Loan AutoRecoveries";
}
