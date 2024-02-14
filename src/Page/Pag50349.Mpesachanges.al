#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50349 "Mpesa changes"
{
    DeleteAllowed = false;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Change MPESA Transactions";
    SourceTableView = where(Status=const(Open));

    layout
    {
        area(content)
        {
            group(Control1102755008)
            {
            }
            field(No;No)
            {
                ApplicationArea = Basic;
            }
            field("Transaction Date";"Transaction Date")
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
            }
            field("Account No";"Account No")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("New Account No";"New Account No")
            {
                ApplicationArea = Basic;
            }
            field(Comments;Comments)
            {
                ApplicationArea = Basic;
            }
            group(Control1102755009)
            {
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Mpesa Changes")
            {
                action("Send for Approval")
                {
                    ApplicationArea = Basic;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        if Confirm('Do you want to send for approval?') = true then begin

                        MPESAChanges.Reset;
                        MPESAChanges.SetRange(MPESAChanges.No,No);
                        if MPESAChanges.Find('-') then begin
                        MPESAChanges.Status:=MPESAChanges.Status::Pending;
                        MPESAChanges."Send For Approval By":=UserId;
                        MPESAChanges."Date Sent For Approval":=Today;
                        MPESAChanges."Time Sent For Approval":=Time;
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
}

