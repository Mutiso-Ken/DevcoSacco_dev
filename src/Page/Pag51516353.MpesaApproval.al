#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516353 "Mpesa Approval"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Change MPESA Transactions";
    SourceTableView = where(Status=const(Pending));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Approved";"Time Approved")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Send For Approval By";"Send For Approval By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Sent For Approval";"Date Sent For Approval")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Sent For Approval";"Time Sent For Approval")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Changed;Changed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Initiated By";"Initiated By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("MPESA Receipt No";"MPESA Receipt No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account No";"Account No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("New Account No";"New Account No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reasons for rejection";"Reasons for rejection")
                {
                    ApplicationArea = Basic;
                }
                field("Date Approved";"Date Approved")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approved By";"Approved By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Mpesa Changes")
            {
                Caption = 'Mpesa Changes';
                action("Finalise Change")
                {
                    ApplicationArea = Basic;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        StatusPermissions.Reset;
                        StatusPermissions.SetRange(StatusPermissions."User Id",UserId);
                        StatusPermissions.SetRange(StatusPermissions."Function",StatusPermissions."function"::"Mpesa Change");
                        if StatusPermissions.Find('-') = false then
                        Error('Please contact system Admin for this permission.');
                        
                        /*
                        
                        ReversalMngt.RESET;
                        ReversalMngt.SETRANGE(ReversalMngt.UserId,USERID);
                        ReversalMngt.SETFILTER(ReversalMngt.Status,'Mpesa Change');
                        IF ReversalMngt.FIND('-') = FALSE THEN BEGIN
                        ERROR('Please contact system Admin for this permission')
                        END;
                        */
                        if "Initiated By"=UpperCase(UserId) then
                        Error('You cannot initiate and finalise same change');
                        
                        if Confirm('Do you want to send for approval?') = true then begin
                        
                        MPESAChanges.Reset;
                        MPESAChanges.SetRange(MPESAChanges.No,No);
                        if MPESAChanges.Find('-') then begin
                        
                        if MPESAChanges."Initiated By"=UserId then begin
                        Error('The user who initiated the transaction cannot be the same as the one who finalises it.');
                        exit;
                        end;
                        
                        MPESATransactions.Reset;
                        MPESATransactions.SetRange(MPESATransactions."Document No.","MPESA Receipt No");
                        if MPESATransactions.Find('-') then begin
                        
                        if MPESATransactions.Changed=false then begin
                        MPESATransactions."Original Account No":=MPESATransactions."Account No.";
                        end;
                        
                        MPESATransactions."Old Account No":=MPESATransactions."Account No.";
                        MPESATransactions."Account No.":=MPESAChanges."New Account No";
                        MPESATransactions."Change Transaction No":=MPESAChanges.No;
                        MPESATransactions.Changed:=true;
                        MPESATransactions."Date Changed":=Today;
                        MPESATransactions."Time Changed":=Time;
                        MPESATransactions."Changed By":=MPESAChanges."Initiated By";
                        MPESATransactions."Approved By":=UserId;
                        MPESATransactions.Modify;
                        end;
                        
                        ///////////
                        MPESAChanges.Status:=MPESAChanges.Status::Approved;
                        MPESAChanges."Approved By":=UserId;
                        MPESAChanges."Date Approved":=Today;
                        MPESAChanges."Time Approved":=Time;
                        MPESAChanges.Changed:=true;
                        MPESAChanges.Modify;
                        end;
                        end;

                    end;
                }
                action("Reject Change")
                {
                    ApplicationArea = Basic;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        if Confirm('Do you want to reject the transaction?') = true then begin
                        TestField("Reasons for rejection");
                        MPESAChanges.Reset;
                        MPESAChanges.SetRange(MPESAChanges.No,No);
                        if MPESAChanges.Find('-') then begin

                        if MPESAChanges."Initiated By"=UserId then begin
                        Error('The user who initiated the transaction cannot be the same as the one who rejects it.');
                        exit;
                        end;


                        MPESAChanges.Status:=MPESAChanges.Status::Rejected;
                        MPESAChanges."Approved By":=UserId;
                        MPESAChanges."Date Approved":=Today;
                        MPESAChanges."Time Approved":=Time;
                        MPESAChanges.Modify;
                        end;
                        end;
                    end;
                }
            }
        }
    }

    var
        MPESAChanges: Record "Change MPESA Transactions";
        MPESATransactions: Record "MPESA Transactions";
        StatusPermissions: Record "Status Change Permision";
}

