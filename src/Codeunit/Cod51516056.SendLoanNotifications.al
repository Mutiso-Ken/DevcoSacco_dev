codeunit 51516056 "Send Loan Notifications"
{
    trigger OnRun()
    begin

    end;

    procedure FnSendLoanReminderNotifications()
    var
        LoansRegister: Record "Loans Register";
        msg: Text[250];
        SurestepFactory: Codeunit "SURESTEP Factory";
        FOSAAccount: Code[100];
    begin
        msg := '';
        FOSAAccount := '';
        LoansRegister.Reset();
        LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
        LoansRegister.SetRange(LoansRegister."Recovery Mode", LoansRegister."Recovery Mode"::"Direct Debits");
        if LoansRegister.Find('-') then begin
            repeat
                if (LoansRegister."Last Reminder SMS Date" <> Today) and (Today <> 20230906D) THEN begin
                    FOSAAccount := '';
                    FOSAAccount := SurestepFactory.FnGetFosaAccount(LoansRegister."Client Code");
                    //......Send Reminder SMS On Loans Due in 7 Days
                    if FnNextLoanRepaymentDate(LoansRegister."Loan  No.", CalcDate('7D', Today)) THEN begin
                        msg := '';
                        msg := 'Dear ' + Format(LoansRegister."Client Name") + ', your ' + Format(LoansRegister."Loan Product Type") + ' repayment of KES.' + Format(LoansRegister."Loan Principle Repayment") + ' is due in 7 Days on ' + Format(CalcDate('7D', Today)) + '. Kindly make arrangements to pay on or before due date using bank A/C or Lipa na MPESA, Paybill 587649.';
                        SurestepFactory.FnSendSMS('MOBILETRAN', msg, LoansRegister."Client Code", FnGetMobileNo(FOSAAccount));
                    end else
                        //......Send Reminder SMS On Loans Due in 7 Days
                        if FnNextLoanRepaymentDate(LoansRegister."Loan  No.", Today) THEN begin
                            msg := '';
                            msg := 'Dear ' + Format(LoansRegister."Client Name") + ', your ' + Format(LoansRegister."Loan Product Type") + ' repayment of KES.' + Format(LoansRegister."Loan Principle Repayment") + ' is due today on ' + Format(Today) + '. Kindly make arrangements to pay on or before due date using bank A/C or Lipa na MPESA, Paybill 587649.';
                            SurestepFactory.FnSendSMS('MOBILETRAN', msg, LoansRegister."Client Code", FnGetMobileNo(FOSAAccount));
                        end;
                    LoansRegister."Last Reminder SMS Date" := today;
                    LoansRegister.Modify(true);
                end;
            until LoansRegister.Next = 0;
        end;
    end;

    local procedure FnNextLoanRepaymentDate(LoanNo: Code[30]; NextLoanRepaymentDay: Date): Boolean
    var
        LoansRepaymentSchedule: record "Loan Repayment Schedule";
    begin
        LoansRepaymentSchedule.Reset();
        LoansRepaymentSchedule.SetRange(LoansRepaymentSchedule."Loan No.", LoanNo);
        LoansRepaymentSchedule.SetRange(LoansRepaymentSchedule."Repayment Date", NextLoanRepaymentDay);
        if LoansRepaymentSchedule.Find('-') then begin
            exit(true);
        end;
        exit(false);
    end;

    local procedure FnGetMobileNo(FOSAAccount: Code[100]): Text
    var
        VendorTable: Record Vendor;
    begin
        VendorTable.Reset();
        VendorTable.SetRange(VendorTable."No.", FOSAAccount);
        if VendorTable.Find('-') then begin
            exit(VendorTable."Phone No.");
        end;
    end;
}
