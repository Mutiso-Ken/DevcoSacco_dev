// Report 51516314 "NET Salary Transfer To FOSA"
// {
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem("Payroll Monthly Transactions"; "Payroll Monthly Transactions")
//         {
//             DataItemTableView = where(Grouping = const(9));
//             RequestFilterFields = "Payroll Period";
//             column(ReportForNavId_6207; 6207)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 //Test the GL's*****************************************************************************************************
//                 if PostingGroup.Get(PostingGroup."Posting Code") then begin
//                     PostingGroup.TestField(PostingGroup."Net Salary Payable");
//                     //Get employees Posting Group and the Posting Accounts**************************************************************
//                     PayablesAcc := PostingGroup."Net Salary Payable";
//                 end;



//                 Depts := '';
//                 //Net pay
//                 PeriodTrans.Reset;
//                 PeriodTrans.SetRange(PeriodTrans."No.", "No.");
//                 PeriodTrans.SetRange(PeriodTrans."Payroll Period", SelectedPeriod);
//                 PeriodTrans.SetFilter(PeriodTrans.Grouping, '9');
//                 PeriodTrans.SetFilter(PeriodTrans.SubGrouping, '0');
//                 if PeriodTrans.Find('-') then begin
//                     //REPEAT
//                     LineNo := LineNo + 10000;
//                     GenJnlLine.Init;
//                     GenJnlLine."Journal Template Name" := 'GENERAL';
//                     GenJnlLine."Journal Batch Name" := 'SALARIES';
//                     GenJnlLine."Line No." := LineNo;
//                     GenJnlLine."Document No." := DocumentNo;            //'OCTOBER 2016 SALARIES';
//                     GenJnlLine."Account Type" := GenJnlLine."account type"::Vendor;

//                     //Get Savings Account

//                     if objEmp.Get("No.") then begin
//                         MEMB.Reset;
//                         MEMB.SetRange(MEMB."Payroll/Staff No", "No.");
//                         if MEMB.Find('-') then begin
//                             AccNo := MEMB."FOSA Account";
//                         end;
//                     end;

//                     GenJnlLine."Account No." := AccNo;
//                     GenJnlLine.Validate(GenJnlLine."Account No.");
//                     GenJnlLine."External Document No." := DocumentNo;     //Depts;
//                     GenJnlLine.Validate(GenJnlLine."External Document No.");
//                     GenJnlLine."Posting Date" := PDATE;
//                     GenJnlLine.Description := PeriodTrans."Transaction Name" + ' ' + "No.";
//                     GenJnlLine."Document No." := DocumentNo;  //PeriodFilter;
//                     GenJnlLine.Amount := PeriodTrans.Amount * -1;
//                     GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
//                     GenJnlLine."Bal. Account No." := '3341';
//                     GenJnlLine.Validate(Amount);
//                     if GenJnlLine.Amount <> 0 then
//                         GenJnlLine.Insert;
//                     //UNTIL PeriodTrans.NEXT =0;


//                     LineNo := LineNo + 10000;
//                     GenJnlLine.Init;
//                     GenJnlLine."Journal Template Name" := 'GENERAL';
//                     GenJnlLine."Journal Batch Name" := 'SALARIES';
//                     GenJnlLine."Line No." := LineNo;
//                     GenJnlLine."Document No." := DocumentNo;            //'OCTOBER 2016 SALARIES';
//                     GenJnlLine."Account Type" := GenJnlLine."account type"::Vendor;

//                     if objEmp.Get("No.") then begin
//                         MEMB.Reset;
//                         MEMB.SetRange(MEMB."Payroll/Staff No", "No.");
//                         if MEMB.Find('-') then begin
//                             AccNo := MEMB."FOSA Account";
//                         end;

//                     end;

//                     GenJnlLine."Account No." := AccNo;
//                     GenJnlLine.Validate(GenJnlLine."Account No.");
//                     GenJnlLine."External Document No." := DocumentNo;
//                     GenJnlLine.Validate(GenJnlLine."External Document No.");
//                     GenJnlLine."Posting Date" := PDATE;
//                     GenJnlLine.Description := Format(SelectedPeriod) + 'Welfare' + '' + "No.";
//                     GenJnlLine."Document No." := DocumentNo;
//                     GenJnlLine.Amount := 300;
//                     GenJnlLine.Validate(Amount);
//                     if GenJnlLine.Amount <> 0 then
//                         GenJnlLine.Insert;


