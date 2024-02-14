#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516833 "Loan Application Card - MICRO"
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Loans Register";
    SourceTableView = where(Source = const(MICRO),
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
                field("Staff No"; "Staff No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff No';
                    Editable = false;
                }
                field("Client Code"; "Client Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account No.';
                    Editable = MNoEditable;

                    trigger OnValidate()
                    begin

                    end;
                }
                field("Client Name"; "Client Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Officer"; "Loan Officer")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID NO"; "ID NO")
                {
                    ApplicationArea = Basic;
                    Caption = 'ID No.';
                    Editable = false;
                }
                field("Group Account"; "Group Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Group Account No.';
                    Editable = false;
                }
                field("Group Name"; "Group Name")
                {
                    ApplicationArea = Basic;
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
                    Editable = LProdTypeEditable;
                }
                field("Shares Balance"; "Shares Balance")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(Installments; Installments)
                {
                    ApplicationArea = Basic;
                    Editable = LProdTypeEditable;

                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field(Interest; Interest)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        if "Repayment Method" = "repayment method"::Constants then begin
                            if (Installments <> 0) and ("Approved Amount" <> 0) then begin
                                TestField(Installments);
                                "Loan Principle Repayment" := ROUND("Approved Amount" / Installments, 1, '>');
                                "Loan Interest Repayment" := (ROUND((Interest / 100) * "Approved Amount", 1, '>')) * Installments / 12;
                                Repayment := "Loan Interest Repayment";
                            end;
                        end;
                    end;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount Applied';
                    Editable = AppliedAmountEditable;

                    trigger OnValidate()
                    var
                        LoanGuarantorDetailsTable: Record "Loans Guarantee Details";
                        reccount: Integer;
                    begin
                        reccount := 0;
                        TestField(Posted, false);
                        //---------------------------Autofill details for guarantor
                        if (Source = source::micro) and ("Loan  No." <> '') and (Posted = false) then begin
                            LoanGuarantorDetailsTable.Reset();
                            LoanGuarantorDetailsTable.SetRange(LoanGuarantorDetailsTable."Loan No", "Loan  No.");
                            if LoanGuarantorDetailsTable.Find('-') then begin
                                LoanGuarantorDetailsTable.DeleteAll();
                            end;
                            //.......................................AutoFill Group MEMBERS
                            Cust.Reset();
                            // Cust.SetRange(Cust."Group Account No", "Group Account");
                            Cust.SetAutoCalcFields(Cust."Current Shares", cust."Outstanding Balance");
                            if Cust.find('-') then begin
                                reccount := cust.Count;
                                repeat
                                    LoanGuarantorDetailsTable.init();
                                    LoanGuarantorDetailsTable."Loan No" := "Loan  No.";
                                    LoanGuarantorDetailsTable."Member No" := Cust."No.";
                                    LoanGuarantorDetailsTable."Loan Balance" := FnGetPersonGuarantingLoanBal(LoanGuarantorDetailsTable."Member No");
                                    LoanGuarantorDetailsTable."Outstanding Balance" := FnGetPersonGuarantingLoanBal(LoanGuarantorDetailsTable."Member No");
                                    LoanGuarantorDetailsTable."Group Account No." := "Group Account";
                                    LoanGuarantorDetailsTable.Shares := (Cust."Current Shares");
                                    LoanGuarantorDetailsTable.Date := "Application Date";
                                    LoanGuarantorDetailsTable.Name := cust.Name;
                                    LoanGuarantorDetailsTable."ID No." := cust."ID No.";
                                    LoanGuarantorDetailsTable."Amont Guaranteed" := Round("Approved Amount" / reccount, 1, '>');
                                    LoanGuarantorDetailsTable."Loanees  No" := "Client Code";
                                    LoanGuarantorDetailsTable.Insert(true);
                                until Cust.next = 0;
                                //-------------------Check For Self Guarantee
                                LoanGuarantorDetailsTable.Reset();
                                LoanGuarantorDetailsTable.SetRange(LoanGuarantorDetailsTable."Loan No", "Loan  No.");
                                LoanGuarantorDetailsTable.SetRange(LoanGuarantorDetailsTable."Member No", "Client Code");
                                if LoanGuarantorDetailsTable.Find('-') then begin
                                    LoanGuarantorDetailsTable."Self Guarantee" := true;
                                    LoanGuarantorDetailsTable.modify(true);
                                end;
                                //-----------------
                            end;
                            //.............................................................
                        end;

                    end;

                }
                field("Recommended Amount"; "Recommended Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approved Amount"; "Approved Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Amount';
                    Editable = AppliedAmountEditable;

                    trigger OnValidate()
                    var
                        LoanGuarantorDetailsTable: Record "Loans Guarantee Details";
                        reccount: Integer;
                    begin
                        reccount := 0;
                        //---------------------------Autofill details for guarantor
                        if (Source = source::micro) and ("Loan  No." <> '') and (Posted = false) then begin
                            LoanGuarantorDetailsTable.Reset();
                            LoanGuarantorDetailsTable.SetRange(LoanGuarantorDetailsTable."Loan No", "Loan  No.");
                            if LoanGuarantorDetailsTable.Find('-') then begin
                                LoanGuarantorDetailsTable.DeleteAll();
                            end;
                            //.......................................AutoFill Group MEMBERS
                            Cust.Reset();
                            // Cust.SetRange(Cust."Group Account No", "Group Account");
                            Cust.SetAutoCalcFields(Cust."Current Shares", cust."Outstanding Balance");
                            if Cust.find('-') then begin
                                reccount := cust.Count;
                                repeat
                                    LoanGuarantorDetailsTable.init();
                                    LoanGuarantorDetailsTable."Loan No" := "Loan  No.";
                                    LoanGuarantorDetailsTable."Member No" := Cust."No.";
                                    LoanGuarantorDetailsTable."Loan Balance" := FnGetPersonGuarantingLoanBal(LoanGuarantorDetailsTable."Member No");
                                    LoanGuarantorDetailsTable."Outstanding Balance" := FnGetPersonGuarantingLoanBal(LoanGuarantorDetailsTable."Member No");
                                    LoanGuarantorDetailsTable."Group Account No." := "Group Account";
                                    LoanGuarantorDetailsTable.Shares := (Cust."Current Shares");
                                    LoanGuarantorDetailsTable.Date := "Application Date";
                                    LoanGuarantorDetailsTable.Name := cust.Name;
                                    LoanGuarantorDetailsTable."ID No." := cust."ID No.";
                                    LoanGuarantorDetailsTable."Amont Guaranteed" := Round("Approved Amount" / reccount, 1, '>');
                                    LoanGuarantorDetailsTable."Loanees  No" := "Client Code";
                                    LoanGuarantorDetailsTable.Insert(true);
                                until Cust.next = 0;
                                //-------------------Check For Self Guarantee
                                LoanGuarantorDetailsTable.Reset();
                                LoanGuarantorDetailsTable.SetRange(LoanGuarantorDetailsTable."Loan No", "Loan  No.");
                                LoanGuarantorDetailsTable.SetRange(LoanGuarantorDetailsTable."Member No", "Client Code");
                                if LoanGuarantorDetailsTable.Find('-') then begin
                                    LoanGuarantorDetailsTable."Self Guarantee" := true;
                                    LoanGuarantorDetailsTable.modify(true);
                                end;
                                //-----------------
                            end;
                            //.............................................................
                        end;

                    end;

                }
                field("Main Sector"; "Main Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = AppliedAmountEditable;

                    trigger OnValidate()
                    begin

                    end;
                }
                field("Sub-Sector"; "Sub-Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = AppliedAmountEditable;
                    trigger OnValidate()
                    begin
                        TestField(Posted, false);
                    end;
                }
                field("Specific Sector"; "Specific Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = AppliedAmountEditable;

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
                field("Loan Principle Repayment"; "Loan Principle Repayment")
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
                    Editable = false;
                }
                field("Loan Status"; "Loan Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateControl();
                    end;
                }
                field("Batch No."; "Batch No.")
                {
                    ApplicationArea = Basic;
                    Editable = BatchNoEditable;
                }
                field("Captured By"; "Captured By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Top Up Amount"; "Top Up Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Mode of Disbursement"; "Mode of Disbursement")
                {
                    ApplicationArea = Basic;
                    Editable = AppliedAmountEditable;
                }
                field("Loan Disbursement Date"; "Loan Disbursement Date")
                {
                    ApplicationArea = Basic;
                    Editable = AppliedAmountEditable;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    Editable = AppliedAmountEditable;
                }
                field("Cheque No."; "Cheque No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if StrLen("Cheque No.") > 6 then
                            Error('Document No. cannot contain More than 6 Characters.');
                    end;
                }
                field("Repayment Start Date"; "Repayment Start Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Expected Date of Completion"; "Expected Date of Completion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("External EFT"; "External EFT")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = true;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Source; Source)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

            }
            part(Control1000000013; "Loans Guarantee Details")
            {
                Caption = 'CEEP Loanee Guarantors  Detail';
                SubPageLink = "Loan No" = field("Loan  No."),
                              "Group Account No." = field("Group Account");

                Editable = AppliedAmountEditable;
            }
            part(Control1000000014; "Loan Appraisal Salary Details")
            {
                Caption = 'CEEP Loanee Salary Details';
                SubPageLink = "Loan No" = field("Loan  No."),
                              "Client Code" = field("Client Code");

                Editable = AppliedAmountEditable;
            }

            part(Control1000000012; "Loan Collateral Security")
            {
                Caption = 'CEEP Loanee Other Securities';
                SubPageLink = "Loan No" = field("Loan  No.");
                Editable = AppliedAmountEditable;
            }
        }
        area(factboxes)
        {
            part("Member Statistics FactBox"; "Member Statistics FactBox")
            {
                SubPageLink = "No." = field("Client Code");
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
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = SendApproval;

                    trigger OnAction()
                    var
                        Text001: label 'This transaction is already pending approval';

                    begin
                        //................Ensure than you cant have two loans same product
                        //SystemGenSet.FnCheckNoOfLoansLimit("Loan  No.", "Loan Product Type", "Client Code");
                        //----------------
                        GSetUp.Get();

                        TestField("Account No");
                        TestField("Main Sector");
                        TestField("Sub-Sector");
                        TestField("Specific Sector");

                        Prof.Reset;
                        Prof.SetRange(Prof."Loan No.", "Loan  No.");
                        Prof.SetRange(Prof."Client Code", "Client Code");
                        if Prof.Find('-') = false then begin
                            Error('Please Insert Profitability Information');
                        end;

                        //***Check Appraisal Details
                        AppExp.Reset;
                        AppExp.SetRange(AppExp.Loan, "Loan  No.");
                        AppExp.SetRange(AppExp."Client Code", "Client Code");
                        if AppExp.Find('-') = false then begin
                            Error('Please Insert Appraisal Expense Detail');
                        end;



                        if LoanType.Get("Loan Product Type") then begin
                            if LoanType."Appraise Guarantors" = true then begin
                                LGuarantors.Reset;
                                LGuarantors.SetRange(LGuarantors."Loan No", "Loan  No.");
                                if LGuarantors.Find('-') = false then begin
                                    Error('Please Insert Loan Applicant Guarantor Information');
                                end;
                            end;
                        end;

                        LoanSecurities.Reset;
                        LoanSecurities.SetRange(LoanSecurities."Loan No", "Loan  No.");
                        if LoanSecurities.Find('-') = false then begin
                            Error(Text002);
                        end;

                        TotalSecurities := 0;
                        LnSecurities.Reset;
                        LnSecurities.SetRange(LnSecurities."Loan No", "Loan  No.");
                        if LnSecurities.Find('-') then begin
                            repeat
                                TotalSecurities := TotalSecurities;
                            until LnSecurities.Next = 0;
                        end;



                        TestField("Approved Amount");
                        TestField("Loan Product Type");

                        // if "Mode of Disbursement" <> "mode of disbursement"::"Bank Transfer" then
                        //     Error('Mode of disbursement must be Bank Transfer');


                        LoanG.Reset;
                        LoanG.SetRange(LoanG."Loan No", "Loan  No.");
                        if LoanG.Find('-') then begin
                            if LoanG.Count < GSetUp."Max Loan Guarantors BLoans" then
                                Error(Text006);
                        end;
                        //***********************Loan Approval Workflow********************//
                        if "Approval Status" <> "approval status"::Open then begin
                            Error(Text001);
                        end else
                            if "Approval Status" = "approval status"::Approved then
                                Error(Text009);
                        if Confirm('Send Approval request?', false) = false then begin
                            exit;
                        end else begin
                            SrestepApprovalsCodeUnit.SendLoanApplicationsRequestForApproval(rec."Loan  No.", Rec);
                        end;
                        //***********************Loan Approval Workflow********************//
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = CancelApproval;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Confirm('Cancel Approval?', false) = true then begin
                            SrestepApprovalsCodeUnit.CancelLoanApplicationsRequestForApproval(rec."Loan  No.", Rec);
                        end;
                    end;
                }

                action("Loan Appraisal")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Appraisal';
                    Enabled = true;
                    Image = Aging;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", "Loan  No.");
                        if LoanApp.Find('-') then begin
                            Report.Run(51516435, true, false, LoanApp);
                        end;
                    end;
                }
                separator(Action1102760046)
                {
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
                        if LoanApp.Find('-') then
                            Report.Run(51516852, true, false, LoanApp);
                    end;
                }
                separator(Action1102755012)
                {
                }
                action("Loans Top Up")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans Top Up';
                    Image = AddAction;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Offset Detail List";
                    RunPageLink = "Loan No." = field("Loan  No."),
                                  "Client Code" = field("Client Code");


                }
                action("Profitability Analysis")
                {
                    ApplicationArea = Basic;
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Profitability Analysis";
                    RunPageLink = "Client Code" = field("Client Code"),
                                  "Loan No." = field("Loan  No.");
                }
                action("Appraisal Expenses")
                {
                    ApplicationArea = Basic;
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Appraisal Expense";
                    RunPageLink = Loan = field("Loan  No."),
                                  "Client Code" = field("Client Code");
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        LnLoans.Reset;
        LnLoans.SetRange(LnLoans.Posted, false);
        LnLoans.SetRange(LnLoans."Approval Status", LnLoans."approval status"::Open);
        LnLoans.SetRange(LnLoans."Captured By", UserId);
        if LnLoans."Requested Amount" = 0 then begin
            if LnLoans.Count > 0 then begin
                //ERROR(Text008,LnLoans."Approval Status");
            end;
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        LoanAppPermisions();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Source := Source::MICRO;
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
        CheckTiersEditable: Boolean;
        ReasonsEditable: Boolean;
        ScheduleCode: Code[20];
        PreviewShedule: Record "Loan Repayment Schedule";
        PeriodInterval: Code[10];
        CancelApproval: Boolean;
        LnLoans: Record "Loans Register";
        CustomerRecord: Record Customer;
        Gnljnline: Record "Gen. Journal Line";
        Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
        CumInterest: Decimal;
        NewPrincipal: Decimal;
        PeriodPrRepayment: Decimal;
        GenBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        GnljnlineCopy: Record "Gen. Journal Line";
        NewLNApplicNo: Code[10];
        Cust: Record Customer;
        LoanApp: Record "Loans Register";
        TestAmt: Decimal;
        CustRec: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
        GenSetUp: Record "Sales & Receivables Setup";
        PCharges: Record "Loan Charges";
        TCharges: Decimal;
        LAppCharges: Record "Loan Appraisal Salary Details";
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
        LoanG: Record "Loans Guarantee Details";
        SpecialComm: Decimal;
        FOSAName: Text[150];
        IDNo: Code[50];
        MovementTracker: Record "Movement Tracker";
        DiscountingAmount: Decimal;
        StatusPermissions: Record "Status Change Permision";
        BridgedLoans: Record "Special Loan Clearances";
        SMSMessage: Record Customer;
        InstallNo2: Integer;
        currency: Record "Currency Exchange Rate";
        CURRENCYFACTOR: Decimal;
        LoanApps: Record "Loans Register";
        LoanDisbAmount: Decimal;
        BatchTopUpAmount: Decimal;
        BatchTopUpComm: Decimal;
        Disbursement: Record "Cheque Disbursment Table";
        SchDate: Date;
        DisbDate: Date;
        WhichDay: Integer;
        LBatches: Record "Loans Register";
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
        Memb: Record Customer;
        LoanSecurities: Record "Loans Guarantee Details";
        Text002: label 'Please Insert Securities Details';
        LnSecurities: Record "Loans Guarantee Details";
        TotalSecurities: Decimal;
        Text003: label 'Collateral Value cannot be less than Applied Amount';
        Text004: label 'This Member has a Pending withdrawal application';
        AppSched: Integer;
        Text005: label 'This loan application is not appraised';
        GSetUp: Record "Sacco General Set-Up";
        Text006: label 'Number of guarantors less than minimum of 4';
        Text007: label 'You already have a similar running loan, please topup to proceed.';
        Text008: label 'There are still pending applications whose status is -%1, Please utilize them first';
        Prof: Record "Micro Profitability Analysis";
        AppExp: Record "Appraisal Expenses-Micro";
        Doc_No: Code[20];
        SystemGenSet: Codeunit "System General Setup";
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Account Opening","Member Closure",Loan;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        compinfo: Record "Company Information";
        Table_id: Integer;
        SendApproval: Boolean;
        Text009: label 'This application has already been approved';
        SFactory: Codeunit "SURESTEP Factory";
        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;

    local procedure FnGetPersonGuarantingLoanBal(MemberNo: Code[20]): Decimal
    var
        LoansRegister: Record "Loans Register";
        LoanBalTotal: Decimal;
    begin
        LoanBalTotal := 0;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Client Code", MemberNo);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance");
        if LoansRegister.Find('-') then begin
            repeat
                LoanBalTotal += LoansRegister."Outstanding Balance";
            until LoansRegister.Next = 0;
        end;
        exit(LoanBalTotal);
    end;

    procedure UpdateControl()
    begin

        //IF "Loan Status"="Loan Status"::Application THEN BEGIN
        if "Approval Status" = "approval status"::Open then begin
            CancelApproval := false;
            SendApproval := true;
            MNoEditable := true;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := true;
            InstallmentEditable := true;
            AppliedAmountEditable := true;
            ApprovedAmountEditable := true;
            RepayMethodEditable := true;
            RepaymentEditable := true;
            BatchNoEditable := false;
            RepayFrequencyEditable := true;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := false;
            CheckTiersEditable := true;
            ReasonsEditable := true;
        end;

        //IF "Loan Status"="Loan Status"::Appraisal THEN BEGIN
        if "Approval Status" = "approval status"::Pending then begin
            CancelApproval := true;
            SendApproval := false;
            MNoEditable := false;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := true;
            RepayMethodEditable := true;
            RepaymentEditable := true;
            BatchNoEditable := false;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := false;
            CheckTiersEditable := false;
            ReasonsEditable := false;

        end;

        //IF "Loan Status"="Loan Status"::Rejected THEN BEGIN
        if "Approval Status" = "approval status"::Rejected then begin
            CancelApproval := false;
            SendApproval := false;
            MNoEditable := false;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := false;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := false;
            DisbursementDateEditable := false;
            CheckTiersEditable := false;
            ReasonsEditable := false;

        end;

        //IF "Loan Status"="Loan Status"::Approved THEN BEGIN
        if "Approval Status" = "approval status"::Approved then begin
            CancelApproval := false;
            SendApproval := false;
            MNoEditable := false;
            LoanStatusEditable := false;
            ApplcDateEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := true;
            RepayFrequencyEditable := true;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := true;
            CheckTiersEditable := false;
            ReasonsEditable := false;
        end;
    end;


    procedure LoanAppPermisions()
    begin
    end;


}

