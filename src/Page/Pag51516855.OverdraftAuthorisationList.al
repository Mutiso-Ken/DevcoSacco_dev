#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516855 "Overdraft Authorisation List"
{
    CardPageID = "Overdraft GeneralSetup";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Over Draft Authorisationx";
    SourceTableView = where(Posted=const(false),
                            "Overdraft Status"=const(Active),
                            "Supervisor Checked"=const(false),
                            Status=const(Approved));

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
                }
                field("Over Draft Payoff";"Over Draft Payoff")
                {
                    ApplicationArea = Basic;
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

