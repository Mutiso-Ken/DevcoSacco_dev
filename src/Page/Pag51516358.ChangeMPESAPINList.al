#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516358 "Change MPESA PIN List"
{
    CardPageID = "Change MPESA PIN No";
    PageType = List;
    SourceTable = "Change MPESA PIN No";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Date Entered";"Date Entered")
                {
                    ApplicationArea = Basic;
                }
                field("Time Entered";"Time Entered")
                {
                    ApplicationArea = Basic;
                }
                field("Entered By";"Entered By")
                {
                    ApplicationArea = Basic;
                }
                field("MPESA Application No";"MPESA Application No")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Customer ID No";"Customer ID No")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name";"Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("MPESA Mobile No";"MPESA Mobile No")
                {
                    ApplicationArea = Basic;
                }
                field("MPESA Corporate No";"MPESA Corporate No")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
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
                }
                field("Time Sent";"Time Sent")
                {
                    ApplicationArea = Basic;
                }
                field("Sent By";"Sent By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Rejected";"Date Rejected")
                {
                    ApplicationArea = Basic;
                }
                field("Time Rejected";"Time Rejected")
                {
                    ApplicationArea = Basic;
                }
                field("Rejected By";"Rejected By")
                {
                    ApplicationArea = Basic;
                }
                field("Sent To Server";"Sent To Server")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

