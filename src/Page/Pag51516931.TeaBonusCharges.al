#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516931 "Tea Bonus Charges"
{
    PageType = List;
    SourceTable = "Tea Bonus Charges";

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
                field("Lower Band";"Lower Band")
                {
                    ApplicationArea = Basic;
                }
                field("Upper Band";"Upper Band")
                {
                    ApplicationArea = Basic;
                }
                field(Charge;Charge)
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

