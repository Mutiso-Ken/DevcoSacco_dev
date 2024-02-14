#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516478 "Investor General Setup"
{
    ApplicationArea = Basic;
    PageType = Card;
    SourceTable = "Investment General Setup";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Investor Application Nos.";"Investor Application Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Investor Account Nos.";"Investor Account Nos.")
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

