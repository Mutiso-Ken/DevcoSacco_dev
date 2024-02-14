#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516322 "ATM Cards Application List"
{
    ApplicationArea = Basic;
    CardPageID = "ATM Applications Card";
    DeleteAllowed = true;
    Editable = false;
    PageType = List;
    SourceTable = "ATM Card Applications";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control15)
            {
                Editable = false;
                field("Account No";"Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Code";"Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Address 1";"Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Address 3";"Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Address 4";"Address 4")
                {
                    ApplicationArea = Basic;
                }
                field("Address 5";"Address 5")
                {
                    ApplicationArea = Basic;
                }
                field("Customer ID";"Customer ID")
                {
                    ApplicationArea = Basic;
                }
                field("Relation Indicator";"Relation Indicator")
                {
                    ApplicationArea = Basic;
                }
                field("Card Type";"Card Type")
                {
                    ApplicationArea = Basic;
                }
                field("Request Type";"Request Type")
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