//                     LineNo := LineNo + 10000;
//                     GenJnlLine.Init;
//                     GenJnlLine."Journal Template Name" := 'GENERAL';
//                     GenJnlLine."Journal Batch Name" := 'SALARIES';
//                     GenJnlLine."Line No." := LineNo;
//                     GenJnlLine."Document No." := DocumentNo;            //'OCTOBER 2016 SALARIES';
//                     GenJnlLine."Account Type" := GenJnlLine."account type"::Vendor;
//                     GenJnlLine."Account No." := 'L01001009064';
//                     GenJnlLine.Validate(GenJnlLine."Account No.");
//                     GenJnlLine."External Document No." := DocumentNo;
//                     GenJnlLine.Validate(GenJnlLine."External Document No.");
//                     GenJnlLine."Posting Date" := PDATE;
//                     GenJnlLine.Description := Format(SelectedPeriod) + 'Welfare' + '' + "No.";
//                     GenJnlLine."Document No." := DocumentNo;
//                     GenJnlLine.Amount := 200 * -1;
//                     GenJnlLine.Validate(Amount);
//                     if GenJnlLine.Amount <> 0 then
//                         GenJnlLine.Insert;


//                     vendz.Reset;
//                     vendz.SetRange(vendz."No.", AccNo);
//                     if vendz.Find('-') then begin
//                         if (vendz."Pastrol Cont" > 0) then
//                             LineNo := LineNo + 10000;
//                         GenJnlLine.Init;
//                         GenJnlLine."Journal Template Name" := 'GENERAL';
//                         GenJnlLine."Journal Batch Name" := 'SALARIES';
//                         GenJnlLine."Line No." := LineNo;
//                         GenJnlLine."Document No." := DocumentNo;            //'OCTOBER 2016 SALARIES';
//                         GenJnlLine."Account Type" := GenJnlLine."account type"::Vendor;

//                         if objEmp.Get("No.") then begin
//                             MEMB.Reset;
//                             MEMB.SetRange(MEMB."Payroll/Staff No", "No.");
//                             if MEMB.Find('-') then begin
//                                 AccNo := MEMB."FOSA Account";
//                             end;

//                         end;

//                         GenJnlLine."Account No." := AccNo;
//                         GenJnlLine.Validate(GenJnlLine."Account No.");
//                         GenJnlLine."External Document No." := DocumentNo;
//                         GenJnlLine.Validate(GenJnlLine."External Document No.");
//                         GenJnlLine."Posting Date" := PDATE;
//                         GenJnlLine.Description := Format(SelectedPeriod) + 'Pastrol Cont' + '' + "No.";
//                         GenJnlLine."Document No." := DocumentNo;
//                         GenJnlLine.Amount := vendz."Pastrol Cont";
//                         GenJnlLine.Validate(Amount);
//                         if GenJnlLine.Amount <> 0 then
//                             GenJnlLine.Insert;


//                         LineNo := LineNo + 10000;
//                         GenJnlLine.Init;
//                         GenJnlLine."Journal Template Name" := 'GENERAL';
//                         GenJnlLine."Journal Batch Name" := 'SALARIES';
//                         GenJnlLine."Line No." := LineNo;
//                         GenJnlLine."Document No." := DocumentNo;            //'OCTOBER 2016 SALARIES';
//                         GenJnlLine."Account Type" := GenJnlLine."account type"::Vendor;
//                         GenJnlLine."Account No." := 'L01001080251';
//                         GenJnlLine.Validate(GenJnlLine."Account No.");
//                         GenJnlLine."External Document No." := DocumentNo;
//                         GenJnlLine.Validate(GenJnlLine."External Document No.");
//                         GenJnlLine."Posting Date" := PDATE;
//                         GenJnlLine.Description := Format(SelectedPeriod) + 'Pastrol Cont' + '' + "No.";
//                         GenJnlLine."Document No." := DocumentNo;
//                         GenJnlLine.Amount := (vendz."Pastrol Cont") * -1;
//                         GenJnlLine.Validate(Amount);
//                         if GenJnlLine.Amount <> 0 then
//                             GenJnlLine.Insert;
//                     end
//                 end;

//             end;

//             trigger OnPostDataItem()
//             begin
//                 Message('Journals Created Successfully');
//             end;

//             trigger OnPreDataItem()
//             begin

