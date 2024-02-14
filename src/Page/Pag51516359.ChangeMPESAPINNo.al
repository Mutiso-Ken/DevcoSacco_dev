#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516359 "Change MPESA PIN No"
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Change MPESA PIN No";
    SourceTableView = where(Status=const(Open));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Date Entered";"Date Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Entered";"Time Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Entered By";"Entered By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("MPESA Application No";"MPESA Application No")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Customer ID No";"Customer ID No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Customer Name";"Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("MPESA Mobile No";"MPESA Mobile No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("MPESA Corporate No";"MPESA Corporate No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Rejection Reason";"Rejection Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Date Sent";"Date Sent")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Sent";"Time Sent")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Sent By";"Sent By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
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
            group("Change Mpesa pin No")
            {
                Caption = 'Change Mpesa pin No';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin


                        if Confirm('Are you sure you would like to send a New PIN No to the customer?') = true then begin
                        TestField("MPESA Application No");
                        TestField(Comments);

                        MPESAApp.Reset;
                        MPESAApp.SetRange(MPESAApp.No,"MPESA Application No");
                        if MPESAApp.Find('-') then begin

                          MPESAApp."Sent To Server":=MPESAApp."sent to server"::No;
                          MPESAApp.Modify;

                        end
                        else
                        begin
                          Error('MPESA Application No not found');
                          exit;
                        end;

                        Status:=Status::Pending;
                        "Date Sent":=Today;
                        "Time Sent":=Time;
                        "Sent By":=UserId;
                        Modify;

                        Message('New PIN No sent to Customer ' + "Customer Name" + '. The Customer will receive a confirmation SMS shortly.');

                        end;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        if Confirm('Are you sure you would like to reject the PIN change request?') = true then begin
                        TestField("MPESA Application No");
                        TestField("Rejection Reason");

                        Status:=Status::Approved;
                        "Date Rejected":=Today;
                        "Time Rejected":=Time;
                        "Rejected By":=UserId;
                        Modify;

                        Message('PIN change request has been rejected.');

                        end;
                    end;
                }
            }
        }
    }

    var
        MPESAApp: Record "MPESA Applications";
}

