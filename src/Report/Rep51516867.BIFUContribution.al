// Report 51516867 "BIFU Contribution"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Layouts/BIFUContribution.rdlc';

//     dataset
//     {
//         dataitem("Payroll Monthly Transactions"; "Payroll Monthly Transactions")
//         {
//             DataItemTableView = where("Transaction Code" = filter('D003'));

//             column(COMPANYNAME_Control1102755015; COMPANYNAME)
//             {
//             }
//             column(COMPANYNAME_Control1102756027; COMPANYNAME)
//             {
//             }
//             column(COMPANYNAME_Control1102756028; COMPANYNAME)
//             {
//             }
//             column(CompanyInfo_Picture; CompanyInfo.Picture)
//             {
//             }
//             column(CompanyInfo_Picture_Control1102756014; CompanyInfo.Picture)
//             {
//             }
//             column(CompName; CompName)
//             {
//             }
//             column(Addr1; Addr1)
//             {
//             }
//             column(Addr2; Addr2)
//             {
//             }
//             column(Email; Email)
//             {
//             }
//             column(PayrollSummary; 'COMPANY PAYROLL SUMMARY')
//             {
//             }
//             column(PeriodNamez; 'PERIOD:  ' + PeriodName)
//             {
//             }
//             column(TransDesc; 'TRANSACTION DESC.')
//             {
//             }
//             column(payments; 'PAYMENTS')
//             {
//             }
//             column(deductions; 'DEDUCTIONS')
//             {
//             }
//             column(kirinyagatitle; COMPANYNAME)
//             {
//             }
//             column(abreviation; 'MUST')
//             {
//             }
//             column(DetDate; DetDate)
//             {
//             }
//             column(EmpNo; "Payroll Monthly Transactions"."No.")
//             {
//             }
//             column(empName; empName)
//             {
//             }
//             column(EmpAmount; "Payroll Monthly Transactions".Amount)
//             {
//             }
//             column("code"; "Payroll Monthly Transactions"."Transaction Code")
//             {
//             }
//             column(name; "Payroll Monthly Transactions"."Transaction Name")
//             {
//             }
//             column(Transaction; "Payroll Monthly Transactions"."Transaction Code" + ': ' + "Payroll Monthly Transactions"."Transaction Name")
//             {
//             }
//             column(TotLabel; "Payroll Monthly Transactions"."Transaction Code" + ': ' + "Payroll Monthly Transactions"."Transaction Name")
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 //  IF NOT (((("Payroll Monthly Transactions"."Grouping"=1) AND
//                 //   ("Payroll Monthly Transactions"."SubGrouping"<>1)) OR
//                 //  ("Payroll Monthly Transactions"."Grouping"=3) OR
//                 //   (("Payroll Monthly Transactions"."Grouping"=4) AND
//                 //    ("Payroll Monthly Transactions"."SubGrouping"<>0)))) THEN
//                 "prPayroll Periods".Reset;
//                 "prPayroll Periods".SetRange("prPayroll Periods"."Date Opened", SelectedPeriod);
//                 if "prPayroll Periods".Find('-') then begin
//                     Clear(DetDate);
//                     DetDate := Format("prPayroll Periods"."Period Name");
//                 end;

//                 Clear(empName);
//                 if emps.Get("Payroll Monthly Transactions"."No.") then
//                     empName := emps."Full Name";
//                 if not (((("Payroll Monthly Transactions".Grouping = 7) and
//                      (("Payroll Monthly Transactions".SubGrouping <> 6)
//                     and ("Payroll Monthly Transactions".SubGrouping <> 5))) or
//                     (("Payroll Monthly Transactions".Grouping = 8) and
//                      ("Payroll Monthly Transactions".SubGrouping <> 9)))) then begin
//                     CurrReport.Skip;
//                 end;


//             end;

//             trigger OnPreDataItem()
//             begin
//                 if CompanyInfo.Get() then
//                     CompanyInfo.CalcFields(CompanyInfo.Picture);

//                 CompName := CompanyInfo.Name;
//                 Addr1 := CompanyInfo.Address;

//                 Addr2 := CompanyInfo.City;
//                 Email := CompanyInfo."E-Mail";


//                 //LastFieldNo := FIELDNO("Period Year");
//                 "Payroll Monthly Transactions".SetFilter("Payroll Monthly Transactions"."Payroll Period", '=%1', SelectedPeriod);
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 field(periodfilter; PeriodFilter)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Period Filter';
//                     TableRelation = "Payroll Calender"."Date Opened";
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

//     trigger OnInitReport()
//     begin
//         objPeriod.Reset;
//         objPeriod.SetRange(objPeriod.Closed, false);
//         if objPeriod.Find('-') then;
//         PeriodFilter := objPeriod."Date Opened";
//     end;

//     trigger OnPreReport()
//     begin
//         if UserSetup.Get(UserId) then begin
//             if UserSetup."Payroll User" = false then Error('You dont have permissions for payroll, Contact your system administrator! ')
//         end else begin
//             Error('You have been setup in the user setup!');
//         end;

//         SelectedPeriod := PeriodFilter;
//         objPeriod.Reset;
//         objPeriod.SetRange(objPeriod."Date Opened", SelectedPeriod);
//         if objPeriod.Find('-') then begin
//             PeriodName := objPeriod."Period Name";
//         end;


//         if CompanyInfo.Get() then
//             CompanyInfo.CalcFields(CompanyInfo.Picture);
//         Clear(rows);
//         Clear(GPY);
//         Clear(STAT);
//         Clear(DED);
//         Clear(NETS);
//     end;

//     var
//         UserSetup: Record "User Setup";
//         CompName: Text[50];
//         Addr1: Text[50];
//         Addr2: Text[50];
//         Email: Text[50];
//         empName: Text[250];
//         DetDate: Text[100];
//         found: Boolean;
//         countz: Integer;
//         PeriodFilter: Date;
//         LastFieldNo: Integer;
//         FooterPrinted: Boolean;
//         PeriodTrans: Record "Payroll Monthly Transactions";
//         objPeriod: Record "Payroll Calender";
//         SelectedPeriod: Date;
//         PeriodName: Text[30];
//         CompanyInfo: Record "Company Information";
//         TotalsAllowances: Decimal;
//         Dept: Boolean;
//         PaymentDesc: Text[200];
//         DeductionDesc: Text[200];
//         GroupText1: Text[200];
//         GroupText2: Text[200];
//         PaymentAmount: Decimal;
//         DeductAmount: Decimal;
//         PayTrans: array[70] of Text[250];
//         PayTransAmt: array[70] of Decimal;
//         DedTrans: array[70] of Text[250];
//         DedTransAmt: array[70] of Decimal;
//         rows: Integer;
//         rows2: Integer;
//         GPY: Decimal;
//         NETS: Decimal;
//         STAT: Decimal;
//         DED: Decimal;
//         TotalFor: label 'Total for ';
//         GroupOrder: label '3';
//         TransBal: array[2, 60] of Text[250];
//         Addr: array[2, 10] of Text[250];
//         RecordNo: Integer;
//         NoOfColumns: Integer;
//         ColumnNo: Integer;
//         emps: Record "Payroll Employee";
//         "prPayroll Periods": Record "Payroll Calender";
// }

