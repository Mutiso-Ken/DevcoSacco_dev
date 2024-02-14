// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Page 51516909 "Loan Disb Batch Card(MICRO)"
// {
//     DeleteAllowed = false;
//     PageType = Card;
//     PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
//     SourceTable = "Loan Disburesment-Batching";
//     SourceTableView = where(Posted = const(false),
//                             Source = filter(MICRO));

//     layout
//     {
//         area(content)
//         {
//             field("Batch No."; "Batch No.")
//             {
//                 ApplicationArea = Basic;
//                 Editable = false;
//             }
//             field(Source; Source)
//             {
//                 ApplicationArea = Basic;
//                 Editable = false;
//             }
//             field("Batch Type"; "Batch Type")
//             {
//                 ApplicationArea = Basic;
//                 Editable = false;
//             }
//             field("Description/Remarks"; "Description/Remarks")
//             {
//                 ApplicationArea = Basic;
//                 Editable = DescriptionEditable;
//             }
//             field(Status; Status)
//             {
//                 ApplicationArea = Basic;
//                 Editable = false;
//             }
//             field("Total Loan Amount"; "Total Loan Amount")
//             {
//                 ApplicationArea = Basic;
//             }
//             field("No of Loans"; "No of Loans")
//             {
//                 ApplicationArea = Basic;
//                 Style = Favorable;
//                 StyleExpr = true;
//             }
//             field("Mode Of Disbursement"; "Mode Of Disbursement")
//             {
//                 ApplicationArea = Basic;
//                 Editable = ModeofDisburementEditable;

//                 trigger OnValidate()
//                 begin

//                     if "Mode Of Disbursement" <> "mode of disbursement"::Cheque then
//                         "Cheque No." := "Batch No.";
//                     Modify;

//                 end;
//             }
//             field("Document No."; "Document No.")
//             {
//                 ApplicationArea = Basic;
//                 Editable = DocumentNoEditable;

//                 trigger OnValidate()
//                 begin


//                 end;
//             }
//             field("Posting Date"; "Posting Date")
//             {
//                 ApplicationArea = Basic;
//                 Editable = PostingDateEditable;
//             }
//             part("`"; MicroLoansDisbursement)
//             {
//                 Editable = false;
//                 SubPageLink = "Batch No." = field("Batch No."),
//                               "System Created" = const(false);
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group(LoansB)
//             {
//                 Caption = 'Batch';
//                 action("Loans Schedule")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Loans Schedule';
//                     Image = SuggestPayment;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     begin

//                         if Posted = true then
//                             Error('Batch already posted.');

//                         LoansBatch.Reset;
//                         LoansBatch.SetRange(LoansBatch."Batch No.", "Batch No.");
//                         if LoansBatch.Find('-') then begin
//                             if LoansBatch."Batch Type" = LoansBatch."batch type"::"Personal Loans" then
//                                 Report.Run(51516232, true, false, LoansBatch)
//                             else
//                                 if LoansBatch."Batch Type" = LoansBatch."batch type"::"Branch Loans" then
//                                     Report.Run(51516232, true, false, LoansBatch)
//                                 else
//                                     if LoansBatch."Batch Type" = LoansBatch."batch type"::"Appeal Loans" then
//                                         Report.Run(51516232, true, false, LoansBatch)
//                                     else
//                                         Report.Run(51516232, true, false, LoansBatch);
//                         end;
//                     end;
//                 }
//                 separator(Action1102760034)
//                 {
//                 }
//                 separator(Action1102760045)
//                 {
//                 }
//                 action("Send A&pproval Request")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Send A&pproval Request';
//                     Image = SendApprovalRequest;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         Text001: label 'This Batch is already pending approval';
//                         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//                     begin
//                         LoanApps.Reset;
//                         LoanApps.SetRange(LoanApps."Batch No.", "Batch No.");
//                         if LoanApps.Find('-') = false then
//                             Error('Batch Is Empty!');
//                         TestField("Description/Remarks");
//                         if Status <> Status::Open then
//                             Error(Text001);

//                         //End allocate batch number
//                         Doc_Type := Doc_type::"Loan Batch";
//                         Table_id := Database::"Loan Disburesment-Batching";


