// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Report 51516855 "MicroFinance Revenue Report"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Layouts/MicroFinanceRevenueReport.rdlc';

//     dataset
//     {
//         dataitem("Loan Officers Details"; "Loan Officers Details")
//         {
//             RequestFilterFields = "Account No.";

//             column(Name_LoanOfficersDetails; "Loan Officers Details".Name)
//             {
//             }
//             dataitem("Member Ledger Entry"; "Cust. Ledger Entry")
//             {
//                 DataItemLink = "BLoan Officer No." = field("Account No.");
//                 DataItemTableView = where("Customer Posting Group" = const('MICRO'), "Transaction Type" = filter(<> Loan | "Interest Due"));
//                 RequestFilterFields = "Transaction Type", "Posting Date";
//                 column(ReportForNavId_1000000000; 1000000000)
//                 {
//                 }
//                 column(TransactionType_MemberLedgerEntry; "Member Ledger Entry"."Transaction Type")
//                 {
//                 }
//                 column(LoanNo_MemberLedgerEntry; "Member Ledger Entry"."Loan No")
//                 {
//                 }
//                 column(GroupCode_MemberLedgerEntry; "Member Ledger Entry"."Group Code")
//                 {
//                 }
//                 column(Type_MemberLedgerEntry; "Member Ledger Entry".Type)
//                 {
//                 }
//                 column(LoanType_MemberLedgerEntry; "Member Ledger Entry"."Loan Type")
//                 {
//                 }
//                 column(LoanProductDescription_MemberLedgerEntry; "Member Ledger Entry"."Loan Product Description")
//                 {
//                 }
//                 column(Source_MemberLedgerEntry; "Member Ledger Entry".Source)
//                 {
//                 }
//                 column(StaffPayrollNo_MemberLedgerEntry; "Member Ledger Entry"."Staff/Payroll No.")
//                 {
//                 }
//                 column(LastDateModified_MemberLedgerEntry; "Member Ledger Entry"."Last Date Modified")
//                 {
//                 }
//                 column(LoanproductType_MemberLedgerEntry; "Member Ledger Entry"."Loan product Type")
//                 {
//                 }
//                 column(BLoanOfficerNo_MemberLedgerEntry; "Member Ledger Entry"."BLoan Officer No.")
//                 {
//                 }
//                 column(EmployerCode_MemberLedgerEntry; "Member Ledger Entry"."Employer Code")
//                 {
//                 }
//                 column(CustomerNo_MemberLedgerEntry; "Member Ledger Entry"."Customer No.")
//                 {
//                 }
//                 column(PostingDate_MemberLedgerEntry; "Member Ledger Entry"."Posting Date")
//                 {
//                 }
//                 column(DocumentType_MemberLedgerEntry; "Member Ledger Entry"."Document Type")
//                 {
//                 }
//                 column(DocumentNo_MemberLedgerEntry; "Member Ledger Entry"."Document No.")
//                 {
//                 }
//                 column(Description_MemberLedgerEntry; "Member Ledger Entry".Description)
//                 {
//                 }
//                 column(CurrencyCode_MemberLedgerEntry; "Member Ledger Entry"."Currency Code")
//                 {
//                 }
//                 column(Amount_MemberLedgerEntry; "Member Ledger Entry".Amount)
//                 {
//                 }
//             }
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }
// }

