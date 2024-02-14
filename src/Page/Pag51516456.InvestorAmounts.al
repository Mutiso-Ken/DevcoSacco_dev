#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516456 "Investor Amounts"
{
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Investor Amounts";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Investor No";"Investor No")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Code";"Interest Code")
                {
                    ApplicationArea = Basic;
                }
                field("Investment Date";"Investment Date")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Last Update User";"Last Update User")
                {
                    ApplicationArea = Basic;
                    Caption = 'Last Updated By';
                }
                field("Last Update Date";"Last Update Date")
                {
                    ApplicationArea = Basic;
                }
                field("Last Update Time";"Last Update Time")
                {
                    ApplicationArea = Basic;
                }
                field("Closure Date";"Closure Date")
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