//                         Message('The batch has been automatically approved');
//                         "Approved By" := UserId;
//                         Status := Status::Approved;
//                         Modify;
//                     end;
//                 }
//                 action("Cancel Approval Request")
//                 {
//                     ApplicationArea = Basic;
//                     Image = Cancel;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         ApprovalMgt: Codeunit "Export F/O Consolidation";
//                     begin
//                         if Confirm('Are you sure you want to cancel the approval request', false) = true then begin
//                             Status := Status::Open;
//                             Modify;
//                         end;
//                     end;
//                 }
//                 action(Post)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Post Batch';
//                     Image = Post;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var

//                     begin
//                         If FnCanPostLoans(UserId) = false then begin
//                             Error('You do not have permissions to Post Loans');
//                         end;
//                         if Posted = true then
//                             Error('Batch Is Already Posted.');

//                         if Status <> Status::Approved then
//                             Error(Format(Text001));
//                         if Confirm('Are you sure you want to post this batch?', false) = false then begin
//                             exit;
//                         end else begin
//                             if ("Mode Of Disbursement" = "mode of disbursement"::cheque) then begin
//                                 FnPostTransferToFosaDisb();
//                                 //.............Post Entries
//                                 GenJournalLine.Reset;
//                                 GenJournalLine.SetRange(GenJournalLine."Journal Template Name", 'GENERAL');
//                                 GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", 'LOANS');
//                                 if GenJournalLine.Find('-') then begin
//                                     GenJournalLine.SendToPosting(Codeunit::"Gen. Jnl.-Post");
//                                     LoanApps.Reset();
//                                     LoanApps.SetRange(LoanApps."Batch No.", "Batch No.");
//                                     if LoanApps.Find('-') then begin
//                                         repeat
//                                             LoanApps."Issued Date" := "Posting Date";
//                                             LoanApps.Advice := true;
//                                             LoanApps."Advice Type" := LoanApps."advice type"::"Fresh Loan";
//                                             LoanApps.Posted := true;
//                                             LoanApps."Loan Interest Repayment" := ((LoanApps."Approved Amount") * LoanApps.Installments / 12 * (LoanApps.Interest / 100));
//                                             LoanApps."Loan Status" := LoanApps."loan status"::Issued;
//                                             LoanApps.Modify;
//                                         //SendSMS;
//                                         //SendMail;
//                                         until LoanApps.Next = 0;
//                                     end;
//                                     Posted := true;
//                                     "Posted By" := UserId;
//                                     Modify;
//                                     CurrPage.Close();
//                                     Message('Batch Successfully Posted');
//                                 end;

//                                 //-------------------------
//                             end else begin
//                                 Error(Format("Mode Of Disbursement") + ' Is not implemented');
//                             end;
//                         end;
//                         //--------------------------Send SMS To Loanee of loan disburse
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         UpdateControl();
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Source := Source::MICRO;
//         "Batch Type" := "Batch Type"::Loans;
//         "Mode Of Disbursement" := "Mode Of Disbursement"::cheque;
//     end;

