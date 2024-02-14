// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Page 51516839 "MC Individual Application List"
// {
//     ApplicationArea = Basic;
//     Caption = 'C.E.E.P Individual Application List';
//     CardPageID = "MC Individual Application Card";
//     DeleteAllowed = false;
//     Editable = false;
//     PageType = List;
//     PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
//     SourceTable = "Membership Applications";
//     SourceTableView = where("Customer Posting Group" = const('MICRO'));
//     UsageCategory = Tasks;

//     layout
//     {
//         area(content)
//         {
//             repeater(Control1102755000)
//             {
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = Basic;

//                 }
//                 field(Name; Name)
//                 {
//                     ApplicationArea = Basic;

//                 }
//                 field("Search Name"; "Search Name")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Responsibility Centre"; "Responsibility Centre")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }

//                 field(Gender; Gender)
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field(Category; Category)
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Bank Account No"; "Bank Account No")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Bank Name"; "Bank Name")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Bank Code"; "Bank Code")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }

//                 field("Recruited By"; "Recruited By")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("ID No."; "ID No.")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Account Category"; "Account Category")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }

//                 field("Mobile Phone No"; "Mobile Phone No")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Customer Type"; "Customer Type")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("BOSA Account No."; "BOSA Account No.")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Membership No.';
//                 }

//                 field("Marital Status"; "Marital Status")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Monthly Contribution"; "Monthly Contribution")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Employer Code"; "Employer Code")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Date of Birth"; "Date of Birth")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("E-Mail (Personal)"; "E-Mail (Personal)")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field(Source; Source)
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
              
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {

//         }
//     }

//     var
//         text002: label 'Kinldy specify the next of kin';
// }

