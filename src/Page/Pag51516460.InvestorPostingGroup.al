#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516460 "Investor Posting Group"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Investor Posting Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Code";"Posting Code")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Group Description";"Posting Group Description")
                {
                    ApplicationArea = Basic;
                }
                field("Investor Deposit A/C";"Investor Deposit A/C")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Payables A/C";"Interest Payables A/C")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Expense A/C";"Interest Expense A/C")
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

