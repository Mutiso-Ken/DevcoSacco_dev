Codeunit 50123 BackOfficePORTAL
{

    trigger OnRun()
    var
        str: BigText;
    begin

        //MESSAGE(fnSendOtp(''));
        //MESSAGE(fnLoanCalculator(30000, 12, 'EMERGENCY'));
        //MESSAGE(fnGetNextofkin('1584'));

    end;

    var
        objMember: Record Customer;
        objLoanRegister: Record "Loans Register";
        objRegMember: Record "Membership Applications";
        objNextKin: Record "Next of Kin/Account Sign";
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
        Loansetup: Record "Loan Products Setup";
        LPrincipal: Decimal;
        LInterest: Decimal;
        LBalance: Decimal;
        TotalMRepay: Decimal;
        InterestRate: Decimal;
        Date: Date;
        Loanperiod: Integer;
        Filename: Text;
        FILESPATH: label 'C:\inetpub\wwwroot\SaccoData\PdfDocs';
        qualificationasperSeposit: Decimal;
        EligibleAmount: Decimal;
        QualificationAsPerSalary: Decimal;
        CompanyInformation: Record "Company Information";
        objLoanGuarantors: Record "Loans Guarantee Details";
        _loans: Record "Loans Register";
        _guarantors: Record "Loans Guarantee Details";
        _variant: Variant;
        ApprovalManagement: Codeunit "Approvals Mgmt.";
        _approvalEntry: Record "Approval Entry";

    procedure FnmemberInfo(MemberNo: Code[20]) info: Text
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            info := objMember."No." + '.' + ':' + objMember.Name + '.' + ':' + objMember."E-Mail" + '.' + ':' + Format(objMember.Status) + '.' + ':' + Format(objMember."Account Category") + '.' + ':' + objMember."Mobile Phone No"
            + '.' + ':' + objMember."ID No." + '.' + ':' + objMember."BOSA Account No.";

        end
        else
            objMember.Reset;
        objMember.SetRange(objMember."ID No.", MemberNo);
        if objMember.Find('-') then begin
            info := objMember."No." + '.' + ':' + objMember.Name + '.' + ':' + objMember."E-Mail" + '.' + ':' + objMember."Employer Name" + '.' + ':' + Format(objMember."Account Category") + '.' + ':' + objMember."Mobile Phone No"
            + '.' + ':' + objMember."Bank Code" + '.' + ':' + objMember."Bank Account No." + '.' + ':' + objMember."BOSA Account No.";

        end;
    end;

    procedure GetDashboardStatistics(MemberNo: Code[10]) responsetext: Text
    var
        bdeposits: Decimal;
        mDeposits: Decimal;
        rsf: Decimal;
        fosaShares: Decimal;
        outstandingLoans: Decimal;
        overallSavings: Decimal;
        sharecapital: Decimal;
        overallLoans: Decimal;
    begin
        bdeposits := 0;
        mDeposits := 0;
        rsf := 0;
        fosaShares := 0;
        outstandingLoans := 0;
        overallSavings := 0;
        sharecapital := 0;
        overallLoans := 0;

        if objMember.Get(MemberNo) then begin
            objMember.CalcFields("Shares Retained", "Outstanding Balance", "Outstanding Interest", "Current Shares");
            bdeposits := objMember."Current Shares";
            outstandingLoans := objMember."Outstanding Balance" + objMember."Outstanding Interest";
            sharecapital := objMember."Shares Retained";
        end;

        overallSavings := bdeposits + mDeposits + rsf + fosaShares;
        overallLoans := outstandingLoans;
        responsetext := Format(bdeposits) + ':::' + Format(mDeposits) + ':::' + Format(rsf) + ':::' + Format(fosaShares) + ':::' + Format(outstandingLoans) + ':::' + Format(overallSavings) + ':::' + Format(sharecapital) + ':::' + Format(overallLoans) + ':::';
    end;

    procedure MiniStatement(MemberNo: Text[100]) MiniStmt: Text
    var
        minimunCount: Integer;
        amount: Decimal;
        description: Text;
        Members: Record Customer;
        loanrepayment2: Option;
        shareCap: Option;
        depContribution: Option;
        runcount: Integer;
        MaxNumberOfRows: Integer;
        MemberLedgerEntry: Record "Cust. Ledger Entry";
    begin

        Members.Reset;
        Members.SetRange(Members."No.", MemberNo);
        if Members.Find('-') then begin
            shareCap := MemberLedgerEntry."transaction type"::"Shares Capital";
            depContribution := MemberLedgerEntry."transaction type"::"Deposit Contribution";
            loanrepayment2 := MemberLedgerEntry."transaction type"::"Repayment";
            MaxNumberOfRows := 10;

            MemberLedgerEntry.Reset;
            MemberLedgerEntry.SetRange(MemberLedgerEntry."Customer No.", Members."No.");
            MemberLedgerEntry.SetFilter(MemberLedgerEntry."Transaction Type", '%1|%2|%3', shareCap, depContribution, loanrepayment2);
            MemberLedgerEntry.Ascending(false);
            if MemberLedgerEntry.Find('-') then begin
                repeat
                    MemberLedgerEntry.CalcFields(Amount);
                    MiniStmt := MiniStmt + Format(MemberLedgerEntry."Posting Date") + '|' + Format(MemberLedgerEntry."Transaction Type") + '|' + Format((Abs(MemberLedgerEntry.Amount))) + ';';
                    runcount := runcount + 1;
                    if runcount >= 10 then begin
                        exit(MiniStmt);
                    end;
                until MemberLedgerEntry.Next = 0;
            end else begin
                MiniStmt := 'No transactions were found';
                exit(MiniStmt);
            end
        end else begin
            MiniStmt := 'Member not found';
            exit(MiniStmt);
        end
    end;

    procedure fndividendStatement(No: Code[50]; Path: Text[100])
    var
        filename: Text;
        "Member No": Code[50];
    begin
        filename := FILESPATH + Path;
        if Exists(filename) then
            Erase(filename);
        objMember.Reset;
        objMember.SetRange(objMember."No.", No);

        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516241, filename, objMember);

        end;
    end;



    procedure FnRegisterKin("Full Names": Text; Relationship: Text; "ID Number": Code[10]; "Phone Contact": Code[10]; Address: Text; Idnomemberapp: Code[10])
    begin
        begin
            objRegMember.Reset;
            objNextKin.Reset;
            objNextKin.Init();
            objRegMember.SetRange("ID No.", Idnomemberapp);
            if objRegMember.Find('-') then begin
                objNextKin."Account No" := objRegMember."No.";
                objNextKin.Name := "Full Names";
                objNextKin.Relationship := Relationship;
                objNextKin."ID No." := "ID Number";
                objNextKin.Telephone := "Phone Contact";
                objNextKin.Address := Address;
                objNextKin.Insert(true);
            end;
        end;
    end;


    procedure fnGetNextofkin(MemberNumber: Code[20]) return: Text
    begin
        objNextKin.Reset;
        objNextKin.SetRange("Account No", MemberNumber);
        if objNextKin.Find('-') then begin
            repeat
                return := return + objNextKin.Name + ':::' + objNextKin.Relationship + ':::' + Format(objNextKin."%Allocation") + '::::';
            until objNextKin.Next = 0;
        end;
    end;

    procedure FnMemberApplication("First Name": Code[30]; "Mid Name": Code[30]; "Last Name": Code[30]; "PO Box": Text; Residence: Code[30]; "Postal Code": Text; Town: Code[30]; "Phone Number": Code[30]; Email: Text; "ID Number": Code[30]; "Branch Code": Code[30]; "Branch Name": Code[30]; "Account Number": Code[30]; Gender: Option; "Marital Status": Option; "Account Category": Option; "Application Category": Option; "Customer Group": Code[30]; "Employer Name": Code[30]; "Date of Birth": Date) num: Text
    begin
        begin

            objRegMember.Reset;
            objRegMember.SetRange("ID No.", "ID Number");
            if objRegMember.Find('-') then begin
                Message('already registered');
            end
            else begin
                objRegMember.Init;
                objRegMember.Name := "First Name" + ' ' + "Mid Name" + ' ' + "Last Name";
                objRegMember.Address := "PO Box";
                objRegMember."Address 2" := Residence;
                objRegMember."Postal Code" := "Postal Code";
                objRegMember.Town := Town;
                objRegMember."Mobile Phone No" := "Phone Number";
                objRegMember."E-Mail (Personal)" := Email;
                objRegMember."Date of Birth" := "Date of Birth";
                objRegMember."ID No." := "ID Number";
                objRegMember."Bank Code" := "Branch Code";
                objRegMember."Bank Name" := "Branch Name";
                objRegMember."Bank Account No" := "Account Number";
                objRegMember.Gender := Gender;
                objRegMember."Created By" := UserId;
                objRegMember."Global Dimension 1 Code" := 'BOSA';
                objRegMember."Registration Date" := Today;
                objRegMember.Status := objRegMember.Status::Open;
                //objRegMember."Application Category" := "Application Category";
                objRegMember."Account Category" := "Account Category";
                objRegMember."Marital Status" := "Marital Status";
                objRegMember."Employer Name" := "Employer Name";
                objRegMember."Customer Posting Group" := "Customer Group";
                objRegMember.Insert(true);
            end;


            //FnRegisterKin('','','','','');
        end;
    end;

    procedure LoanApplication(memberNo: Code[20]; loanType: Code[20]; interest: Decimal; months: Integer; amount: Decimal; bank: Code[20]; bankBranch: Code[20]; bankAccount: Code[50]; remarks: Text[250]; portalb: Boolean) loanNo: Code[20]
    var
        _record: Record "Loans Register";
        membersTable: Record Customer;
    begin

        membersTable.Reset;
        membersTable.SetRange(membersTable."No.", memberNo);
        if membersTable.Find('-') then begin

            _record.Reset;
            _record."Loan Product Type" := loanType;
            _record.Interest := interest;
            _record.Installments := months;
            _record."Client Code" := memberNo;
            _record."Client Name" := membersTable.Name;
            _record."ID NO" := membersTable."ID No.";
            _record."Requested Amount" := amount;
            _record."Approved Amount" := amount;
            _record."Bank No" := bank;
            _record."Bank Branch" := bankBranch;
            _record."Bank No" := bankAccount;
            _record.Remarks := remarks;
            _record."Loan Status" := _record."loan status"::Application;
            _record.Source := _record.Source::BOSA;
            //_record.pORTAL:=portalb;
            _record.Insert(true);

            loanNo := _record."Loan  No.";
        end;
    end;

    procedure SendApprovalRequest(Type: Option Loan; AppNo: Code[20])
    begin
        begin
            if (Type = Type::Loan) then begin
                _loans.Reset;
                _loans.SetRange("Loan  No.", AppNo);
                if (_loans.Find('-')) then begin

                    // if ApprovalManagement.CheckLoanApplicationApprovalsWorkflowEnabled(_loans) then
                    //  ApprovalManagement.OnSendLoanApplicationForApproval(_loans);

                end
                else
                    Error('The record cannot be found: ' + AppNo);
            end;

        end;

    end;

    procedure CancelApprovalRequest(Type: Option Loan; AppNo: Code[20])
    begin
        if (Type = Type::Loan) then begin
            _loans.Reset;
            _loans.SetRange("Loan  No.", AppNo);
            if (_loans.Find('-')) then begin
                _variant := _loans;
                //ApprovalManagement.OnCancelDocApprovalRequest(_variant);
            end
            else
                Error('The record cannot be found: ' + AppNo);
        end;

    end;

    procedure Approve(Type: Option Loan; AppNo: Code[20])
    begin
        if (Type = Type::Loan) then begin
            _approvalEntry.Reset;
            _approvalEntry.SetRange("Document Type", _approvalEntry."document type"::LoanApplication);
            _approvalEntry.SetRange("Document No.", AppNo);
            _approvalEntry.SetRange(Status, _approvalEntry.Status::Open);
            if (_approvalEntry.Find('-')) then begin
                ApprovalManagement.ApproveApprovalRequests(_approvalEntry);
            end
            else
                Error('The record cannot be found: ' + AppNo);
        end;

    end;

    procedure Reject(Type: Option Loan; AppNo: Code[20])
    begin
        if (Type = Type::Loan) then begin
            _approvalEntry.Reset;
            _approvalEntry.SetRange("Document Type", _approvalEntry."document type"::LoanApplication);
            _approvalEntry.SetRange("Document No.", AppNo);
            _approvalEntry.SetRange(Status, _approvalEntry.Status::Open);
            if (_approvalEntry.Find('-')) then begin
                ApprovalManagement.RejectApprovalRequests(_approvalEntry);
            end
            else
                Error('The record cannot be found: ' + AppNo);
        end;

    end;

    procedure Delegate(Type: Option Loan; AppNo: Code[20])
    begin
        if (Type = Type::Loan) then begin
            _approvalEntry.Reset;
            _approvalEntry.SetRange("Document Type", _approvalEntry."document type"::LoanApplication);
            _approvalEntry.SetRange("Document No.", AppNo);
            _approvalEntry.SetRange(Status, _approvalEntry.Status::Open);
            if (_approvalEntry.Find('-')) then begin
                ApprovalManagement.DelegateApprovalRequests(_approvalEntry);
            end
            else
                Error('The record cannot be found: ' + AppNo);
        end;

    end;

    procedure ApprovalEntriesApprove(entryNo: Integer) success: Text[250]
    var
        _record: Record "Approval Entry";
    begin
        _approvalEntry.Reset;
        _approvalEntry.SetRange(_approvalEntry."Entry No.", entryNo);

        if (_approvalEntry.Find('-')) then begin
            _approvalEntry.Status := _approvalEntry.Status::Approved;

            _approvalEntry.Modify();
        end;
    end;

    procedure ApprovalEntriesReject(entryNo: Integer) success: Text[250]
    var
        _record: Record "Approval Entry";
    begin
        _approvalEntry.Reset;
        _approvalEntry.SetRange(_approvalEntry."Entry No.", entryNo);

        if (_approvalEntry.Find('-')) then begin
            _approvalEntry.Status := _approvalEntry.Status::Rejected;

            _approvalEntry.Modify();
        end;
    end;

    procedure ApprovalEntriesDelegate(entryNo: Integer) success: Text[250]
    var
        _record: Record "Approval Entry";
    begin
        _approvalEntry.Reset;
        _approvalEntry.SetRange(_approvalEntry."Entry No.", entryNo);

        if (_approvalEntry.Find('-')) then begin
            _approvalEntry.Status := _approvalEntry.Status::Open;

            _approvalEntry.Modify();
        end;
    end;

    procedure GuarantorAccept(loanNo: Code[20]; guarantorNo: Code[20]) success: Text[250]
    var
        _record: Record "Loans Guarantee Details";
    begin
        _record.Reset;
        _record.SetRange(_record."Loan No", loanNo);
        _record.SetRange(_record."Member No", guarantorNo);

        if (_record.Find('-')) then begin
            _record."Acceptance Status" := _record."acceptance status"::Accepted;
            _record.Modify();
            success := 'Request has been successfully Approved.';
        end
        else
            Error('Integrity breach! The loan and guarantor number');
    end;

    procedure GuarantorReject(loanNo: Code[20]; guarantorNo: Code[20]) success: Text[250]
    var
        _record: Record "Loans Guarantee Details";
    begin
        _record.Reset;
        _record.SetRange(_record."Loan No", loanNo);
        _record.SetRange(_record."Member No", guarantorNo);

        if (_record.Find('-')) then begin
            _record."Acceptance Status" := _record."acceptance status"::Declined;
            _record.Modify();
            success := 'Request has been successfully rejected.';
        end
        else
            Error('Integrity breach! The loan and guarantor number');
    end;


    procedure GenerateDividendStatement(MemberNo: Code[50]; Filename: Text[100])
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516241, Filename, objMember);
        end;
    end;


    procedure GenerateLoansGuaranteedStatement(MemberNo: Code[50]; Filename: Text)
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516503, Filename, objMember);
        end;
    end;


    procedure GenerateLoansGuarantorsStatement(MemberNo: Code[50]; Filename: Text)
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516504, Filename, objMember);
        end;
    end;


    procedure GenerateLoanRepaymentShedule("Loan No": Code[50]; Filename: Text)
    begin
        objLoanRegister.Reset;
        objLoanRegister.SetRange(objLoanRegister."Loan  No.", "Loan No");
        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516477, Filename, objLoanRegister);
        end;
    end;


    procedure GenerateDepositsStatement("Account No": Code[30]; StartDate: DateTime; EndDate: DateTime; Filename: Text)
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", "Account No");
        // objMember.SETFILTER("Date Filter", DateFilter);

        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516354, Filename, objMember);
        end;
    end;


    procedure GenerateShareCapitalStatement("Account No": Code[30]; StartDate: DateTime; EndDate: DateTime; Filename: Text)
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", "Account No");
        // objMember.SETFILTER("Date Filter", DateFilter);

        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516908, Filename, objMember);
        end;
    end;


    procedure GenerateLoansStatement(MemberNo: Code[30]; StartDate: DateTime; EndDate: DateTime; FileName: Text)
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        //objMember.SETFILTER("Date Filter", DateFilter);
        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516531, FileName, objMember);
        end;
    end;


    procedure GenerateMemberStatement(MemberNo: Code[50]; StartDate: DateTime; EndDate: DateTime; Filename: Text)
    begin
        if Exists(Filename) then
            Erase(Filename);

        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        //objMember.SETFILTER("Date Filter",DateFilter);
        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516886, Filename, objMember);
        end;
    end;

    procedure GetGuarantorRequestList(memberNo: Text) response: Text
    var

    begin

        _guarantors.Reset;
        _guarantors.SetRange("Member No", memberNo);
        _guarantors.SetRange("Acceptance Status", _guarantors."acceptance status"::Pending);
        if _guarantors.Find('-') then begin
            repeat
                response := response + _guarantors."Loan No" + ':::' + _guarantors."Loanees  No" + ':::' + _guarantors."Loanees  Name" + ':::' + Format(_guarantors."Amont Guaranteed") + ';';
            until _guarantors.Next = 0;
        end
    end;


    procedure GuarantorRequest(memberNo: Code[30]; loanNo: Code[30]; amount: Decimal; actionTaken: Text) returnText: Text
    var

    begin

        begin
            _guarantors.Init;
            _guarantors."Loan No" := loanNo;
            _guarantors."Member No" := memberNo;
            _guarantors."Amont Guaranteed" := amount;
            _guarantors."Acceptance Status" := _guarantors."acceptance status"::Pending;
            _guarantors.Insert;
            returnText := 'True';
        end;
    end;


    procedure FnLoansInsertGuarantor(LoanNumber: Code[100]; MemberNo: Code[100]; LoaneeNumber: Code[100])
    var
        OnlineLoanGuarantors: Record "Loans Guarantee Details";
    begin

        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            OnlineLoanGuarantors.Init;
            OnlineLoanGuarantors."Loan No" := LoanNumber;
            OnlineLoanGuarantors."Member No" := objMember."No.";
            OnlineLoanGuarantors.Validate(OnlineLoanGuarantors."Member No");
            OnlineLoanGuarantors."Loanees  No" := LoaneeNumber;
            OnlineLoanGuarantors.Insert;
        end;
    end;


    procedure fnSaveGuarantor("Loan number": Code[50]; "guarantor number": Code[50])
    begin

        objLoanGuarantors.Reset;
        objLoanGuarantors.SetRange(objLoanGuarantors."Loan No", "Loan number");
        objLoanGuarantors.SetRange(objLoanGuarantors."Member No", "guarantor number");

        if objLoanGuarantors.Find('-') then begin
            Error('The guarantor can not be added twice in one loan!')
        end;
        objLoanGuarantors.Init;
        objLoanGuarantors."Loan No" := "Loan number";
        objLoanGuarantors.Validate(objLoanGuarantors."Loan No");
        objLoanGuarantors."Member No" := "guarantor number";
        objLoanGuarantors.Validate(objLoanGuarantors."Member No");
        objLoanGuarantors.Insert;
        Message('guarantor saved!');
    end;



    procedure FnSMSMessage(accfrom: Text[30]; phone: Text[20]; message: Text[250]; documentNo: Text[20])
    begin

        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else begin
            iEntryNo := 1;
        end;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;

        SMSMessages."Batch No" := documentNo;
        SMSMessages."Document No" := documentNo;
        SMSMessages."Account No" := accfrom;
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'PORTALTRAN';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        SMSMessages."SMS Message" := message;
        SMSMessages."Telephone No" := phone;
        // IF SMSMessages."Telephone No"<>'' THEN
        SMSMessages.Insert;
    end;


    procedure fnLoanBalance(MemberNo: Code[20]) loans: Text
    var
        loanlist: Text;
    begin
        objLoanRegister.Reset;
        objLoanRegister.SetRange("Client Code", MemberNo);
        //objLoanRegister.SETRANGE("Loan Status",objLoanRegister."Loan Status"::Appraisal);
        //objLoanRegister.SETRANGE("Loan Status",objLoanRegister."Loan Status"::Approval1);
        //objLoanRegister.SETRANGE("Loan Status",objLoanRegister."Loan Status"::Approved);
        //objLoanRegister.SETRANGE("Loan Status",objLoanRegister."Loan Status"::"Being Repaid");
        if objLoanRegister.Find('-') then begin
            //objLoanRegister.SETCURRENTKEY("Application Date");
            //objLoanRegister.ASCENDING(FALSE);

            repeat
                //Loanperiod:=Kentoursfactory.KnGetCurrentPeriodForLoan(objLoanRegister."Loan  No.");

                objLoanRegister.CalcFields("Outstanding Balance");
                loanlist := loanlist + '::::' + objLoanRegister."Loan Product Type" + ':' + Format(objLoanRegister."Outstanding Balance") + ':' + Format(objLoanRegister."Loan Status") + ':' + Format(objLoanRegister.Installments) + ':'
                  + Format(objLoanRegister.Installments - Loanperiod) + ':' + Format(objLoanRegister."Approved Amount") + ':' + Format(objLoanRegister."Requested Amount") + ':' + objLoanRegister."Loan  No." + '::::';

            until objLoanRegister.Next = 0;
            loans := loanlist;

        end;
    end;


    procedure fnLoanCalculator(LoanAmount: Decimal; RepayPeriod: Integer; LoanCode: Code[30]) text: Text
    begin
        Loansetup.Reset;
        Loansetup.SetRange(Loansetup.Code, LoanCode);

        if Loansetup.Find('-') then begin

            if Loansetup."Repayment Method" = Loansetup."repayment method"::Amortised then begin

                repeat
                    Date := Today;

                    Loansetup.TestField(Loansetup."Interest rate");
                    Loansetup.TestField(Loansetup."Instalment Period");
                    TotalMRepay := ROUND((Loansetup."Interest rate" / 12 / 100) / (1 - Power((1 + (Loansetup."Interest rate" / 12 / 100)), -RepayPeriod)) * (LoanAmount), 0.05, '>');
                    LInterest := ROUND((LBalance / 100 / 12) * InterestRate, 0.005, '>');
                    LPrincipal := TotalMRepay - LInterest;
                    RepayPeriod := RepayPeriod - 1;

                    Date := CalcDate('+1M', Date);
                    Message(Format(Date));
                    text := text + Format(Date) + '!!' + Format(ROUND(LPrincipal)) + '!!' + Format(ROUND(LInterest)) + '!!' + Format(ROUND(TotalMRepay)) + '!!' + Format(ROUND(LoanAmount)) + '??';

                    //MESSAGE(FORMAT( TotalMRepay));
                    Message(Format(LInterest));
                // MESSAGE(FORMAT( LPrincipal));
                until RepayPeriod = 0;

            end;
            if Loansetup."Repayment Method" = Loansetup."repayment method"::"Straight Line" then begin
                repeat
                    Date := Today;
                    //LoansRec.TESTFIELD(LoansRec.Interest);
                    //LoansRec.TESTFIELD(LoansRec.Installments);

                    LPrincipal := LoanAmount / RepayPeriod;
                    LInterest := (Loansetup."Interest rate" / 12 / 100) * LoanAmount / RepayPeriod;
                    TotalMRepay := LPrincipal + LInterest;
                    RepayPeriod := RepayPeriod - 1;
                    LoanAmount := LoanAmount - LPrincipal;
                    text := text + Format(Date) + '!!' + Format(ROUND(LPrincipal)) + '!!' + Format(ROUND(LInterest)) + '!!' + Format(ROUND(TotalMRepay)) + '!!' + Format(ROUND(LoanAmount)) + '??';
                    Date := CalcDate('+1M', Date);
                until RepayPeriod = 0;
            end;


            if Loansetup."Repayment Method" = Loansetup."repayment method"::"Reducing Balance" then begin
                //LoansRec.TESTFIELD(LoansRec.Interest);
                //LoansRec.TESTFIELD(LoansRec.Installments);
                Message('type is %1', LoanCode);
                Date := Today;

                //    //MESSAGE('HERE');
                //  // TotalMRepay:=ROUND((Loansetup."Interest Rate2"/12/100) / (1 - POWER((1 +(Loansetup."Interest Rate2"/12/100)),- (RepayPeriod))) * (LoanAmount),0.0001,'>');
                //   REPEAT
                //  LInterest:=ROUND(LoanAmount * Loansetup."Interest Rate2"/12/100,0.0001,'>');
                //  LPrincipal:=TotalMRepay-LInterest;
                //    LoanAmount:=LoanAmount-LPrincipal;
                // RepayPeriod:= RepayPeriod-1;
                //
                //  text:=text+FORMAT(Date)+'!!'+FORMAT(ROUND( LPrincipal))+'!!'+FORMAT(ROUND( LInterest))+'!!'+FORMAT(ROUND(TotalMRepay))+'!!'+FORMAT(ROUND(LoanAmount))+'??';
                //  Date:=CALCDATE('+1M', Date);
                //
                //  UNTIL RepayPeriod=0;

                // ELSE BEGIN
                TotalMRepay := ROUND((Loansetup."Interest rate" / 12 / 100) / (1 - Power((1 + (Loansetup."Interest rate" / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 0.0001, '>');
                repeat
                    LInterest := ROUND(LoanAmount * Loansetup."Interest rate" / 12 / 100, 0.0001, '>');
                    LPrincipal := TotalMRepay - LInterest;
                    LoanAmount := LoanAmount - LPrincipal;
                    RepayPeriod := RepayPeriod - 1;

                    text := text + Format(Date) + '!!' + Format(ROUND(LPrincipal)) + '!!' + Format(ROUND(LInterest)) + '!!' + Format(ROUND(TotalMRepay)) + '!!' + Format(ROUND(LoanAmount)) + '??';
                    Date := CalcDate('+1M', Date);

                until RepayPeriod = 0;
            end;

            /*IF  Loansetup."Repayment Method"= Loansetup."Repayment Method"::Constants THEN BEGIN
            LoansRec.TESTFIELD(LoansRec.Repayment);
            IF LBalance < LoansRec.Repayment THEN
            LPrincipal:=LBalance
            ELSE
            LPrincipal:=LoansRec.Repayment;
            LInterest:=LoansRec.Interest;
            END;*/



            //END;

            //EXIT(Amount);
        end;

    end;


    procedure fnLoanProducts() loanType: Text
    begin
        Loansetup.Reset;
        if Loansetup.Find('-') then begin
            loanType := '';
            repeat
                loanType := Format(Loansetup.Code) + ':' + Loansetup."Product Description" + ':::' + loanType;
            until Loansetup.Next = 0;
        end;
    end;


    procedure fnGetLoanProductDetails(productType: Text) response: Text
    begin

        Loansetup.Reset;
        Loansetup.SetRange(Code, productType);
        if Loansetup.Find('-') then begin
            response := Format(Loansetup."Min. Loan Amount") + ':::' + Format(Loansetup."Max. Loan Amount") + ':::' + Format(Loansetup."Interest rate") + ':::' + Format(Loansetup."No of Installment");
        end;
    end;


    procedure fnedtitloan(memberNo: Text; Amount: Decimal; Loan: Code[20]; Repaymperiod: Integer; LoanPurpose: Code[20]; LoanType: Code[20])
    begin
        objLoanRegister.Reset;
        objLoanRegister.SetRange("Client Code", memberNo);
        objLoanRegister.SetRange("Loan  No.", Loan);
        if objLoanRegister.Find('-') then begin
            objLoanRegister.Init;
            objLoanRegister."Requested Amount" := Amount;
            objLoanRegister.Validate("Requested Amount");
            objLoanRegister.Installments := Repaymperiod;
            // objLoanRegister.VALIDATE(Installments);
            objLoanRegister."Loan Product Type" := LoanType;
            objLoanRegister.Validate("Loan Product Type");
            objLoanRegister."Loan Purpose" := LoanPurpose;
            objLoanRegister.Validate("Loan Purpose");
            objLoanRegister.Modify;
        end;
    end;


    procedure fnGetLoanNumber(memberno: Code[50]) loanno: Code[1024]
    var
        faccount: Code[1024];
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", memberno);
        if objMember.Find('-') then
            objLoanRegister.Reset;
        objLoanRegister.SetRange(objLoanRegister."Client Code", memberno);
        if objLoanRegister.Find('-') then begin
            repeat
                faccount := faccount + '::::' + objLoanRegister."Loan  No." + ' - ' + objLoanRegister."Loan Product Type Name" + '::::';

            until objLoanRegister.Next = 0;
            loanno := faccount;

        end;
    end;


    procedure FnValidateOtp(ServiceNo: Text[10]; otp: Text[6]) Response: Boolean
    begin
        objMember.Reset;
        objMember.SetRange("No.", ServiceNo);
        //objMember.SETRANGE("OTP Code", otp);
        if objMember.Find('-') then begin
            Response := true;
        end
        else
            Response := false;
        exit(Response);
    end;


    // procedure FnGetProfilePic(ServiceNo: Code[50];BigText: BigText)
    // var
    //     Members: Record Customer;
    //     Convert: dotnet Convert;
    //     Path: dotnet Path;
    //     _File: dotnet File;
    //     FileAccess: dotnet FileMode;
    //     FileMode: dotnet FileMode;
    //     MemoryStream: dotnet MemoryStream;
    //     FileStream: dotnet FileStream;
    //     Outputstream: OutStream;
    //     FileName: Text[100];
    //     "Count": Integer;
    //     FilePath: Text;
    // begin
    //     Members.Reset;
    //     Members.SetRange("No.", ServiceNo);
    //     if Members.FindFirst() then begin
    //       FileName:='C:\inetpub\wwwroot\SaccoData\MemberPics\'+ServiceNo+'.png';

    //       Members.Picture.ExportFile(FileName);
    //       Message(FileName);
    //     end;
    // end;


    // procedure GetPic(ServiceNo: Code[20])
    // var
    //     Members: Record Customer;
    //     "count": Boolean;
    //     Text000: label '%1 media files were exported';
    // begin
    //     Members.Reset;
    //     Members.SetRange("No.", ServiceNo);
    //     if Members.FindFirst() then begin
    //       Filename:='C:\inetpub\wwwroot\SaccoData\MemberPics\'+ServiceNo+'.png';
    //       //Members.CALCFIELDS(Picture);
    //       Members.Picture.ExportFile(Filename);
    //       Message(Filename);
    //       //MESSAGE('%1 files exported.', count)
    //       end
    // end;


    procedure GetPhoneNo(MemberNo: Code[20]) number: Code[20]
    var
        ObjMemberRegister: Record Customer;
        ObjGuaranteeDetails: Record "Loans Guarantee Details";
    begin
        ObjMemberRegister.Reset;
        ObjMemberRegister.SetRange(ObjMemberRegister."No.", MemberNo);
        if ObjMemberRegister.Find('-') then begin
            number := ObjMemberRegister."Phone No.";
        end;
        exit(number);
    end;

    procedure fnAppliedLoans(MemberNo: Code[20]) loans: Text
    var
        loanlist: Text;
    begin
        objLoanRegister.Reset;
        objLoanRegister.SetRange("Client Code", MemberNo);
        objLoanRegister.SetRange("Loan Status", objLoanRegister."loan status"::Application); // Filter for "Application" status

        if objLoanRegister.Find('-') then begin
            repeat
                objLoanRegister.CalcFields("Outstanding Balance");
                loanlist := loanlist + '::::' + objLoanRegister."Loan Product Type" + ':' + Format(objLoanRegister."Outstanding Balance") + ':' + Format(objLoanRegister."Loan Status") + ':' + Format(objLoanRegister.Installments) + ':'
                  + Format(objLoanRegister.Installments - Loanperiod) + ':' + Format(objLoanRegister."Approved Amount") + ':' + Format(objLoanRegister."Requested Amount") + ':' + objLoanRegister."Loan  No." + '::::';

            until objLoanRegister.Next = 0;
        end;
    end;


    procedure FnSpecificloanCalc(LoanAmount: Decimal; RepayPeriod: Integer; LoanCode: Code[30]; MmemberNo: Code[10]; BasicSalary: Decimal; TotalDeductions: Decimal) text: Text
    var
        InterestRate: Decimal;
        LBalance: Decimal;
        BosaLoans: Record "Loans Register";
        FosaLoans: Record Vendor;
        Cust: Record Customer;
        Psalary: Decimal;
        Msalary: Decimal;
    begin
        Loansetup.Reset;
        Loansetup.SetRange(Code, LoanCode);

        if Loansetup.Find('-') then begin
            if Loansetup."Repayment Method" = Loansetup."repayment method"::"Straight Line" then
                LPrincipal := LoanAmount / RepayPeriod;
            LInterest := (Loansetup."Interest rate" / 12 / 100) * LoanAmount / RepayPeriod;
            TotalMRepay := LPrincipal + LInterest;
            RepayPeriod := RepayPeriod - 1;
            // LoanAmount:=LoanAmount-LPrincipal;


            Psalary := (2 / 3 * (BasicSalary - TotalDeductions));

            Msalary := ROUND((Psalary * LoanAmount) / RepayPeriod, 100, '<');


            if (Psalary > TotalMRepay) or (Psalary = TotalMRepay) then
                Msalary := LoanAmount
            else
                //Msalary:=ROUND((BasicSalary*100*RepayPeriod)/(100+RepayPeriod),100,'<');
                Msalary := ROUND((Psalary * LoanAmount) / TotalMRepay, 100, '<');
            QualificationAsPerSalary := LoanAmount;
            //End Qualification As Per Salary
            Message(Format(QualificationAsPerSalary));
            //Qualification As Per Deposits
            Loansetup.Reset;
            Loansetup.SetRange(Code, LoanCode);

            if Loansetup.Find('-') then begin
                objMember.Reset;
                objMember.SetRange("No.", MmemberNo);
                if objMember.Find('-') then begin
                    objMember.CalcFields("Current Shares");
                    objMember.CalcFields("Total Loans Outstanding");
                    qualificationasperSeposit := (objMember."Current Shares" * Loansetup."Shares Multiplier") - (objMember."Total Loans Outstanding");

                    if qualificationasperSeposit > LoanAmount then
                        qualificationasperSeposit := LoanAmount
                    else
                        qualificationasperSeposit := qualificationasperSeposit;

                end;

            end;
            // "Deficit on Deposit":=("Requested Amount"-"Qualification As Per Deposit")/LoanType."Shares Multiplier";
            //End Qualification As Per Deposits

            if qualificationasperSeposit < QualificationAsPerSalary then
                EligibleAmount := qualificationasperSeposit
            else
                if QualificationAsPerSalary < qualificationasperSeposit then
                    EligibleAmount := QualificationAsPerSalary;
            Message(Format(QualificationAsPerSalary));
            text := text + Format(ROUND(qualificationasperSeposit)) + '!!' + Format(ROUND(QualificationAsPerSalary)) + '!!' + Format(ROUND(EligibleAmount));
            // Date:=CALCDATE('+1M', Date);

        end;
    end;


    procedure FnValidateMember(memberNo: Text; Idnumber: Text) valid: Text
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", memberNo);
        objMember.SetRange(objMember."ID No.", Idnumber);
        if objMember.Find('-') then begin
            valid := 'success';

        end
        else
            Error('Invalid details! Please confirm your Id Number and Member Number and try again.');
    end;

    procedure FnMyGuarantors(memberno: Text) guarantors: Text
    var
        OnlineLoanGuarantors: Record "Loans Guarantee Details";
    begin

        _guarantors.Reset;
        _guarantors.SetRange("Loanees  No", memberno);
        //OnlineLoanGuarantors.SETRANGE("Approval Status", OnlineLoanGuarantors."Approval Status"::Pending);
        if _guarantors.Find('-') then begin
            repeat
                guarantors := guarantors + _guarantors."Loan No" + ':::' + _guarantors."Member No" + ':::' + _guarantors.Name + ':::' + Format(_guarantors."Amont Guaranteed") + ';';
            until OnlineLoanGuarantors.Next = 0;
        end;
    end;
}