//     var
//         MovementTracker: Record "File Movement Tracker";
//         FileMovementTracker: Record "File Movement Tracker";
//         NextStage: Integer;
//         EntryNo: Integer;
//         NextLocation: Text[100];
//         LoansBatch: Record "Loan Disburesment-Batching";
//         i: Integer;
//         LoanType: Record "Loan Products Setup";
//         PeriodDueDate: Date;
//         ScheduleRep: Record "Loan Repayment Schedule";
//         RunningDate: Date;
//         G: Integer;
//         IssuedDate: Date;
//         GracePeiodEndDate: Date;
//         InstalmentEnddate: Date;
//         GracePerodDays: Integer;
//         InstalmentDays: Integer;
//         NoOfGracePeriod: Integer;
//         NewSchedule: Record "Loan Repayment Schedule";
//         RSchedule: Record "Loan Repayment Schedule";
//         GP: Text[30];
//         ScheduleCode: Code[20];
//         PreviewShedule: Record "Loan Repayment Schedule";
//         PeriodInterval: Code[10];
//         CustomerRecord: Record Customer;
//         Gnljnline: Record "Gen. Journal Line";
//         Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
//         CumInterest: Decimal;
//         NewPrincipal: Decimal;
//         PeriodPrRepayment: Decimal;
//         GenBatch: Record "Gen. Journal Batch";
//         LineNo: Integer;
//         GnljnlineCopy: Record "Gen. Journal Line";
//         NewLNApplicNo: Code[10];
//         Cust: Record Customer;
//         TestAmt: Decimal;
//         CustRec: Record Customer;
//         CustPostingGroup: Record "Customer Posting Group";
//         GenSetUp: Record "Sacco General Set-Up";
//         PCharges: Record "Loan Product Charges";
//         TCharges: Decimal;
//         LAppCharges: Record "Loan Applicaton Charges";
//         Loans: Record "Loans Register";
//         LoanAmount: Decimal;
//         InterestRate: Decimal;
//         RepayPeriod: Integer;
//         LBalance: Decimal;
//         RunDate: Date;
//         InstalNo: Decimal;
//         RepayInterval: DateFormula;
//         TotalMRepay: Decimal;
//         LInterest: Decimal;
//         LPrincipal: Decimal;
//         RepayCode: Code[40];
//         GrPrinciple: Integer;
//         GrInterest: Integer;
//         QPrinciple: Decimal;
//         QCounter: Integer;
//         InPeriod: DateFormula;
//         InitialInstal: Integer;
//         InitialGraceInt: Integer;
//         GenJournalLine: Record "Gen. Journal Line";
//         FOSAComm: Decimal;
//         BOSAComm: Decimal;
//         GLPosting: Codeunit "Gen. Jnl.-Post Line";
//         LoanTopUp: Record "Loan Offset Details";
//         Vend: Record Vendor;
//         BOSAInt: Decimal;
//         TopUpComm: Decimal;
//         DActivity: Code[20];
//         DBranch: Code[20];
//         UsersID: Record User;
//         TotalTopupComm: Decimal;
//         Notification: Codeunit Mail;
//         CustE: Record Customer;
//         DocN: Text[50];
//         DocM: Text[100];
//         DNar: Text[250];
//         DocF: Text[50];
//         MailBody: Text[250];
//         ccEmail: Text[250];
//         LoanG: Record "Loans Guarantee Details";
//         SpecialComm: Decimal;
//         LoanApps: Record "Loans Register";
//         Banks: Record "Bank Account";
//         BatchTopUpAmount: Decimal;
//         BatchTopUpComm: Decimal;
//         TotalSpecialLoan: Decimal;
//         SpecialLoanCl: Record "Loan Special Clearance";
//         Loans2: Record "Loans Register";
//         DActivityBOSA: Code[20];
//         DBranchBOSA: Code[20];
//         Refunds: Record "Loan Products Setup";
//         TotalRefunds: Decimal;
//         WithdrawalFee: Decimal;
//         NetPayable: Decimal;
//         NetRefund: Decimal;
//         FWithdrawal: Decimal;
//         OutstandingInt: Decimal;
//         TSC: Decimal;
//         LoanDisbAmount: Decimal;
//         NegFee: Decimal;
//         DValue: Record "Dimension Value";
//         ChBank: Code[20];
//         Trans: Record Transactions;
//         TransactionCharges: Record "Transaction Charges";
//         BChequeRegister: Record "Banker Cheque Register";
//         OtherCommitments: Record "Other Commitements Clearance";
//         BoostingComm: Decimal;
//         BoostingCommTotal: Decimal;
//         BridgedLoans: Record "Loan Special Clearance";
//         InterestDue: Decimal;
//         ContractualShares: Decimal;
//         BridgingChanged: Boolean;
//         BankersChqNo: Code[20];
//         LastPayee: Text[100];
//         RunningAmount: Decimal;
//         BankersChqNo2: Code[20];
//         BankersChqNo3: Code[20];
//         EndMonth: Date;
//         RemainingDays: Integer;
//         PrincipalRepay: Decimal;
//         InterestRepay: Decimal;
//         TMonthDays: Integer;
//         SMSMessage: Record "Loan Appraisal Salary Details";
//         iEntryNo: Integer;
//         Temp: Record Customer;
//         Jtemplate: Code[30];
//         JBatch: Code[30];
//         LBatches: Record "Loan Disburesment-Batching";
//         ApprovalMgt: Codeunit "Export F/O Consolidation";
//         DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Imprest,ImprestSurrender,Interbank;
//         DescriptionEditable: Boolean;
//         ModeofDisburementEditable: Boolean;
//         DocumentNoEditable: Boolean;
//         PostingDateEditable: Boolean;
//         SourceEditable: Boolean;
//         PayingAccountEditable: Boolean;
//         ChequeNoEditable: Boolean;
//         ChequeNameEditable: Boolean;
//         upfronts: Decimal;
//         EmergencyInt: Decimal;
//         Table_id: Integer;
//         Doc_No: Code[20];
//         Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Account Opening","Member Closure",Loan,"Loan Batch";
//         Deductions: Decimal;
//         BatchBoostingCom: Decimal;
//         HisaRepayment: Decimal;
//         HisaLoan: Record "Loans Register";
//         BatchHisaRepayment: Decimal;
//         BatchFosaHisaComm: Decimal;
//         BatchHisaShareBoostComm: Decimal;
//         BatchShareCap: Decimal;
//         BatchIntinArr: Decimal;
//         Loaninsurance: Decimal;
//         TLoaninsurance: Decimal;
//         ProductCharges: Record "Loan Product Charges";
//         InsuranceAcc: Code[20];
//         PTEN: Code[20];
//         Text001: label 'The Batch need to be approved.';
//         ProcessingFees: Decimal;
//         ExciseGL: Code[50];
//         PepeaShares: Decimal;
//         SaccoDeposits: Decimal;
//         InsFees: Decimal;
//         FormFees: Decimal;
//         CreditFees: Decimal;
//         LoanTypes: Record "Loan Products Setup";
//         Customer: Record Customer;
//         DataSheet: Record "Data Sheet Main";
//         TotBoost: Decimal;
//         ShareAmount: Decimal;
//         Commitm: Decimal;
//         Scharge: Decimal;
//         EftAmount: Decimal;
//         EFTDeduc: Decimal;
//         linecharges: Decimal;
//         SFactory: Codeunit "SURESTEP Factory";
//         BATCH_TEMPLATE: Code[100];
//         BATCH_NAME: Code[100];
//         DOCUMENT_NO: Code[100];
//         BalanceCutOffDate: Date;


