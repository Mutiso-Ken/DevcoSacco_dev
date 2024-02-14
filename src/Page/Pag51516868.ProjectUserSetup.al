#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516868 "Project User Setup"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Project User Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Reclassification Template";"Reclassification Template")
                {
                    ApplicationArea = Basic;
                }
                field("Reclassification Batch";"Reclassification Batch")
                {
                    ApplicationArea = Basic;
                }
                field("General Journal Template";"General Journal Template")
                {
                    ApplicationArea = Basic;
                }
                field("General Journal Batch";"General Journal Batch")
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

