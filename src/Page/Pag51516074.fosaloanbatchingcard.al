
// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// page 51516074 fosaloanbatchingcard
// {

//     PageType = Card;
//     Editable = true;
//     DeleteAllowed = true;
//     InsertAllowed = true;
//     PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
//     SourceTable = "Loan Disburesment-Batching";
//     SourceTableView = where(Posted = filter(false),
//                             Source = filter(FOSA), Status = filter(<> Approved));
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
//                 Editable = SourceEditable;
//             }
//             field("Batch Type"; "Batch Type")
//             {
//                 ApplicationArea = Basic;
//                 //Editable = false;
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
//             }
//             field("Mode Of Disbursement"; "Mode Of Disbursement")
//             {
//                 ApplicationArea = Basic;
//                 //Editable = ModeofDisburementEditable;

//                 trigger OnValidate()
//                 begin
//                     /*IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
//                     "Cheque No.":="Batch No.";
//                     MODIFY;  */
//                     if "Mode Of Disbursement" <> "mode of disbursement"::"Cheque" then
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
//                     /*IF STRLEN("Document No.") > 6 THEN
//                       ERROR('Document No. cannot contain More than 6 Characters.');
//                       */

//                 end;
//             }
//             field("Posting Date"; "Posting Date")
//             {
//                 ApplicationArea = Basic;
//                 Editable = PostingDateEditable;
//             }
//             field("BOSA Bank Account"; "BOSA Bank Account")
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Paying Bank';
//                 Editable = PayingAccountEditable;
//                 Visible = false;
//             }
//             field("Cheque No."; LoansBatch."Cheque No.")
//             {
//                 ApplicationArea = Basic;
//                 Editable = ChequeNoEditable;
//                 Visible = false;
//             }
//             part("`"; "Loans Sub-Page List")
//             {
//                 Editable = true;
//                 SubPageLink = "Batch No." = field("Batch No."),
//                             "System Created" = const(false);

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
//                 action("Export EFT")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Export EFT';
//                     Image = SuggestPayment;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;

//                     trigger OnAction()
//                     begin

//                         LoanApp.Reset;
//                         LoanApp.SetRange(LoanApp."Batch No.", "Batch No.");
//                         if LoanApp.Find('-') then begin

//                             Xmlport.Run(51516012, true, false, LoanApp);
//                         end;
//                     end;
//                 }
//                 action("Member Card")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Member Card';
//                     Image = Customer;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;

//                     trigger OnAction()
//                     begin

//                         /*LoanApp.RESET;
//                         LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm);
//                         IF LoanApp.FIND('-') THEN BEGIN*/

//                         /*Cust.RESET;
//                         Cust.SETRANGE(Cust."No.",LoanApp."Client Code");
//                         IF Cust.FIND('-') THEN
//                         PAGE.RUNMODAL(,Cust);*/
//                         //END;

//                     end;
//                 }
//                 action("Loan Application")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Loan Application Card';
//                     Image = Loaners;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;

//                     trigger OnAction()
//                     begin
//                         /*
//                         LoanApp.RESET;
//                         //LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.PAGE.GetLoanNo);
//                         IF LoanApp.FIND('-') THEN
//                         PAGE.RUNMODAL(,LoanApp);
//                         */

//                     end;
//                 }
//                 action("Loan Appraisal")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Loan Appraisal';
//                     Image = Statistics;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;

//                     trigger OnAction()
//                     begin
//                         /*
//                         LoanApp.RESET;
//                         //LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.PAGE.GetLoanNo);
//                         IF LoanApp.FIND('-') THEN BEGIN
//                         IF COPYSTR(LoanApp."Loan Product Type",1,2) = 'PL' THEN
//                         REPORT.RUN(,TRUE,FALSE,LoanApp)
//                         ELSE
//                         REPORT.RUN(,TRUE,FALSE,LoanApp);
//                         END;
//                         */

//                     end;
//                 }
//                 separator(Action1102760045)
//                 {
//                 }
//                 action(Approvals)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Approvals';
//                     Image = Approval;
//                     Promoted = true;
//                     PromotedCategory = Category4;

//                     trigger OnAction()
//                     var
//                         ApprovalEntries: Page "Approval Entries";
//                     begin
//                         DocumentType := Documenttype::Batches;
//                         ApprovalEntries.SetRecordFilters(Database::"Approvals Users Set Up", DocumentType, "Batch No.");
//                         ApprovalEntries.Run;
//                     end;
//                 }
//                 action("Send A&pproval Request")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Send A&pproval Request';
//                     Image = SendApprovalRequest;
//                     Promoted = true;
//                     PromotedCategory = Category4;

//                     trigger OnAction()
//                     var
//                         Text001: label 'This Batch is already pending approval';
//                         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//                     begin
//                         LoanApps.Reset;
//                         LoanApps.SetRange(LoanApps."Batch No.", "Batch No.");
//                         if LoanApps.Find('-') = false then
//                             Error('You cannot send an empty batch for approval');
//                         TestField("Description/Remarks");
//                         if Status <> Status::Open then
//                             Error(Text001);

//                         //End allocate batch number
//                         //Doc_Type:=Doc_Type::"Loan Batch";
//                         //Table_id:=DATABASE::"Loan Disburesment-Batching";
//                         //IF ApprovalMgt.SendApproval(Table_id,"Batch No.",Doc_Type,Status)THEN;


