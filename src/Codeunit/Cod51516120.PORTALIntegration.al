// // #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516120 "PORTALIntegration"
{

    trigger OnRun()
    begin

    end;

    var
        objMember: Record Customer;
        objLoanRegister: Record "Loans Register";
        objRegMember: Record "Membership Applications";
        objNextKin: Record "Members Next Kin Details";
        LoansGuaranteeDetails: Record "Loans Guarantee Details";
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
        Loansetup: Record "Loan Products Setup";
        LoansPurpose: Record "Loans Purpose";
        ObjLoansregister: Record "Loans Register";
        LPrincipal: Decimal;
        LInterest: Decimal;
        Amount: Decimal;
        LBalance: Decimal;
        TotalMRepay: Decimal;
        InterestRate: Decimal;
        Date: Date;
        FormNo: Code[40];
        Loanperiod: Integer;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        LineNo: Integer;
        Gnjlline: Record "Gen. Journal Line";
        FILESPATH: label 'C:\inetpub\wwwroot\SaccoData\PdfDocs';
        CompanyInformation: Record "Company Information";
        _loans: Record "Loans Register";
        _members: Record Customer;
        _guarantors: Record "Loans Guarantee Details";
        _variant: Variant;
        ApprovalManagement: Codeunit "Approvals Mgmt.";
        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
        _approvalEntry: Record "Approval Entry";


    procedure FnmemberInfo(MemberNo: Code[20]) info: Text
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            info := objMember."No." + '.' + ':' + objMember.Name + '.' + ':' + objMember."E-Mail" + '.' + ':' + Format(objMember.Status) + '.' + ':' + Format(objMember."Account Category") + '.' + ':' + objMember."Mobile Phone No"
            + '.' + ':' + objMember."ID No." + '.';

        end
        else
            objMember.Reset;
        objMember.SetRange(objMember."ID No.", MemberNo);
        if objMember.Find('-') then begin
            info := objMember."No." + '.' + ':' + objMember.Name + '.' + ':' + objMember."E-Mail" + '.' + ':' + objMember."Employer Name" + '.' + ':' + Format(objMember."Account Category") + '.' + ':' + objMember."Mobile Phone No"
            + '.' + ':' + objMember."Bank Code" + '.' + ':' + objMember."Bank Account No." + '.';

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

        objMember.Reset();
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-')
         then begin
            objMember.CalcFields("Shares Retained", "Outstanding Balance", "Outstanding Interest", "Current Shares");
            bdeposits := objMember."Current Shares";
            outstandingLoans := objMember."Outstanding Balance" + objMember."Outstanding Interest";
            sharecapital := objMember."Shares Retained";

            overallSavings := bdeposits + mDeposits + rsf + fosaShares;
            overallLoans := outstandingLoans;
            responsetext := Format(bdeposits) + ':::' + Format(mDeposits) + ':::' + Format(rsf) + ':::' + Format(fosaShares) + ':::' + Format(outstandingLoans) + ':::' + Format(overallSavings) + ':::' + Format(sharecapital) + ':::' + Format(overallLoans) + ':::';
        end else
            responsetext := 'Member Not Found.'


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
            loanrepayment2 := MemberLedgerEntry."transaction type"::Repayment;
            MaxNumberOfRows := 10;

            MemberLedgerEntry.Reset;
            MemberLedgerEntry.SetRange(MemberLedgerEntry."Customer No.", Members."No.");
            MemberLedgerEntry.SetFilter(MemberLedgerEntry."Transaction Type", '%1|%2|%3', shareCap, depContribution, loanrepayment2);
            MemberLedgerEntry.Ascending(false);
            if MemberLedgerEntry.Find('-') then begin
                repeat
                    MiniStmt := MiniStmt + Format(MemberLedgerEntry."Posting Date") + '|' + Format(MemberLedgerEntry."Transaction Type") + '|' + Format((Abs(MemberLedgerEntry."Amount Posted"))) + ';';
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


    procedure fnMemberStatement(MemberNo: Code[50]; "filter": Text; var BigText: BigText) exitString: Text
    var
        Filename: Text[100];
        Convert: dotnet Convert;
        Path: dotnet Path;
        _File: dotnet File;
        FileAccess: Integer;
        FileMode: dotnet FileMode;
        MemoryStream: dotnet MemoryStream;
        FileStream: dotnet FileStream;
        Outputstream: OutStream;
    begin


        Message(FILESPATH);

        if Exists(Filename) then
            Erase(Filename);
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        objMember.SetFilter("Date Filter", filter);
        Filename := Path.GetTempPath() + Path.GetRandomFileName();
        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516886, Filename, objMember);
            FileMode := 4;
            FileAccess := 1;

            FileStream := _File.Open(Filename, FileMode, FileAccess);

            MemoryStream := MemoryStream.MemoryStream();

            MemoryStream.SetLength(FileStream.Length);
            FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

            BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
            Message(Format(BigText));
            // exitString:=BigText;
            //MESSAGE(exitString);
            MemoryStream.Close();
            MemoryStream.Dispose();
            FileStream.Close();
            FileStream.Dispose();
            _File.Delete(Filename);

        end;
    end;


    procedure fndividentstatement(No: Code[50]; Path: Text[100])
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


    procedure fnLoanGuranteed(MemberNo: Code[50]; "filter": Text; var BigText: BigText)
    var
        Filename: Text[100];
        Convert: dotnet Convert;
        Path: dotnet Path;
        _File: dotnet File;
        FileAccess: Integer;
        FileMode: dotnet FileMode;
        MemoryStream: dotnet MemoryStream;
        FileStream: dotnet FileStream;
        Outputstream: OutStream;
    begin

        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);


        if objMember.Find('-') then begin
            //  objMember.SETFILTER("Date Filter", filter);
            Filename := Path.GetTempPath() + Path.GetRandomFileName();
            Report.SaveAsPdf(51516503, Filename, objMember);

            FileMode := 4;
            FileAccess := 1;

            FileStream := _File.Open(Filename, FileMode, FileAccess);

            MemoryStream := MemoryStream.MemoryStream();

            MemoryStream.SetLength(FileStream.Length);
            FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

            BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
            Message(Format(BigText));
            // exitString:=BigText;
            //MESSAGE(exitString);
            MemoryStream.Close();
            MemoryStream.Dispose();
            FileStream.Close();
            FileStream.Dispose();
            _File.Delete(Filename);

        end;
    end;


    procedure fnLoanRepaymentShedule(MemberNo: Code[50]; var BigText: BigText)
    var
        Filename: Text[100];
        Convert: dotnet Convert;
        Path: dotnet Path;
        _File: dotnet File;
        FileAccess: Integer;
        FileMode: dotnet FileMode;
        MemoryStream: dotnet MemoryStream;
        FileStream: dotnet FileStream;
        Outputstream: OutStream;
    begin
        Message(FILESPATH);

        if Exists(Filename) then
            Erase(Filename);
        objLoanRegister.Reset;
        objLoanRegister.SetRange(objLoanRegister."Loan  No.", MemberNo);
        Filename := Path.GetTempPath() + Path.GetRandomFileName();
        if objLoanRegister.Find('-') then begin
            Report.SaveAsPdf(51516477, Filename, objLoanRegister);
            FileMode := 4;
            FileAccess := 1;

            FileStream := _File.Open(Filename, FileMode, FileAccess);

            MemoryStream := MemoryStream.MemoryStream();

            MemoryStream.SetLength(FileStream.Length);
            FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

            BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
            Message(Format(BigText));
            // exitString:=BigText;
            //MESSAGE(exitString);
            MemoryStream.Close();
            MemoryStream.Dispose();
            FileStream.Close();
            FileStream.Dispose();
            _File.Delete(Filename);

        end;
    end;


    procedure fnLoanGurantorsReport(MemberNo: Code[50]; "filter": Text; var BigText: BigText)
    var
        Filename: Text[100];
        Convert: dotnet Convert;
        Path: dotnet Path;
        _File: dotnet File;
        FileAccess: Integer;
        FileMode: dotnet FileMode;
        MemoryStream: dotnet MemoryStream;
        FileStream: dotnet FileStream;
        Outputstream: OutStream;
    begin

        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);


        if objMember.Find('-') then begin
            //  objMember.SETFILTER("Date Filter", filter);
            Filename := Path.GetTempPath() + Path.GetRandomFileName();
            Report.SaveAsPdf(51516504, Filename, objMember);

            FileMode := 4;
            FileAccess := 1;

            FileStream := _File.Open(Filename, FileMode, FileAccess);

            MemoryStream := MemoryStream.MemoryStream();

            MemoryStream.SetLength(FileStream.Length);
            FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

            BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
            Message(Format(BigText));
            // exitString:=BigText;
            //MESSAGE(exitString);
            MemoryStream.Close();
            MemoryStream.Dispose();
            FileStream.Close();
            FileStream.Dispose();
            _File.Delete(Filename);

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

    procedure LoanApplication(memberNo: Code[20]; loanType: Code[20]; interest: Decimal; months: Integer; amount: Decimal; bank: Code[20]; bankBranch: Code[20]; bankAccount: Code[50]; remarks: Text[250]) loanNo: Code[20]
    var
        _record: Record "Loans Register";
    begin
        _record.Reset;

        _record."Loan Product Type" := loanType;
        _record.Interest := interest;
        _record.Installments := months;
        _record."Requested Amount" := amount;
        _record."Approved Amount" := amount;
        _record."Branch Code" := bank;
        _record."Bank Branch" := bankBranch;
        _record."Bank No" := bankAccount;
        _record.Remarks := remarks;
        _record."Loan Status" := _record."loan status"::Application;
        _record.Source := _record.Source::BOSA;

        _record.Insert(true);
        loanNo := _record."Loan  No.";
    end;

    procedure SendApprovalRequest(Type: Option Loan; AppNo: Code[20])
    begin
        begin
            if (Type = Type::Loan) then begin
                _loans.Reset;
                _loans.SetRange("Loan  No.", AppNo);
                if (_loans.Find('-')) then begin


                    SrestepApprovalsCodeUnit.SendLoanApplicationsRequestForApproval(_loans."Loan  No.", _loans);

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
        _record: Record "Loans Guarantee Details";
    begin

        _record.Reset;
        _record.SetRange("Member No", memberNo);
        _record.SetRange("Acceptance Status", _record."acceptance status"::Pending);
        if _record.Find('-') then begin
            repeat
                response := response + _record."Loanees  No" + ':::' + _record."Loanees  Name" + ':::' + Format(_record."Amont Guaranteed") + ';';
            until _record.Next = 0;
        end
    end;


    procedure GuarantorRequest(memberNo: Code[30]; loanNo: Code[30]; amount: Decimal; actionTaken: Text) returnText: Text
    var
        _record: Record "Loans Guarantee Details";
    begin

        returnText := 'Guarantor Requests,Error Occurred! Submit once more,error';
        _record.Reset;
        _record.SetRange(_record."Member No", memberNo);
        _record.SetRange(_record."Loan No", loanNo);
        _record.SetRange(_record."Acceptance Status", _record."acceptance status"::Pending);
        if _record.Find('-') then begin
            if actionTaken = 'Approve' then begin
                _record."Acceptance Status" := _record."acceptance status"::Accepted;
                _record."Amont Guaranteed" := amount;
            end;
            if actionTaken <> 'Approve' then begin
                _record."Acceptance Status" := _record."acceptance status"::Declined;
                _record."Amont Guaranteed" := 0;
            end;
            _record.Modify();
            returnText := 'Guarantor Requests,' + Format(_record."Acceptance Status") + ' successfully,success';

        end;
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


    procedure FnDepositsStatement(MemberNo: Code[50]; var BigText: BigText)
    var
        Filename: Text[100];
        Convert: dotnet Convert;
        Path: dotnet Path;
        _File: dotnet File;
        FileAccess: Integer;
        FileMode: dotnet FileMode;
        MemoryStream: dotnet MemoryStream;
        FileStream: dotnet FileStream;
        Outputstream: OutStream;
    begin


        Message(FILESPATH);

        if Exists(Filename) then
            Erase(Filename);
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        Filename := Path.GetTempPath() + Path.GetRandomFileName();
        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516354, Filename, objMember);
            FileMode := 4;
            FileAccess := 1;

            FileStream := _File.Open(Filename, FileMode, FileAccess);

            MemoryStream := MemoryStream.MemoryStream();

            MemoryStream.SetLength(FileStream.Length);
            FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

            BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
            Message(Format(BigText));
            // exitString:=BigText;
            //MESSAGE(exitString);
            MemoryStream.Close();
            MemoryStream.Dispose();
            FileStream.Close();
            FileStream.Dispose();
            _File.Delete(Filename);

        end;
    end;


    procedure FnLoanStatement(MemberNo: Code[50]; Datefilter: Text; var BigText: BigText)
    var
        Convert: dotnet Convert;
        Path: dotnet Path;
        _File: dotnet File;
        FileAccess: Integer;
        FileMode: dotnet FileMode;
        MemoryStream: dotnet MemoryStream;
        FileStream: dotnet FileStream;
        Outputstream: OutStream;
        FileName: Text[100];
        "Count": Integer;
        FilePath: Text;
        objMembers: Record Customer;
    begin


        Message(FILESPATH);

        if Exists(FileName) then
            Erase(FileName);
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        objMember.SetFilter("Date Filter", Datefilter);
        FileName := Path.GetTempPath() + Path.GetRandomFileName();
        if objMember.Find('-') then begin
            Report.SaveAsPdf(51516531, FileName, objMember);
            FileMode := 4;
            FileAccess := 1;

            FileStream := _File.Open(FileName, FileMode, FileAccess);

            MemoryStream := MemoryStream.MemoryStream();

            MemoryStream.SetLength(FileStream.Length);
            FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

            BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
            Message(Format(BigText));
            // exitString:=BigText;
            //MESSAGE(exitString);
            MemoryStream.Close();
            MemoryStream.Dispose();
            FileStream.Close();
            FileStream.Dispose();
            _File.Delete(FileName);

        end;
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
    var
        StaticPeriod: Integer;
    begin
        StaticPeriod := RepayPeriod;
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

                    LPrincipal := LoanAmount / StaticPeriod;
                    LInterest := (Loansetup."Interest rate" / 1200) * LoanAmount;
                    TotalMRepay := LPrincipal + LInterest;
                    RepayPeriod := RepayPeriod - 1;
                    LoanAmount := LoanAmount - LPrincipal;
                    text := text + Format(Date) + '!!' + Format(ROUND(LPrincipal)) + '!!' + Format(ROUND(LInterest)) + '!!' + Format(ROUND(TotalMRepay)) + '!!' + Format(ROUND(LoanAmount)) + '??';
                    Date := CalcDate('+1M', Date);
                until LoanAmount = 0;
            end;


            if Loansetup."Repayment Method" = Loansetup."repayment method"::"Reducing Balance" then begin
                //LoansRec.TESTFIELD(LoansRec.Interest);
                //LoansRec.TESTFIELD(LoansRec.Installments);
                Message('type is %1', LoanCode);
                Date := Today;


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


        end;

    end;


    procedure fnLoanProducts() loanType: Text
    begin
        Loansetup.Reset;
        if Loansetup.Find('-') then begin
            loanType := '';
            repeat
                loanType := Format(Loansetup.Code) + ':' + Loansetup."Product Description" + ':::' + loanType + ':::' + Format(Loansetup."Interest rate");
            until Loansetup.Next = 0;
        end;
    end;


    procedure fnGetLoanProductDetails(productType: Text) response: Text
    begin

        Loansetup.Reset;
        Loansetup.SetRange(Code, productType);
        if Loansetup.Find('-') then begin
            repeat
                response := Format(Loansetup."Min. Loan Amount") + ':::' + Format(Loansetup."Max. Loan Amount") + ':::' + Format(Loansetup."Interest rate") + ':::' + Format(Loansetup."No of Installment");
            until Loansetup.Next = 0;
        end;
    end;


    procedure FnLoansInsertGuarantor(LoanNumber: Code[30]; MemberNo: Code[20]; LoaneeNumber: Code[30])
    begin

        objMember.Reset;
        objMember.SetRange("No.", MemberNo);
        if objMember.Find('-') then begin
            _guarantors.Init;
            _guarantors."Loan No" := LoanNumber;
            _guarantors."Member No" := objMember."No.";
            _guarantors.Validate(_guarantors."Member No");
            _guarantors."Loanees  No" := LoaneeNumber;
            _guarantors.Insert;
        end;
    end;


    procedure fnGetLoanNumber(memberno: Code[50]) loanno: Code[1024]
    var
        faccount: Text;
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


    procedure fnAppliedLoans(MemberNo: Code[20]) response: Text
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

                response := loanlist;
            until objLoanRegister.Next = 0;
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
    begin

        _guarantors.Reset;
        _guarantors.SetRange("Loanees  No", memberno);
        //OnlineLoanGuarantors.SETRANGE("Approval Status", OnlineLoanGuarantors."Approval Status"::Pending);
        if _guarantors.Find('-') then begin
            repeat
                guarantors := guarantors + _guarantors."Loan No" + ':::' + _guarantors."Member No" + ':::' + _guarantors.Name + ':::' + Format(_guarantors."Amont Guaranteed") + ';';
            until _guarantors.Next = 0;
        end;
    end;


    procedure GetMemberNumber(idNumber: Text) response: Text
    var
        memberTable: Record Customer;
    begin

        memberTable.Reset;
        memberTable.SetRange("ID No.", idNumber);
        if memberTable.Find('-') then begin
            response := memberTable."No.";
        end else begin
            response := 'Member does not exist or incorrect ID No. was supplied';
        end;
    end;


    procedure GetMemberDetails(idNumber: Text) response: Text
    var
        memberTable: Record Customer;
        memberInfo: Text;
    begin

        response := '{ "StatusCode":"2","StatusDescription":"ERROR","MemberInfo": [] }';

        memberTable.Reset;
        memberTable.SetRange("ID No.", idNumber);
        if memberTable.Find('-') then begin
            memberInfo := '{"Name":"' + memberTable.Name + '", "phoneNumber":"' + memberTable."Mobile Phone No" + '"}';

            if memberInfo <> '' then begin
                response := '{ "StatusCode":"1","StatusDescription":"SUCCESS","MemberInfo": [' + memberInfo + '] }';
            end else begin
                response := '{ "StatusCode":"2","StatusDescription":"MEMBERNOTFOUND","MemberInfo": [] }';
            end
        end
    end;
}