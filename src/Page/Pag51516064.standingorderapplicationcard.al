
// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// page 51516064 "standingorderapplicationcard"
// {
//     DeleteAllowed = true;
//     PageType = Card;
//     PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
//     RefreshOnActivate = true;
//     SourceTable = "Standing Orders";


//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field("Source Account No."; "Source Account No.")
//                 {
//                     ApplicationArea = Basic;
//                     AssistEdit = false;
//                     Editable = true;
//                 }
//                 field("Staff/Payroll No."; "Staff/Payroll No.")
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field("Account Name"; "Account Name")
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field(Amount; Amount)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Destination Account Type"; "Destination Account Type")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Destination Account No."; "Destination Account No.")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Destination Account Name"; "Destination Account Name")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Bank Code"; "Bank Code")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;

//                     trigger OnValidate()
//                     begin
//                         BankName := '';
//                         if Banks.Get("Bank Code") then
//                             BankName := Banks."Bank Name";

//                     end;
//                 }
//                 field(BankName; BankName)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Bank Name';
//                     visible = false;
//                 }
//                 field("BOSA Account No."; "BOSA Account No.")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Allocated Amount"; "Allocated Amount")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Effective/Start Date"; "Effective/Start Date")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(Duration; Duration)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("End Date"; "End Date")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(Frequency; Frequency)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Don't Allow Partial Deduction"; "Don't Allow Partial Deduction")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(Remarks; Remarks)
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(Unsuccessfull; Unsuccessfull)
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field("Next Run Date"; "Next Run Date")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(Balance; Balance)
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field(Effected; Effected)
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field("Auto Process"; "Auto Process")
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field("Income Type"; "Income Type")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Date Reset"; "Date Reset")
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field(Status; Status)
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;

//                     trigger OnValidate()
//                     begin
//                         if Status = Status::Open then
//                             CurrPage.Editable := true;
//                     end;
//                 }
//                 field("Company Code"; "Company Code")
//                 {
//                     ApplicationArea = Basic;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action(Reset)
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Reset';
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Visible = false;

//                 trigger OnAction()
//                 begin
//                     if Confirm('Are you sure you want to reset the standing order?') = true then begin

//                         Effected := false;
//                         Balance := 0;
//                         Unsuccessfull := false;
//                         "Auto Process" := false;
//                         "Date Reset" := Today;
//                         Modify;

//                         RAllocations.Reset;
//                         RAllocations.SetRange(RAllocations."Document No", "No.");
//                         if RAllocations.Find('-') then begin
//                             repeat
//                                 RAllocations."Amount Balance" := 0;
//                                 RAllocations."Interest Balance" := 0;
//                                 RAllocations.Modify;
//                             until RAllocations.Next = 0;
//                         end;

//                     end;
//                 end;
//             }
//             action(Approve)
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Approve';
//                 Enabled = true;
//                 Image = Approve;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Visible = false;

//                 trigger OnAction()
//                 begin
//                     TestField("Source Account No.");
//                     if "Destination Account Type" <> "destination account type"::BOSA then
//                         TestField("Destination Account No.");
//                     TestField("Effective/Start Date");
//                     TestField(Frequency);
//                     TestField("Next Run Date");


//                     StatusPermissions.Reset;
//                     StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
//                     StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::"Standing Order");
//                     if StatusPermissions.Find('-') = false then
//                         Error('You do not have permissions to change the standing order status.');
//                 end;
//             }
//             action(Reject)
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Reject';
//                 Image = Reject;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Visible = false;

//                 trigger OnAction()
//                 begin
//                     StatusPermissions.Reset;
//                     StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
//                     StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::"Standing Order");
//                     if StatusPermissions.Find('-') = false then
//                         Error('You do not have permissions to change the standing status.');
//                 end;
//             }
//             action(Stop)
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Stop';
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Visible = false;

//                 trigger OnAction()
//                 begin
//                     StatusPermissions.Reset;
//                     StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
//                     StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::"Standing Order");
//                     if StatusPermissions.Find('-') = false then
//                         Error('You do not have permissions to stop the standing order.');