//                         /*IF ApprovalsMgmt.CheckLBatchApprovalsWorkflowEnabled(Rec) THEN
//                           ApprovalsMgmt.OnSendLBatchDocForApproval(Rec);
//                           Status:=Status::"Pending Approval";*/


//                         //TESTFIELD("Document No.");
//                         //TESTFIELD("Posting Date");


//                         Status := Status::Approved;
//                         Modify;

//                         Message(Text002);


//                         //ApprovalMgt.SendBatchApprRequest(LBatches);

//                     end;
//                 }
//                 action("Canel Approval Request")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Cancel Approval Request';
//                     Image = Cancel;
//                     Promoted = true;
//                     PromotedCategory = Category4;

//                     trigger OnAction()
//                     var
//                     //ApprovalMgt: Codeunit "Export F/O Consolidation";
//                     begin
//                         //IF ApprovalMgt.CancelBatchAppr(Rec,TRUE,TRUE) THEN;

//                         if Confirm('Are you sure you want to cancel the approval request', false) = true then begin
//                             Status := Status::Open;
//                             Modify;
//                         end;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         UpdateControl();
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         Source := Source::FOSA;
//         "Batch Type" := "batch type"::Loans;
//     end;

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     begin
//         Source := Source::FOSA;
//         "Batch Type" := "batch type"::Loans;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Source := Source::FOSA;
//         "Batch Type" := "batch type"::Loans;
//     end;

//     var
//         Text001: label 'Status must be open';
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
//         LoanApp: Record "Loans Register";
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
//         //Notification: Codeunit Mail;
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
//         Text002: label 'Loan Batch Approved Successfully';
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

//     local procedure FnRecoverOverDraft("Account No": Code[100]; RunningBalance: Decimal): Decimal
//     var
//         ObjVendor: Record Vendor;
//         ObjOverDraft: Record "Over Draft Register";
//         ObjOverDraftSetup: Record "Overdraft Setup";
//         AmountToDeduct: Decimal;
//         ODNumber: Code[100];
//     begin
//         if RunningBalance > 0 then begin
//             ODNumber := FnGetApprovedOverDraftNo("Account No");
//             ObjOverDraftSetup.Get();
//             AmountToDeduct := 0;
//             ObjVendor.Reset;
//             ObjVendor.SetRange(ObjVendor."No.", "Account No");
//             ObjVendor.SetFilter(ObjVendor."Date Filter", '..' + Format("Posting Date"));
//             if ObjVendor.Find('-') then begin
//                 ObjVendor.CalcFields(ObjVendor."Oustanding Overdraft interest", ObjVendor.Balance, ObjVendor."Outstanding Overdraft");
//                 if ObjVendor."Outstanding Overdraft" > 0 then begin
//                     LineNo := LineNo + 10000;
//                     AmountToDeduct := FnGetMonthlyRepayment("Account No");

//                     if ObjVendor."Outstanding Overdraft" <= AmountToDeduct then
//                         AmountToDeduct := ObjVendor."Outstanding Overdraft";

//                     if RunningBalance <= AmountToDeduct then
//                         AmountToDeduct := RunningBalance;

//                     SFactory.FnCreateGnlJournalLineBalancedCashier(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0", GenJournalLine."account type"::Vendor,
//                     "Account No", "Posting Date", AmountToDeduct, 'FOSA', 'OV' + "Account No", "Account No" + ' Overdraft paid', '',
//                     GenJournalLine."account type"::"G/L Account", ObjOverDraftSetup."Control Account", ODNumber, GenJournalLine."overdraft codes"::"Overdraft Paid");
//                     RunningBalance := RunningBalance - AmountToDeduct;
//                 end;
//             end;
//         end;
//         exit(RunningBalance);
//     end;

//     local procedure FnGetApprovedOverDraftNo(AccNo: Code[100]): Code[100]
//     var
//         ObjOverdraftRegister: Record "Over Draft Register";
//     begin
//         ObjOverdraftRegister.Reset;
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister."Account No", AccNo);
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister.Status, ObjOverdraftRegister.Status::Approved);
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister."Overdraft Status", ObjOverdraftRegister."overdraft status"::Active);
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister."Running Overdraft", true);
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister."Recovery Mode", ObjOverdraftRegister."recovery mode"::Loan);
//         if ObjOverdraftRegister.FindFirst then
//             exit(ObjOverdraftRegister."Over Draft No");
//     end;

//     local procedure FnGetMonthlyRepayment(AccNo: Code[100]): Decimal
//     var
//         ObjOverdraftRegister: Record "Over Draft Register";
//     begin
//         ObjOverdraftRegister.Reset;
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister."Account No", AccNo);
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister.Status, ObjOverdraftRegister.Status::Approved);
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister."Overdraft Status", ObjOverdraftRegister."overdraft status"::Active);
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister."Running Overdraft", true);
//         ObjOverdraftRegister.SetRange(ObjOverdraftRegister."Recovery Mode", ObjOverdraftRegister."recovery mode"::Loan);
//         if ObjOverdraftRegister.FindFirst then
//             exit(ObjOverdraftRegister."Monthly Overdraft Repayment");
//     end;

//     local procedure FnGetMemberBranch(MemberNo: Code[50]): Code[100]
//     var
//         MemberBranch: Code[100];
//     begin
//         Vend.Reset;
//         Vend.SetRange(Vend."No.", LoanApps."Account No");
//         if Vend.Find('-') then begin
//             MemberBranch := Vend."Global Dimension 2 Code";
//         end;
//         exit(MemberBranch);
//     end;
// }
