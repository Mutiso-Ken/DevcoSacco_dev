#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516382 "Appeal batches Card"
{
    SourceTable = "Loan Disburesment-Batching";

    layout
    {
        area(content)
        {
            group(Control1000000015)
            {
                field("Batch No."; "Batch No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Source; Source)
                {
                    ApplicationArea = Basic;
                    Editable = SourceEditable;
                }
                field("Batch Type"; "Batch Type")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Description/Remarks"; "Description/Remarks")
                {
                    ApplicationArea = Basic;
                    Editable = DescriptionEditable;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Mode Of Disbursement"; "Mode Of Disbursement")
                {
                    ApplicationArea = Basic;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*IF STRLEN("Document No.") > 6 THEN
                          ERROR('Document No. cannot contain More than 6 Characters.');
                          */

                    end;
                }
                field("Total Appeal Amount"; "Total Appeal Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                }
                field("Cheque No."; "Cheque No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("BOSA Bank Account"; "BOSA Bank Account")
                {
                    ApplicationArea = Basic;
                    Editable = PayingAccountEditable;
                    Enabled = false;
                }
                field(Location; Location)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Location';
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group(LoansB)
            {
                Caption = 'Batch';
                action("Loans Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans Schedule';
                    Image = SuggestPayment;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        LoansBatch.Reset;
                        LoansBatch.SetRange(LoansBatch."Batch No.", "Batch No.");
                        if LoansBatch.Find('-') then begin
                            //IF LoansBatch."Mode Of Disbursement"=LoansBatch."Mode Of Disbursement"::"M-Pesa" THEN
                            //REPORT.RUN(39004266,TRUE,FALSE,LoansBatch)
                            //ELSE
                            Report.Run(39004265, true, false, LoansBatch);
                        end;
                    end;
                }
                action("Export EFT")
                {
                    ApplicationArea = Basic;
                    Caption = 'Export EFT';
                    Image = SuggestPayment;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Batch No.", "Batch No.");
                        if LoanApp.Find('-') then begin

                            Xmlport.Run(39004244, true, false, LoanApp);
                        end;
                    end;
                }
                separator(Action1000000026)
                {
                }
                action("Member Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member Card';
                    Image = Customer;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        /*
                        LoanApp.RESET;
                        LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.GetLoanNo);
                        IF LoanApp.FIND('-') THEN BEGIN
                        Cust.RESET;
                        Cust.SETRANGE(Cust."No.",LoanApp."Client Code");
                        IF Cust.FIND('-') THEN
                        PAGE.RUNMODAL(39004251,Cust);
                        END;
                        */

                    end;
                }
                action("Loan Application")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Application Card';
                    Image = Loaners;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        LoanApp.Reset;
                        //LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.PAGE.GetLoanNo);
                        if LoanApp.Find('-') then
                            Page.RunModal(39004254, LoanApp);
                    end;
                }
                action("Loan Appraisal")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Appraisal';
                    Image = Statistics;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        LoanApp.Reset;
                        //LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.PAGE.GetLoanNo);
                        if LoanApp.Find('-') then begin
                            if CopyStr(LoanApp."Loan Product Type", 1, 2) = 'PL' then
                                Report.Run(39004319, true, false, LoanApp)
                            else
                                Report.Run(39004319, true, false, LoanApp);
                        end;
                    end;
                }
                separator(Action1000000022)
                {
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType := Documenttype::Batches;
                        ApprovalEntries.SetRecordFilters(Database::"Loan Disburesment-Batching", DocumentType, "Batch No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Canel Approval Request")
                {
                    ApplicationArea = Basic;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        //IF ApprovalMgt.CancelBatchAppr(Rec,TRUE,TRUE) THEN;
                    end;
                }
                separator(Action1000000018)
                {
                }
            }
        }
    }

    var
        ApprovalsSetup: Record "Approval Setup";
        MovementTracker: Record "Movement Tracker";
        FileMovementTracker: Record "File Movement Tracker";
        NextStage: Integer;
        EntryNo: Integer;
        NextLocation: Text[100];
        LoansBatch: Record "Loan Disburesment-Batching";
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
        NewLNApplicNo: Code[10];
        Cust: Record Customer;
        LoanApp: Record "Loans Register";
        TestAmt: Decimal;
        CustRec: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
        GenSetUp: Record "Sacco General Set-Up";
        PCharges: Record "Loan Product Charges";
        TCharges: Decimal;
        LAppCharges: Record "Loan Applicaton Charges";
        Loans: Record "Loans Register";
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
        UsersID: Record User;
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
        LoanApps: Record "Loans Register";
        Banks: Record "Bank Account";
        BatchTopUpAmount: Decimal;
        BatchTopUpComm: Decimal;
        TotalSpecialLoan: Decimal;
        SpecialLoanCl: Record "Special Loan Clearances";
        Loans2: Record "Loans Register";
        DActivityBOSA: Code[20];
        DBranchBOSA: Code[20];
        Refunds: Record Refunds;
        TotalRefunds: Decimal;
        WithdrawalFee: Decimal;
        NetPayable: Decimal;
        NetRefund: Decimal;
        FWithdrawal: Decimal;
        OutstandingInt: Decimal;
        TSC: Decimal;
        LoanDisbAmount: Decimal;
        NegFee: Decimal;
        DValue: Record "Dimension Value";
        ChBank: Code[20];
        Trans: Record Transactions;
        TransactionCharges: Record "Transaction Charges";
        BChequeRegister: Record "Banker Cheque Register";
        OtherCommitments: Record "Other Commitements Clearance";
        BoostingComm: Decimal;
        BoostingCommTotal: Decimal;
        BridgedLoans: Record "Special Loan Clearances";
        InterestDue: Decimal;
        ContractualShares: Decimal;
        BridgingChanged: Boolean;
        BankersChqNo: Code[20];
        LastPayee: Text[100];
        RunningAmount: Decimal;
        BankersChqNo2: Code[20];
        BankersChqNo3: Code[20];
        EndMonth: Date;
        RemainingDays: Integer;
        PrincipalRepay: Decimal;
        InterestRepay: Decimal;
        TMonthDays: Integer;
        iEntryNo: Integer;
        Temp: Record "Funds User Setup";
        Jtemplate: Code[30];
        JBatch: Code[30];
        LBatches: Record "Loan Disburesment-Batching";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Imprest,ImprestSurrender,Interbank;
        DescriptionEditable: Boolean;
        ModeofDisburementEditable: Boolean;
        DocumentNoEditable: Boolean;
        PostingDateEditable: Boolean;
        PayingAccountEditable: Boolean;
        SourceEditable: Boolean;
        ResponsibilityCenter: Boolean;
        BoostingShares: Record "Boosting Shares";
        Partial: Record "Partial Disbursment Table";
        CheckDate: Date;
        TotalChequeAmount: Decimal;
        CustID: Code[10];
        MsaccoMembers: Record "MPESA Applications";
        "MPESAno.": Text;
        tarrifHeader: Record "Tarrif Header";
        mpesa: Record "MPESA Transactions";
        SpeedCharge: Decimal;
        Employer: Record "Sacco Employers";
        CompInfo: Record "Company Information";
        SMSMessage: Record "SMS Messages";
        smsMsg: Text[250];
        PayingBank: Record "Cheque Disbursment Table";
        Deduction: Decimal;
        Tariffs: Record "Tarrif Header";
        Charges: Decimal;
        MpesaTotal: Decimal;
        MpesaCharges: Decimal;
        Text001: label 'Status must be open';


    procedure UpdateControl()
    begin
        if Status = Status::Open then begin
            DescriptionEditable := true;
            ModeofDisburementEditable := true;
            DocumentNoEditable := false;
            PostingDateEditable := false;
            SourceEditable := true;
            PayingAccountEditable := true;
            ResponsibilityCenter := true;

        end;

        if Status = Status::"Pending Approval" then begin
            DescriptionEditable := false;
            ModeofDisburementEditable := false;
            DocumentNoEditable := false;
            PostingDateEditable := false;
            SourceEditable := false;
            PayingAccountEditable := false;
            ResponsibilityCenter := false;
        end;

        if Status = Status::Rejected then begin
            DescriptionEditable := false;
            ModeofDisburementEditable := false;
            DocumentNoEditable := false;
            PostingDateEditable := false;
            SourceEditable := false;
            PayingAccountEditable := false;
            ResponsibilityCenter := false;
        end;

        if Status = Status::Approved then begin
            DescriptionEditable := false;
            ModeofDisburementEditable := false;
            DocumentNoEditable := true;
            SourceEditable := false;
            PostingDateEditable := true;
            PayingAccountEditable := true;//FALSE;
            ResponsibilityCenter := false;
        end;
    end;


    procedure SendSMS(var LoanApp: Record "Loans Register")
    begin

        GenSetUp.Get;
        CompInfo.Get;

        // if GenSetUp."Send SMS Notifications" = true then begin

        //     smsMsg := '';

        //     if LoanApp."Mode of Disbursement" = LoanApp."mode of disbursement"::"Individual Cheques" then begin
        //         smsMsg := 'Your Cheque of KSHs. ' + Format(LoanApp."Approved Amount") + ' is ready';
        //     end
        //     else
        //         if LoanApp."Mode of Disbursement" = LoanApp."mode of disbursement"::Cheque then begin

        //             if Cust.Get(LoanApp."Client Code") then
        //                 smsMsg := 'Your loan of KES. ' + Format(LoanApp."Approved Amount") +
        //                       ' has been sent to your Bank Acc. No. ' + Cust."Bank Account No." + ' at MMH SACCO LTD.';
        //         end
        //         else
        //             if (LoanApp."Mode of Disbursement" = LoanApp."mode of disbursement"::"Bank Transfer")
        //             or (LoanApp."Mode of Disbursement" = LoanApp."mode of disbursement"::"FOSA Loans") then begin

        //                 if Cust.Get(LoanApp."Client Code") then
        //                     smsMsg := 'Your loan of KES. ' + Format(LoanApp."Approved Amount") +
        //                           ' has been sent to your FOSA Acc. No. ' + Cust."FOSA Account" + ' at MMH SACCO LTD.';
        //             end;




        //     //SMS MESSAGE
        //     SMSMessage.Reset;
        //     if SMSMessage.Find('+') then begin
        //         iEntryNo := SMSMessage."Entry No";
        //         iEntryNo := iEntryNo + 1;
        //     end
        //     else begin
        //         iEntryNo := 1;
        //     end;


        //     SMSMessage.Init;
        //     SMSMessage."Entry No" := iEntryNo;
        //     SMSMessage."Batch No" := "Batch No.";
        //     SMSMessage."Document No" := '';
        //     SMSMessage."Account No" := LoanApp."Account No";
        //     SMSMessage."Date Entered" := Today;
        //     SMSMessage."Time Entered" := Time;
        //     SMSMessage.Source := 'LOAN ISSUE';
        //     SMSMessage."Entered By" := UserId;
        //     SMSMessage."Sent To Server" := SMSMessage."sent to server"::No;
        //     SMSMessage."SMS Message" := smsMsg;
        //     if Cust.Get(LoanApp."Client Code") then
        //         SMSMessage."Telephone No" := Cust."Mobile Phone No";
        //     if Cust."Mobile Phone No" <> '' then
        //         SMSMessage.Insert;

        // end;

    end;
}