//                 //Create batch*****************************************************************************
//                 GenJnlBatch.Reset;
//                 GenJnlBatch.SetRange(GenJnlBatch."Journal Template Name", 'GENERAL');
//                 GenJnlBatch.SetRange(GenJnlBatch.Name, 'SALARIES');
//                 if GenJnlBatch.Find('-') = false then begin
//                     GenJnlBatch.Init;
//                     GenJnlBatch."Journal Template Name" := 'GENERAL';
//                     GenJnlBatch.Name := 'SALARIES';
//                     GenJnlBatch.Insert;
//                 end;
//                 // End Create Batch************************************************************************

//                 // Clear the journal Lines ****************************************************************
//                 GeneraljnlLine.SetRange(GeneraljnlLine."Journal Batch Name", 'SALARIES');
//                 if GeneraljnlLine.Find('-') then
//                     GeneraljnlLine.DeleteAll;

//                 SetRange("Payroll Monthly Transactions"."Payroll Period", SelectedPeriod);
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 field(SelectedPeriod; SelectedPeriod)
//                 {
//                     ApplicationArea = Basic;
//                     TableRelation = "Payroll Calender"."Date Opened";
//                 }
//                 field(DocumentNo; DocumentNo)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Document No';
//                 }
//                 field(PDATE; PDATE)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Posting Date';
//                 }
//             }
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     var
//         NssfAmount: Decimal;
//         TotNssfAmount: Decimal;
//         EmployeeName: Text[30];
//         NssfNo: Text[30];
//         IDNumber: Text[30];
//         "Volume Amount": Decimal;
//         "TotVolume Amount": Decimal;
//         TotalAmount: Decimal;
//         totTotalAmount: Decimal;
//         CompanyInfo: Record "Company Information";
//         ExcelBuf: Record "Excel Buffer" temporary;
//         PrinttoExcel: Boolean;
//         EmployerNSSFNo: Integer;
//         GenJnlLine: Record "Gen. Journal Line";
//         LineNo: Integer;
//         DocumentNo: Code[100];
//         NHIfAmount: Decimal;
//         totNHIFTotalAmount: Decimal;
//         PAYEAmount: Decimal;
//         totPAYETotalAmount: Decimal;
//         PENSIONAmount: Decimal;
//         totPENSIONTotalAmount: Decimal;
//         totHELBTotalAmount: Decimal;
//         HELBAMOUNT: Decimal;
//         totGRATTotalAmount: Decimal;
//         GRATAMOUNT: Decimal;
//         ICEAAMOUNT: Decimal;
//         totSACCOTotalAmount: Decimal;
//         SACCOAMOUNT: Decimal;
//         totICEATotalAmount: Decimal;
//         Pension: Decimal;
//         NssfAmountemployer: Decimal;
//         TotalNssfAmountemployer: Decimal;
//         totTotalNssfAmountemployer: Decimal;
//         NssfAmountemployee: Decimal;
//         TotalNssfAmountemployee: Decimal;
//         totTotalNssfAmountemployee: Decimal;
//         ICEATotalAmount: Decimal;
//         GeneraljnlLine: Record "Gen. Journal Line";
//         gRATAMOUNT1: Decimal;
//         prsalrycard: Record "Payroll Monthly Transactions";
//         amount: Decimal;
//         TOTALamountGRAT: Decimal;
//         nETPAY: Decimal;
//         Finlemsacco: Decimal;
//         csrcontribution: Decimal;
//         sALARYaDVANCE: Decimal;
//         CarLoanInt: Decimal;
//         Staffloanint: Decimal;
//         "prEmployee Transactions": Record "Payroll Employee Transactions";
//         "prTransaction Codes": Record "Payroll Transaction Code";
//         Addr: array[2, 10] of Text[250];
//         NoOfRecords: Integer;
//         RecordNo: Integer;
//         NoOfColumns: Integer;
//         ColumnNo: Integer;
//         intInfo: Integer;
//         i: Integer;
//         PeriodTrans: Record "Payroll Monthly Transactions";
//         intRow: Integer;
//         Index: Integer;
//         objEmp: Record "Payroll Employee";
//         PeriodName: Text[30];
//         PeriodFilter: Text[30];
//         SelectedPeriod: Date;
//         objPeriod: Record "Payroll Calender";
//         ControlInfo: Record "Company Information";
//         strEmpName: Text[150];
//         STATUS: Text[50];
//         DEPT: Code[20];
//         GenJnlBatch: Record "Gen. Journal Batch";
//         "Slip/Receipt No": Code[50];
//         LineNumber: Integer;
//         SalaryCard: Record "Payroll Monthly Transactions";
//         TaxableAmount: Decimal;
//         PostingGroup: Record "Payroll Posting Groups";
//         TaxAccount: Code[20];
//         salariesAcc: Code[20];
//         PayablesAcc: Code[20];
//         NSSFEMPyer: Code[20];
//         PensionEMPyer: Code[20];
//         PostingDate: Date;
//         GlobalDim1: Code[10];
//         GlobalDim2: Code[10];
//         TransCode: Record "Payroll Transaction Code";
//         AccountNo: Code[50];
//         NSSFEMPyee: Code[20];
//         AccountNoEmp: Code[50];
//         NHIFEMPyer: Code[20];
//         NHIFEMPyee: Code[20];
//         prEmployeeTransactions: Record "Payroll Employee Transactions";
//         rvalue: Text[30];
//         PDATE: Date;
//         Vend: Record Vendor;
//         AccNo: Code[20];
//         Depts: Text[30];
//         MEMB: Record Customer;
//         vendz: Record Vendor;


