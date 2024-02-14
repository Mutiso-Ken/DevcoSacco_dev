#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 51516066 "fosaloansapplicationcard"
{
    DeleteAllowed = false;
    PageType = Card;
    InsertAllowed = true;
    Editable = true;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Loans Register";
    SourceTableView = where(Posted = filter(false),
                            Source = const(FOSA));


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Loan  No."; "Loan  No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field("Account No"; "Account No")
                {
                    ApplicationArea = Basic;
                    Caption = 'FOSA Account No';
                    Editable = MNoEditable;
                    Style = StrongAccent;
                }
                field("Client Name"; "Client Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("ID NO"; "ID NO")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = Basic;
                    Editable = LProdTypeEditable;
                    Style = StrongAccent;
                    trigger OnValidate()
                    begin
                        if ("Loan Product Type" = 'OVERDRAFT') OR ("Loan Product Type" = 'OKOA') OR ("Loan Product Type" = 'MOBILE LOAN') THEN begin
                            ERROR('The product cannot be applied here ');
                        end;
                    end;
                }
                field(Installments; Installments)
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                    //Editable = false;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field(Interest; Interest)
                {
                    ApplicationArea = Basic;
                    Editable = Interrest;
                    Style = Unfavorable;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount Applied';
                    Editable = AppliedAmountEditable;
                    Style = Unfavorable;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);

                    end;
                }
                field("Approved Amount"; "Approved Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Amount';
                    Editable = MNoEditable;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field("Recommended Amount"; "Recommended Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Purpose"; "Loan Purpose")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Visible = false;
                }
                field("Main Sector"; "Main Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = MNoEditable;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field("Sub-Sector"; "Sub-Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = MNoEditable;
                    //TableRelation = "Sub-Sector".Code where(No = field("Main Sector"));

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field("Specific Sector"; "Specific Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = MNoEditable;
                    //TableRelation = "Specific-Sector".Code where(No = field("Sub-Sector"));

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }

                field(Repayment; Repayment)
                {
                    ApplicationArea = Basic;
                    //Editable = RepaymentEditable;
                    Editable = false;
                }
                field("Loan Status"; "Loan Status")
                {
                    ApplicationArea = Basic;
                    Editable = LoanStatusEditable;

                    trigger OnValidate()
                    begin

                        UpdateControl();

                    end;
                }


                field("Top Up Amount"; "Top Up Amount")
                {
                    ApplicationArea = Basic;
                }

                field("Total TopUp Commission"; "Total TopUp Commission")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = Basic;
                    //Editable = RepayFrequencyEditable;
                    Editable = false;
                }

                field("Recovery Mode"; "Recovery Mode")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                    Style = StrongAccent;
                }

                field("Mode of Disbursement"; "Mode of Disbursement")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                }

                field("Loan Disbursement Date"; "Loan Disbursement Date")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                }

                field("Repayment Start Date"; "Repayment Start Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field("Expected Date of Completion"; "Expected Date of Completion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field("Staff No"; "Staff No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff No';
                    Editable = false;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    Editable = MNoEditable;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = Basic;
                    //Editable = RepayMethodEditable;
                    Editable = false;
                }
                field("Captured By"; "Captured By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part("Loans Guarantee Details"; "Loans Guarantee Details")
            {
                Caption = 'FOSA Loan Guarantor Details';
                SubPageLink = "Loan No" = field("Loan  No.");
            }
            part("Loan Collateral Security"; "Loan Collateral Security")
            {
                Caption = 'Loan Collateral Security Details';
                SubPageLink = "Loan No" = field("Loan  No.");
            }
            part("Loan Appraisal Salary Details"; "Loan Appraisal Salary Details")
            {
                Caption = 'Loan Appraisal Salary Details';
                SubPageLink = "Loan No" = field("Loan  No.");
            }
        }
        area(factboxes)
        {
            part("FOSA Statistics FactBox"; "FOSA Statistics FactBox")
            {
                SubPageLink = "No." = field("Account No");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Loan)
            {
                Caption = 'Loan';
                Image = AnalysisView;

                action("Loan Appraisal")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Appraisal';
                    Enabled = true;
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", "Loan  No.");
                        if LoanApp.Find('-') then begin

                            Report.Run(51516263, true, false, LoanApp);
                        end;
                    end;
                }
                action("View Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Schedule';
                    Image = ViewDetails;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    begin

                        if ("Repayment Start Date" = 0D) then
                            Error('Please enter Disbursement Date to continue');
                        SFactory.FnGenerateRepaymentSchedule("Loan  No.");

                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", "Loan  No.");
                        if LoanApp.Find('-') then begin
                            Report.Run(51516477, true, false, LoanApp);
                        end;
                    end;
                }
                separator(Action9)
                {
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = SendApprovalEnabled;

                    trigger OnAction()
                    var
                        GuaranteedAmountsTotal: Decimal;
                        CollateralAmountsTotal: Decimal;
                        SalaryAmountsTotal: Decimal;
                        SalaryRegister: Record "Loan Appraisal Salary Details";
                        CollateralRegister: Record "Loan Collateral Details";
                        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
                        SystemGenSet: Codeunit "System General Setup";
                    begin
                        //................Ensure than you cant have two loans same product
                        // SystemGenSet.FnCheckNoOfLoansLimit("Loan  No.", "Loan Product Type", "Client Code");
                        //----------------
                        TestField("Approved Amount");
                        TestField("Loan Product Type");
                        TestField("Loan Disbursement Date");
                        TestField("Main Sector");
                        TestField("Sub-Sector");
                        TestField("Specific Sector");
                        TestField("Requested Amount");
                        // LGuarantors.Reset;
                        // LGuarantors.SetRange(LGuarantors."Loan No", "Loan  No.");
                        // if LGuarantors.Find('-') = false then begin
                        //     Error('Please Insert Loan Applicant Guarantor Information');
                        // end;
                        //.............................Check If Approved Amount Is Equal to the Guarantor Amount
                        GuaranteedAmountsTotal := 0;
                        LGuarantors.Reset;
                        LGuarantors.SetRange(LGuarantors."Loan No", "Loan  No.");
                        if LGuarantors.Find('-') = true then begin
                            repeat
                                GuaranteedAmountsTotal += LGuarantors."Amont Guaranteed";
                            until LGuarantors.Next = 0;
                        end;
                        //Check if collateral is provide
                        CollateralAmountsTotal := 0;
                        CollateralRegister.Reset();
                        CollateralRegister.SetRange(CollateralRegister."Loan No", "Loan  No.");
                        if CollateralRegister.Find('-') then begin
                            repeat
                                CollateralAmountsTotal += CollateralRegister.Value;
                            until CollateralRegister.Next = 0;
                        end;
                        //Check if salary is provide
                        SalaryAmountsTotal := 0;
                        SalaryRegister.Reset();
                        SalaryRegister.SetRange(SalaryRegister."Loan No", "Loan  No.");
                        if SalaryRegister.Find('-') then begin
                            repeat
                                SalaryAmountsTotal += SalaryRegister.Amount;
                            until CollateralRegister.Next = 0;
                        end;
                        if "Approved Amount" > GuaranteedAmountsTotal + CollateralAmountsTotal + SalaryAmountsTotal then begin
                            error('The Loan Amount requested MUST Equally tally the Total Guaranteed Amount To cover the loan')
                        end;
                        //--------------------------------------------------------------------------------------
                        //---------------------------------------Approval workflow
                        if Confirm('Send Approval Request?', false) = true then begin
                            if SrestepApprovalsCodeUnit.SendLoanApplicationsRequestForApproval(rec."Loan  No.", Rec) then begin
                                //---------------------------------------Send SMS To Guarantors
                                FnSendNotifications();
                                CurrPage.Close();

                            end;
                        end;
                        //-------------------------------------------------------
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = CancelApprovalEnabled;

                    trigger OnAction()
                    var
                        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
                    begin
                        if Confirm('Are you sure you want to cancel the approval request sent', false) = true then begin
                            if SrestepApprovalsCodeUnit.CancelLoanApplicationsRequestForApproval(rec."Loan  No.", Rec) then begin
                                CurrPage.Close();
                            end;
                        end;
                    end;
                }

            }
            action(Refresh)
            {

                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Refresh;
                Caption = 'Refresh Page';
                trigger OnAction()
                begin
                    CurrPage.Update();
                    CurrPage.Update();
                end;
            }
            action("OffsetLoan")
            {
                ApplicationArea = Basic;
                Caption = 'Offset Member Loan';
                Enabled = SendApprovalEnabled;
                Image = Loaner;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Loan Offset Detail List";
                RunPageLink = "Loan No." = FIELD("Loan  No."), "Client Code" = FIELD("Client Code");
                trigger OnAction()
                begin

                end;
            }

        }

    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        LoanAppPermisions();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Source := Source::FOSA;
        "Mode of Disbursement" := "mode of disbursement"::"Cheque";
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        if "Loan Status" = "loan status"::Approved then
            CurrPage.Editable := false;
    end;

    trigger OnOpenPage()
    begin
        // SetRange(Posted, false);
        // SetRange("Captured By", UserId);
    end;

    var
        iEntryNo: Integer;
        VEND1: Record Vendor;
        LoanGuar: Record "Loans Guarantee Details";
        SMSMessage: Record "SMS Messages";
        SMSMessages: Record "SMS Messages";
        i: Integer;
        LoanType: Record "Loan Products Setup";
        PeriodDueDate: Date;
        ScheduleRep: Record "Loan Repayment Schedule";
        RunningDate: Date;
        G: Integer;
        IssuedDate: Date;
        GracePeiodEndDate: Date;
        InstalmentEnddate: Date;
        GracePerodDays: Integer;
        InstalmentDays: Integer;
        NoOfGracePeriod: Integer;
        NewSchedule: Record "Loan Repayment Schedule";
        RSchedule: Record "Loan Repayment Schedule";
        GP: Text[30];
        ScheduleCode: Code[20];
        PreviewShedule: Record "Loan Repayment Schedule";
        PeriodInterval: Code[10];
        CustomerRecord: Record Customer;
        Gnljnline: Record "Gen. Journal Line";
        Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
        CumInterest: Decimal;
        NewPrincipal: Decimal;
        PeriodPrRepayment: Decimal;
        GenBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        GnljnlineCopy: Record "Gen. Journal Line";
        NewLNApplicNo: Code[15];
        Cust: Record Customer;
        LoanApp: Record "Loans Register";
        TestAmt: Decimal;
        CustRec: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
        GenSetUp: Record "Sales & Receivables Setup";
        PCharges: Record "Loan Product Charges";
        TCharges: Decimal;
        LAppCharges: Record "Loan Applicaton Charges";
        LoansR: Record "Loans Register";
        LoanAmount: Decimal;
        InterestRate: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Decimal;
        RepayInterval: DateFormula;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        RepayCode: Code[40];
        GrPrinciple: Integer;
        GrInterest: Integer;
        QPrinciple: Decimal;
        QCounter: Integer;
        InPeriod: DateFormula;
        InitialInstal: Integer;
        InitialGraceInt: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        FOSAComm: Decimal;
        BOSAComm: Decimal;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        LoanTopUp: Record "Loan Offset Details";
        Vend: Record Vendor;
        BOSAInt: Decimal;
        TopUpComm: Decimal;
        DActivity: Code[20];
        DBranch: Code[20];
        TotalTopupComm: Decimal;
        Notification: Codeunit Mail;
        CustE: Record Customer;
        DocN: Text[50];
        DocM: Text[100];
        DNar: Text[250];
        DocF: Text[50];
        MailBody: Text[250];
        ccEmail: Text[250];
        LoanG: Record "Loans Register";
        SpecialComm: Decimal;
        FOSAName: Text[150];
        IDNo: Code[50];
        MovementTracker: Record "File Movement Tracker";
        DiscountingAmount: Decimal;
        StatusPermissions: Record "Status Change Permision";
        BridgedLoans: Record "Loan Offset Details";
        InstallNo2: Integer;
        currency: Record "Currency Exchange Rate";
        CURRENCYFACTOR: Decimal;
        LoanApps: Record "Loans Register";
        LoanDisbAmount: Decimal;
        BatchTopUpAmount: Decimal;
        BatchTopUpComm: Decimal;
        SchDate: Date;
        DisbDate: Date;
        WhichDay: Integer;
        LBatches: Record "Loan Disburesment-Batching";
        SalDetails: Record "Loan Appraisal Salary Details";
        LGuarantors: Record "Loans Guarantee Details";
        Text001: label 'Status Must Be Open';
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","FOSA Opening","Loan Batching",Leave,"Imprest Requisition","Imprest Surrender","Stores Requisition","Funds Transfer","Change Request","Staff Claims","BOSA Transfer","Loan Tranche","Loan TopUp","Memb Opening","Member Withdrawal";
        CurrpageEditable: Boolean;
        LoanStatusEditable: Boolean;
        MNoEditable: Boolean;
        ApplcDateEditable: Boolean;
        LProdTypeEditable: Boolean;
        InstallmentEditable: Boolean;
        AppliedAmountEditable: Boolean;
        ApprovedAmountEditable: Boolean;
        RepayMethodEditable: Boolean;
        RepaymentEditable: Boolean;
        BatchNoEditable: Boolean;
        RepayFrequencyEditable: Boolean;
        ModeofDisburesmentEdit: Boolean;
        DisbursementDateEditable: Boolean;
        Interrest: Boolean;
        InterestSal: Decimal;
        NetIncome: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        compinfo: Record "Company Information";
        Text002: label 'The Loan has already been approved';
        ApprovalEntries: Record "Approval Entry";
        ApprovalEntry: Record "Approval Entry";
        Table_id: Integer;
        Doc_No: Code[20];
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Account Opening","Member Closure",Loan;
        SFactory: Codeunit "SURESTEP Factory";
        CancelApprovalEnabled: Boolean;
        SendApprovalEnabled: Boolean;


    procedure UpdateControl()
    begin
        if "Loan Status" = "loan status"::Application then begin
            CancelApprovalEnabled := false;
            SendApprovalEnabled := true;
            MNoEditable := true;
            ApplcDateEditable := true;
            LoanStatusEditable := false;
            LProdTypeEditable := true;
            InstallmentEditable := true;
            NetIncome := true;
            Interrest := false;
            AppliedAmountEditable := true;
            ApprovedAmountEditable := true;
            RepayMethodEditable := true;
            RepaymentEditable := true;
            BatchNoEditable := false;
            RepayFrequencyEditable := true;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := true;
        end;

        if "Loan Status" = "loan status"::Appraisal then begin
            CancelApprovalEnabled := true;
            SendApprovalEnabled := false;
            MNoEditable := false;
            ApplcDateEditable := true;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
            Interrest := false;
            NetIncome := true;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := true;
            RepayMethodEditable := true;
            RepaymentEditable := true;
            BatchNoEditable := false;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := false;
        end;

        if "Loan Status" = "loan status"::Rejected then begin
            CancelApprovalEnabled := false;
            SendApprovalEnabled := true;
            MNoEditable := false;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            NetIncome := false;
            Interrest := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := false;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := false;
            DisbursementDateEditable := false;
        end;

        if "Loan Status" = "loan status"::Approved then begin
            SendApprovalEnabled := false;
            CancelApprovalEnabled := false;
            MNoEditable := false;
            LoanStatusEditable := false;
            ApplcDateEditable := false;
            Interrest := false;
            LProdTypeEditable := false;
            NetIncome := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := true;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := true;
        end;
    end;


    procedure LoanAppPermisions()
    begin
    end;

    local procedure FnSendNotifications()
    var
        msg: Text[250];
        PhoneNo: Text[250];
    begin
        LoansR.Reset();
        LoansR.SetRange(LoansR."Loan  No.", "Loan  No.");
        if LoansR.Find('-') then begin
            msg := '';
            msg := 'Dear Member, Your ' + Format(LoansR."Loan Product Type") + ' loan application of KSHs.' + Format("Requested Amount") + ' has been received and is being processed.Jamii Yetu Sacco.';
            PhoneNo := FnGetPhoneNo("Client Code");
            SendSMSMessage("Client Code", msg, PhoneNo);
            LGuarantors.Reset;
            LGuarantors.SetRange(LGuarantors."Loan No", "Loan  No.");
            LGuarantors.SetRange(LGuarantors."Self Guarantee", true);
            if LGuarantors.Find('-') then begin
                msg := '';
                msg := 'Dear Member,you have self guaranteed on ' + Format(LoansR."Loan Product Type") + ' loan application of KSHs.' + Format("Requested Amount") + ' with ' + Format(LGuarantors."Amont Guaranteed") + ' of you current deposits.Jamii Yetu Sacco.';
                PhoneNo := FnGetPhoneNo("Client Code");
                SendSMSMessage(LGuarantors."Member No", msg, PhoneNo);
            end;
            //....................................
            LGuarantors.Reset;
            LGuarantors.SetRange(LGuarantors."Loan No", "Loan  No.");
            LGuarantors.SetRange(LGuarantors."Self Guarantee", false);
            if LGuarantors.Find('-') then begin
                repeat
                    msg := '';
                    msg := 'Dear Member,you have guaranteed ' + format(LoansR."Client Name") + 'on ' + Format(LoansR."Loan Product Type") + ' loan application with ' + Format(LGuarantors."Amont Guaranteed") + ' of your current deposits. Any queries contact JAMII YETU SACCO.';
                    PhoneNo := FnGetPhoneNo(LGuarantors."Member No");
                    SendSMSMessage(LGuarantors."Member No", msg, PhoneNo);
                until LGuarantors.Next = 0;
            end;

        end;
    end;

    local procedure SendSMSMessage(BOSANo: Code[20]; msg: Text[250]; PhoneNo: Text[250])
    begin
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else begin
            iEntryNo := 1;
        end;
        //--------------------------------------------------
        SMSMessages.Reset;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := BOSANo;
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'MOBILETRAN';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        SMSMessages."SMS Message" := msg;
        SMSMessages."Telephone No" := PhoneNo;
        SMSMessages.Insert;
    end;

    local procedure FnGetPhoneNo(ClientCode: Code[50]): Text[250]
    var
        Member: Record Customer;
        Vendor: Record Vendor;
    begin
        Member.Reset();
        Member.SetRange(Member."No.", ClientCode);
        if Member.Find('-') = true then begin
            if (Member."Mobile Phone No." <> '') or (Member."Mobile Phone No." <> '0') then begin
                exit(Member."Mobile Phone No.");
            end;
            if (Member."Mobile Phone No" <> '') or (Member."Mobile Phone No" <> '0') then begin
                exit(Member."Mobile Phone No");
            end;
            Vendor.Reset();
            Vendor.SetRange(Vendor."BOSA Account No", ClientCode);
            if Vendor.Find('-') then begin
                if (Vendor."Mobile Phone No." <> '') or (Vendor."Mobile Phone No." <> '0') then begin
                    exit(Vendor."Mobile Phone No.");
                end;
                if (Vendor."Mobile Phone No" <> '') or (Vendor."Mobile Phone No" <> '0') then begin
                    exit(Vendor."Mobile Phone No");
                end;
                if (Vendor."MPESA Mobile No" <> '') or (Vendor."MPESA Mobile No" <> '0') then begin
                    exit(Vendor."MPESA Mobile No");
                end;
            end;

        end else
            if Member.find('-') = false then begin
                Vendor.Reset();
                Vendor.SetRange(Vendor."BOSA Account No", ClientCode);
                if Vendor.Find('-') then begin
                    if (Vendor."Mobile Phone No." <> '') or (Vendor."Mobile Phone No." <> '0') then begin
                        exit(Vendor."Mobile Phone No.");
                    end;
                    if (Vendor."Mobile Phone No" <> '') or (Vendor."Mobile Phone No" <> '0') then begin
                        exit(Vendor."Mobile Phone No");
                    end;
                    if (Vendor."MPESA Mobile No" <> '') or (Vendor."MPESA Mobile No" <> '0') then begin
                        exit(Vendor."MPESA Mobile No");
                    end;
                end;
            end;
    end;

}


