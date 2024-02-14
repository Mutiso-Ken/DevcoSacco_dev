#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516927 "Okoa Authorisation List"
{
    ApplicationArea = Basic;
    CardPageID = "Okoa Authorization";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    PageType = List;
    SourceTable = "Okoa Authorisationx";
    SourceTableView = where(Posted=const(false),
                            "Supervisor Checked"=const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Over Draft No";"Over Draft No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa No';
                }
                field("Over Draft Payoff";"Over Draft Payoff")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa Payoff';
                }
                field("Account No";"Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Application date";"Application date")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Date";"Approved Date")
                {
                    ApplicationArea = Basic;
                }
                field("Captured by";"Captured by")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Current Account No";"Current Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Outstanding Overdraft";"Outstanding Overdraft")
                {
                    ApplicationArea = Basic;
                    Caption = '<Outstanding Okoa>';
                }
                field("Amount applied";"Amount applied")
                {
                    ApplicationArea = Basic;
                }
                field("Date Filter";"Date Filter")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No";"Phone No")
                {
                    ApplicationArea = Basic;
                }
                field("Email Address";"Email Address")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Overdraft Status";"Overdraft Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa Status';
                }
                field("Approved Amount";"Approved Amount")
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