//     procedure CreateJnlEntry(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Member,"None",Staff; AccountNo: Code[20]; GlobalDime1: Code[20]; GlobalDime2: Code[20]; Description: Text[50]; DebitAmount: Decimal; CreditAmount: Decimal; PostAs: Option " ",Debit,Credit; LoanNo: Code[20]; TransType: Option " ","Registration Fee",Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Welfare Contribution","Deposit Contribution","Loan Penalty","Application Fee","Appraisal Fee",Investment,"Unallocated Funds","Shares Capital","Loan Adjustment",Dividend,"Withholding Tax","Administration Fee","Welfare Contribution 2"; BalAccountNo: Code[20])
//     begin
//         /*
//         LOCAL FnRecoverOverDraft("Account No" : Code[100];RunningBalance : Decimal) : Decimal
//         IF RunningBalance >0 THEN
//         BEGIN
//             ODNumber:=FnGetApprovedOverDraftNo("Account No");
//             ObjOverDraftSetup.GET();
//             AmountToDeduct:=0;
//             ObjVendor.RESET;
//             ObjVendor.SETRANGE(ObjVendor."No.","Account No");
//             ObjVendor.SETFILTER(ObjVendor."Date Filter",'..'+FORMAT(PDate));
//             IF  ObjVendor.FIND('-') THEN
//             BEGIN
//             ObjVendor.CALCFIELDS(ObjVendor."Oustanding Overdraft interest",ObjVendor.Balance,ObjVendor."Outstanding Overdraft");
//             IF  ObjVendor."Outstanding Overdraft">0 THEN
//               BEGIN
//                 LineNo:=LineNo+10000;
//                   AmountToDeduct:=FnGetMonthlyRepayment("Account No");
        
//                   IF ObjVendor."Outstanding Overdraft"<=AmountToDeduct THEN
//                   AmountToDeduct:=ObjVendor."Outstanding Overdraft";
        
//                  IF RunningBalance <= AmountToDeduct THEN
//                   AmountToDeduct:=RunningBalance;
        
//                   SFactory.FnCreateGnlJournalLineBalancedCashier(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"0",GenJournalLine."Account Type"::Vendor,
//                   "Account No",PDate,AmountToDeduct,'FOSA',ODNumber,"Account No"+' Overdraft paid','',
//                   GenJournalLine."Account Type"::"G/L Account",ObjOverDraftSetup."Control Account",ODNumber,GenJournalLine."Overdraft codes"::"Overdraft Paid");
//                  RunningBalance:=RunningBalance-AmountToDeduct;
//                 END;
//             END;
//         END;
//         EXIT(RunningBalance);
        
//         LOCAL FnGetApprovedOverDraftNo(AccNo : Code[100]) : Code[100]
//         ObjOverdraftRegister.RESET;
//         ObjOverdraftRegister.SETRANGE(ObjOverdraftRegister."Account No",AccNo);
//         ObjOverdraftRegister.SETRANGE(ObjOverdraftRegister.Status,ObjOverdraftRegister.Status::Approved);
//         ObjOverdraftRegister.SETRANGE(ObjOverdraftRegister."Overdraft Status",ObjOverdraftRegister."Overdraft Status"::Active);
//         ObjOverdraftRegister.SETRANGE(ObjOverdraftRegister."Running Overdraft",TRUE);
//         ObjOverdraftRegister.SETRANGE(ObjOverdraftRegister."Recovery Mode",ObjOverdraftRegister."Recovery Mode"::Salary);
//         IF ObjOverdraftRegister.FINDFIRST THEN
//           EXIT(ObjOverdraftRegister."Over Draft No");
//           */

//     end;
// }

