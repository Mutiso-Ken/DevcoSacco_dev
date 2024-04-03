// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Report 51516854 "BLoans Officers Targets"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Layouts/BLoansOfficersTargets.rdlc';

//     dataset
//     {
//         dataitem(Loans; "Loans Register")
//         {
//             DataItemTableView = where(Posted = const(true), Source = const(MICRO));
//             RequestFilterFields = "Loan Officer", "Date filter";

//             column(LoanOfficer_Loans; Loans."Loan Officer")
//             {
//             }
//             column(OutstandingBalance_Loans; Loans."Outstanding Balance")
//             {
//             }
//             column(OustandingInterest_Loans; Loans."Oustanding Interest")
//             {
//             }
//             column(LoanNo_Loans; Loans."Loan  No.")
//             {
//             }
//             column(ApplicationDate_Loans; Loans."Application Date")
//             {
//             }
//             column(LoanProductType_Loans; Loans."Loan Product Type")
//             {
//             }
//             column(ClientCode_Loans; Loans."Client Code")
//             {
//             }
//             column(GroupCode_Loans; Loans."Group Code")
//             {
//             }
//             column(Savings_Loans; Loans.Savings)
//             {
//             }
//             column(ExistingLoan_Loans; Loans."Existing Loan")
//             {
//             }
//             column(RequestedAmount_Loans; Loans."Requested Amount")
//             {
//             }
//             column(ApprovedAmount_Loans; Loans."Approved Amount")
//             {
//             }
//             column(Interest_Loans; Loans.Interest)
//             {
//             }
//             column(OfficerName; OfficerName)
//             {
//             }
//             column(Space; Space)
//             {
//             }
//             column(Viewtotals; Viewtotals)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 //i:=i+1;

//                 LoanCount := 0;
//                 OfficerName := '';

//                 LoanOfficer.Reset;
//                 //LoanOfficer.SETRANGE(LoanOfficer."Account No.",Loans."Loan Officer");
//                 LoanOfficer.SetRange(LoanOfficer."Account Name", Loans."Loan Officer");
//                 if LoanOfficer.Find('-') then begin
//                     Loans.CalcFields(Loans."Outstanding Balance");
//                     OfficerName := LoanOfficer."Account Name";
//                     LoanCount := Loans."Outstanding Balance";
//                 end;
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 field(Viewtotals; Viewtotals)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'View Totals Only';
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
//         LoanOfficer: Record "Loan Officers Details";
//         LoanCount: Decimal;
//         OfficerName: Code[80];
//         Space: Code[10];
//         MembLedge: Record "Cust. Ledger Entry";
//         DepCount: Decimal;
//         Viewtotals: Boolean;
// }

