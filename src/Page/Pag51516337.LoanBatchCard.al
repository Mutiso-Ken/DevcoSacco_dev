// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Page 51516337 "Loan Batch Card"
// {
//     DeleteAllowed = false;
//     PageType = Card;
//     PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
//     SourceTable = "Loan Disburesment-Batching";
//     SourceTableView = where(Posted = const(false), Source = const(BOSA));

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
//             field(o; "Posting Date")
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Posting Date';
//                 Editable = PostingDateEditable;
//             }
//             field("BOSA Bank Account"; "BOSA Bank Account")
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Paying Bank';
//                 Editable = PayingAccountEditable;
//             }
//             field("Cheque No."; LoansBatch."Cheque No.")
//             {
//                 ApplicationArea = Basic;
//                 Editable = ChequeNoEditable;
//             }
//             part("`"; "Loans Sub-Page List Disburse")
//             {
//                 Editable = false;
//                 SubPageLink = "Batch No." = field("Batch No.");
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         UpdateControl();
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
//         // Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
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
//         //GLPosting: Codeunit "Gen. Jnl.-Post Line";
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
//         ///ApprovalMgt: Codeunit "Export F/O Consolidation";
//         DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","FOSA Opening","Loan Batching",Leave,"Imprest Requisition","Imprest Surrender","Stores Requisition","Funds Transfer","Change Request","Staff Claims","BOSA Transfer","Loan Tranche","Loan TopUp","Memb Opening","Member Withdrawal";
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
//         AccountOpening: Codeunit SureAccountCharges;
//         Membz: Record Customer;
//         SFactory: Codeunit "SURESTEP Factory";
//         BATCH_TEMPLATE: Code[100];
//         BATCH_NAME: Code[100];
//         DOCUMENT_NO: Code[100];
//         BalanceCutOffDate: Date;
//         SMSMessages: Record "SMS Messages";
//         compinfo: Record "Company Information";
//         SendApprovalEditable: Boolean;
//         CancelApprovalEditable: Boolean;
//         PostEnabled: Boolean;


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
//             SendApprovalEditable := true;
//             CancelApprovalEditable := false;
//             PostEnabled := false;
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
//             SendApprovalEditable := false;
//             CancelApprovalEditable := true;
//             PostEnabled := false;

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
//             SendApprovalEditable := true;
//             CancelApprovalEditable := false;
//             PostEnabled := false;
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
//             SendApprovalEditable := false;
//             CancelApprovalEditable := false;
//             PostEnabled := true;

//         end;
//     end;

//     procedure FnSendDisburesmentSMS(LoanNo: Code[20]; AccountNo: Code[20])
//     begin
//         GenSetUp.Get;
//         compinfo.Get;

//         //SMS MESSAGE
//         SMSMessages.Reset;
//         if SMSMessages.Find('+') then begin
//             iEntryNo := SMSMessages."Entry No";
//             iEntryNo := iEntryNo + 1;
//         end
//         else begin
//             iEntryNo := 1;
//         end;


//         SMSMessages.Init;
//         SMSMessages."Entry No" := iEntryNo;
//         SMSMessages."Batch No" := "Batch No.";
//         SMSMessages."Document No" := LoanNo;
//         SMSMessages."Account No" := AccountNo;
//         SMSMessages."Date Entered" := Today;
//         SMSMessages."Time Entered" := Time;
//         //SMSMessages.Source:='BATCH';
//         SMSMessages.Source := 'DISBURSE';
//         SMSMessages."Entered By" := UserId;
//         SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
//         SMSMessages."SMS Message" := 'Dear Member,Your Loan has been Approved and posted to your Bank Account,'
//         + compinfo.Name + ' ' + GenSetUp."Customer Care No";
//         Cust.Reset;
//         Cust.SetRange(Cust."No.", AccountNo);
//         if Cust.Find('-') then begin
//             SMSMessages."Telephone No" := Cust."Phone No.";
//         end;
//         if Cust."Phone No." <> '' then
//             SMSMessages.Insert;
//     end;

//     local procedure FnGetMemberBranch(MemberNo: Code[50]): Code[100]
//     var
//         MemberBranch: Code[100];
//     begin
//         Cust.Reset;
//         Cust.SetRange(Cust."No.", MemberNo);
//         if Cust.Find('-') then begin
//             MemberBranch := Cust."Global Dimension 2 Code";
//         end;
//         exit(MemberBranch);
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         CurrPage.Editable := true;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin

//     end;
// }

