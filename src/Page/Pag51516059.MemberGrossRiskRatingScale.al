#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 51516059 "Member Gross Risk Rating Scale"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Member Gross Risk Rating Scale";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Risk Rate"; "Minimum Risk Rate")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Risk Rate"; "Maximum Risk Rate")
                {
                    ApplicationArea = Basic;
                }
                field("Risk Scale"; "Risk Scale")
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

