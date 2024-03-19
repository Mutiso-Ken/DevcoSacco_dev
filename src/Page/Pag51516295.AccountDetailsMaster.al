// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Page 51516295 "Account Details Master"
// {
//     ApplicationArea = Basic;
//     CardPageID = "Account Card";
//     DeleteAllowed = false;
//     Editable = false;
//     InsertAllowed = false;
//     ModifyAllowed = false;
//     PageType = List;
//     SourceTable = Vendor;
//     SourceTableView = where("Global Dimension 1 Code" = const('FOSA'),
//                             "Account Type" = filter(<> 'HOSPITAL'));
//     UsageCategory = Lists;




//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = Basic;
//                 }

//                 field(Name; Name)
//                 {
//                     ApplicationArea = Basic;
//                     Style = StrongAccent;

//                 }
//                 field("Search Name"; "Search Name")
//                 {
//                     ApplicationArea = Basic;
//                     Visible = false;
//                 }

//                 field("ID No."; "ID No.")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("AccountType"; "Account Type")
//                 {
//                     ApplicationArea = Basic;
//                 }

//                 field("Salary Processing"; "Salary Processing")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Global Dimension 2 Code"; "Global Dimension 2 Code")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Phone No."; "Phone No.")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("ATM No."""; "ATM No.")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'ATM No.';
//                     visible = false;
//                 }
//                 field("Mobile Phone No"; "Mobile Phone No")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("BOSA Account No"; "BOSA Account No")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Member No.';
//                 }

//                 field(Balance; Balance)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Company Code"; "Company Code")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }


//                 field(AvailableBal; ("Balance (LCY)" + "Authorised Over Draft") - ("Uncleared Cheques" + "ATM Transactions" + "EFT Transactions" + MinBalance + 1090))
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                     visible = false;
//                 }
//                 field(Status; Status)
//                 {
//                     ApplicationArea = Basic;
//                 }

//                 field("Staff No"; "Staff No")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Registration Date"; "Registration Date")
//                 {
//                     ApplicationArea = Basic;
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(Control1000000004; "FOSA Statistics FactBox")
//             {
//                 SubPageLink = "No." = field("No.");
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group(Account)
//             {
//                 //Caption = 'Account';
//                 // visible= false;


//                 separator(Action1102755225)
//                 {
//                 }
//                 action("Member Page")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Member Page';
//                     Image = Planning;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page "Member Account Card";
//                     RunPageLink = "FOSA Account" = field("No.");
//                 }
//                 action("Account Statement")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Account Statement';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     begin

//                         Vend.Reset;
//                         Vend.SetRange(Vend."No.", "No.");
//                         if Vend.Find('-') then
//                             Report.Run(51516248, true, false, Vend)
//                     end;
//                 }
//                 separator(Action1102755222)
//                 {
//                 }

//                 action("Loan Recovery")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Loans Recovery';
//                     Image = PostApplication;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = page "Loan Recovery List";
//                 }

//             }

//             group(ActionGroup1102755220)
//             {
//                 action("Next Of Kin")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Next Of Kin';
//                     Image = Relationship;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page "Account Next of Kin Details";
//                     RunPageLink = "Account No" = field("No.");
//                     VISIBLE = FALSE;
//                 }
//                 separator(Action1102755217)
//                 {
//                 }

//                 action("FOSA Statistics")
//                 {
//                     ApplicationArea = Basic;
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page "FOSA Statistics";
//                     RunPageLink = "No." = field("No."),
//                                   "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
//                                   "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");


//                 }
//                 action("Ledger E&ntries")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Ledger E&ntries';
//                     Image = VendorLedger;
//                     RunObject = Page "Vendor Ledger Entries";
//                     RunPageLink = "Vendor No." = field("No.");
//                     RunPageView = sorting("Vendor No.");
//                     ShortCutKey = 'Ctrl+F7';
//                     Promoted = true;
//                     PromotedCategory = process;

//                 }
//             }
//         }
//     }



//     var
//         CalendarMgmt: Codeunit "Calendar Management";
//         PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
//         CustomizedCalEntry: Record "Customized Calendar Entry";
//         CustomizedCalendar: Record "Customized Calendar Change";
//         PictureExists: Boolean;
//         AccountTypes: Record "Account Types-Saving Products";
//         GenJournalLine: Record "Gen. Journal Line";
//         // GLPosting: Codeunit "Gen. Jnl.-Post Line";
//         StatusPermissions: Record "Status Change Permision";
//         Charges: Record Charges;
//         ForfeitInterest: Boolean;
//         InterestBuffer: Record "Interest Buffer";
//         FDType: Record "Fixed Deposit Type";
//         Vend: Record Vendor;
//         Cust: Record Customer;
//         LineNo: Integer;
//         UsersID: Record User;
//         DActivity: Code[20];
//         DBranch: Code[20];
//         MinBalance: Decimal;
//         OBalance: Decimal;
//         OInterest: Decimal;
//         Gnljnline: Record "Gen. Journal Line";
//         TotalRecovered: Decimal;
//         LoansR: Record "Loans Register";
//         LoanAllocation: Decimal;
//         LGurantors: Record "Loan GuarantorsFOSA";
//         Loans: Record "Loans Register";
//         DefaulterType: Code[20];
//         LastWithdrawalDate: Date;
//         AccountType: Record "Account Types-Saving Products";
//         ReplCharge: Decimal;
//         Acc: Record Vendor;
//         SearchAcc: Code[10];
//         Searchfee: Decimal;
//         Statuschange: Record "Status Change Permision";
//         UnclearedLoan: Decimal;
//         LineN: Integer;
//         OBal: Decimal;
//         RunBal: Decimal;
//         AvailableBal: Decimal;
//         GenSetup: Record "Sacco General Set-Up";
// }