//     procedure UpdateControl()
//     begin
//         if Status = Status::Open then begin
//             DescriptionEditable := true;
//             ModeofDisburementEditable := false;
//             DocumentNoEditable := false;
//             PostingDateEditable := false;
//             SourceEditable := true;
//             PayingAccountEditable := true;
//             ChequeNoEditable := false;
//             ChequeNameEditable := false;
//         end;

//         if Status = Status::"Pending Approval" then begin
//             DescriptionEditable := false;
//             ModeofDisburementEditable := false;
//             DocumentNoEditable := false;
//             PostingDateEditable := false;
//             SourceEditable := false;
//             PayingAccountEditable := false;
//             ChequeNoEditable := false;
//             ChequeNameEditable := false;

//         end;

//         if Status = Status::Rejected then begin
//             DescriptionEditable := false;
//             ModeofDisburementEditable := false;
//             DocumentNoEditable := false;
//             PostingDateEditable := false;
//             SourceEditable := false;
//             PayingAccountEditable := false;
//             ChequeNoEditable := false;
//             ChequeNameEditable := false;
//         end;

//         if Status = Status::Approved then begin
//             DescriptionEditable := false;
//             ModeofDisburementEditable := true;
//             DocumentNoEditable := true;
//             SourceEditable := false;
//             PostingDateEditable := true;
//             PayingAccountEditable := true;//FALSE;
//             ChequeNoEditable := true;
//             ChequeNameEditable := true;

//         end;
//     end;

