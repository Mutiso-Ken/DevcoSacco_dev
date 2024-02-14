report 51516038 "Send P9 Report Via Mail"
{
    ApplicationArea = All;
    Caption = 'Send P9 Report Via Mail';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(MembersRegister; Customer)
        {
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
