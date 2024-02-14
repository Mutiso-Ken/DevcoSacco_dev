#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516867 "Property Sizes"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Property Sizes";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Acreage;Acreage)
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