//     local procedure FnPostTransferToFosaDisb()
//     begin
//         TestField("Description/Remarks");
//         TestField("Posting Date");
//         TestField("Document No.");
//         //------------------------------------
//         EndMonth := CalcDate('-1D', CalcDate('1M', Dmy2date(1, Date2dmy("Posting Date", 2), Date2dmy("Posting Date", 3))));
//         RemainingDays := (EndMonth - "Posting Date") + 1;
//         TMonthDays := Date2dmy(EndMonth, 1);
//         GenJournalLine.Reset;
//         GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
//         GenJournalLine.SetRange("Journal Batch Name", 'LOANS');
//         GenJournalLine.DeleteAll;
//         //------------------------------------
//         GenSetUp.Get;
//         DActivity := '';
//         DBranch := '';
//         //------------------------------------
//         LoanApps.Reset;
//         LoanApps.SetRange(LoanApps."Batch No.", "Batch No.");
//         //LoanApps.SetRange(LoanApps.Posted, false);
//         if LoanApps.Find('-') then begin
//             repeat
//                 TCharges := 0;
//                 DActivity := '';
//                 DBranch := '';
//                 if Cust.Get(LoanApps."Client Code") then begin
//                     DActivity := Cust."Global Dimension 1 Code";
//                     DBranch := Cust."Global Dimension 2 Code";
//                 end;
//                 LoanDisbAmount := LoanApps."Approved Amount";
//                 LoanApps.CalcFields(LoanApps."Top Up Amount");
//                 RunningDate := "Posting Date";
//                 //Generate and post Approved Loan Amount
//                 if not GenBatch.Get('GENERAL', 'LOANS') then begin
//                     GenBatch.Init;
//                     GenBatch."Journal Template Name" := 'GENERAL';
//                     GenBatch.Name := 'LOANS';
//                     GenBatch.Insert;
//                 end;
//                 //----------------------------------------------
//                 //Principle Amount
//                 LineNo := LineNo + 10000;
//                 GenJournalLine.INIT;
//                 GenJournalLine."Journal Template Name" := 'GENERAL';
//                 GenJournalLine."Journal Batch Name" := 'LOANS';
//                 GenJournalLine."Line No." := LineNo;
//                 GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
//                 GenJournalLine."Account No." := LoanApps."Client Code";
//                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
//                 GenJournalLine."Document No." := "Document No.";
//                 GenJournalLine."External Document No." := LoanApps."Loan  No.";
//                 GenJournalLine."Posting Date" := "Posting Date";
//                 GenJournalLine.Description := 'Principle Amount';
//                 GenJournalLine.Amount := LoanDisbAmount;
//                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
//                 GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Loan;
//                 GenJournalLine."Loan No" := LoanApps."Loan  No.";
//                 GenJournalLine."Group Code" := LoanApps."Group Code";
//                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
//                 GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
//                 GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
//                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
//                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
//                 IF GenJournalLine.Amount <> 0 THEN
//                     GenJournalLine.INSERT;

