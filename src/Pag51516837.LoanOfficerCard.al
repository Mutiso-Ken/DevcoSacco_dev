// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Page 51516837 "Loan Officer Card"
// {
//     ApplicationArea = Basic;
//     Caption = 'C.E.E.P Officer Card';
//     DeleteAllowed = false;
//     PageType = Card;
//     SourceTable = "Loan Officers Details";
//     UsageCategory = Lists;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 field("Account Type";"Account Type")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Account No.";"Account No.")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Account Name";"Account Name")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Group Target";"Group Target")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Savings Target";"Savings Target")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Member Target";"Member Target")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Disbursement Target";"Disbursement Target")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Payment Target";"Payment Target")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("No. of Loans";"No. of Loans")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Exit Target";"Exit Target")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(Status;Status)
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field(Branch;Branch)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(Created;Created)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Staff Status";"Staff Status")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Name Used";"Name Used")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("User ID";"User ID")
//                 {
//                     ApplicationArea = Basic;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             separator(Action1000000022)
//             {
//             }
//             action(Approval)
//             {
//                 ApplicationArea = Basic;
//                 Image = Approvals;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 begin
//                       ///rereer
//                 end;
//             }
//             separator(Action1000000020)
//             {
//             }
//             action("Send Approval Request")
//             {
//                 ApplicationArea = Basic;
//                 Image = SendApprovalRequest;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     ApprovalMgt: Codeunit "Export F/O Consolidation";
//                 begin

//                     //ApprovalMgt.SendLOFFApprovalRequest(Rec);
//                 end;
//             }
//             separator(Action1000000017)
//             {
//             }
//             action("Cancel Approval Request")
//             {
//                 ApplicationArea = Basic;
//                 Image = Cancel;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     ApprovalMgt: Codeunit "Export F/O Consolidation";
//                 begin

//                     //IF ApprovalMgt.CancelLOFFApprovalrequest(Rec,TRUE,TRUE) THEN;
//                 end;
//             }
//         }
//     }


//     procedure UpdateControls()
//     begin
//             /* IF Status=Status::Approved THEN BEGIN
//              ReasonEditable:=FALSE;
//              "Transfer TypeEditable":=FALSE;
//              TranscodeEditable:=FALSE;
//              DocumentNoEditable:=FALSE;
//              FTransferLineEditable:=FALSE;
//              END;
        
//              IF Status=Status::Pending THEN BEGIN
//               ReasonEditable :=TRUE;
//              "Transfer TypeEditable":=TRUE;
//              TranscodeEditable:=TRUE;
//              DocumentNoEditable:=TRUE;
//              FTransferLineEditable:=TRUE;
//              END;
        
//              IF Status=Status::Cancelled THEN BEGIN
//              ReasonEditable:=FALSE;
//              "Transfer TypeEditable":=FALSE;
//              TranscodeEditable:=FALSE;
//              DocumentNoEditable:=FALSE;
//              FTransferLineEditable:=FALSE;
//              END;
//              */

//     end;
// }

