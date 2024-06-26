#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516326 "Front Office Charges"
{
    PageType = ListPart;
    SourceTable = "Transaction Charges";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Charge Code";"Charge Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Charge Amount";"Charge Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Percentage of Amount";"Percentage of Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Use Percentage";"Use Percentage")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account";"G/L Account")
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Amount";"Minimum Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Amount";"Maximum Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Due Amount";"Due Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Due to Account";"Due to Account")
                {
                    ApplicationArea = Basic;
                }
                field("Charge Type";"Charge Type")
                {
                    ApplicationArea = Basic;
                }
                field("Staggered Charge Code";"Staggered Charge Code")
                {
                    ApplicationArea = Basic;
                }
                field("Charge Excise Duty";"Charge Excise Duty")
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