//                     if Confirm('Are you sure you want to stop the standing order?', false) = true then begin
//                         //Status:=Status::"2";
//                         //MODIFY;
//                     end;
//                 end;
//             }
//             group(Approvals)
//             {
//                 action(Approval)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Approvals';
//                     Image = Approval;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         ApprovalEntries: Page "Approval Entries";
//                     begin
//                         DocumentType := Documenttype::STO;
//                         ApprovalEntries.SetRecordFilters(Database::"Payroll Company Setup", DocumentType, "No.");
//                         ApprovalEntries.Run;
//                     end;
//                 }
//                 action("Send Approval Request")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Send Approval Request';
//                     Image = SendApprovalRequest;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         Text001: label 'This request is already pending approval';
//                     // Approvalmgt: Codeunit "Export F/O Consolidation";
//                     begin
//                         TestField("Source Account No.");
//                         if "Destination Account Type" <> "destination account type"::BOSA then
//                             TestField("Destination Account No.");

//                         TestField("Effective/Start Date");
//                         TestField(Frequency);
//                         TestField("Next Run Date");

//                         if "Destination Account Type" = "destination account type"::BOSA then begin
//                             CalcFields("Allocated Amount");
//                             if Amount <> "Allocated Amount" then
//                                 Error('Allocated amount must be equal to amount');
//                         end;

//                         if Status <> Status::Open then
//                             Error(Text001);


//                         /*
//                        //End allocate batch number
//                        IF Approvalmgt.SendFOSASTOApprovalRequest(Rec) THEN;
//                          */
//                         Status := Status::Approved;

//                     end;
//                 }
//                 action("Cancel Approval Request")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Cancel Approval Request';
//                     Image = Cancel;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                     //Approvalmgt: Codeunit "Export F/O Consolidation";
//                     begin

//                         //IF Approvalmgt.CancelFOSASTOApprovalRequest(Rec,TRUE,TRUE) THEN;
//                     end;
//                 }
//             }
//         }
//         area(creation)
//         {
//             action(Create_STO)
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Create_STO';
//                 Enabled = true;
//                 Image = Approve;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Visible = false;

//                 trigger OnAction()
//                 begin
//                     TestField("Source Account No.");
//                     if "Destination Account Type" <> "destination account type"::BOSA then
//                         TestField("Destination Account No.");
//                     TestField("Effective/Start Date");
//                     TestField(Frequency);
//                     TestField("Next Run Date");

//                     //IF Status<>Status::"2" THEN
//                     //ERROR('Standing order status must be approved for you to create it');

//                     StatusPermissions.Reset;
//                     StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
//                     StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::"Standing Order");
//                     if StatusPermissions.Find('-') = false then
//                         Error('You do not have permissions to change the standing order status.');
//                 end;
//             }
//             action(Reactivate_STO)
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Reactivate_STO';
//                 Enabled = true;
//                 Image = ReOpen;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Visible = true;

//                 trigger OnAction()
//                 begin
//                     StatusPermissions.Reset;
//                     StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
//                     StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::"Standing Order");
//                     if StatusPermissions.Find('-') = false then
//                         Error('You do not have permissions to re-activate the standing order.');

//                     if Status <> Status::Stopped then
//                         Error('Standing order status must be stopped');

//                     if Confirm('Are you sure you want to reactivate the standing order?', false) = true then begin
//                         Status := Status::Open;
//                         Modify;
//                     end;
//                 end;
//             }
//             action(Refresh)
//             {

//                 ApplicationArea = Basic;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Image = Refresh;
//                 trigger OnAction()
//                 begin
//                     CurrPage.Update();
//                 end;
//             }
//             action(Stop_STO)
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Stop_STO';
//                 Image = Stop;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 begin
//                     StatusPermissions.Reset;
//                     StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
//                     StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::"Standing Order");
//                     if StatusPermissions.Find('-') = false then
//                         Error('You do not have permissions to stop the standing order.');

//                     if Confirm('Are you sure you want to stop the standing order?', false) = true then begin
//                         Status := Status::Stopped;
//                         Modify;
//                     end;
//                 end;
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         if Status = Status::Open then
//             CurrPage.Editable := true;
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         BankName := '';
//         if Banks.Get("Bank Code") then
//             BankName := Banks."Bank Name";
//     end;

//     trigger OnInit()
//     begin
//         if Status = Status::Open then
//             CurrPage.Editable := true;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         if Status = Status::Open then
//             CurrPage.Editable := true;
//     end;

//     trigger OnOpenPage()
//     begin
//         if Status = Status::Approved then
//             CurrPage.Editable := false;
//     end;

//     var
//         StatusPermissions: Record "Status Change Permision";
//         BankName: Text[200];
//         Banks: Record Banks;
//         UsersID: Record User;
//         RAllocations: Record "Receipt Allocation";
//         DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",STO;

//     local procedure AllocatedAmountOnDeactivate()
//     begin
//         CurrPage.Update := true;
//     end;



// }