//                 //Interest Due
//                 LineNo := LineNo + 10000;
//                 GenJournalLine.INIT;
//                 GenJournalLine."Journal Template Name" := 'GENERAL';
//                 GenJournalLine."Journal Batch Name" := 'LOANS';
//                 GenJournalLine."Line No." := LineNo;
//                 GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
//                 GenJournalLine."Account No." := LoanApps."Client Code";
//                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
//                 GenJournalLine."Document No." := "Document No.";
//                 GenJournalLine."External Document No." := LoanApps."Loan  No.";
//                 GenJournalLine."Posting Date" := "Posting Date";
//                 GenJournalLine.Description := 'Loan Total Interest Due';
//                 //GenJournalLine.Amount := (LoanApps."Loan Interest Repayment");
//                 GenJournalLine.Amount := ((LoanApps."Approved Amount") * LoanApps.Installments / 12 * (LoanApps.Interest / 100));
//                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
//                 GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Due";
//                 GenJournalLine."Loan No" := LoanApps."Loan  No.";
//                 GenJournalLine."Group Code" := LoanApps."Group Code";
//                 IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
//                     GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
//                     GenJournalLine."Bal. Account No." := LoanType."Loan Interest Account";
//                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
//                 END;
//                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
//                 GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
//                 GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
//                 IF GenJournalLine.Amount <> 0 THEN
//                     GenJournalLine.INSERT;
//                 //***************FOSA Account
//                 BatchTopUpAmount := TotalTopupComm;
//                 LineNo := LineNo + 10000;
//                 GenJournalLine.INIT;
//                 GenJournalLine."Journal Template Name" := 'GENERAL';
//                 GenJournalLine."Journal Batch Name" := 'LOANS';
//                 GenJournalLine."Line No." := LineNo;
//                 GenJournalLine."Document No." := "Document No.";
//                 GenJournalLine."Posting Date" := "Posting Date";
//                 GenJournalLine."External Document No." := LoanApps."Loan  No.";
//                 GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::Vendor;
//                 GenJournalLine."Account No." := LoanApps."Account No";
//                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
//                 IF Cust.GET(LoanApps."Client Code") THEN BEGIN
//                     GenJournalLine."External Document No." := Cust."ID No.";
//                     GenJournalLine.Description := Cust."Payroll/Staff No" + ' - ' + GenJournalLine.Description;
//                 END;
//                 GenJournalLine.Description := LoanApps."Loan Product Type Name";
//                 GenJournalLine.Amount := (LoanDisbAmount) * -1;
//                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
//                 GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
//                 GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
//                 IF GenJournalLine.Amount <> 0 THEN
//                     GenJournalLine.INSERT;
//                 //Recover OV From FOSA Account
//                 //Product Charges
//                 PCharges.RESET;
//                 PCharges.SETRANGE(PCharges."Product Code", LoanApps."Loan Product Type");
//                 IF PCharges.FIND('-') THEN BEGIN
//                     REPEAT
//                         PCharges.TESTFIELD(PCharges."G/L Account");
//                         LineNo := LineNo + 10000;
//                         GenJournalLine.INIT;
//                         GenJournalLine."Journal Template Name" := 'GENERAL';
//                         GenJournalLine."Journal Batch Name" := 'LOANS';
//                         GenJournalLine."Line No." := LineNo;
//                         GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
//                         GenJournalLine."Account No." := LoanApps."Account No";
//                         GenJournalLine.VALIDATE(GenJournalLine."Account No.");
//                         GenJournalLine."Document No." := "Document No.";
//                         GenJournalLine."External Document No." := LoanApps."Loan  No.";
//                         GenJournalLine."Posting Date" := "Posting Date";
//                         GenJournalLine.Description := PCharges.Description;
//                         IF PCharges."Use Perc" = TRUE THEN BEGIN
//                             GenJournalLine.Amount := (LoanDisbAmount * (PCharges.Percentage / 100));
//                         END ELSE
//                             IF PCharges."Use Perc" = false then begin
//                                 GenJournalLine.Amount := PCharges.Amount;
//                             end;
//                         GenJournalLine.VALIDATE(GenJournalLine.Amount);
//                         GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
//                         GenJournalLine."Bal. Account No." := PCharges."G/L Account";
//                         GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
//                         GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
//                         GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
//                         IF GenJournalLine.Amount <> 0 THEN
//                             GenJournalLine.INSERT;

//                     UNTIL PCharges.NEXT = 0;
//                 END;
//                 if LoanApps."Top Up Amount" > 0 then begin
//                     LoanTopUp.Reset;
//                     LoanTopUp.SetRange(LoanTopUp."Loan No.", LoanApps."Loan  No.");
//                     if LoanTopUp.Find('-') then begin
//                         repeat
//                             //Principle
//                             LineNo := LineNo + 10000;
//                             GenJournalLine.Init;
//                             GenJournalLine."Journal Template Name" := 'GENERAL';
//                             GenJournalLine."Journal Batch Name" := 'LOANS';
//                             GenJournalLine."Line No." := LineNo;
//                             GenJournalLine."Document No." := "Document No.";
//                             GenJournalLine."Posting Date" := "Posting Date";
//                             GenJournalLine."External Document No." := LoanApps."Loan  No.";
//                             GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
//                             GenJournalLine."Account No." := LoanApps."Client Code";
//                             GenJournalLine.Validate(GenJournalLine."Account No.");
//                             GenJournalLine.Description := 'Loan Principle Off Set By - ' + LoanApps."Loan  No.";
//                             GenJournalLine.Amount := LoanTopUp."Principle Top Up" * -1;
//                             GenJournalLine.Validate(GenJournalLine.Amount);
//                             GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
//                             GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";

//                             GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
//                             GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
//                             GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
//                             GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
//                             if GenJournalLine.Amount <> 0 then
//                                 GenJournalLine.Insert;
//                             BatchTopUpAmount := BatchTopUpAmount + (GenJournalLine.Amount * -1);


