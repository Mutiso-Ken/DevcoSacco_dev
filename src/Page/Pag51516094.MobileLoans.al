#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516094 "Mobile Loans"
{
    ApplicationArea = Basic;
    Editable = false;
    PageType = List;
    SourceTable = "Mobile Loans";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No"; "Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Account No"; "Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Batch No"; "Batch No")
                {
                    ApplicationArea = Basic;

                }
                field("Loan No"; "Loan No")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Amount"; "Loan Amount")
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }

                field("Date Entered"; "Date Entered")
                {
                    ApplicationArea = Basic;
                }
                field("Time Entered"; "Time Entered")
                {
                    ApplicationArea = Basic;
                }
                field("Entered By"; "Entered By")
                {
                    ApplicationArea = Basic;
                }
                field("Sent To Server"; "Sent To Server")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Date Sent To Server"; "Date Sent To Server")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Time Sent To Server"; "Time Sent To Server")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }

                field("Member No"; "Member No")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Telephone No"; "Telephone No")
                {
                    ApplicationArea = Basic;
                }
                field("Corporate No"; "Corporate No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Delivery Center"; "Delivery Center")
                {
                    ApplicationArea = Basic;
                }

                field(Purpose; Purpose)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("MPESA Doc No."; "MPESA Doc No.")
                {
                    ApplicationArea = Basic;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
                field("Entry No"; "Entry No")
                {
                    ApplicationArea = Basic;
                }
                field("Ist Notification"; "Ist Notification")
                {
                    ApplicationArea = Basic;
                }
                field("2nd Notification"; "2nd Notification")
                {
                    ApplicationArea = Basic;
                }
                field("3rd Notification"; "3rd Notification")
                {
                    ApplicationArea = Basic;
                }
                field("Penalty Date"; "Penalty Date")
                {
                    ApplicationArea = Basic;
                }

                field(Recovery; Recovery)
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

