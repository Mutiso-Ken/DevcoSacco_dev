xmlport 51516103 "Import Tea Payout"
{
    Caption = 'Import Tea Payout';
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(TransactionSchedule; "Transaction Schedule")
            {
            }
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