//                             //****************************Debit Vendor*******************************

//                             LineNo := LineNo + 10000;
//                             GenJournalLine.Init;
//                             GenJournalLine."Journal Template Name" := 'GENERAL';
//                             GenJournalLine."Journal Batch Name" := 'LOANS';
//                             GenJournalLine."Line No." := LineNo;
//                             GenJournalLine."Document No." := "Document No.";
//                             GenJournalLine."Posting Date" := "Posting Date";
//                             GenJournalLine."External Document No." := LoanApps."Loan  No.";
//                             GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
//                             GenJournalLine."Account No." := LoanApps."Account No";
//                             GenJournalLine.Validate(GenJournalLine."Account No.");
//                             GenJournalLine.Description := LoanTopUp."Loan Type" + '-Loan Principle Recovered ';
//                             GenJournalLine.Amount := LoanTopUp."Principle Top Up";
//                             GenJournalLine.Validate(GenJournalLine.Amount);
//                             GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";

//                             GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
//                             GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
//                             if GenJournalLine.Amount <> 0 then
//                                 GenJournalLine.Insert;
//                             //Interest (Reversed if top up)
//                             if LoanType.Get(LoanApps."Loan Product Type") then begin
//                                 LineNo := LineNo + 10000;
//                                 GenJournalLine.Init;
//                                 GenJournalLine."Journal Template Name" := 'GENERAL';
//                                 GenJournalLine."Journal Batch Name" := 'LOANS';
//                                 GenJournalLine."Line No." := LineNo;
//                                 GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
//                                 GenJournalLine."Account No." := LoanApps."Client Code";
//                                 GenJournalLine.Validate(GenJournalLine."Account No.");
//                                 GenJournalLine."Document No." := "Document No.";
//                                 GenJournalLine."Posting Date" := "Posting Date";
//                                 GenJournalLine.Description := 'Interest Due Paid on top up ';
//                                 GenJournalLine.Amount := -LoanTopUp."Interest Top Up";
//                                 GenJournalLine."External Document No." := LoanApps."Loan  No.";
//                                 GenJournalLine.Validate(GenJournalLine.Amount);
//                                 GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";
//                                 GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
//                                 GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
//                                 GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
//                                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
//                                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
//                                 if GenJournalLine.Amount <> 0 then
//                                     GenJournalLine.Insert;
//                                 BatchTopUpAmount := BatchTopUpAmount + (GenJournalLine.Amount * -1);

//                             end;
//                             //****************************Debit Vendor for int recovery*******************************
//                             LineNo := LineNo + 10000;
//                             GenJournalLine.Init;
//                             GenJournalLine."Journal Template Name" := 'GENERAL';
//                             GenJournalLine."Journal Batch Name" := 'LOANS';
//                             GenJournalLine."Line No." := LineNo;
//                             GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Vendor;
//                             GenJournalLine."Account No." := LoanApps."Account No";
//                             GenJournalLine.Validate(GenJournalLine."Account No.");
//                             GenJournalLine."Document No." := "Document No.";
//                             GenJournalLine."Posting Date" := "Posting Date";
//                             GenJournalLine.Description := LoanTopUp."Loan Type" + '-Loan Interest Recovered ';
//                             GenJournalLine.Amount := LoanTopUp."Interest Top Up";
//                             GenJournalLine."External Document No." := LoanApps."Loan  No.";
//                             GenJournalLine.Validate(GenJournalLine.Amount);
//                             GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
//                             GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
//                             GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
//                             if GenJournalLine.Amount <> 0 then
//                                 GenJournalLine.Insert;
//                         //***************************Debit Vendor top up commission***********************************/
//                         until LoanTopUp.Next = 0;

//                     end;
//                 end;
//             until LoanApps.Next = 0;
//         end;
//     end;

//     local procedure FnCanPostLoans(UserId: Text): Boolean
//     var
//         UserSetUp: Record "User Setup";
//     begin
//         if UserSetUp.get(UserId) then begin
//             if UserSetUp."Can POST Loans" = true then begin
//                 exit(true);
//             end;
//         end;
//         exit(false);
//     end;
// }

