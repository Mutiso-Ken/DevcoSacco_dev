page 51516484 "Okoa Loans Application Card"
{
    Caption = 'Okoa Applications Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Loans Register";
    SourceTableView = where(Source = const(FOSA), "Loan Product Type" = const('OKOA'),
                            Posted = const(false));

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
                    trigger OnValidate()
                    begin
                        if loanproduct.Get("Loan Product Type") then begin
                            Interest := loanproduct."Interest rate";
                            "Repayment Frequency" := loanproduct."Repayment Frequency";
                            CurrPage.Update();
                        end;

                    end;
                }
                field("Client Name"; "Client Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID NO"; "ID NO")
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
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = ApplcDateEditable;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Installments; Installments)
                {
                    ApplicationArea = Basic;
                    Editable = ApplcDateEditable;

                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if loanproduct.Get("Loan Product Type") then begin
                            IF Installments > loanproduct."No of Installment" then begin
                                ERROR('Installments cannot be greater than the maximum installments.');
                            end;
                        end;
                    end;
                }
                field(Interest; Interest)
                {
                    ApplicationArea = Basic;
                    Editable = Interrest;
                    trigger OnValidate()
                    begin

                    end;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount Applied';
                    Editable = AppliedAmountEditable;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                        if loanproduct.Get("Loan Product Type") then begin
                            IF "Requested Amount" > loanproduct."Max. Loan Amount" then begin
                                ERROR('Applied amount cannot be greater than the maximum allowed amount.');
                            end;
                        end;
                        //...................
                        "Recommended Amount" := "Requested Amount";

                        if "Repayment Method" = "repayment method"::Constants then begin
                            TestField(Installments);
                            TestField("Approved Amount");
                            LPrincipal := ROUND("Approved Amount" / Installments, 1, '>');
                            LInterest := ROUND((rec.Interest / 100) * "Approved Amount", 1, '>');
                            Repayment := LPrincipal;
                            "Loan Principle Repayment" := LPrincipal;
                            "Loan Interest Repayment" := LInterest;
                        end;
                        //.............................................................
                    end;
                }
                field("Approved Amount"; "Approved Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Amount';
                    Editable = ApprovedAmountEditable;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                        //...................
                        if loanproduct.Get("Loan Product Type") then begin
                            IF "Requested Amount" > loanproduct."Max. Loan Amount" then begin
                                ERROR('Approved amount cannot be greater than the maximum allowed amount.');
                            end;
                        end;
                        if "Repayment Method" = "repayment method"::Constants then begin
                            TestField(Installments);
                            TestField("Approved Amount");
                            LPrincipal := ROUND("Approved Amount" / Installments, 1, '>');
                            LInterest := ROUND((rec.Interest / 100) * "Approved Amount", 1, '>');
                            Repayment := LPrincipal;
                            "Loan Principle Repayment" := LPrincipal;
                            "Loan Interest Repayment" := LInterest;
                        end;
                        //.............................................................
                    end;
                }
                field("Main Sector"; "Main Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = LProdTypeEditable;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field("Sub-Sector"; "Sub-Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = LProdTypeEditable;
                    TableRelation = "Sub-Sector".Code where(No = field("Main Sector"));

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field("Specific Sector"; "Specific Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = LProdTypeEditable;
                    TableRelation = "Specific-Sector".Code where(No = field("Sub-Sector"));

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Interest Repayment"; "Loan Interest Repayment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Repayment; Repayment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Repayment';
                    Editable = false;
                }
                field("Loan Status"; "Loan Status")
                {
                    ApplicationArea = Basic;
                    Editable = LoanStatusEditable;
                    Style = Ambiguous;

                    trigger OnValidate()
                    begin
                        UpdateControl();


                    end;
                }
                field("Captured By"; "Captured By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = Basic;
                    Editable = RepayFrequencyEditable;
                }
                field("Recovery Mode"; "Recovery Mode")
                {
                    ApplicationArea = Basic;
                    Editable = LProdTypeEditable;
                }
                field("Loan Disbursement Date"; "Loan Disbursement Date")
                {
                    ApplicationArea = Basic;
                    Editable = LProdTypeEditable;
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
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Recommended Amount"; "Recommended Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part("Loans Guarantee Details"; "Loans Guarantee Details")
            {
                Caption = 'OKOA Guarantor Details';
                SubPageLink = "Loan No" = field("Loan  No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Loan)
            {
                Image = AnalysisView;
                action("View Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Schedule';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = true;

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
                action("Post Loan")
                {
                    ApplicationArea = Basic;
                    Caption = 'POST';
                    Visible = true;
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = PostLoan;

                    trigger OnAction()
                    var
                        msg: Text[250];
                        PhoneNo: text[25];
                    begin
                        //...........Post Loan 
                        TestField(Posted, false);
                        if Confirm('Are you sure you want to POST Overdtaft Loan amount Ksh.' + Format("Approved Amount") + ' to Loanee?', false) = false then begin
                            exit;
                        end else begin
                            BATCH_TEMPLATE := 'PAYMENTS';
                            BATCH_NAME := 'LOANS';
                            DOCUMENT_NO := "Loan  No.";

                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", BATCH_TEMPLATE);
                            GenJournalLine.SetRange("Journal Batch Name", BATCH_NAME);
                            GenJournalLine.DeleteAll;

                            FnCreateOkoaGLEntries();
                            //..........................Offset Loans
                            FnCreateLoanOffsetLines();
                            //Generate Loan Schedule In System
                            SFactory.FnGenerateRepaymentSchedule("Loan  No.");
                            //......................Post Entries
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", BATCH_TEMPLATE);
                            GenJournalLine.SetRange("Journal Batch Name", BATCH_NAME);
                            if GenJournalLine.Find('-') then begin
                                if Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine) = true then begin
                                    //...........Send Notifications of disbursments
                                    msg := '';
                                    msg := 'Dear Member, Your ' + Format(LoansR."Loan Product Type") + ' loan application of KSHs.' + Format("Requested Amount") + ' has been processed and disbursed to your FOSA Account.Jamii Yetu Sacco.';
                                    PhoneNo := FnGetPhoneNo("Client Code");
                                    SendSMSMessage("Client Code", msg, PhoneNo);
                                    //................................................
                                    //SendEmail Of Repayment Schedule
                                    //................................................
                                    Posted := true;
                                    "Posted By" := UserId;
                                    "Loan Status" := "Loan Status"::Issued;
                                    "disbursement time" := Time;
                                    //"Loans Category-SASRA" := "Loans Category-SASRA"::Perfoming;
                                    "Issued Date" := Today;
                                    Source := Source::FOSA;
                                    "disbursement time" := Time;
                                    "Advice Type" := "Advice Type"::"Fresh Loan";
                                    Modify(true);
                                    Message('The Loan Has Successfully Posted to member FOSA account(Ordinary) and Member Notified');
                                    CurrPage.Close();
                                end else begin
                                    error('Error posting the Loan Enties,Contact system administrator');
                                end;
                            end;
                        end;

                    end;

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
                        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
                    begin
                        TestField("Approved Amount");
                        TestField("Loan Product Type");
                        TestField("Loan Disbursement Date");
                        TestField("Main Sector");
                        TestField("Sub-Sector");
                        TestField("Specific Sector");
                        TestField("Requested Amount");
                        LGuarantors.Reset;
                        LGuarantors.SetRange(LGuarantors."Loan No", "Loan  No.");
                        if LGuarantors.Find('-') = false then begin
                            Error('Please Insert Loan Applicant Guarantor Information');
                        end;
                        //.............................Check If Approved Amount Is Equal to the Guarantor Amount
                        GuaranteedAmountsTotal := 0;
                        LGuarantors.Reset;
                        LGuarantors.SetRange(LGuarantors."Loan No", "Loan  No.");
                        if LGuarantors.Find('-') = true then begin
                            repeat
                                GuaranteedAmountsTotal += LGuarantors."Amont Guaranteed";
                            until LGuarantors.Next = 0;
                        end;
                        if "Approved Amount" <> GuaranteedAmountsTotal then begin
                            error('The OKOA Amount requested MUST Equally tally the Total Guaranteed Amount')
                        end;
                        //--------------------------------------------------------------------------------------
                        //---------------------------------------Approval workflow
                        if Confirm('Send Approval Request?', false) = true then begin
                            SrestepApprovalsCodeUnit.SendLoanApplicationsRequestForApproval(rec."Loan  No.", Rec);
                            //---------------------------------------Send SMS To Guarantors
                            FnSendNotifications();
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
                    Enabled = CancelApproval;

                    trigger OnAction()
                    var
                        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
                    begin

                        if Confirm('Are you sure you want to cancel the approval request sent', false) = true then begin
                            SrestepApprovalsCodeUnit.CancelLoanApplicationsRequestForApproval(rec."Loan  No.", Rec);
                        end;
                    end;
                }

            }
            group(OffsetLoans)
            {
                action("OffsetLoan")
                {
                    ApplicationArea = Basic;
                    Caption = 'Offset Okoa';
                    ToolTip = 'Off set Member Previous Okoa Loans';
                    Enabled = true;
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
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
    end;

    trigger OnInit()
    begin
        Source := Source::FOSA;
        "Loan Product Type" := 'OKOA';
        "Repayment Method" := "Repayment Method"::Constants;
        "Repayment Frequency" := "Repayment Frequency"::Monthly;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        LoanAppPermisions();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Source := Source::FOSA;
        "Loan Product Type" := 'OKOA';
        "Mode of Disbursement" := "mode of disbursement"::Cheque;
        "Repayment Method" := "Repayment Method"::Constants;
        "Repayment Frequency" := "Repayment Frequency"::Monthly;

    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        if "Loan Status" = "loan status"::Approved then
            CurrPage.Editable := false;
    end;

    trigger OnOpenPage()
    begin
        SetRange(Posted, false);
    end;

    var
        BATCH_TEMPLATE: code[50];
        BATCH_NAME: code[50];
        DOCUMENT_NO: code[50];
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
        PostLoan: Boolean;
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
        loanproduct: Record "Loan Products Setup";

        SchDate: Date;
        DisbDate: Date;
        WhichDay: Integer;
        LBatches: Record "Loan Disburesment-Batching";
        SalDetails: Record "Loan Appraisal Salary Details";
        LGuarantors: Record "Loans Guarantee Details";
        Text001: label 'Status Must Be Open';
        CurrpageEditable: Boolean;
        LoanStatusEditable: Boolean;
        MNoEditable: Boolean;
        ApplcDateEditable: Boolean;
        LProdTypeEditable: Boolean;
        InstallmentEditable: Boolean;
        AppliedAmountEditable: Boolean;
        ApprovedAmountEditable: Boolean;
        RepayMethodEditable: Boolean;
        CancelApproval: Boolean;
        RepaymentEditable: Boolean;
        BatchNoEditable: Boolean;
        RepayFrequencyEditable: Boolean;
        ModeofDisburesmentEdit: Boolean;
        DisbursementDateEditable: Boolean;
        Interrest: Boolean;
        SendApprovalEnabled: Boolean;
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


    procedure UpdateControl()
    begin
        if "Loan Status" = "loan status"::Application then begin
            PostLoan := false;
            CancelApproval := false;
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
            PostLoan := false;
            CancelApproval := true;
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
            PostLoan := false;
            CancelApproval := false;
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
            PostLoan := true;
            CancelApproval := false;
            SendApprovalEnabled := false;
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
            PhoneNo := FnGetPhoneNo(LoansR."Client Code");
            SendSMSMessage(LoansR."BOSA No", msg, PhoneNo);
            LGuarantors.Reset;
            LGuarantors.SetRange(LGuarantors."Loan No", "Loan  No.");
            if LGuarantors.Find('-') = false then begin
                repeat
                    if LGuarantors."Self Guarantee" = true then begin
                        msg := '';
                        msg := 'Dear Member,you have self guaranteed on ' + Format(LoansR."Loan Product Type") + ' loan application of KSHs.' + Format("Requested Amount") + ' with ' + Format(LGuarantors."Amont Guaranteed") + ' of you current deposits.Jamii Yetu Sacco.';
                        PhoneNo := FnGetPhoneNo("Client Code");
                        SendSMSMessage(LGuarantors."Member No", msg, PhoneNo);
                    end else
                        if LGuarantors."Self Guarantee" = false then begin
                            msg := '';
                            msg := 'Dear Member,you have guaranteed ' + format(LoansR."Client Name") + 'on ' + Format(LoansR."Loan Product Type") + ' loan application with ' + Format(LGuarantors."Amont Guaranteed") + ' of your current deposits. Any queries contact JAMII YETU SACCO.';
                            PhoneNo := FnGetPhoneNo(LGuarantors."Member No");
                            SendSMSMessage(LGuarantors."Member No", msg, PhoneNo);
                        end;
                //.........................
                until LoanGuar.Next = 0;
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

    local procedure FnCreateOkoaGLEntries()
    begin
        //1.----------------------CREDIT FOSA A/C WITH Okoa Biashara AMOUNT---------------------------------------------------APPROVED AMOUNT-------------------------------------------------
        LineNo := 0;
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
        GenJournalLine."Journal Batch Name" := BATCH_NAME;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
        GenJournalLine."Account No." := "Account No";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := DOCUMENT_NO;
        GenJournalLine."External Document No." := DOCUMENT_NO;
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Okoa Biashara Principal Amount-disbursed';
        GenJournalLine.Amount := ("Approved Amount") * -1;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := SFactory.FnGetMemberBranch("Client Code");
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //2.----------------------CREDIT FOSA A/C WITH FORM CHARGE---------------------------------------------------COMMISSION-------------------------------------------------
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
        GenJournalLine."Journal Batch Name" := BATCH_NAME;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
        GenJournalLine."Account No." := "Account No";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := DOCUMENT_NO;
        GenJournalLine."External Document No." := DOCUMENT_NO;
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Okoa Biashara Commission';
        GenJournalLine.Amount := 100;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := SFactory.FnGetMemberBranch("Client Code");
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //3.----------------------Balance with Form Fees Account
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
        GenJournalLine."Journal Batch Name" := BATCH_NAME;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
        GenJournalLine."Account No." := '1533';
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := DOCUMENT_NO;
        GenJournalLine."External Document No." := DOCUMENT_NO;
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := "Loan Product Type" + ' -Okoa Biashara Commission- ' + "Loan  No.";
        GenJournalLine.Amount := -(100);
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := SFactory.FnGetMemberBranch("Client Code");
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        //-------------Balance out the amount disbursed with account receivable
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
        GenJournalLine."Journal Batch Name" := BATCH_NAME;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := "Client Code";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := DOCUMENT_NO;
        GenJournalLine."External Document No." := DOCUMENT_NO;
        GenJournalLine."Posting Date" := Today;
        GenJournalLine."Loan No" := "Loan  No.";
        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Loan;
        GenJournalLine.Description := 'Okoa Biashara Loan Issued-' + Format("Loan  No.");
        GenJournalLine.Amount := "Approved Amount";
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := SFactory.FnGetMemberBranch("Client Code");
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //----------------------------------Accrue Interest Due for the Loan
        LineNo := LineNo + 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
        GenJournalLine."Journal Batch Name" := BATCH_NAME;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
        GenJournalLine."Account No." := "Client Code";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Document No." := DOCUMENT_NO;
        GenJournalLine."External Document No." := DOCUMENT_NO;
        GenJournalLine."Posting Date" := Today;
        GenJournalLine."Loan No" := "Loan  No.";
        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Due";
        GenJournalLine.Description := 'Okoa Biashara Loan Interest Due-' + Format("Loan  No.");
        GenJournalLine.Amount := "Loan Interest Repayment";
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := '5500';
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := SFactory.FnGetMemberBranch("Client Code");
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;
        //........................................................................................
    end;

    local procedure FnCreateLoanOffsetLines()
    begin
        DBranch := SFactory.FnGetMemberBranch("Client Code");
        CalcFields("Top Up Amount");
        if "Top Up Amount" > 0 then begin
            LoanTopUp.RESET;
            LoanTopUp.SETRANGE(LoanTopUp."Loan No.", "Loan  No.");
            IF LoanTopUp.FIND('-') THEN BEGIN
                REPEAT//Maybe there are multiple topup loans
                      //Principle

                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                    GenJournalLine."Journal Batch Name" := BATCH_NAME;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := DOCUMENT_NO;
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine."External Document No." := DOCUMENT_NO;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                    GenJournalLine."Account No." := "Client Code";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine.Description := 'Loan OffSet By - ' + "Loan  No.";
                    GenJournalLine.Amount := LoanTopUp."Principle Top Up" * -1;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                    GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    //****************************Debit Vendor To pay loan principle*******************************
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                    GenJournalLine."Journal Batch Name" := BATCH_NAME;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := DOCUMENT_NO;
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine."External Document No." := "Loan  No.";
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Account No." := "Account No";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine.Description := 'Loan offset Principal to loan-' + LoanTopUp."Loan Top Up" + '-' + LoanTopUp."Loan Type";
                    GenJournalLine.Amount := LoanTopUp."Principle Top Up";
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    //..................Recover Interest On Top Up
                    IF LoanType.GET("Loan Product Type") THEN BEGIN
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                        GenJournalLine."Journal Batch Name" := BATCH_NAME;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Document No." := DOCUMENT_NO;
                        GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::Customer;
                        GenJournalLine."Account No." := "Client Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := "Loan  No.";
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Interest Due Paid on top up';
                        GenJournalLine.Amount := -LoanTopUp."Interest Top Up";
                        GenJournalLine."External Document No." := "Loan  No.";
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                        GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                    END;
                    //Recover Loan Interest From FOSA Account
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                    GenJournalLine."Journal Batch Name" := BATCH_NAME;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := DOCUMENT_NO;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Account No." := "Account No";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := "Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Loan offset Interest to loan-' + LoanTopUp."Loan Top Up" + '-' + LoanTopUp."Loan Type";
                    GenJournalLine.Amount := LoanTopUp."Interest Top Up";
                    GenJournalLine."External Document No." := "Loan  No.";
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    //Recover Commission on topup
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                    GenJournalLine."Journal Batch Name" := BATCH_NAME;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := DOCUMENT_NO;
                    GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                    GenJournalLine."Account No." := '5411';
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := "Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Commission on ' + format(LoanTopUp."Loan No.") + ' Loan Offset';
                    GenJournalLine.Amount := -LoanTopUp.Commision;
                    GenJournalLine."External Document No." := "Loan  No.";
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    //Recover Loan Interest From FOSA Account
                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := BATCH_TEMPLATE;
                    GenJournalLine."Journal Batch Name" := BATCH_NAME;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := DOCUMENT_NO;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Account No." := "Account No";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := "Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Commission Charged on ' + format(LoanTopUp."Loan No.") + ' Loan Offset';
                    GenJournalLine.Amount := LoanTopUp.Commision;
                    GenJournalLine."External Document No." := "Loan  No.";
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                UNTIL LoanTopUp.NEXT = 0;
            END;
        end;
    end;
}

